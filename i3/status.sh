#!/usr/bin/env bash

while true
do
	disk=$(df --output=avail -mh / | tail -1 | tr -d ' ')
	forecast=$(weather)
	ip=$(get-ip)

    printf "${ip} | ${disk} | ${forecast}\n"  || exit 1
	sleep 1
done
