#!/bin/bash

puzzle_file="./puzzle.txt"

to_binary() {
    local num=$1
    local width=$2
    local bin=""

    if [ "$num" -eq 0 ]; then
        bin="0"
    else
        while [ "$num" -gt 0 ]; do
            bin=$((num % 2))$bin
            num=$((num / 2))
        done
    fi

    while [ "${#bin}" -lt "$width" ]; do
        bin="0$bin"
    done

    echo "$bin"
}

press_button(){
    local -n push_lights=$1
    local button=$2
    local light

    IFS=',' read -ra flipped_lights <<< "$button"

    for flipped_light in "${flipped_lights[@]}"; do
      light=${push_lights[$flipped_light]}

      if [[ $light == "1" ]]; then
        light=0
      else
        light=1
      fi

      push_lights[$flipped_light]="$light"
    done
}

line_index=0
while read line; do
  echo $line_index

  ((line_index++))
    lights_str=${line%% *}
    lights_str=${lights_str:1:${#lights_str} - 2}

    lights=()
    target=()
    for ((i=0; i < ${#lights_str}; i++)); do
        target+=("0")

        if [[ ${lights_str:i:1} == "#" ]]; then
            lights+=(1)
        else
            lights+=(0)
        fi
    done

    buttons_string=${line#* }
    buttons_string=${buttons_string%\{*}
    buttons_string=${buttons_string//(/}
    buttons_string=${buttons_string//)/}

    read -a buttons <<< "$buttons_string"

    buttons_len=${#buttons[@]}

    test_n=$(( 1 << buttons_len))

    min=1000000
    for ((i = 0; i < test_n; i++)); do
        bin=$(to_binary $i $buttons_len )

        test_lights=()
        test_lights+=("${lights[@]}")

        presses=0
        for ((j = 0; j < buttons_len; j++)); do
            value=${bin:$j:1}

            if (( value == 1 )); then
                press_button test_lights ${buttons[$j]}
                # echo "flip ${buttons[$j]} => ${test_lights[@]}"
                (( presses++ ))
            fi
        done

        if [[ "${test_lights[@]}" == "${target[@]}" ]]; then
          # echo "$presses < $min"
          if (( presses < min )); then
            min=$presses
          fi
        fi
    done

    sum=$(( sum + min ))
done < $puzzle_file

echo $sum
