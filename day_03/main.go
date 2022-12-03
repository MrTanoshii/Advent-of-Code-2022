package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	// Try to open the input file
	file, err := os.Open("tests/input.txt")
	if err != nil {
		fmt.Println(err)
	}
	defer file.Close()

	// Read the file line by line
	scanner := bufio.NewScanner(file)
	totalPriority := 0
	lineNumber := 0
	var elfGroupString [3]string
	elfGroupotalPriority := 0
	for scanner.Scan() {
		line := scanner.Text()
		firstHalf := line[:len(line)/2]
		secondHalf := line[len(line)/2:]
		// fmt.Println(len(line), " | ", line, " | ", firstHalf, " + ", secondHalf)

		for _, char := range firstHalf {
			result := strings.ContainsRune(secondHalf, char)
			if result {
				priority := getPriority(char)
				// fmt.Println(priority, " | ", string(char))
				totalPriority += priority
				break
			}
		}

		// PART 2
		lineNumber++
		elfGroupString[lineNumber%3] = line
		if lineNumber%3 == 0 {
			for _, char := range elfGroupString[0] {
				if strings.ContainsRune(elfGroupString[1], char) && strings.ContainsRune(elfGroupString[2], char) {
					priority := getPriority(char)
					elfGroupotalPriority += priority
					// fmt.Println(priority, " | ", string(char))
					break
				}
			}
		}
	}

	// Display error message if any
	if err := scanner.Err(); err != nil {
		fmt.Println(err)
	}

	fmt.Println("Total priority: ", totalPriority)
	fmt.Println("Elf group total priority: ", elfGroupotalPriority)
}

// Return the priority of a rune
func getPriority(char rune) int {
	priorityMap := map[string]int{
		"a": 1,
		"b": 2,
		"c": 3,
		"d": 4,
		"e": 5,
		"f": 6,
		"g": 7,
		"h": 8,
		"i": 9,
		"j": 10,
		"k": 11,
		"l": 12,
		"m": 13,
		"n": 14,
		"o": 15,
		"p": 16,
		"q": 17,
		"r": 18,
		"s": 19,
		"t": 20,
		"u": 21,
		"v": 22,
		"w": 23,
		"x": 24,
		"y": 25,
		"z": 26,
		"A": 27,
		"B": 28,
		"C": 29,
		"D": 30,
		"E": 31,
		"F": 32,
		"G": 33,
		"H": 34,
		"I": 35,
		"J": 36,
		"K": 37,
		"L": 38,
		"M": 39,
		"N": 40,
		"O": 41,
		"P": 42,
		"Q": 43,
		"R": 44,
		"S": 45,
		"T": 46,
		"U": 47,
		"V": 48,
		"W": 49,
		"X": 50,
		"Y": 51,
		"Z": 52,
	}

	return priorityMap[string(char)]
}
