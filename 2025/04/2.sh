#!/bin/bash

# puzzle_file="./puzzle.txt"
puzzle_file="./example.txt"

mapfile -t lines < $puzzle_file

cols_len=${#lines[0]}
rows_len=${#lines[@]}

declare -A rows
declare -A columns
declare -A d_main
declare -A d_secondary
i=0
j=0
for ((i = 0; i < rows_len; i++)); do
    line=${lines[$i]}

    for ((j = 0; j < cols_len; j++)); do
        char=${line:j:1}

        if [[ $char == "@" ]]; then
            rows[$i]=$((rows[$i]+1))
            columns[$j]=$((columns[$j]+1))

            dl=$((i-j))
            d_main[$dl]=$((d_main[$dl]+1))

            dr=$((i+j))
            d_secondary[$dr]=$((d_secondary+1))
        fi
    done
done

echo ${rows[@]}
echo ${columns[@]}

echo ${d_main[@]}
echo ${d_secondary[@]}

i=0
j=0
for ((i = 0; i < rows_len; i++)); do
    line=${lines[$i]}

    for ((j = 0; j < cols_len; j++)); do
        if [[ $char == "@" ]]; then
            if [[ $((${rows[$i]} - 1)) < 4 || $((${columns[$j]}-1)) < 4 ]]; then
                echo "menor"
            fi
        fi
    done
done
