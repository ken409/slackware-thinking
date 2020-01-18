#!/bin/bash

PROCESS="Xorg"

function get_pid_x { 
	PID=""
	while [ ! $PID ]; do
		PID=$(pidof $1)
		sleep 1
	done
	echo $PID
}

function get_cpu_x { 
	echo $(top -b -p $1 -n 2 | tail -n 1 | awk '{print $9}' | cut -d "." -f 1) 
}

pid=$(get_pid_x $PROCESS)
while true; do
	if (( $(get_cpu_x $pid) > 80 )); then
		s=4
		while (( $s > 0 )); do
			sleep 1
			s=$(($s-1))
			echo "s=$s"
			echo $cpu
			if (( $(get_cpu_x $pid) < 80 )); then
				break
			elif (( $(get_cpu_x $pid) > 80 && $s == 0 )); then
				#kill $pid
				kill $(pidof fcitx)
				fcitx & 
				sleep 1 && fcitx-remote -t
				pid=$(get_pid_x $PROCESS)
			fi
		done
	fi
	sleep 10 
done
