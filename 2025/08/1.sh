# puzzle_file="./example.txt"
# puzzle_file="./dev.txt"
puzzle_file="./puzzle.txt"

readarray -t lines < $puzzle_file
how_many_to_count=10

if (( ${#lines[@]} > 100 )); then
    how_many_to_count=1000
fi

get_distance() {
    a=$1
    b=$2

    a_x=${points["$a,x"]}
    a_y=${points["$a,y"]}
    a_z=${points["$a,z"]}

    b_x=${points["$b,x"]}
    b_y=${points["$b,y"]}
    b_z=${points["$b,z"]}

    diff_x=$(( b_x - a_x ))
    (( diff_x < 0 )) && diff_x=$(( -diff_x ))
    x=$(( diff_x * diff_x ))

    diff_y=$(( b_y - a_y ))
    (( diff_y < 0 )) && diff_y=$(( -diff_y ))
    y=$(( diff_y * diff_y ))

    diff_z=$(( b_z - a_z ))
    (( diff_z < 0 )) && diff_z=$(( -diff_z ))
    z=$(( diff_z * diff_z ))

    sum=$(( x + y + z ))
    local distance=$( echo "scale=2; sqrt($sum)" | bc )
    distance=${distance//./}

    echo $distance
}

distances_indexes=()
add_to_sorted_array(){
    index=$1

    len=${#distances_indexes[@]}
    if (( len == 0 ));then
        distances_indexes+=("$index")
        return
    fi

    new_distance=${distances[$key]}

    for ((n = 0; n <= len; n++)); do
        if (( n == len )); then
            distances_indexes+=("$index")
            return
        fi

        current_distance_index=${distances_indexes[$n]}
        current_distance=${distances[$current_distance_index]}

        if (( n == 0 && new_distance <= current_distance )); then
            # echo "at start - $new_distance <= $current_distance "
            distances_indexes=("$index" "${distances_indexes[@]}")
            return
        fi

        previous_distance_index=${distances_indexes[$n - 1]}
        previous_distance=${distances[$previous_distance_index]}

        if (( previous_distance <= new_distance && new_distance <= current_distance )); then
            # echo "$previous_distance <= $new_distance <= $current_distance"
            distances_indexes=("${distances_indexes[@]:0:$n}" "$index" "${distances_indexes[@]:$n}")
            return
        fi
    done

}

declare -A points
declare -A distances

for i in ${!lines[@]}; do
    line=${lines[$i]}

    IFS=',' read -a line_points <<< "$line"

    x=${line_points[0]}
    y=${line_points[1]}
    z=${line_points[2]}

    points["$i,x"]=$x
    points["$i,y"]=$y
    points["$i,z"]=$z
done

for i in ${!lines[@]}; do

    echo $i

    for j in ${!lines[@]}; do
        if (( i != j )); then
            key="$i-$j"
            key2="$j-$i"
            if [[ ${distances[$key]} != "" ]] || [[ ${distances[$key2]} != "" ]]; then
                continue
            fi

            distance=$(get_distance $i $j)
            distances[$key]=$distance

            # add_to_sorted_array $key
        fi
    done
done

circuits=()
for ((i = 0; i < $how_many_to_count; i++)); do
    key=${distances_indexes[$i]}

    # echo "$key for ${distances[$key]}"
    while IFS=- read start end; do
        # echo "${points["$start,x"]},${points["$start,y"]},${points["$start,z"]} - ${points["$end,x"]},${points["$end,y"]},${points["$end,z"]}"

        merge=()
        for circuit_index in ${!circuits[@]}; do
            circuit=${circuits[$circuit_index]};

            # echo "verify $circuit"
            if [[ $circuit == *",$start,"* ]] && [[ $circuit != *",$end,"* ]]; then
                circuits[$circuit_index]+="$end,"
                merge+=("$circuit_index")

                # echo "adding $end only"
            elif [[ $circuit == *",$end,"* ]] && [[ $circuit != *",$start,"* ]]; then
                circuits[$circuit_index]+="$start,"
                merge+=("$circuit_index")

                # echo "adding $start only"
            elif [[ $circuit == *",$end,"* ]] && [[ $circuit == *",$start,"* ]]; then
                # echo "already added, skipping"
                :
            fi
        done

        if (( ${#merge[@]} == 0 )); then
            # echo "not found - adding new"
            circuits+=(",$start,$end,")

            continue 2
        elif (( ${#merge[@]} > 1 )); then
            # echo "merging ${merge[@]}"

            for merge_circuit_index in ${!merge[@]}; do
                merge_circuit=${merge[$merge_circuit_index]}

                if (( merge_circuit_index == 0));then
                    temp_circuits=""
                    for temp_merge in ${merge[@]}; do
                        temp_circuits+=${circuits[temp_merge]}
                    done
                    circuits[$merge_circuit]="$temp_circuits"
                    continue
                fi
                circuits[$merge_circuit]=""
            done
        fi

    done <<< "$key"
    # echo "----"
done


# for index in ${distances_indexes[@]}; do
#     echo ${distances[$index]}
# done

counts=()
for circuit in ${circuits[@]}; do
    str=${circuit//,,/,}
    str="${str:1:${#str}-2}"

    no_dup_str=","
    count=0

    while IFS=, read -a circuit_points; do
        for circuit_point in ${circuit_points[@]}; do
            if [[ $no_dup_str != *",$circuit_point,"* ]]; then

                no_dup_str+="$circuit_point,"

                (( count++ ))
            fi
        done
    done <<< $str

    counts+=("$count")

    # echo "$no_dup_str - $count"
    # echo "----"
done

echo ${counts[@]}
