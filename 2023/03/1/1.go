package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"unicode"
)

func getNumber(grid [][]rune, x int, y int) (int, int) {
	max_y, max_x := len(grid), len(grid[0])
	start_x := x

	number_str := ""

	for {
		if x == max_x {
			break
		}

		char := grid[y][x]
		if !unicode.IsDigit(char) {
			break
		}

		number_str += string(char)
		x++
	}

	end_x := x - 1

	for i_y := y - 1; i_y <= y+1; i_y++ {
		if i_y < 0 || i_y >= max_y {
			continue
		}

		for i_x := start_x - 1; i_x <= end_x+1; i_x++ {
			if i_x < 0 || i_x >= max_x {
				continue
			}

			if i_y == y && i_x >= start_x && i_x <= end_x {
				continue
			}

			char := grid[i_y][i_x]
			if !unicode.IsDigit(char) && char != '.' {
				number, _ := strconv.Atoi(number_str)
				return number, len(number_str)
			}
		}
	}

	return 0, 0
}

func main() {
	file, _ := os.Open("../puzzle.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)

	var grid [][]rune
	for scanner.Scan() {
		line := scanner.Text()
		row := []rune(line)
		grid = append(grid, row)
	}

	sum := 0
	max_x := len(grid[0])

	for y, line := range grid {
		for x := 0; x < max_x; x++ {
			if unicode.IsDigit(line[x]) {
				number, len := getNumber(grid, x, y)

				if len > 0 {
					sum += number
					x += len
				}
			}
		}
	}

	fmt.Println(sum)
}
