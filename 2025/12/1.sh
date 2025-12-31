#!/bin/bash

puzzle_file="./puzzle.txt"

mapfile -t lines < "$puzzle_file"
lines=("${lines[@]:30}")

total=0
for line in "${lines[@]}"; do
    cords=${line%:*}
    presents_n_str=${line#*: }

    IFS='x' read x y <<< "$cords"
    IFS=' ' read -a presents_n <<< "$presents_n_str"

    counts=0
    for present_n in "${presents_n[@]}"; do
        counts=$(( present_n + counts))
    done

    area=$(bc <<EOF
scale=6
($x / 3) * ($y / 3)
EOF
    )

    result=$(bc <<EOF
$area >= $counts
EOF
    )

    if (( result )); then
        total=$((total + 1))
    fi
done

echo "$total"
