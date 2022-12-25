import Rock from "./classes/rock.ts";

/**
 * Perform a horizontal move on the rock.
 * @param tunnel The tunnel array.
 * @param cmd The command to execute.
 * @returns
 */
export function horizontal_move(tunnel: number[][], cmd: string) {
  let tunnel_width = tunnel[0].length;
  let move_left = false;
  let move_right = false;

  if (cmd == "<") {
    // Check if movement to the left is possible
    move_left = true;
    for (let row = 0; row < tunnel.length; row++) {
      for (let col = 0; col < tunnel_width; col++) {
        if (tunnel[row][col] == 2 && (col - 1 < 0 || tunnel[row][col - 1] == 1))
          return;
      }
    }
  } else if (cmd == ">") {
    // Check if movement to the right is possible
    move_right = true;
    for (let row = 0; row < tunnel.length; row++) {
      for (let col = tunnel_width; col >= 0; col--) {
        if (
          tunnel[row][col] == 2 &&
          (col + 1 >= tunnel_width || tunnel[row][col + 1] == 1)
        )
          return;
      }
    }
  }

  if (move_left) {
    for (let row = 0; row < tunnel.length; row++) {
      for (let col = 0; col < tunnel_width; col++) {
        if (tunnel[row][col] == 2) {
          tunnel[row][col - 1] = 2;
          tunnel[row][col] = 0;
        }
      }
    }
  } else if (move_right) {
    for (let row = 0; row < tunnel.length; row++) {
      for (let col = tunnel_width - 2; col >= 0; col--) {
        if (tunnel[row][col] == 2) {
          tunnel[row][col + 1] = 2;
          tunnel[row][col] = 0;
        }
      }
    }
  }
}

/**
 * Attempt to find a repeating pattern in the rock list.
 * @param rock_list The list of rocks.
 * @returns [-1, -1] if no pattern found, otherwise [pattern_start_rock_id, pattern_end_rock_id]
 */
export function find_pattern(rock_list: Rock[]): [number, number] {
  let pattern_start_rock_id = -1;
  let pattern_end_rock_id = -1;

  outer_loop: for (let i = 0; i < rock_list.length / 4; i++) {
    for (let j = rock_list.length / 2 - 1; j >= i + 1; j--) {
      let rock1 = rock_list[i];
      let rock2 = rock_list[j];

      if (
        rock1.jet_pattern_end_id == rock2.jet_pattern_end_id &&
        rock1.jet_pattern_start_id == rock2.jet_pattern_start_id &&
        rock1.shape_id == rock2.shape_id
      ) {
        // Found a potential pattern starting matching rocks
        let found_pattern = true;
        inner_loop: for (let k = i + 1; k < j; k++) {
          let rock3 = rock_list[k];
          let rock4 = rock_list[j + (k - i)];
          if (
            rock3.jet_pattern_end_id != rock4.jet_pattern_end_id ||
            rock3.jet_pattern_start_id != rock4.jet_pattern_start_id ||
            rock3.shape_id != rock4.shape_id
          ) {
            // Pattern is broken if any rocks in between don't match
            found_pattern = false;
            break inner_loop;
          }
        }

        // Pattern is found if all rocks in between match
        if (found_pattern) {
          pattern_start_rock_id = i;
          pattern_end_rock_id = j;
          break outer_loop;
        }
      }
    }
  }

  return [pattern_start_rock_id, pattern_end_rock_id];
}

/**
 * Prune the blocked/unreachable rows from the tunnel.
 * @param tunnel The tunnel array.
 * @returns The amount of rows that were pruned.
 */
export function prune_blocked_rows(tunnel: number[][]): number {
  let tunnel_width = tunnel[0].length;
  let prune_count = 0;
  let fully_blocked_row = -1;

  // Skip the first 4 rows as they are always reachable
  // Don't check the full tunnel length for performance
  for (let row = 4; row < tunnel.length * 0.5; row++) {
    let is_fully_blocked = true;
    inner_loop_blocked: for (let col = 0; col < tunnel_width; col++) {
      if (tunnel[row][col] == 0) {
        // Create an empty array of visited cells
        let visited: number[][] = [];
        for (let i = 0; i <= row; i++) {
          visited.unshift(new Array(tunnel_width).fill(0));
        }

        // Cells that can reach the top are not fully blocked
        if (can_reach_top(tunnel, row, col, visited)) {
          is_fully_blocked = false;
          break inner_loop_blocked;
        }
      } else if (tunnel[row][col] == 2) {
        // If there is an unsettled rock, the cell is reachable
        is_fully_blocked = false;
        break;
      }
    }
    if (is_fully_blocked) {
      fully_blocked_row = row;
      break;
    }
  }
  // Remove fully blocked rows
  if (fully_blocked_row != -1) {
    prune_count = tunnel.length - fully_blocked_row;
    tunnel.splice(fully_blocked_row, prune_count);
  }
  return prune_count;
}

/**
 * Recursively check if a cell can reach the top.
 * Checks the left, top and right sides only.
 * @param tunnel The tunnel array.
 * @param row The row to check.
 * @param col The column to check.
 * @param visited The array of visited cells.
 * @returns True if the cell can reach the top. False otherwise.
 */
export function can_reach_top(
  tunnel: number[][],
  row: number,
  col: number,
  visited: number[][]
): boolean {
  let tunnel_width = tunnel[0].length;
  visited[row][col] = 1;

  // Can reach top if at the top or there is an unsettled block above
  if (row == 0 || tunnel[row - 1][col] == 2) return true;

  // Recursively try the top if there are no rocks
  if (tunnel[row - 1][col] == 0 && visited[row - 1][col] == 0) {
    visited[row - 1][col] = 1;
    if (can_reach_top(tunnel, row - 1, col, visited)) return true;
  }

  // Recursively try the left if there are no rocks
  if (col - 1 >= 0 && tunnel[row][col - 1] == 0 && visited[row][col - 1] == 0) {
    visited[row][col - 1] = 1;
    if (can_reach_top(tunnel, row, col - 1, visited)) return true;
  }

  // Recursively try the right if there are no rocks
  if (
    col + 1 < tunnel_width &&
    tunnel[row][col + 1] == 0 &&
    visited[row][col + 1] == 0
  ) {
    visited[row][col + 1] = 1;
    if (can_reach_top(tunnel, row, col + 1, visited)) return true;
  }

  return false;
}

/**
 * Find the height of the stacked rocks.
 * @param tunnel The tunnel array.
 * @returns The height of the stacked rocks.
 */
export function find_stack_height(tunnel: number[][]): number {
  for (let i = 0; i < tunnel.length; i++) {
    for (let j = 0; j < tunnel[i].length; j++) {
      // Stop at the first settled rock
      if (tunnel[i][j] == 1) {
        return tunnel.length - i;
      }
    }
  }
  return 0;
}

/**
 * Perform a vertical move on the rock.
 * @param tunnel The tunnel array.
 * @returns True if rock is settled. False otherwise.
 */
export function vertical_move(
  tunnel: number[][],
  unsettled_rock_chunks_count: number
): boolean {
  let tunnel_width = tunnel[0].length;
  let is_rock_settled = false;
  let chunks_checked = 0;

  // Check if the rock can move down
  outer_loop_settle: for (let row = tunnel.length - 1; row >= 0; row--) {
    for (let col = 0; col < tunnel_width; col++) {
      if (tunnel[row][col] == 2) {
        chunks_checked++;
        if (row + 1 >= tunnel.length || tunnel[row + 1][col] == 1) {
          is_rock_settled = true;
          break outer_loop_settle;
        }
      }
      // Break out of loop if all unsettled chunks have been checked.
      if (chunks_checked == unsettled_rock_chunks_count) {
        break outer_loop_settle;
      }
    }
  }

  chunks_checked = 0;
  if (is_rock_settled) {
    // Convert the unsettled rock into a settled rock
    outer_loop_convert: for (let row = 0; row < tunnel.length; row++) {
      for (let col = 0; col < tunnel_width; col++) {
        if (tunnel[row][col] == 2) {
          chunks_checked++;
          tunnel[row][col] = 1;
        }

        // Break out of loop if all unsettled chunks have been checked
        if (chunks_checked == unsettled_rock_chunks_count)
          break outer_loop_convert;
      }
    }
  } else {
    // Falling down
    outer_loop_fall: for (let row = tunnel.length - 1; row >= 0; row--) {
      for (let col = 0; col < tunnel_width; col++) {
        if (tunnel[row][col] == 2) {
          chunks_checked++;
          tunnel[row][col] = 0;
          tunnel[row + 1][col] = 2;
        }

        // Break out of loop if all unsettled chunks have been checked.
        if (chunks_checked == unsettled_rock_chunks_count) {
          break outer_loop_fall;
        }
      }
    }
  }

  return is_rock_settled;
}

/**
 * Generate a string representation of the tunnel.
 * @param tunnel The tunnel array.
 * @returns The tunnel string.
 */
export function generateTunnelStr(tunnel: number[][]): String {
  let tunnel_width = tunnel[0].length;
  let output = "+vvvvvvv+\n";

  for (let i = 0; i < tunnel.length; i++) {
    output += "|";
    for (let j = 0; j < tunnel[i].length; j++) {
      if (tunnel[i][j] == 0) {
        output += ".";
      } else if (tunnel[i][j] == 1) {
        output += "#";
      } else if (tunnel[i][j] == 2) {
        output += "@";
      }
    }
    output += "|\n";
  }
  output += "+";
  for (let i = 0; i < tunnel_width; i++) {
    output += "-";
  }
  output += "+";

  return output;
}
