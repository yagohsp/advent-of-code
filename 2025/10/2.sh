#!/bin/bash

puzzle_file="./puzzle.txt"

mapfile -t lines < "$puzzle_file"

total=0
for line in "${lines[@]}"; do
    line=${line#* }

    buttons_str=${line% \{*}
    buttons_str=${buttons_str//[()]/}
    read -a buttons <<< "$buttons_str"

target_joltage_str=${line##*) }
target_joltage_str=${target_joltage_str//[{\}]/}

    IFS=',' read -a targets <<< "$target_joltage_str"
    vars=()

    str="min:"

    for i in "${!buttons[@]}"; do
        button=${buttons[$i]}
        IFS=',' read -a joltage_indexes <<< $button

        for joltage_index in "${joltage_indexes[@]}"; do
            if [[ -z ${vars[$joltage_index]} ]]; then
                vars[$joltage_index]="x${i}"
            else
                vars[$joltage_index]="${vars[$joltage_index]} + x${i}"
            fi
        done

        str+=" x${i}"
    done
    str+=$';\n\n'


    for i in "${!targets[@]}"; do
        str+="${vars[$i]} = ${targets[$i]};"
        str+=$'\n'
    done
    str+=$'\n'

    str+="int"
    for i in "${!buttons[@]}"; do
        str+=" x${i},"
    done
    str=${str:0:${#str} - 1}
    str+=";"

    result=$(lp_solve <<< "$str")

    c=0
    sum=0
    while IFS='\n' read -a result_line; do
        if (( c <= 3)); then
            (( c++ ))
            continue
        fi

        button_presses="${result_line##* }"
        sum=$(( sum + button_presses))

        (( c++ ))
    done <<< "$result"
    total=$(( total + sum ))
done

echo $total
