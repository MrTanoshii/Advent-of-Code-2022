import Rock from "./classes/rock.ts";
import {
  find_pattern,
  find_stack_height,
  generateTunnelStr,
  horizontal_move,
  prune_blocked_rows,
  vertical_move,
} from "./utils.ts";

const start_time = new Date().getTime();
const input_str: string = await Deno.readTextFile(Deno.args[0]);

const tunnel_width = 7;
const tunnel: number[][] = [];

/**
 * 0 - ..####.
 *
 * 1 - ...#...
 *     ..###..
 *     ...#...
 *
 * 2 - ....#..
 *     ....#..
 *     ..###..
 *
 * 3 - ..#....
 *     ..#....
 *     ..#....
 *     ..#....
 *
 * 4 - ..##...
 *     ..##...
 */
let new_rock_index = 0;
let rock_count = 0;
const cmds = [...input_str.trim()];
("");
let cmd_index = 0;
let stack_height = 0;
let pruned_stack_height = 0;
let unsettled_rock_chunks_count = 0;
const prune_check_interval = 10;
let rock_list: Rock[] = [];
let is_pattern_found = false;
let pattern_start_rock_id = -1;
let pattern_end_rock_id = -1;

console.log("Prune check interval: " + prune_check_interval + " rocks.");
console.log("There are " + cmds.length + " commands.");
console.log("There are 5 types of rocks.");

const max_rock_sim: number = Deno.args[1];
const min_rock_sim = 8000;

// Run simulation until the rocks have settled
while (rock_count < max_rock_sim) {
  // Compute required extra height
  let req_extra_height = 4;
  switch (new_rock_index) {
    case 3:
      req_extra_height += 1;
    case 1:
    case 2:
      req_extra_height += 1;
    case 4:
      req_extra_height += 1;
    case 0:
      break;
    default:
      console.log("Invalid rock index.");
  }

  // Grow tunnel as required
  while (stack_height + req_extra_height > tunnel.length) {
    tunnel.unshift(new Array(tunnel_width).fill(0));
  }
  // Shrink tunnel if too many free rows are available
  while (stack_height + req_extra_height < tunnel.length) {
    tunnel.shift();
  }

  // Add rock
  let rock = new Rock(rock_count, cmd_index);
  rock.shape_id = new_rock_index;
  if (new_rock_index == 0) {
    // ..####.

    tunnel[0][2] = 2;
    tunnel[0][3] = 2;
    tunnel[0][4] = 2;
    tunnel[0][5] = 2;
    unsettled_rock_chunks_count += 4;
  } else if (new_rock_index == 1) {
    // ...#...
    // ..###..
    // ...#...

    tunnel[0][3] = 2;
    tunnel[1][2] = 2;
    tunnel[1][3] = 2;
    tunnel[1][4] = 2;
    tunnel[2][3] = 2;
    unsettled_rock_chunks_count += 5;
  } else if (new_rock_index == 2) {
    // ....#..
    // ....#..
    // ..###..

    tunnel[0][4] = 2;
    tunnel[1][4] = 2;
    tunnel[2][2] = 2;
    tunnel[2][3] = 2;
    tunnel[2][4] = 2;
    unsettled_rock_chunks_count += 5;
  } else if (new_rock_index == 3) {
    // ..#....
    // ..#....
    // ..#....
    // ..#....

    tunnel[0][2] = 2;
    tunnel[1][2] = 2;
    tunnel[2][2] = 2;
    tunnel[3][2] = 2;
    unsettled_rock_chunks_count += 4;
  } else if (new_rock_index == 4) {
    // ..##...
    // ..##...

    tunnel[0][2] = 2;
    tunnel[0][3] = 2;
    tunnel[1][2] = 2;
    tunnel[1][3] = 2;
    unsettled_rock_chunks_count += 4;
  }
  rock_count++;

  while (true) {
    horizontal_move(tunnel, cmds[cmd_index]);
    cmd_index = (cmd_index + 1) % cmds.length;

    if (vertical_move(tunnel, unsettled_rock_chunks_count)) {
      unsettled_rock_chunks_count = 0;
      rock.jet_pattern_end_id = cmd_index;
      rock.stack_height_on_settle =
        find_stack_height(tunnel) + pruned_stack_height;
      rock_list.push(rock);
      break;
    }
  }

  // Prune tunnel from fully blocked rows at regular intervals
  if (rock_count % prune_check_interval == 0) {
    pruned_stack_height += prune_blocked_rows(tunnel);
  }

  if (rock_count % 100000 == 0) {
    // Display time elapsed and rock count
    console.log(
      (new Date().getTime() - start_time) / 1000 +
        "s - Rock count: " +
        rock_count
    );

    // Find the pattern if more than the minimum number of rocks have been simulated
    if (rock_count > min_rock_sim && !is_pattern_found) {
      [pattern_start_rock_id, pattern_end_rock_id] = find_pattern(rock_list);
      if (pattern_start_rock_id != -1 && pattern_end_rock_id != -1)
        is_pattern_found = true;
    }
  }

  // If pattern was found, simulate the rocks
  if (is_pattern_found) {
    let pattern_length = pattern_end_rock_id - pattern_start_rock_id;
    // Make sure the sim starting point is correct
    if ((rock_count - pattern_start_rock_id) % pattern_length == 0) {
      // Simulate complete pattern chunks
      while (
        (max_rock_sim - (pattern_start_rock_id + rock_count)) /
          pattern_length >=
        1
      ) {
        rock_count += pattern_length;
        pruned_stack_height +=
          rock_list[pattern_end_rock_id - 1].stack_height_on_settle -
          rock_list[pattern_start_rock_id - 1].stack_height_on_settle;
      }
    }
  }
  stack_height = find_stack_height(tunnel);
  new_rock_index = (new_rock_index + 1) % 5;
}

// Display results
stack_height = find_stack_height(tunnel);
let output = generateTunnelStr(tunnel);
console.log("Final Results:");
console.log("    Rock count: " + rock_count);
console.log(
  "    Tunnel height: " + (stack_height + pruned_stack_height) + " blocks"
);
console.log("    Pruned height: " + pruned_stack_height + " blocks");

// Display elapsed time
const end_time = new Date().getTime();
console.log("    Time taken: " + (end_time - start_time) / 1000 + "s");

// Save to file
Deno.writeTextFile("./output.txt", output);
