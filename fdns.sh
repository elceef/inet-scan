#!/bin/bash

#zmap -M udp -p 53 -q -v 0 -o - -i $1 -B 1M --probe-args=file:ednsreq.bin -f "saddr,data" $2 | stdbuf -i0 -o0 -e0 awk -F, '{if(length($2)>1100) print $1}'
zmap -M udp -p 53 -q -v 0 -o - -i $1 -B 1M --probe-args=file:ednsreq.bin -f "saddr,data" $2 | stdbuf -i0 -o0 -e0 awk -F, '{print $1" "length($2)}'

exit

IP=`zmap -M udp -p 53 -q -v 0 -o - -i $1 -B 1M $2`
for i in $IP; do
	ROOT=`timeout 1 dig . any +edns=0 @$i | grep root-servers`
	if [ -n "$ROOT" ]; then
		echo $i
	fi
done
