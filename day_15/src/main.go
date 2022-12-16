package main

import (
	"bufio"
	"fmt"
	"log"
	"math"
	"os"
	"regexp"
	"strconv"
	"strings"
	"time"
)

// A 2D vector of integers.
type Vector2DInt struct {
	x int
	y int
}

func main() {
	scriptStart := time.Now()

	// Display usage information
	if len(os.Args) != 3 {
		fmt.Println("Advent of Code 2022 - Day 15")
		fmt.Println()
		fmt.Println("Usage:")
		fmt.Println("  go run ", os.Args[0], " <input_file> <map_y_illegal_beacon_check>")
		fmt.Println("Example:")
		fmt.Println("  go run ", os.Args[0], " ./data/input.dat 2000000")
		return
	}

	// Try to open the input file
	file, err := os.Open(os.Args[1])
	if err != nil {
		fmt.Println(err)
	}
	defer file.Close()

	// Init map data
	var sensorList []Vector2DInt
	var beaconList []Vector2DInt
	mapLimX := Vector2DInt{math.MaxInt, math.MinInt}
	mapLimY := Vector2DInt{math.MaxInt, math.MinInt}

	// Read the file line by line
	scanner := bufio.NewScanner(file)
	lineNumber := 0
	for scanner.Scan() {
		lineNumber++
		line := scanner.Text()
		regex := regexp.MustCompile(`[a-zA-Z]`)
		line = regex.ReplaceAllString(line, "")
		line = strings.ReplaceAll(line, "=", "")
		line = strings.ReplaceAll(line, " ", "")

		modules := strings.Split(line, ":")
		for i, module := range modules {
			coords := strings.Split(module, ",")
			x, _ := strconv.Atoi(coords[0])
			y, _ := strconv.Atoi(coords[1])

			// Add sensor or beacon to respective lists.
			if i%2 == 0 {
				sensorList = append(sensorList, Vector2DInt{x, y})
				// fmt.Println("Sensor: ", x, ", ", y)
			} else {
				beaconList = append(beaconList, Vector2DInt{x, y})
				// fmt.Println("Beacon: ", x, ", ", y)
			}

			// Update map limits
			if x < mapLimX.x {
				mapLimX.x = x
			} else if x > mapLimX.y {
				mapLimX.y = x
			}
			if y < mapLimY.x {
				mapLimY.x = y
			}
			if y > mapLimY.y {
				mapLimY.y = y
			}
		}
	}

	// // Init map
	// zoneMap := generateMap(mapLimX, mapLimY, sensorList, beaconList)

	// // Display map
	// displayMap(zoneMap)

	// // Write map to file
	// writeMapToFile(zoneMap, "map.out")

	// Part 1
	targetY, _ := strconv.Atoi(os.Args[2])
	fmt.Println("Part 1 | Illegal beacon positions on map at y=", targetY, ": ", computePosBeaconIllegalNum(mapLimX, mapLimY, sensorList, beaconList, targetY))

	// Part 2
	distressBeacon := computeDistressBeacon(mapLimX, mapLimY, sensorList, beaconList)
	fmt.Println("Part 2 | Position of distress beacon: ", distressBeacon)
	fmt.Println("Part 2 | Tuning frequency: ", computeTuningFreq(distressBeacon))

	fmt.Println("Script execution time: ", time.Since(scriptStart))
}

// Deprecated.
func generateMap(mapLimX Vector2DInt, mapLimY Vector2DInt, sensorList []Vector2DInt, beaconList []Vector2DInt) [][]string {

	fmt.Println("Map limits: ", mapLimX, " | ", mapLimY)
	zoneMap := make([][]string, mapLimY.y-mapLimY.x+1)
	for i := range zoneMap {
		fmt.Println("Generating map line ", i+1, "/", mapLimY.y-mapLimY.x+1, " (", mapLimY.y-mapLimY.x, "elements)")
		zoneMap[i] = make([]string, mapLimX.y-mapLimX.x+1)
		for j := range zoneMap[i] {
			zoneMap[i][j] = "."
		}
	}
	// Add sensors and beacons to map
	for _, beacon := range beaconList {
		zoneMap[beacon.y-mapLimY.x][beacon.x-mapLimX.x] = "B"
	}
	for _, sensor := range sensorList {
		zoneMap[sensor.y-mapLimY.x][sensor.x-mapLimX.x] = "S"
	}
	// Add sensor range to map
	for i, sensor := range sensorList {
		sensorRange := getRange(Vector2DInt{sensor.x, sensor.y}, beaconList[i])
		// fmt.Println("Sensor #", i, "at [", sensor.x, ",", sensor.y, "]sensorRange: ", sensorRange)

		for y := sensor.y - sensorRange; y <= sensor.y+sensorRange; y++ {
			for x := sensor.x - sensorRange; x <= sensor.x+sensorRange; x++ {
				if x >= mapLimX.x && x <= mapLimX.y && y >= mapLimY.x && y <= mapLimY.y {
					if getRange(Vector2DInt{sensor.x, sensor.y}, Vector2DInt{x, y}) <= sensorRange {
						if zoneMap[y-mapLimY.x][x-mapLimX.x] == "." {
							zoneMap[y-mapLimY.x][x-mapLimX.x] = "#"
						}
					}
				}
			}
		}
	}

	return zoneMap
}

// Deprecated.
func displayMap(mapData [][]string) {
	for i := range mapData {
		for j := range mapData[i] {
			fmt.Print(mapData[i][j])
		}
		fmt.Println()
	}
}

// Returns the Range/Manhattan distance between 2 Vector2DInt.
func getRange(point1, point2 Vector2DInt) int {
	y_range := computeAbsDiff(point1.y, point2.y)
	x_range := computeAbsDiff(point1.x, point2.x)

	return y_range + x_range
}

// Returns the magnitude of the difference between 2 integers.
func computeAbsDiff(x1, x2 int) int {
	diff := x1 - x2
	if diff < 0 {
		diff = -diff
	}

	return diff
}

// Returns the number of illegal beacon positions on the map at a given y coordinate.
func computePosBeaconIllegalNum(mapLimX Vector2DInt, mapLimY Vector2DInt, sensorList []Vector2DInt, beaconList []Vector2DInt, y int) int {
	illegalPosNum := 0

	if y < mapLimY.x || y > mapLimY.y {
		return -1
	}

	for x := mapLimX.x * 5; x <= mapLimX.y*5; x++ {
		// Check if occupied by sensor
		for _, sensor := range sensorList {
			if x == sensor.x && y == sensor.y {
				continue
			}
		}
		// Check if occupied by beacon
		for _, beacon := range beaconList {
			if x == beacon.x && y == beacon.y {
				continue
			}
		}
		// Check if in range of sensor
		detected, sensor, sensorRange := isWithinRange(Vector2DInt{x, y}, sensorList, beaconList)
		if detected {
			jumpDest := sensor.x + sensorRange - computeAbsDiff(y, sensor.y)
			illegalPosNum += 1 + jumpDest - x
			// fmt.Println("Illegal positions from [", x, ",", y, "] to [", jumpDest, ",", y, "] (sensor #", sensor, ")")
			x = jumpDest
		}
	}

	return illegalPosNum - 1
}

// Returns the coordinates of the distress beacon.
func computeDistressBeacon(mapLimX Vector2DInt, mapLimY Vector2DInt, sensorList []Vector2DInt, beaconList []Vector2DInt) Vector2DInt {
	var distressBeacon Vector2DInt
	scanLimits := Vector2DInt{0, 4000000}

outerLoop:
	for y := scanLimits.x; y <= scanLimits.y; y++ {
		for x := scanLimits.x; x <= scanLimits.y; x++ {
			detected, sensor, sensorRange := isWithinRange(Vector2DInt{x, y}, sensorList, beaconList)
			if detected {
				y_range := computeAbsDiff(y, sensor.y)
				// fmt.Println("Jumping from [", x, ",", y, "] to [", sensor.x+sensorRange-y_range, ",", y, "]")
				x = sensor.x + sensorRange - y_range
			} else if !detected {
				distressBeacon = Vector2DInt{x, y}
				break outerLoop
			}
		}
	}

	return distressBeacon
}

// Returns whether the location is within range of any sensor, the sensor coordinates that detected it and the range of the sensor.
//
// Returns false, Vector2DInt(-1, -1), -1 if the location is not within range of any sensor.
func isWithinRange(location Vector2DInt, sensorList []Vector2DInt, beaconList []Vector2DInt) (bool, Vector2DInt, int) {
	for i, sensor := range sensorList {
		sensorRange := getRange(Vector2DInt{sensor.x, sensor.y}, beaconList[i])
		if getRange(Vector2DInt{sensor.x, sensor.y}, location) <= sensorRange {
			// fmt.Println("Location [", location.x, ",", location.y, "] is within range of sensor #", i, " (", sensor.x, ",", sensor.y, ")")
			return true, sensor, sensorRange
		}
	}

	return false, Vector2DInt{-1, -1}, -1
}

// Deprecated.
func writeMapToFile(mapData [][]string, fileName string) {
	file, err := os.Create(fileName)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	for i := range mapData {
		for j := range mapData[i] {
			file.WriteString(mapData[i][j])
		}
		file.WriteString("\n")
	}
}

// Returns the tuning frequency for a given location.
func computeTuningFreq(location Vector2DInt) int {
	return location.x*4000000 + location.y
}
