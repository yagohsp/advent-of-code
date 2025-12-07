puzzle_file="./puzzle.txt"
# puzzle_file="./example.txt"

readarray -t lines < $puzzle_file

read -r -a firsts <<< "${lines[0]}"
read -r -a seconds <<< "${lines[1]}"
read -r -a thirds <<< "${lines[2]}"
read -r -a fourths <<< "${lines[3]}"
read -r -a signals <<< "${lines[4]}"

count=0
for i in ${!firsts[@]}; do
    signal="${signals[$i]}"

    first="${firsts[$i]}"
    second="${seconds[$i]}"
    third="${thirds[$i]}"
    fourth="${fourths[$i]}"

    case "$signal" in
        "*") count=$(( count + first * second * third * fourth ))
            ;;
        "+") count=$(( count + first + second + third + fourth ))
            ;;
        *)
            ;;
    esac
done

echo $count
