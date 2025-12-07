#!/bin/bash

file="./puzzle.txt"
puzzle=$(<$puzzle_file)

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

    id=$(( ids[0] ))
    end=$(( ids[1] ))

    while [[ id -le end ]]; do
        # echo "$id/$end"
        size=${#id}

        halfCounter=1
        half=$(( size / 2))

        # echo "try $half times"
        while [[ halfCounter -le half ]]; do
            res=$(( size % halfCounter))

            # echo "$halfCounter good"
            if [[ res -eq 0 ]]; then
                j=0

                n_divisions=$(( size / halfCounter))
                skip=0
                # echo "skip is $skip"
                while [[ j -lt n_divisions && skip -eq 0 ]]; do
                    x0=${id:0:halfCounter}
                    x1=${id:halfCounter*j:halfCounter}

                    # echo "compare $x0 and $x1"
                    if [[ $x0 != $x1 ]]; then
                        # echo "break at $x0 != $x1"
                        skip=1
                        break
                    fi

                    j=$((j+1))
                done

                # echo "skip is $skip"
                if [[ skip -eq 0 ]]; then
                    echo "$id IS VALID for $x0"
                    count=$(( count + id))
                    break
                fi
            else
                :
                # echo "$i bad"
            fi

            halfCounter=$((halfCounter+1))
            # echo "-"
        done

        id=$((id+1))
        # echo "-----"
    done
done

echo "$count"

set +f
IFS=$OLD_IFS
