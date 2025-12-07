# puzzle_file="./example.txt"
# puzzle_file="./dev.txt"
# puzzle_file="./puzzle.txt"

declare -A ranges

j=0
while read line; do
    echo $j
    (( j++ ))

    if [[ $line == "" ]]; then
        break
    fi

    start=${line%-*}
    end=${line##*-}

    echo "$(( end - start))"

    for ((i = start; i <= end; i++)); do
        ranges[$i]="x"
    done
done < $puzzle_file

echo ${#ranges[@]}
