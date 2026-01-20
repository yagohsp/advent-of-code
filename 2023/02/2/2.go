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

	for scanner.Scan() {
		line := scanner.Text()

		game := strings.Split(line, ":")

		blue, red, green := 0, 0, 0

		for play := range strings.SplitSeq(game[1], ";") {
			for cubes := range strings.SplitSeq(play, ",") {
				cubes := cubes[1:]

				cubes_split := strings.Split(cubes, " ")

				quantity_str, color := cubes_split[0], cubes_split[1]
				quantity, _ := strconv.Atoi(quantity_str)

				switch color {
				case "red":
					if quantity > red {
						red = quantity
					}

				case "green":
					if quantity > green {
						green = quantity
					}

				case "blue":
					if quantity > blue {
						blue = quantity
					}
				}
			}
		}

		sum += blue * red * green
	}

	fmt.Println(sum)
}
