#!/bin/sh -eu

if (\syspatch | \grep -qi 'create unique kernel'); then
	\sleep 5;
	\reboot
fi

exit 0