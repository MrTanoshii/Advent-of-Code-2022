source("./src/util.r")

start_time <- Sys.time()

args = commandArgs(trailingOnly=TRUE)
# Display usage information if number of arguments doesn't match expectation
if (length(args) != 1) {
  stop("Usage: Rscript ./src/main.r <input_file>")
}

# Read in the file
path <- getwd()
input_file_lines <- readLines(paste(path, args[1], sep = ""))
input_line_chars <- strsplit(input_file_lines, split = "")

# Find the start and end positions
line_index <- 1
for (line_chars in input_line_chars) {
  char_index <- 1
  for (char in line_chars) {
    if (char == "S") {
      start_position <- c(char_index, line_index)
    } else if (char == "E") {
      end_position <- c(char_index, line_index)
    }
    char_index <- char_index + 1
  }
  line_index <- line_index + 1
}

char_value <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "E")

"Generating int_map from char_map..."
int_map <- convert_charmap_to_intmap(input_line_chars)

shortest_step_list <- list()

# Search from `S` to `E`
print(paste("Search # 1 at (", start_position[[1]], ",", start_position[[2]], ") ..."))
distance_map <- breadth_first_search(int_map, start_position, end_position)
shortest_step_list[[1]] <- get_coord_int(end_position, distance_map)
print(paste("Minimum steps from `S`:", get_coord_int(end_position, distance_map)))
# write.csv2(distance_map, "distance_map.csv")

# PART 2

start_positions <- list()

# Find all `a` postions and add them as starting positions
for (i in 1:nrow(int_map)) {
  for (j in 1:ncol(int_map)) {
    if (int_map[i, j] == 1) {
      start_positions[[length(start_positions) + 1]] <- c(j, i)
    }
  }
}

# Search from all `a`s to `E`
search_count <- 2
for (start_position in start_positions) {
  max_search_value <- min(unlist(shortest_step_list))
  print(paste("Search #", search_count ," of #", length(start_positions) + 1, " at (", start_position[[1]], ",", start_position[[2]], ") with max value allowed ", max_search_value ," ...", sep = ""))

  distance_map <- breadth_first_search(int_map, start_position, end_position, max_search_value)
  shortest_step <- get_coord_int(end_position, distance_map)

  # Do not retain 0s as they haven't reached the end position
  if (shortest_step != 0) {
    shortest_step_list[[length(shortest_step_list) + 1]] <- get_coord_int(end_position, distance_map)
  }

  search_count <- search_count + 1
}
# write.csv2(shortest_step_list, "shortest_steps.csv")

print(paste("Minimum steps from any `a`: ", min(unlist(shortest_step_list)), sep = ""))
print(Sys.time() - start_time)