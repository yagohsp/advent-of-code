package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

main :: proc() {
	data, err := os.read_entire_file("./puzzle.txt", context.allocator)
	if err != nil {
		return
	}
	defer delete(data, context.allocator)

	text := string(data)

	points := 0
	for line in strings.split_lines_iterator(&text) {
		enemy, me := utf8.rune_at(line, 0), utf8.rune_at(line, 2)

		switch enemy {
		case 'A':
			// pedra
			switch me {
			case 'X':
				points += 3
			case 'Y':
				points += 4
			case 'Z':
				points += 8
			}

		case 'B':
			// papel
			switch me {
			case 'X':
				points += 1
			case 'Y':
				points += 5
			case 'Z':
				points += 9
			}

		case 'C':
			//tesoura
			switch me {
			case 'X':
				points += 2
			case 'Y':
				points += 6
			case 'Z':
				points += 7
			}

		}
	}

	fmt.println(points)
}
