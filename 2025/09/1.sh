# puzzle_file="./dev.txt"
# puzzle_file="./example.txt"
puzzle_file="./puzzle.txt"

readarray -t lines < $puzzle_file

max=0

for i in ${lines[@]}; do
    IFS=',' read -ra range_i <<< "$i"

    for j in ${lines[@]}; do
        if [[ $i == $j ]]; then
            continue
        fi

        IFS=',' read -ra range_j <<< "$j"

        echo "(${range_i[0]} - ${range_j[0]}) * (${range_i[1]} - ${range_j[1]})"

        width=$(( ${range_j[0]} - ${range_i[0]} + 1 ))
        height=$(( ${range_j[1]} - ${range_i[1]} + 1 ))

        area=$(( ${width#-} * ${height#-} ))
        echo $area

        if (( area > max)); then
            max=$area
        fi
        echo ""
    done
done

echo $max
