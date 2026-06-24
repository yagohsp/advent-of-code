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
	biggest := 0
	for line in strings.split_lines_iterator(&text) {
		value, _ := strconv.parse_int(line)

		if value == 0 {
			if current > biggest {
				biggest = current
			}
			current = 0
		} else {
			current += value
		}

	}

	if current > biggest {
		biggest = current
	}
	current = 0

	fmt.println(biggest)
}
