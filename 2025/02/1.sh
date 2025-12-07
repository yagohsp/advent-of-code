#!/bin/bash

file="./puzzle.txt"
puzzle=$(<$file)

OLD_IFS=$IFS
IFS=,

set -f
set -- $puzzle

ranges=()

for field in "$@"; do
    ranges+=("$field")
done

IFS=-

count=0

for range in "${ranges[@]}"; do
    set -- $range

    ids=()
    for id in "$@"; do
        ids+=("$id")
    done

    x=$(( ids[0] ))
    end=$(( ids[1] ))

    # echo "from $x to $end"

    while [[ x -le end ]]; do

        size=${#x}
        isEven=$(( size % 2 ))

        if [[ isEven -eq 0 ]]; then
            # echo "$x is even"

            half=$(( size / 2 ))

            half1=${x:0:half}
            half2=${x:half:size}

            if [[ $half1 == $half2 ]]; then
                # echo -e "$half1 - $half2 \033[0;31mEQUAL\033[0m"

                count=$(( count + x))
            else
                # echo "$half1 - $half2 not equal"
                :
            fi


        else
            # echo "$x is odd"
            :
        fi

        x=$((x+1))
    done
done

echo "$count"

set +f
IFS=$OLD_IFS
