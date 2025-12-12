# puzzle_file="./2-example.txt"
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
    local has_fft=$2
    local has_dac=$3
    local str=$4
    local i=$5

    read -a outputs <<< "${inputs[$key]}"

    echo "$output => $str"
    for output in ${outputs[@]}; do
        if [[ $output == "out" ]]; then

            if [[ $has_fft == true ]] && [[ $has_dac == true ]]; then
                echo "$output => $str"
                count=$(( count + 1 ))
            fi
        else

            if [[ $has_fft == false ]] && [[ $output == "fft" ]]; then
                has_fft=true
            elif [[ $has_dac == false ]] && [[ $output == "dac" ]]; then
                has_dac=true
            fi

            local next="$str $output"
            (( i++ ))
            count_outputs $output $has_fft $has_dac "$next" $i
        fi
    done
}

count_outputs "svr" false false "svr" 0

echo "$count"
