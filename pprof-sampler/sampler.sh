#!/bin/bash
set -e -o pipefail

: ${SAMPLING_RATE:?Specify the sampling rate as SAMPLING_RATE}

config=/config.json

if [[ ! -f $config ]]; then
	echo "Config file $config does not exist"
	exit 1
fi

addresses="$(jq -r '.addresses[]' $config)"
suffixes="$(jq -r '.paths|keys[]' $config)"

declare -A paths

for suffix in $suffixes; do
	paths[$suffix]=$(jq -r ".paths[\"$suffix\"]" $config)
done

while true; do
	sleep $SAMPLING_RATE
	date_time=$(date +"%Y%m%d-%H%M%S")
	(
		mkdir -p $date_time
		cd $date_time
		for address in $addresses; do
			node=${address%:*}
			for suffix in $suffixes; do
				path=${paths[$suffix]}
				curl -s "http://${address}${path}" > $address.$suffix &
			done
		done
	) &
done
