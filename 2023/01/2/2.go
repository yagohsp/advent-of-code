package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func getNum(line string) int {
	c := line[0]

	if c >= '0' && c <= '9' {
		return int(c - '0')
	}

	switch c {
	case 'z':
		if strings.HasPrefix(line, "zero") {
			return 0
		}
	case 'o':
		if strings.HasPrefix(line, "one") {
			return 1
		}
	case 't':
		if strings.HasPrefix(line, "two") {
			return 2
		}
		if strings.HasPrefix(line, "three") {
			return 3
		}
	case 'f':
		if strings.HasPrefix(line, "four") {
			return 4
		}
		if strings.HasPrefix(line, "five") {
			return 5
		}
	case 's':
		if strings.HasPrefix(line, "six") {
			return 6
		}
		if strings.HasPrefix(line, "seven") {
			return 7
		}
	case 'e':
		if strings.HasPrefix(line, "eight") {
			return 8
		}
	case 'n':
		if strings.HasPrefix(line, "nine") {
			return 9
		}
	}

	return -1
}

func main() {
	file, _ := os.Open("../puzzle.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)

	total := 0
	for scanner.Scan() {
		line := scanner.Text()

		start, end := -1, -1
		line_length := len(line)

		for i := range line_length {
			line_start := line[i:]
			result := getNum(line_start)
			if result != -1 {
				start = result
				break
			}
		}

		for i := line_length - 1; i >= 0; i-- {
			line_end := line[i:]
			result := getNum(line_end)
			if result != -1 {
				end = result
				break
			}
		}

		fmt.Println(start, end, line)

		if start != -1 && end != -1 {
			total += start*10 + end
		}
	}

	fmt.Println(total)
}
