package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func split(s, sep string) (string, string) {
	x := strings.Split(s, sep)
	return x[0], x[1]
}

func main() {
	file, _ := os.Open("../puzzle.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)

	total := 0

	for scanner.Scan() {
		line := scanner.Text()

		_, all_numbers := split(line, ": ")
		all_numbers = strings.ReplaceAll(all_numbers, "  ", " ")
		winners_str, numbers_str := split(all_numbers, " | ")

		winners := strings.Split(winners_str, " ")
		numbers := strings.Split(numbers_str, " ")

		numbers_set := make(map[string]struct{})
		for _, x := range numbers {
			numbers_set[x] = struct{}{}
		}

		points := 0

		for _, x := range winners {
			if _, exists := numbers_set[x]; exists {
				if points == 0 {
					points = 1
				} else {
					points *= 2
				}
			}
		}

		total += points
	}

	fmt.Println("total", total)
}
