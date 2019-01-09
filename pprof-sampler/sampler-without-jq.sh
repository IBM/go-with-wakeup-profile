#!/bin/bash
set -e -o pipefail

: ${SAMPLING_RATE:?Specify the sampling rate as SAMPLING_RATE}

addresses=("localhost:6060")
suffixes=("pprof" "wakeup" "block")

declare -A paths

paths["pprof"]="/debug/pprof/goroutine?debug=2"
paths["wakeup"]="/debug/pprof/wakeup?debug=2&rate=1000"
paths["block"]="/debug/pprof/block?debug=1"

while true; do
        sleep $SAMPLING_RATE
        date_time=$(date +"%Y%m%d-%H%M%S")
        (
                mkdir -p $date_time
                cd $date_time
                for address in ${addresses[@]}; do
                        node=${address%:*}
                        for suffix in ${suffixes[@]}; do
                                path=${paths[$suffix]}
                                curl -s "http://${address}${path}" > $address.$suffix &
                        done
                done
        ) &
done

