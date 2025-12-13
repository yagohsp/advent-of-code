#!/bin/bash

puzzle_file="./puzzle.txt"
# puzzle_file="./2-example.txt"

declare -A inputs
declare -A reverse_inputs

while read -r line; do
    read -a codes <<< "$line"

    key="${codes[0]::-1}"
    outputs="${codes[*]:1}"

    inputs["$key"]="$outputs"

    for output in $outputs; do
        reverse_inputs["$output"]+="$key "
    done
done < "$puzzle_file"

declare -A out_paths
declare -A dac_paths
declare -A fft_paths

reverse_bfs() {
    local target=$1
    local start=$2

    declare -n visited="${target}_paths"

    local queue=("$start")
    local qi=0

    visited["$start"]=1

    while (( qi < ${#queue[@]} )); do
        local node="${queue[qi++]}"

        for prev in ${reverse_inputs[$node]}; do
            if [[ ${visited[$prev]} -ne 1 ]]; then
                visited["$prev"]=1
                queue+=("$prev")
            fi
        done
    done
}

reverse_bfs out out
reverse_bfs dac dac
reverse_bfs fft fft

declare -A memo
count=0

count_paths() {
    local node=$1
    local seen_fft=$2
    local seen_dac=$3

    local key="$node|$seen_fft|$seen_dac"

    if [[ -n ${memo[$key]} ]]; then
        ((count += memo[$key]))
        return
    fi

    [[ ${out_paths[$node]} -ne 1 ]] && { memo[$key]=0; return; }
    [[ $seen_fft -eq 0 && ${fft_paths[$node]} -ne 1 ]] && { memo[$key]=0; return; }
    [[ $seen_dac -eq 0 && ${dac_paths[$node]} -ne 1 ]] && { memo[$key]=0; return; }

    [[ $node == "fft" ]] && seen_fft=1
    [[ $node == "dac" ]] && seen_dac=1

    if [[ $node == "out" ]]; then
        if (( seen_fft && seen_dac )); then
            memo[$key]=1
            ((count++))
        else
            memo[$key]=0
        fi
        return
    fi

    local subtotal=0
    local before

    for next in ${inputs[$node]}; do
        before=$count
        count_paths "$next" "$seen_fft" "$seen_dac"
        ((subtotal += count - before))
    done

    memo[$key]=$subtotal
}

count_paths "svr" 0 0
echo "$count"

