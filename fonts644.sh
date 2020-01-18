#!/bin/sh
if ! [ $(id -u) = 0 ]; then
	   echo "The script need to be run as root." >&2
	      exit 1
fi

cd /usr/share/fonts 
find -type d -exec chmod 755 {} \;
find -type f -exec chmod 644 {} \;
