#!/usr/bin/env bash
# patch_funes.sh — run the prebuilt funes binary against a newer glibc overlay
#
# Why this exists: the prebuilt funes at $HOME/.local/bin/funes was linked on
# Ubuntu 24.04.  It references GLIBC_2.38 (from the pyke prebuilt
# libonnxruntime.a — __isoc23_strtoll, __isoc23_sscanf, ...) and GLIBC_2.39
# (pidfd_spawnp).  22.04's glibc tops out at 2.35, so the system ld rejects
# the binary outright.
#
# What this does (default): boots a Ubuntu 24.04 docker image enough to extract
# its /lib/x86_64-linux-gnu and /usr/lib/x86_64-linux-gnu into a local
# overlay directory, then invokes the funes binary through that overlay's
# ld-linux-x86-64.so.2 with --library-path so all glibc-internal symbols
# resolve consistently from the same glibc release.  Nothing on the host is
# modified.
#
# Modes:
#   --install    Bootstrap the overlay and install a symlink at $FUNES_BIN
#                pointing at this script; the original binary is preserved at
#                $FUNES_BIN.dist.  After this, `funes` on $PATH transparently
#                runs through the overlay.
#   --uninstall  Reverse --install: remove the symlink, restore .dist.
#   --bootstrap-only
#                Stage the overlay directory; do not invoke funes.
#   --verbose    Print the ld + via image on every invocation.
#   --help       Print this help.
#
# Knobs (env vars):
#   FUNES_BIN             default $HOME/.local/bin/funes
#   PATCH_FUNES_OVERLAY   default $HOME/.local/share/funes-overlay
#   PATCH_FUNES_IMAGE     default ubuntu:24.04

set -euo pipefail

FUNES_BIN="${FUNES_BIN:-$HOME/.local/bin/funes}"
OVERLAY_DIR="${PATCH_FUNES_OVERLAY:-$HOME/.local/share/funes-overlay}"
UBUNTU_IMAGE="${PATCH_FUNES_IMAGE:-ubuntu:24.04}"
HOST_LIB_PATHS="/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu"

# Single-pass arg scan: script-level flags can appear at any position (not just
# before the subcommand), so a `for` here, not a `while + break`.
mode="run"
verbose=0
fwd_args=()
for arg in "$@"; do
  case "$arg" in
    --install|--install-on-path) mode="install" ;;
    --uninstall)                 mode="uninstall" ;;
    --bootstrap-only)            mode="bootstrap" ;;
    --verbose)                   verbose=1 ;;
    --help|-h)                   mode="help" ;;
    *)                           fwd_args+=("$arg") ;;
  esac
done

# Real path of this script regardless of how we were invoked (direct path or
# a symlink such as FUNES_BIN after --install).  Used by --install/--uninstall
# to compare against the symlink target.
SELF="$(realpath "$0" 2>/dev/null || readlink -f "$0" 2>/dev/null || echo "$0")"

if [ "$mode" = "help" ]; then
  sed -n '2,30p' "$0"
  exit 0
fi

# Docker check is needed for any mode that triggers a stage; install also
# bootstraps, so it needs docker too.  uninstall does not, unless the
# overlay has gone missing on a system that still relies on it.
need_docker=1
[ "$mode" = "uninstall" ] && [ -x "$OVERLAY_DIR/lib/ld-linux-x86-64.so.2" ] && need_docker=0
if [ "$need_docker" = "1" ]; then
  command -v docker >/dev/null 2>&1          || { echo "patch_funes: docker not on PATH (install docker, or set PATCH_FUNES_OVERLAY to a pre-staged dir)" >&2; exit 1; }
  docker info >/dev/null 2>&1                || { echo "patch_funes: docker daemon unreachable (start the daemon or check perms)" >&2; exit 1; }
fi

# === stage overlay (idempotent; gated by image marker) ===
stage_overlay() {
  mkdir -p "$OVERLAY_DIR/lib" "$OVERLAY_DIR/usr-lib"
  local marker="$OVERLAY_DIR/.image-marker"
  if [ -f "$marker" ] && [ "$(cat "$marker" 2>/dev/null || true)" = "$UBUNTU_IMAGE" ] && [ -x "$OVERLAY_DIR/lib/ld-linux-x86-64.so.2" ]; then
    return 0
  fi
  echo "[patch_funes] staging glibc from $UBUNTU_IMAGE into $OVERLAY_DIR ..." >&2
  local cid
  cid=$(docker create "$UBUNTU_IMAGE" bash)
  trap 'docker rm -f "$cid" >/dev/null 2>&1 || true' EXIT
  # Copy directory *contents* (./) so the overlay layout is $OVERLAY_DIR/lib/...
  # rather than $OVERLAY_DIR/lib/x86_64-linux-gnu/...
  docker cp "$cid:/lib/x86_64-linux-gnu/." "$OVERLAY_DIR/lib/"
  docker cp "$cid:/usr/lib/x86_64-linux-gnu/." "$OVERLAY_DIR/usr-lib/" 2>/dev/null || true
  docker rm -f "$cid" >/dev/null 2>&1 || true
  trap - EXIT
  printf '%s\n' "$UBUNTU_IMAGE" > "$marker"
}

# === install: rename FUNES_BIN to .dist, symlink FUNES_BIN -> this script ===
do_install() {
  stage_overlay

  # Already installed?  Refuse silently unless it's our symlink, in which case
  # this is a no-op replay.
  if [ -L "$FUNES_BIN" ]; then
    local target
    target="$(readlink -f "$FUNES_BIN" 2>/dev/null || echo "$FUNES_BIN")"
    if [ "$target" = "$SELF" ]; then
      echo "[patch_funes] already installed: $FUNES_BIN -> $SELF" >&2
      return 0
    fi
    echo "[patch_funes] $FUNES_BIN is a symlink to $target; refusing to overwrite" >&2
    return 1
  fi
  if [ -e "$FUNES_BIN.dist" ]; then
    echo "[patch_funes] $FUNES_BIN.dist already exists; refusing to overwrite.  Remove it manually first." >&2
    return 1
  fi
  if [ ! -e "$FUNES_BIN" ]; then
    echo "[patch_funes] $FUNES_BIN does not exist; nothing to install" >&2
    return 1
  fi

  mv "$FUNES_BIN" "$FUNES_BIN.dist"
  ln -s "$SELF" "$FUNES_BIN"
  echo "[patch_funes] installed: $FUNES_BIN -> $SELF" >&2
  echo "[patch_funes] original binary preserved at $FUNES_BIN.dist" >&2
  echo "[patch_funes] run \`patch_funes --uninstall\` to revert" >&2
}

# === uninstall: remove symlink, restore .dist ===
do_uninstall() {
  if [ -L "$FUNES_BIN" ] && [ -e "$FUNES_BIN.dist" ]; then
    local target
    target="$(readlink -f "$FUNES_BIN" 2>/dev/null || echo "$FUNES_BIN")"
    if [ "$target" = "$SELF" ]; then
      rm "$FUNES_BIN"
      mv "$FUNES_BIN.dist" "$FUNES_BIN"
      echo "[patch_funes] uninstalled: $FUNES_BIN restored from $FUNES_BIN.dist" >&2
      return 0
    fi
    echo "[patch_funes] $FUNES_BIN is a symlink but not to $SELF; manual cleanup needed" >&2
    return 1
  fi
  echo "[patch_funes] nothing to uninstall ($FUNES_BIN.dist not found)" >&2
  return 0
}

case "$mode" in
  install)    do_install;    exit 0 ;;
  uninstall)  do_uninstall;  exit 0 ;;
  bootstrap)  stage_overlay;  exit 0 ;;
  run)        stage_overlay  ;;
esac

# === run ===

# Pick the actual binary: after --install, FUNES_BIN points at this script
# and the real binary lives at FUNES_BIN.dist.  Always prefer .dist if it
# exists; absent that, fall back to FUNES_BIN (pre-install state).
if [ -e "$FUNES_BIN.dist" ]; then
  REAL_FUNES_BIN="$FUNES_BIN.dist"
else
  REAL_FUNES_BIN="$FUNES_BIN"
fi
[ -x "$REAL_FUNES_BIN" ] || { echo "patch_funes: $REAL_FUNES_BIN not executable" >&2; exit 1; }

NEW_LD="$OVERLAY_DIR/lib/ld-linux-x86-64.so.2"
[ -x "$NEW_LD" ] || { echo "patch_funes: missing $NEW_LD — overlay stage failed" >&2; exit 1; }

# Overlay first (libc, libpthread, libm, libdl, libresolv, libnss_*, ...),
# then host lib paths so non-glibc deps (libstdc++, ...) stay resolvable.
LIBPATH="$OVERLAY_DIR/lib:$OVERLAY_DIR/usr-lib:$HOST_LIB_PATHS"

if [ "$verbose" = "1" ]; then
  ELF_VERSION="$("$NEW_LD" --version 2>&1 | head -1 || true)"
  printf '\033[1;34m[patch_funes]\033[0m %s via %s\n  ld:   %s\n' "$REAL_FUNES_BIN" "$UBUNTU_IMAGE" "$ELF_VERSION" >&2
fi

exec "$NEW_LD" --library-path "$LIBPATH" "$REAL_FUNES_BIN" "${fwd_args[@]}"
