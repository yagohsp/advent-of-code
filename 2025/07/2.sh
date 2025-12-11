puzzle_file="./puzzle.txt"
# puzzle_file="./example.txt"
# puzzle_file="./dev.txt"

readarray -t lines < $puzzle_file

pipes=()

column_len=${#lines[0]}

for ((i = 0; i < column_len; i++)); do
    pipes+=(0)
done

first_pipe=${lines[0]%%S*}
first_pipe_index=${#first_pipe}
pipes[$first_pipe_index]=1

for line_i in ${!lines[@]}; do
    line=${lines[$line_i]}

    if (( line_i % 2 == 0)); then
        # echo $line

        i=0
        while IFS= read -n1 char; do
            if [[ $char == "^" ]]; then
                previous=$(( $i - 1 ))
                next=$(( $i + 1 ))

                pipes[$next]=$(( pipes[next] + pipes[i] ))
                pipes[$previous]=$(( pipes[previous] + pipes[i] ))

                pipes[$i]=0
            fi

            (( i++ ))
        done <<< "$line"
    fi
done

count=0
str=""
for ((i = 0; i < column_len; i++)); do
    value=${pipes[$i]}
    count=$(( count + value ))
    str+="${value} "
done

# echo $str
echo $count
