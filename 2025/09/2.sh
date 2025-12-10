# puzzle_file="./dev.txt"
puzzle_file="./example.txt"
# puzzle_file="./puzzle.txt"

readarray -t lines < $puzzle_file

max=0

lines+=("${lines[0]}")

declare -A map

max_x=0
max_y=0

function print_map(){
    for ((x = 0; x <= max_x + 1; x++)); do
        str=""
        for ((y = 0; y <= max_y + 1; y++)); do

            c=${map[$x,$y]}
            if [[  $c == "#" ]]; then
                str+="#"
            elif [[ $c == "O" ]]; then
                str+="O"
            else
                str+="."
            fi
        done
        echo $str
    done
}

for ((i = 0; i < ${#lines[@]} - 1; i++)); do
    range_i=${lines[$i]}
    IFS=',' read -ra range <<< "$range_i"

    y=${range[0]}
    x=${range[1]}

    if (( y > max_y ));then
        max_y=$y
    fi

    if (( x > max_x ));then
        max_x=$x
    fi

    map[$x,$y]="O"

    range_next_i=${lines[$i + 1]}
    IFS=',' read -ra range_next <<< "$range_next_i"

    y_next=${range_next[0]}
    x_next=${range_next[1]}

    if (( x == x_next));then
        # echo "move through y - $range_i $range_next_i"

        start=$y
        end=$y_next
        if (( y > y_next ));then
            start=$y_next
            end=$y
        fi

        for ((pos_y = $start+1; pos_y < end; pos_y++)); do
            map[$x,$pos_y]="#"
        done
    else
        # echo "move through x - $range_i $range_next_i"

        start=$x
        end=$x_next
        if (( x > x_next ));then
            start=$x_next
            end=$x
        fi

        for ((pos_x = $start+1; pos_x < end; pos_x++)); do
            map[$pos_x,$y]="#"
        done
    fi
done

print_map

for ((x = 0; x <= max_x + 1; x++)); do
    inside=0
    printing=0
    for ((y = 0; y <= max_y + 1; y++)); do

        c=${map[$x,$y]}

        if (( inside == 1 )); then
            if [[ $c == "O" ]]; then
                inside=0
                printing=0
            elif [[ $c == "#" && $printing -eq 1 ]]; then
                printing=0
                inside=0
            elif [[ $c == "" || $printing -eq 1 ]]; then
                map[$x,$y]="#"
                printing=1
            fi
        else
            if [[ $c == "#" || $c == "O" ]]; then
                inside=1
            fi
        fi

    done
done


print_map


# max=0
# for ((i = 0; i < ${#lines[@]} - 2; i++)); do
#     range_i=${lines[$i]}
#     IFS=',' read -ra range <<< "$range_i"
#
#     y=${range[0]}
#     x=${range[1]}
#
#     current_x=$x
#
#     while (( current_x <= max_x )); do
#         # echo "$range_i"
#
#         if [[ ${map[$x,$y]} == "O" || ${map[$x,$y]} == "#" ]]; then
#             # echo "at $current_x $y"
#             :
#         fi
#         (( current_x++ ))
#     done
#     # echo "-----"
# done
