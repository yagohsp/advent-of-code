#!/bin/bash

# puzzle_file="./puzzle.txt"
# puzzle_file="./example.txt"
puzzle_file="./dev.txt"

RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m'

clear
tput civis

count=0
while read line; do
    echo -ne "\033[1;1H$line"\\r

    size=${#line}
    # echo "size: $size"

    start=0
    len=$((size - 12 + 1))
    number=""

    while [[ ${#number} -le 11 ]]; do
        part=${line:start:len}
        part_len=${#part}

        # echo -ne "\033[2;1H$part"\\r

        i=0
        biggest=0
        biggest_i=0

        for (( i=0; i<part_len; i++ )); do
            digit=${part:i:1}
            if (( digit > biggest )); then
                biggest_i=$i
                biggest=$digit
                if [[ biggest -eq 9 ]]; then
                    i=100
                fi
            fi

            str="$PURPLE$number$NC"
            j=0
            for (( j=0; j<part_len; j++ )); do
                if [[ $j == $biggest_i ]];then
                    str="$str$GREEN"
                    elif [[ $j == $i ]];then
                    str="$str$RED"
                fi

                str="$str${part:j:1}$NC"
            done


            echo -ne "\033[2;1H$str${line:start+${#part}:100}"\\r
            sleep .3
        done

        number="$number$biggest"

        echo -ne "\033[4;1H$number"\\r

        len=$(( len - biggest_i ))
        start=$(( start + biggest_i + 1 ))
    done

    count=$(( count + number ))

done < $puzzle_file

echo "$count"
tput cnorm
