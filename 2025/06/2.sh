puzzle_file="./puzzle.txt"
# puzzle_file="./example.txt"

readarray -t lines < $puzzle_file

numbers=()

lines_len=${#lines[@]}
numbers_len=${#lines[0]}
signals="${lines[$lines_len - 1]}"

for ((i = 0; i < $lines_len; i++)); do
    numbers+=("${lines[$i]}")
done

total=0
signal=${signals:0:1}

case "$signal" in
    "*")
        sum=1
        ;;
    "+")
        sum=0
        ;;
esac

for ((i = 0; i < $numbers_len + 1; i++)); do
    number=""

    for ((j = 0; j < $lines_len-1; j++)); do
        n="${numbers[$j]:i:1}"

        if [[ $n != " " ]]; then
            number+=$n
        fi
    done

    if [[ $number == "" ]]; then
        echo "signal $signal"
        echo "sum $sum"
        echo "---"

        signal=${signals:i+1:1}
        total=$(( total + sum ))

        case "$signal" in
            "*")
                sum=1
                ;;
            "+")
                sum=0
                ;;
        esac
    else
        echo "number $number"

        case "$signal" in
            "*")
                sum=$(( sum * number ))
                ;;
            "+")
                sum=$(( sum + number ))
                ;;
        esac
    fi
done

echo "=$total"

