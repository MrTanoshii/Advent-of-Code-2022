use std::{
    cmp, env,
    fs::{self, File},
    io::{BufRead, BufReader},
};

#[derive(Debug, Clone, Copy)]
struct Sand {
    x: usize,
    y: usize,
    settled: bool,
}

fn main() {
    let args: Vec<String> = env::args().collect();

    // Ensure that a single argument is passed
    if args.len() != 3 || args[1] != "p1" && args[1] != "p2" {
        println!("Advent of Code 2022 - Day 14");
        println!();
        println!("Usage:");
        println!("  cargo run {{p1|p2}} <input_file>");
        println!("Example:");
        println!("  cargo run p1 ./tests/input_2.txt");
        return;
    }

    // Init the cave attributes
    let mut rock_list: Vec<Vec<(usize, usize)>> = Vec::new();
    let sand_source = (500, 0);
    let mut cave_x_limits = (sand_source.0, sand_source.0);
    let mut cave_y_limits = (sand_source.1, sand_source.1);

    // Read the file and parse the rock paths
    let input_file = File::open(args[2].as_str()).unwrap();
    let reader = BufReader::new(input_file);
    for (index, line) in reader.lines().enumerate() {
        rock_list.push(Vec::new());
        let line = line.unwrap();
        let coords_list = line.split(" -> ");
        for coords_str in coords_list {
            let coords = coords_str.split(",").collect::<Vec<&str>>();
            let x = coords[0].parse::<usize>().unwrap_or_default();
            let y = coords[1].parse::<usize>().unwrap_or_default();
            rock_list[index].push((x, y));

            if x < cave_x_limits.0 {
                cave_x_limits.0 = x;
            }
            if x > cave_x_limits.1 {
                cave_x_limits.1 = x;
            }
            if y < cave_y_limits.0 {
                cave_y_limits.0 = y;
            }
            if y > cave_y_limits.1 {
                cave_y_limits.1 = y;
            }
        }
    }

    // Part 2, double the width of the cave and add 2 layers at the bottom
    if args[1] == "p2" {
        cave_x_limits = (0, cave_x_limits.0 * 2);
        cave_y_limits = (0, cave_y_limits.1 + 2);
    }

    println!(
        "Generating cave of size {}x{} between (x:{}, y:{}) and (x:{}, y:{})...",
        cave_x_limits.1 - cave_x_limits.0,
        cave_y_limits.1 - cave_y_limits.0,
        cave_x_limits.0 + cave_x_limits.0,
        cave_y_limits.0 + cave_y_limits.0,
        cave_x_limits.1 + cave_x_limits.0,
        cave_y_limits.1 + cave_y_limits.0
    );

    // Generate an empty cave
    let mut cave = vec![
        vec!['.'; cave_x_limits.1 - cave_x_limits.0 + 1];
        cave_y_limits.1 - cave_y_limits.0 + 1
    ];

    // Add the sand source
    cave[(sand_source.1 - cave_y_limits.0)][(sand_source.0 - cave_x_limits.0)] = '+';

    // Add the rocks
    for rock in rock_list {
        let mut last_coord = rock[0];
        cave[(last_coord.1 - cave_y_limits.0)][(last_coord.0 - cave_x_limits.0)] = '#';
        for i in 1..rock.len() {
            let coord = rock[i];
            if last_coord != coord {
                for x in cmp::min(coord.0, last_coord.0)..cmp::max(coord.0, last_coord.0) {
                    cave[(coord.1 - cave_y_limits.0)][(x - cave_x_limits.0)] = '#';
                }
                for y in cmp::min(coord.1, last_coord.1)..cmp::max(coord.1, last_coord.1) {
                    cave[(y - cave_y_limits.0)][(coord.0 - cave_x_limits.0)] = '#';
                }
            }
            cave[(coord.1 - cave_y_limits.0)][(coord.0 - cave_x_limits.0)] = '#';
            last_coord = coord;
        }
    }

    // Part 2, add a layer of rock at the bottom
    if args[1] == "p2" {
        let last_row = cave.len() - 1;
        for x in 0..cave[last_row].len() {
            cave[last_row][x] = '#';
        }
    }

    let mut sand_list: Vec<Sand> = Vec::new();
    let mut falling_abyss = false;
    let mut sand_source_blocked = false;

    // Add sand until it falls into the abyss or the sand source is blocked
    while !falling_abyss && !sand_source_blocked {
        let mut sand = Sand {
            x: sand_source.0,
            y: sand_source.1,
            settled: false,
        };
        while !sand.settled {
            let x = sand.x - cave_x_limits.0;
            let y = sand.y - cave_y_limits.0;

            // Out of lower bounds
            if cave_y_limits.1 - cave_y_limits.0 <= y {
                cave[y][x] = '~';
                falling_abyss = true;
                break;
            }

            if cave[y + 1][x] == '#' || cave[y + 1][x] == 'o' {
                // There is a rock or sand directly below
                if x < 1 {
                    // Out of left bounds
                    cave[y][x] = '~';
                    falling_abyss = true;
                    break;
                } else if cave[y + 1][x - 1] == '.' {
                    // There is air to the bottom left
                    cave[y][x] = '.';
                    cave[y + 1][x - 1] = 'o';
                    sand.x -= 1;
                    sand.y += 1;
                } else if x + 1 > cave_x_limits.1 - cave_x_limits.0 {
                    // Out of right bounds
                    cave[y][x] = '~';
                    falling_abyss = true;
                    break;
                } else if cave[y + 1][x + 1] == '.' {
                    // There is air to the bottom right
                    cave[y][x] = '.';
                    cave[y + 1][x + 1] = 'o';
                    sand.x += 1;
                    sand.y += 1;
                } else {
                    sand.settled = true;
                }
            } else if cave[y + 1][x] == '.' {
                // There is air directly below
                cave[y][x] = '.';
                cave[y + 1][x] = 'o';
                sand.y += 1;
            } else {
                sand.settled = true;
            }
        }

        if !falling_abyss {
            sand_list.push(sand);
            // Part 2, sand source is blocked
            if sand.x == sand_source.0 && sand.y == sand_source.1 {
                cave[sand.y - cave_y_limits.0][sand.x - cave_x_limits.0] = 'o';
                println!("Part 2 - Sand list length: {}", sand_list.len());
                sand_source_blocked = true;
            }
        } else {
            // Part 1, sand source is falling to the abyss
            println!("Past 1 - Sand list length: {}", sand_list.len());
        }
    }

    // Build output string
    let mut output_str = String::new();
    if args[1] == "p1" {
        cave[sand_source.1 - cave_y_limits.0][sand_source.0 - cave_x_limits.0] = '+';
    }
    for row in &cave {
        for col in row {
            output_str.push(*col);
        }
        output_str.push('\n');
    }

    // Write output string to file
    if args[1] == "p1" {
        fs::write("cave_part1.txt", output_str).unwrap();
    } else {
        fs::write("cave_part2.txt", output_str).unwrap();
    }
}
