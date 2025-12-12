#!/bin/bash

# puzzle_file="./example.txt"
puzzle_file="./puzzle.txt"

ranges=()

miss_count=0
while read line; do
    if [[ $line == "" ]]; then
        break
    fi

    start=${line%-*}
    end=${line##*-}

    miss_count=$(( miss_count + 1 + end - start))

    len=${#ranges[@]}

    if (( len == 0 )); then
        # echo "first $start-$end"
        ranges+=("$start-$end")
        continue
    elif (( len == 1)); then
        range_prev=${ranges[0]}
        range_prev_start=${range_prev%-*}

        if (( start <= range_prev_start )); then
            # echo "second before $start-$end"
            ranges=("$start-$end" ${ranges[@]:0:1})
        else
            # echo "second next $start-$end"
            ranges+=("$start-$end")
        fi
        continue 2
    fi

    for ((i = 0; i < len; i++)); do
        range_next=${ranges[$i]}
        range_next_start=${range_next%-*}

        if (( start <= range_next_start )); then
            # echo "place $start before $range_next_start "

            ranges=(${ranges[@]:0:i} "$start-$end" ${ranges[@]:i:99999})
            # echo ${ranges[@]}

            continue 2
        fi
    done

    # echo "end $start-$end"
    ranges+=("$start-$end")
done < $puzzle_file

# echo ${ranges[@]}
# echo "------"

# echo "base $miss_count"

for ((i = 1; i <= len; i++)); do
    range=${ranges[$i]}
    start=${range%-*}
    end=${range##*-}

    i_prev=$(( i - 1))

    range_prev=${ranges[$i_prev]}
    range_prev_start=${range_prev%-*}
    range_prev_end=${range_prev##*-}

    if [[ $range == $range_prev ]]; then
        ranges=(${ranges[@]:0:i} ${ranges[@]:i+1:99999})
        (( i-- ))
        (( len-- ))
        continue
    fi

    if (( start <= range_prev_end )); then
        # echo "fix $range with $range_prev"
        start=$(( range_prev_end + 1 ))

        if (( start > end)); then
            # echo "remove $start-$end"
            ranges=(${ranges[@]:0:i} ${ranges[@]:i+1:99999})
            (( i-- ))
            (( len-- ))
            continue
        fi

        ranges[$i]="$start-$end"
        echo "${ranges[$i]}"
    fi
done

# echo ${ranges[@]}
# echo "------"

count=0
for range in ${ranges[@]}; do
    # echo $range

    start=${range%-*}
    end=${range##*-}

    count=$((count + end - start + 1))
done

echo "total $count"
