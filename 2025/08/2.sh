#!/bin/bash

# readarray -t lines < "./example.txt"
readarray -t lines < "./puzzle.txt"

declare -a xs ys zs
for i in "${!lines[@]}"; do
    IFS=',' read -r xs[i] ys[i] zs[i] <<<"${lines[$i]}"
done

distances=()
for ((i = 0; i < ${#lines[@]}; i++)); do
    xi=${xs[i]}; yi=${ys[i]}; zi=${zs[i]}
    for ((j = i + 1; j < ${#lines[@]}; j++)); do
        dx=$(( xs[j] - xi ))
        dy=$(( ys[j] - yi ))
        dz=$(( zs[j] - zi ))

        dist=$(( dx*dx + dy*dy + dz*dz ))
        distances+=("$dist $i-$j")
    done
done

mapfile -t sorted_distances < <(printf '%s\n' "${distances[@]}" | sort -n)

counts=()
circuits=()
for distance in "${sorted_distances[@]}"; do
    keys=${distance#* }
    IFS=- read a b <<<"$keys"

    # echo "-> ${circuits[@]}"
    # echo "+ $a $b"

    added=0
    added_to=()
    for circuit_i in "${!circuits[@]}"
    do
        circuit=${circuits[$circuit_i]}

        IFS=- read -a circuit_keys <<<"$circuit"

        add=""

        has_a=0
        has_b=0
        for circuit_key in "${circuit_keys[@]}"
        do
            # echo "check $a == $circuit_key ${#a} ${#circuit_key}"
            if [[ "$a" == "$circuit_key" ]]; then
                # echo "${circuit[@]} has $a"
                has_a=1
            fi

            # echo "check $b == $circuit_key ${#b} ${#circuit_key}"
            if [[ "$b" == "$circuit_key" ]]; then
                # echo "${circuit[@]} has $b"
                has_b=1
            fi
        done

        if (( has_a == 1)) && (( has_b == 1))
        then
            added=1
            # echo "has both"
            # echo "----"
        elif (( has_a == 1)) && (( has_b == 0))
        then
            added=1
            circuits[$circuit_i]+="-$b"
            added_to+=("$circuit_i")
            # echo "becomes ${circuits[$circuit_i]}"
            # echo "----"
        elif (( has_a == 0)) && (( has_b == 1))
        then
            added=1
            circuits[$circuit_i]+="-$a"
            added_to+=("$circuit_i")
            # echo "becomes ${circuits[$circuit_i]}"
            # echo "----"
        fi

    done

    if (( added == 0 )); then
        circuits+=("$a-$b")
        # echo "is new"
        continue
    elif (( ${#added_to[@]} > 1 )); then
        for ((i = 0; i < "${#added_to[@]}"; i++)); do
            circuit_index=${added_to[$i]}

            if (( i == 0 )); then
                main_circuit_index=$circuit_index
                for ((j = 1; j < "${#added_to[@]}"; j++)); do
                    circuit_index_to_del=${added_to[$j]}
                    circuits[$circuit_index]+="-${circuits[$circuit_index_to_del]}"
                done
                continue
            fi

            circuits=("${circuits[@]:0:$circuit_index}" "${circuits[@]:$circuit_index+1}")
        done

        main_circuit_index=${added_to[0]}
        main_circuit=${circuits[$main_circuit_index]}

        out=$(printf "%s\n" ${main_circuit//-/ } | sort -u | paste -sd-)
        circuits[$main_circuit_index]="$out"

    fi

    if (( ${#circuits[@]} == 1)); then
        IFS='-' read -a ns <<< "${circuits[0]}"
        if (( ${#ns[@]} == ${#lines[@]} )); then
            x_a=${xs[$a]}
            x_b=${xs[$b]}

            echo $(( x_a * x_b))
            break
        fi
    fi
done
