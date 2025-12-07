#!/bin/bash

puzzle_file="./puzzle.txt"
# puzzle_file="./dev.txt"
# puzzle_file="./example.txt"

mapfile -t lines < $puzzle_file

cols_len=${#lines[0]}
rows_len=${#lines[@]}

i=0
j=0

rerun=1
while (( rerun == 1 )); do
    sub_total=0

    for ((i = 0; i < rows_len; i++)); do
        line_t=${lines[$i-1]}
        line=${lines[$i]}
        line_b=${lines[$i+1]}

        for ((j = 0; j < cols_len; j++)); do
            char=${line:j:1}
            if [[ $char == "@" ]]; then
                count=0

                if (( i != 0 )); then
                    # top-left
                    if [[ j -ne 0 ]] && [[ ${line_t:j-1:1} == "@" ]] ; then
                        count=$(( count + 1 ))
                    fi

                    # top
                    if [[ ${line_t:j:1} == "@" ]]; then
                        count=$(( count + 1 ))
                    fi

                    # top-right
                    if [[ j -ne cols_len ]] && [[ ${line_t:j+1:1} == "@" ]]; then
                        count=$(( count + 1 ))
                    fi
                fi
                if (( i != rows_len )); then
                    # bottom-left
                    if [[ j -ne 0 ]] && [[ ${line_b:j-1:1} == "@" ]]; then
                        count=$(( count + 1 ))
                    fi

                    # bottom
                    if [[ ${line_b:j:1} == "@" ]]; then
                        count=$(( count + 1 ))
                    fi

                    # bottom-right
                    if [[ j -ne cols_len ]] && [[ ${line_b:j+1:1} == "@" ]]; then
                        count=$(( count + 1 ))
                    fi
                fi

                # left
                if [[ j -ne 0 ]] && [[ ${lines[$i]:j-1:1} == "@" ]]; then
                    count=$(( count + 1 ))
                fi

                # right
                if [[ j -ne cols_len ]] && [[ ${lines[$i]:j+1:1} == "@" ]]; then
                    count=$(( count + 1 ))
                fi

                # sub_total
                if [[ count -lt 4 ]]; then

                    lines[$i]="${lines[$i]:0:j}.${lines[$i]:j+1:9999}"
                    sub_total=$(( sub_total + 1 ))
                fi
            fi
        done
    done

    total=$(( total + sub_total ))
    if (( sub_total == 0)); then
        rerun=0
    fi
done

echo $total
