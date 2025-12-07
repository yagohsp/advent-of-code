#!/bin/bash

file="./puzzle.txt"

if [[ ! -f "$file" ]]; then
    echo "file not found"
    exit 1
fi

total=50
count=0

resolve(){
    if [[ total -gt 99 ]]; then
        total=$((total - 100))
        resolve
    elif [[ total -lt 0 ]]; then
        total=$((100 + total))
        resolve
    elif [[ total -eq 0 ]]; then
        count=$((count+1))
    fi
}

while read line; do
    letter=${line%%[0-9]*}
    number=${line##*[!0-9]}


    if [[ $letter = "L" ]]; then
        # echo "$total-$number"
        total=$((total-number))
    else
        # echo "$total+$number"
        total=$((total+number))
    fi

    echo $total

    resolve

    echo "result $total"

    echo "----"

done < $file

echo ""
echo $count

