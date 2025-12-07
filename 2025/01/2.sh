#!/bin/bash

file="./puzzle.txt"

total=50
count=0

while read line; do
    letter=${line%%[0-9]*}
    number=${line##*[!0-9]}

    modulus=$((number/100))
    count=$((count+modulus))

    number=$((number%100))

    pre=$total

    if [[ $letter == "L" ]]; then
        echo "$total - $number"

        total=$((total-number))

        if [[ $total -lt 0 ]]; then
            total=$((total+100))

            if [[ $pre -ne 0 ]]; then
                echo "click"
                count=$((count+1))
            fi
        fi

    else
        echo "$total + $number"

        total=$((total+number))

        if [[ $total -gt 100 ]]; then
            total=$((total-100))

            if [[ $pre -ne 0 ]]; then
                echo "click"
                count=$((count+1))
            fi
        fi
    fi

    if [[ $total -eq 0 || $total -eq 100 ]]; then
        count=$((count+1))
        total=0
        echo "click zero"
    fi

    echo "end $total"
    echo "----"

done < $file


if [[ $total -eq 100 || $total -eq 0 ]]; then
    count=$(( $count + 1 ))
fi

# echo "6133?"
echo $count
