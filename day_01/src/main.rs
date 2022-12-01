use std::{env, fs::File, io::Read};

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() != 2 {
        // Ensure that a single argument is passed
        println!("Please input the file path as 2nd argument.");
        println!("Format: cargo run --release path/to/file");
        println!("Example: cargo run --release ./tests/input.txt");
    } else {
        // Try reading the file
        let input_file_result = File::open(args[1].as_str());
        let mut input_file = match input_file_result {
            Ok(file) => file,
            Err(error) => {
                println!("Error: {}", error);
                return;
            }
        };
        let mut input_file_str = String::new();
        input_file
            .read_to_string(&mut input_file_str)
            .expect("Error reading file");

        // Init variables
        let mut total = 0u32;
        let mut calories_max = 0u32;
        let mut elf_index = 0usize;
        let mut elf_calories_max_index = 0usize;
        let mut calories_total_vec: Vec<u32> = Vec::new();
        let mut lines = input_file_str.lines();

        // Loop through each line
        while let Some(line) = lines.next() {
            let calories = line.parse::<u32>().unwrap_or_default();

            // Check if the calories is 0, i.e. the elf is different
            if calories == 0 {
                elf_index += 1;

                // Set the max calories
                if total > calories_max {
                    calories_max = total;
                    elf_calories_max_index = elf_index;
                };

                calories_total_vec.push(total);

                // Reset the total for the next elf
                total = 0;
            } else {
                total += calories;
            }
        }
        println!(
            "Elf #{} has the most calories: {}",
            elf_calories_max_index, calories_max
        );

        // Sort in descending order
        calories_total_vec.sort();
        calories_total_vec.reverse();

        println!(
            "The 3 elves with the most calories have: {:?}",
            calories_total_vec.get(0..3).unwrap()
        );
        println!(
            "The 3 elves with the most calories have a total of {:?} calories.",
            calories_total_vec.get(0..3).unwrap().iter().sum::<u32>()
        );
    }
}
