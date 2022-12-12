# Breadth First Search Algorithm
# Inspired from: https://medium.com/@urna.hybesis/pathfinding-algorithms-the-four-pillars-1ebad85d4c6b
#
# @param int_map The map with the elevations
# @param start_position The start position (x, y)
# @param end_position The end position (x, y)
# @param max_value The maximum value to search for (default = -1)
#
# @return The number of steps to reach the end position
breadth_first_search <- function(int_map, start_position, end_position, max_value = -1) {
  distance_map <- int_map
  for (i in 1:nrow(distance_map)) {
    for (j in 1:ncol(distance_map)) {
      distance_map[i, j] <- 0
    }
  }

  visited <- list(start_position)
  queue <- list(start_position)
  distance <- 0
  steps <- 0

  while (length(queue) != 0) {
    # Get next node
    current_position <- queue[[1]]
    # Remove node from queue
    queue[1] <- NULL
    # Set distance to current node distance + 1
    distance <- distance_map[current_position[2], current_position[1]] + 1

    # End if end position reached
    if (current_position[1] == end_position[1] && current_position[2] == end_position[2]) {
      return(distance_map)
    }

    # End current iteration if max_value reached
    if (max_value != -1 && distance >= max_value) {
      next
    }

    # Check valid neighbours and add them to the queue
    valid_neighbours <- get_valid_neighbours(current_position, int_map)
    for (neighbour in valid_neighbours) {
      already_visited <- FALSE
      for (visited_node in visited) {
        if (visited_node[1] == neighbour[1] && visited_node[2] == neighbour[2]) {
          already_visited <- TRUE
          break
        }
      }
      # Nodes that are not yet visited are added to the queue
      if (already_visited == FALSE) {
        queue[[length(queue) + 1]] <- neighbour
        visited[[length(visited) + 1]] <- neighbour
        distance_map[neighbour[2], neighbour[1]] <- distance
      }
    }
    steps <- steps + 1
  }

  return(distance_map)
}

# Check if coordinate is in matrix
#
# @param coordinate The coordinate to check (x, y)
check_coordinate_in_matrix <- function(coordinate, matrix) {
  if (coordinate[2] < 1 || coordinate[2] > nrow(matrix)) {
    return(FALSE)
  }
  if (coordinate[1] < 1 || coordinate[1] > ncol(matrix)) {
    return(FALSE)
  }
  return(TRUE)
}

# Get valid neighbours
#
# @param coordinate The coordinate to check (x, y)
get_valid_neighbours <- function(coordinate, int_map) {
  neighbours <- list()

  # Check bottom node
  bottom_position <- c(coordinate[1], coordinate[2] + 1)
  if (check_coordinate_in_matrix(bottom_position, int_map) == TRUE && get_coord_int(bottom_position, int_map) - 1 <= get_coord_int(coordinate, int_map)) {
    neighbours[[length(neighbours) + 1]] <- bottom_position
  }
  # Check right node
  right_position <- c(coordinate[1] + 1, coordinate[2])
  if (check_coordinate_in_matrix(right_position, int_map) == TRUE && get_coord_int(right_position, int_map) - 1 <= get_coord_int(coordinate, int_map)) {
    neighbours[[length(neighbours) + 1]] <- right_position
  }
  # Check top node
  top_position <- c(coordinate[1], coordinate[2] - 1)
  if (check_coordinate_in_matrix(top_position, int_map) == TRUE && get_coord_int(top_position, int_map) - 1 <= get_coord_int(coordinate, int_map)) {
    neighbours[[length(neighbours) + 1]] <- top_position
  }
  # Check left node
  left_position <- c(coordinate[1] - 1, coordinate[2])
  if (check_coordinate_in_matrix(left_position, int_map) == TRUE && get_coord_int(left_position, int_map) - 1 <= get_coord_int(coordinate, int_map)) {
    neighbours[[length(neighbours) + 1]] <- left_position
  }

  return(neighbours)
}

get_coord_int <- function(coordinate, int_map) {
  return(int_map[coordinate[2], coordinate[1]])
}

convert_charmap_to_intmap <- function(char_map) {
  int_map <- matrix(, nrow = length(char_map), ncol = length(char_map[[1]]))
  for (i in 1:nrow(int_map)) {
    for (j in 1:ncol(int_map)) {
      if (char_map[[i]][j] == "S") {
        int_map[i, j] <- 1
      } else {
        int_map[i, j] <- which(char_value == char_map[[i]][j])
      }
    }
  }
  return(int_map)
}