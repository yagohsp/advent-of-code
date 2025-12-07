#!/bin/bash

puzzle_file="./puzzle.txt"
# puzzle_file="./example.txt"


count=0
while read line; do

    size=$(( ${#line}  - 1))
    x1=${line:0:1}
    x2=${line:1:1}

    i=2
    while [[ $i -le $size ]]; do
        number=${line:i:1}

        if [[ $x1$number -gt $x1$x2 && $x1$number -gt $x2$number ]]; then
            x2=$number
        elif [[ $x2$number -gt $x1$x2 ]]; then
            x1=$x2
            x2=$number
        fi

        ((i++))
    done

    res=$x1$x2
    count=$(( count + res ))
    echo $x1$x2

done < $puzzle_file

echo "$count"
