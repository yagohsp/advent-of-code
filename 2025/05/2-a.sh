# puzzle_file="./example.txt"
# puzzle_file="./dev.txt"
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
        # echo "start $start-$end"
        ranges+=("$start-$end")
        continue
    elif (( len == 1)); then
        range_prev=${ranges[0]}
        range_prev_start=${range_prev%-*}

        if (( start <= range_prev_start )); then
            # echo "second start $start-$end"
            ranges=("$start-$end" ${ranges[@]:0:1})
        else
            # echo "second end $start-$end"
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

echo $miss_count

for ((i = 1; i <= len; i++)); do
    range=${ranges[$i]}
    start=${range%-*}
    end=${range##*-}

    i_prev=$(( i - 1))

    range_prev=${ranges[$i_prev]}
    range_prev_start=${range_prev%-*}
    range_prev_end=${range_prev##*-}

    if (( start <= range_prev_end )); then
        ranges[$i_prev]="$range_prev_start-$end"
        ranges=(${ranges[@]:0:i} ${ranges[@]:i+1:999})

        i=$(( i-1 ))
        len=$(( len-1 ))
    fi
done

count=0
for range in ${ranges[@]}; do
    # echo $range

    start=${range%-*}
    end=${range##*-}

    count=$((count + end - start + 1))
done

for i in ${!ranges[@]}; do
    range=${ranges[$i]}
    start=${range%-*}
    end=${range##*-}

    for j in ${#ranges[@]}; do
        range_j=${ranges[$j]}
        start_j=${range_j%-*}
        end_j=${range_j##*-}

        if (( i != j && end == end_j )); then
            echo "$start-$end and $end-$end_j"
            :
        fi
    done


    count=$((count + end - start + 1))
done

echo $count
