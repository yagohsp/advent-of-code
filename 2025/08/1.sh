puzzle_file="./example.txt"
# puzzle_file="./dev.txt"

readarray -t lines < $puzzle_file

distances=()

add() {
    local new_value=$1
    # echo "$new_value"
    # echo "${distances[@]}"

    if (( new_value <= distances[0] )); then
        # echo "new smallest"
        distances=("$new_value" "${distances[@]}")
        # echo "${distances[@]}"
        # echo "----"
        return
    fi

    for ((i = 1; i < ${#distances[@]}; i++)); do
        local curr=${distances[i]}
        local prev=${distances[i-1]}

        if (( new_value >= prev && new_value <= curr )); then
            distances=( "${distances[@]:0:i}" "$new_value" "${distances[@]:i}" )
            # echo "inserted between $prev and $curr"
            # echo "${distances[@]}"
            # echo "----"
            return
        fi
    done

    # echo "new largest"
    distances+=("$new_value")
    # echo "${distances[@]}"
    # echo "----"
}

euclid() {
    awk -v x1="$1" -v y1="$2" -v z1="$3" \
        -v x2="$4" -v y2="$5" -v z2="$6" \
        'BEGIN { print sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2) }'
}


for line_i in ${lines[@]}; do
    IFS=',' read -ra i <<< "$line_i"

    for line_j in ${lines[@]}; do
        IFS=',' read -ra j <<< "$line_j"

        res=$(euclid ${i[0]} ${i[1]} ${i[2]} ${j[0]} ${j[1]} ${j[2]})

        echo "$res - $line_i with $line_j"

        add ${res%%.*}
    done
done

echo "${distances[@]}"
