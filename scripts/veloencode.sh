#!/bin/bash

if [ -z "$2" ]; then
	echo "
Usage: $0 <local_path> <remote_path> [max_line_size]

 Encode file to transfer it over serial port without uudecode
  !! Very slow !!
 Use an archive with necessary files only whenever possible

 Steps:

 1. Encode file on any PC with bash (must have 'xxd' installed)
   $0 archive.tgz /tmp/archive.tgz
 2. Put newly created decode-*.sh file to host
 (PC with serial connection to embedded device)
 3. Use decode-*.sh file as a script for serial terminal
   Example for Windows with putty/plink:
     3.1. Create & save 'serial' session in putty
     3.2. Open cmd.exe
     3.2. Call plink for saved session while reading input from file:
       plink -load COM3 < decode-archive.tgz-123456.sh
     3.4. Wait for a while
   Alternative way for Windows, if COM port can't handle too much data:
     3.1. Use very small max line size (e.g. 20)
     3.2. Update decode-* file to include Windows line endings:
       sed -i -e 's/\r$//' -e 's/$/\r/' decode-archive.tgz-123456.sh
     3.3. Install RealTerm
     3.4. Goto 'Port', set correct 'Baud', press 'Change'
     3.5. Goto 'Send', check 'Literal', set 100ms delay per line
     3.6. Select file and press 'Send File'
     3.7. Wait a lot (better leave this for a night)
   Example for *nix:
     sudo sh -c 'cat decode-archive.tgz-123456.sh > /dev/ttyUSB0'
"
	exit 1
fi

trap 'echo "Error at $LINENO: $BASH_COMMAND"; exit 1;' ERR

len="${3:-1000}"

test -f "$1"
test "$len" -ge 1
hash xxd

size=$(stat -c %s "$1")

f="decode-$(basename "$2")-$size.sh"
echo "rm -f '$2'" > "$f"

o=0
while [ $o -lt $size ]; do
	s="printf '"

	while read b; do
		s+="\\x$b"
	done < <(xxd -p -c 1 -s $o -l $len "$1")
	let o=o+len

	echo "$s' >> '$2'" >> "$f"
done

chmod a+x "$f"
echo "Done: $f"

