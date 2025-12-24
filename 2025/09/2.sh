#!/bin/bash

index_of() {
    local value=$1; shift
    local arr=("$@")
    for ((i=0; i<${#arr[@]}; i++)); do
        [[ ${arr[i]} == "$value" ]] && { echo "$i"; return; }
    done
}

print_grid(){
    declare -n this_grid=$1

    for (( cx = 0; cx < x_len; cx++ )); do
        str=""
        for (( cy = 0; cy < y_len; cy++ )); do
            str+="${this_grid["$cx,$cy"]} "
        done

        echo "$str"
    done
    echo ""
}

# puzzle_file="./example.txt"
puzzle_file="./puzzle.txt"

readarray -t lines < $puzzle_file

xs=()
ys=()
declare -A grid

for line in ${lines[@]}; do
    IFS=',' read -r x y <<< "$line"

    ys+=("$y")
    xs+=("$x")
done

ys=($(printf "%s\n" "${ys[@]}" | sort -nu))
xs=($(printf "%s\n" "${xs[@]}" | sort -nu))

loop_lines=("${lines[@]}" "${lines[0]}")

x_len=$(( ${#xs[@]} * 2 - 1 ))
y_len=$(( ${#ys[@]} * 2 - 1 ))

for ((cx=0; cx<x_len; cx++)); do
    for ((cy=0; cy<y_len; cy++)); do
        grid["$cx,$cy"]=0
    done
done


for (( i = 0; i < ${#loop_lines[@]} - 1; i++ )) do
    IFS=',' read -r x1 y1 <<< "${loop_lines[$i]}"
    IFS=',' read -r x2 y2 <<< "${loop_lines[$i + 1]}"

    ix1=$(index_of "$x1" "${xs[@]}")
    ix2=$(index_of "$x2" "${xs[@]}")
    iy1=$(index_of "$y1" "${ys[@]}")
    iy2=$(index_of "$y2" "${ys[@]}")

    cx1=$(( ix1 * 2 ))
    cx2=$(( ix2 * 2 ))
    cy1=$(( iy1 * 2 ))
    cy2=$(( iy2 * 2 ))

    (( cx1 > cx2 )) && { t=$cx1; cx1=$cx2; cx2=$t; }
    (( cy1 > cy2 )) && { t=$cy1; cy1=$cy2; cy2=$t; }

    for ((cx = cx1; cx <= cx2; cx++)); do
        for ((cy = cy1; cy <= cy2; cy++)); do
            grid["$cx,$cy"]=1
        done
    done
done

declare -A outside
outside["-1,-1"]=1
queue=("-1,-1")

while (( ${#queue[@]} > 0 )); do
    IFS=',' read -r qx qy <<< "${queue[0]}"
    queue=("${queue[@]:1}")

    around=("$(( qx + 1)),$qy" "$(( qx - 1)),$qy" "$qx,$(( qy + 1))" "$qx,$(( qy - 1))")

    for side in ${around[@]}; do
        IFS=',' read -r sx sy <<< "$side"

        (( sx < -1 || sy < -1 || sx > x_len || sy > y_len )) && continue;
        (( grid["$sx,$sy"] == 1 )) &&  continue;
        (( outside["$sx,$sy"] == 1 )) && continue;

        outside["$sx,$sy"]=1
        queue+=("$sx,$sy")
    done
done

for (( x=0; x < x_len; x++ )); do
    for (( y=0; y < y_len; y++ )); do
        (( outside["$x,$y"] != 1 )) && grid["$x,$y"]=1
    done
done

# print_grid grid

declare -A grid_psa

for (( x = 0; x < x_len; x++ )); do
    for (( y = 0; y < y_len; y++ )); do

        left=0
        top=0
        top_left=0

        (( x > 0 )) && left=${grid_psa["$(( x - 1)),$y"]}
        (( y > 0 )) && top=${grid_psa["$x,$(( y - 1))"]}
        (( x > 0 && y > 0 ))  && top_left=${grid_psa["$(( x - 1)),$(( y - 1))"]}

        v=${grid["$x,$y"]}

        grid_psa["$x,$y"]=$(( top + left - top_left + v ))
    done
done

# print_grid grid_psa

validate(){
    x1=$1
    y1=$2
    x2=$3
    y2=$4

    ix1=$(index_of "$x1" "${xs[@]}")
    ix2=$(index_of "$x2" "${xs[@]}")
    iy1=$(index_of "$y1" "${ys[@]}")
    iy2=$(index_of "$y2" "${ys[@]}")

    cx1=$(( ix1 * 2 ))
    cx2=$(( ix2 * 2 ))
    cy1=$(( iy1 * 2 ))
    cy2=$(( iy2 * 2 ))

    (( cx1 > cx2 )) && { t=$cx1; cx1=$cx2; cx2=$t; }
    (( cy1 > cy2 )) && { t=$cy1; cy1=$cy2; cy2=$t; }

    # echo "$cx1 $cy1 $cx2 $cy2"

    left=0
    top=0
    top_left=0

    (( cx1 > 0 )) && left=${grid_psa["$(( cx1 - 1)),$cy2"]}
    (( cy1 > 0 )) && top=${grid_psa["$cx2,$(( cy1 - 1))"]}
    (( cx1 > 0 && cy1 > 0 )) && top_left=${grid_psa["$(( cx1 - 1)),$(( cy1 - 1))"]}

    v=${grid_psa["$cx2,$cy2"]}

    count=$(( v - left - top + top_left ))
    area=$(( (cx2 - cx1 + 1) * (cy2 - cy1 + 1) ))

    last_valid=0
    if (( count == area )); then
        last_valid=1
    fi
}

max=0
for (( i = 0; i < ${#loop_lines[@]}; i++ )); do
    IFS=',' read -r x1 y1 <<< "${loop_lines[$i]}"

    for ((j = 0; j < i; j++)); do
        IFS=',' read -r x2 y2 <<< "${loop_lines[$j]}"

        validate "$x1" "$y1" "$x2" "$y2"

        if (( last_valid == 1 )); then
            dx=$((x1 - x2))
            dy=$((y1 - y2))
            (( dx < 0 )) && dx=$((-dx))
            (( dy < 0 )) && dy=$((-dy))
            area=$(( (dx + 1) * (dy + 1) ))
            (( area > max )) && max=$area
        fi

    done
done
echo "$max"
