split(){
    local pos=$1
    local line_i=$2
    local n=$3
    local next_line=${lines[$line_i+1]}

    if (( line_i < len - 3 )); then

        local next_i=$(( $line_i + 2))
        local left_pos=$(( $pos - 1))
        local right_pos=$(( $pos + 1))

        split $next_i $left_pos $(( n+1 ))
        split $next_i $right_pos $(( n+1 ))
    else
        count=$((count+n))
    fi

else
    if (( line_i < len - 3 )); then
        local next_i=$(( $line_i + 2))
        split $next_i $pos $n
    else
        count=$((count+n))
        if [[ ${next_line:pos:1} == "^" ]];then
        fi

    fi
}


# puzzle_file="./puzzle.txt"
puzzle_file="./example.txt"
# puzzle_file="./dev.txt"

readarray -t lines < $puzzle_file
lines[1]=${lines[0]//S/|}

len=${#lines[@]}
count=0
split 7 1 1

echo $count
