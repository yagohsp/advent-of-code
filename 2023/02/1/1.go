package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, _ := os.Open("../puzzle.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)

	sum := 0

game:
	for scanner.Scan() {
		line := scanner.Text()

		game := strings.Split(line, ":")

		game_id_str := game[0][5:]
		game_id, _ := strconv.Atoi(game_id_str)

		for play := range strings.SplitSeq(game[1], ";") {
			for cubes := range strings.SplitSeq(play, ",") {
				cubes := cubes[1:]

				cubes_split := strings.Split(cubes, " ")

				quantity_str, color := cubes_split[0], cubes_split[1]
				quantity, _ := strconv.Atoi(quantity_str)

				switch color {
				case "red":
					if quantity > 12 {
						continue game
					}
				case "green":
					if quantity > 13 {
						continue game
					}
				case "blue":
					if quantity > 14 {
						continue game
					}
				}
			}
		}
		sum += game_id
	}

	fmt.Println(sum)
}
