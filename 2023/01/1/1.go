package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	file, _ := os.Open("../puzzle.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)

	total := 0
	for scanner.Scan() {
		line := scanner.Text()

		start, end := -1, -1

		for i := 0; i < len(line); i++ {
			c := line[i]
			if c >= '0' && c <= '9' {
				start = int(c - '0')
				break
			}
		}

		for i := len(line) - 1; i >= 0; i-- {
			c := line[i]
			if c >= '0' && c <= '9' {
				end = int(c - '0')
				break
			}
		}

		if start != -1 && end != -1 {
			total += start*10 + end
		}
	}

	fmt.Println(total)
}
