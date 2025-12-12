#!/bin/bash

puzzle_file="./puzzle.txt"
# puzzle_file="./example.txt"

readarray -t lines < $puzzle_file

lines[0]=${lines[0]//S/|}

count=0
lines_len=${#lines[@]}
for ((i = 1; i <= lines_len - 1; i++)); do
    line=${lines[$i]}
    prev_line=${lines[$i-1]}

    # echo "$prev_line - ${#prev_line}"
    # echo "$line - ${#line}"
    # echo "="

    for ((j = 0; j < ${#line}; j++)); do
        current=${line:j:1}
        previous=${prev_line:j:1}

        if [[ $previous == "|" ]]; then
            if [[ $current == "^" ]]; then
                (( count++ ))
                line="${line:0:j-1}|.|${line:j+2:9999}"
            else
                line="${line:0:j}|${line:j+1:9999}"
            fi
        fi
    done

    lines[$i]=$line

    # echo ${lines[$i]}
    # echo ""
done

echo $count
