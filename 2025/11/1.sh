# puzzle_file="./1-example.txt"
puzzle_file="./puzzle.txt"

declare -A inputs

while read line; do
    read -a codes <<< "$line"

    key="${codes[0]:0:${#codes[0]}-1}"
    outputs="${codes[@]:1}"

    inputs[$key]=$outputs
done < $puzzle_file


count=0

count_outputs(){
    local key=$1

    read -a outputs <<< "${inputs[$key]}"

    for output in ${outputs[@]}; do
        if [[ $output == "out" ]]; then
            count=$(( count + 1 ))
        else
            count_outputs $output
        fi
    done
}

count_outputs "you"

echo "$count"
