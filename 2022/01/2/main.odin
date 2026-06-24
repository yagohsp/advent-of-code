package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	data, err := os.read_entire_file("./puzzle.txt", context.allocator)
	if err != nil {
		return
	}

	defer delete(data, context.allocator)

	text := string(data)
	current := 0
	top_1, top_2, top_3 := 0, 0, 0
	for line in strings.split_lines_iterator(&text) {
		value, _ := strconv.parse_int(line)

		if value == 0 {
			check: if current > top_3 {
				if current > top_2 {
					if current > top_1 {
						top_3 = top_2
						top_2 = top_1
						top_1 = current

						break check
					}
					top_3 = top_2
					top_2 = current
					break check
				}
				top_3 = current
			}
			current = 0
		} else {
			current += value
		}

	}
	check_2: if current > top_3 {
		if current > top_2 {
			if current > top_1 {
				top_3 = top_2
				top_2 = top_1
				top_1 = current

				break check_2
			}
			top_3 = top_2
			top_2 = current
			break check_2
		}
		top_3 = current
	}

	fmt.println(top_1, top_2, top_3)
	fmt.println(top_1 + top_2 + top_3)
}
