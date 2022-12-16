import 'dart:io';

import 'class/cratestack.dart';
import 'class/moveorder.dart';

/// Return crate details.
String getCrateDetails(String rawInput) {
  String crateDetails = rawInput.split("move")[0].trimRight();
  return crateDetails;
}

/// Return list of crate stacks (populated)
List<CrateStack> getCrateStacks(String rawInput) {
  String crateDetails = getCrateDetails(rawInput);
  final List<String> lines = crateDetails.split("\n");
  lines.removeLast(); // Remove crate numbering
  List<CrateStack> stacks = [];

  List<String> exceptions = [" ", "[", "]", '\r'];

  for (int i = lines.length - 1; i >= 0; i--) {
    // print("Line: ${lines[i]}");
    int j = 0;
    int stackID = 0;

    for (int k = 0; k < lines[i].length; k++) {
      final String char = lines[i][k];
      if (j % 4 == 1) {
        stackID++;
        if (stacks.length < stackID) stacks.add(CrateStack(stackID, []));
      }

      if (!exceptions.contains(char)) {
        // print("Adding crate $char to stack $stackID");
        Crate crate = Crate(char);
        stacks[stackID - 1].addCrate(crate);
      }

      j++;
    }
  }

  return stacks;
}

/// Return list of move orders.
List<MoveOrder> getMoveOrders(String rawInput) {
  List<MoveOrder> moveOrders = [];
  List<String> moveList = rawInput.split("move");

  moveList.removeAt(0); // Remove the crate details

  for (int i = 0; i < moveList.length; i++) {
    moveList[i] = moveList[i].trim();
    List<String> splitMove = moveList[i].split(" ");
    moveOrders.add(MoveOrder(int.parse(splitMove[0]), int.parse(splitMove[2]),
        int.parse(splitMove[4])));
  }

  return moveOrders;
}

void main() async {
  // Try to read the input file
  String rawInput;
  try {
    // Read the input file
    final file = File('./data/input.dat');
    rawInput = await file.readAsString();
  } catch (e) {
    // If encountering an error, return
    print("Error reading file");
    exit(1);
  }

  // Process the raw input
  List<CrateStack> stacks = getCrateStacks(await rawInput);
  List<MoveOrder> moveOrders = getMoveOrders(await rawInput);

  // // Display statistics
  // print("Crate Details: ");
  // print(getCrateDetails(await rawInput));
  // print("Number of move orders: " + moveOrders.length.toString());
  // for (int i = 0; i < moveOrders.length; i++) {
  //   print("#" + i.toString() + " - " + moveOrders[i].toString());
  // }
  // for (int i = 0; i < stacks.length; i++) {
  //   print("#" + (i + 1).toString() + " - " + stacks[i].toString());
  // }

  // Process the move orders
  for (MoveOrder moveOrder in moveOrders) {
    // print("Move order: " + moveOrder.toString());
    for (int i = 0; i < moveOrder.amount; i++) {
      // print("   Moving crate " +
      //     stacks[moveOrder.from - 1].getTop().name +
      //     " from stack " +
      //     moveOrder.from.toString() +
      //     " to stack " +
      //     moveOrder.to.toString());
      Crate crate = stacks[moveOrder.from - 1].removeCrate();
      stacks[moveOrder.to - 1].addCrate(crate);
    }
  }

  // Print stacks after move orders
  print("--------------------------------");
  for (int i = 0; i < stacks.length; i++) {
    print("#" + (i + 1).toString() + " - " + stacks[i].toString());
  }
  print("--------------------------------");

  // PART 2
  print("------------PART 2--------------");

  // Part 2: Process the raw input
  List<CrateStack> stacksPart2 = getCrateStacks(await rawInput);

  // Part 2: Process the move orders
  for (MoveOrder moveOrder in moveOrders) {
    // print("Move order: " + moveOrder.toString());
    List<Crate> crates =
        stacksPart2[moveOrder.from - 1].removeCrateStack(moveOrder.amount);
    // String moveProcessString = "   Moving crates [";
    for (int i = crates.length - 1; i >= 0; i--) {
      // moveProcessString += crates[i].name + ", ";
      stacksPart2[moveOrder.to - 1].addCrate(crates[i]);
    }
    // moveProcessString = moveProcessString.substring(
    //     0, moveProcessString.length - 2); // Remove last comma
    // moveProcessString += "] from stack " +
    //     moveOrder.from.toString() +
    //     " to stack " +
    //     moveOrder.to.toString();
    // print(moveProcessString);
  }

  // Part 2: Print stacks after move orders
  print("--------------------------------");
  for (int i = 0; i < stacksPart2.length; i++) {
    print("#" + (i + 1).toString() + " - " + stacksPart2[i].toString());
  }
  print("--------------------------------");

  return;
}
