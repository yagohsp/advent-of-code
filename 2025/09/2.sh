#!/bin/bash

index_of() {
    local value=$1; shift
    local arr=("$@")
    for ((i=0; i<${#arr[@]}; i++)); do
        [[ ${arr[i]} == "$value" ]] && { echo "$i"; return; }
    done
}

print_grid(){
    for (( cx = 0; cx < x_len; cx++ )); do
        str=""
        for (( cy = 0; cy < y_len; cy++ )); do
            str+="${grid["$cx,$cy"]}"
        done

        echo "$str"
    done
    echo ""
}

puzzle_file="./example.txt"
# puzzle_file="./puzzle.txt"

readarray -t lines < $puzzle_file

xs=()
ys=()
declare -A x_sizes
declare -A y_sizes
declare -A grid

for line in ${lines[@]}; do
    IFS=',' read -r x y <<< "$line"

    ys+=("$y")
    xs+=("$x")
done

ys=($(printf "%s\n" "${ys[@]}" | sort -nu))
xs=($(printf "%s\n" "${xs[@]}" | sort -nu))

for ((i = 1; i < ${#xs[@]}; i++)); do
    x1=${xs[$i - 1]}
    x2=${xs[$i]}
    size=$(( x2 - x1 - 1))

    abs_size=$(( size < 0 ? -size : size ))

    index=$(( i * 2 + 1 ))

    x_sizes[$index]="$abs_size"
done

for ((i = 1; i < ${#ys[@]}; i++)); do
    y1=${ys[$i - 1]}
    y2=${ys[$i]}
    size=$(( y2 - y1 - 1))

    abs_size=$(( size < 0 ? -size : size ))

    index=$(( i * 2 + 1 ))

    y_sizes[$index]="$abs_size"
done

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
