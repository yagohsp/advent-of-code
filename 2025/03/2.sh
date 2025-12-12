#!/bin/bash

# puzzle_file="./puzzle.txt"
puzzle_file="./example.txt"


count=0
while read line; do
    # echo $line

    size=${#line}

    # echo "size: $size"

    start=0
    len=$((size - 12 + 1))
    number=""

    while [[ ${#number} -le 11 ]]; do
        part=${line:start:len}

        # echo "$part"
        # echo "$((start + 1))-$((start + len))"

        i=0
        biggest=0
        biggest_i=0
        part_len=${#part}

        for (( i=0; i<part_len; i++ )); do
            digit=${part:i:1}

            if (( digit > biggest )); then
                biggest_i=$i
                biggest=$digit
                (( biggest == 9 )) && break
            fi
        done

        number="$number$biggest"

        # echo "biggest: $biggest index: $biggest_i"
        # echo "number: $number"

        len=$(( len - biggest_i ))
        start=$(( start + biggest_i + 1 ))

        # echo ""
    done

    # echo $number

    count=$(( count + number ))

done < $puzzle_file

echo "$count"
