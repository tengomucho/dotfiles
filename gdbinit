set history save

set history filename ~/.gdb_history

# Syntax color from:
# http://attila-ssvr.blogspot.com/2012/03/gdb-disassembly-and-source-syntax.html

shell rm -f /tmp/colorPipe
shell mkfifo /tmp/colorPipe

define logging_on
  set logging redirect on
  set logging on /tmp/colorPipe
end

define logging_off
  set logging off
  set logging redirect off
  shell sleep 0.1s
end

define highlight
   echo \n
   shell cat /tmp/colorPipe  | c++filt | highlight --syntax=$arg0 -Oxterm256 &
end

define hook-disassemble
  highlight asm
  logging_on
end

define hookpost-disassemble
  logging_off
end

define hook-list
  highlight C++
  logging_on
end

define hookpost-list
  logging_off
end

define hook-quit
  shell rm /tmp/colorPipe
end
add-auto-load-safe-path /home/alvaromo/Dev/apeak/.gdbinit
