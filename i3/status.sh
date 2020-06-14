#!/usr/bin/env bash

tick="$(date -u +%s)"
refresh=5

while true
do
	disk=$(df --output=avail -mh / | tail -1 | tr -d ' ')
	ip=$(get-ip)
	date=$(date "+%Y-%m-%d %H:%M:%S")

	if [ "${forecast}" = "" ] || [ "$(($tick-$forecast_tick))" -gt 60 ];
	then
		forecast=$(weather)
		forecast_tick="$(date -u +%s)"
	fi

	printf "${ip} | ${disk} | ${forecast} | ${date}\n"  || exit 1
	tick="$(date -u +%s)"
	sleep ${refresh}
done
