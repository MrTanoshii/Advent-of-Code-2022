import 'dart:io';

import 'class/valve.dart';
import 'class/path.dart';

void main(List<String> args) async {
  final stopwatch = Stopwatch()..start();

  // Display usage information
  if (args.length != 1) {
    print("Usage: dart ./src/main.dart <input file>");
    exit(1);
  }

  // Try to read the input file
  String rawInput;
  try {
    // Read the input file
    File file = File(args[0]);
    rawInput = await file.readAsString();
  } catch (e) {
    // If encountering an error, return
    print("Error reading file");
    exit(1);
  }

  List<Valve> valveList = parseValves(rawInput);
  print("Found " + valveList.length.toString() + " valves");

  /* Try sorted way */
  Path part1Path = findBestPath(valveList, 30);
  print("Part 1 | Optimal " + part1Path.toString());
  print("         Open valves are: " + part1Path.openValves.toString());
  print("         Minutes used: " + part1Path.getUsedActions().toString());

  print("Execution took ${stopwatch.elapsed}");
}

Path findBestPath(List<Valve> valveList, int actions) {
  List<Valve> sortedValveList = findSortedValves(valveList);
  print("There are " +
      sortedValveList.length.toString() +
      " valves with flowrates.");

  return assemblePath(valveList, 30);
}

Path assemblePath(List<Valve> valveList, int actions) {
  List<Valve> sortedValveList = findSortedValves(valveList);
  print(sortedValveList);
  List<Path> allPaths = <Path>[
    // Path([valveList[0]]) // For demo
    // Path([sortedValveList[0]]) // For part 1
  ];
  int maxRelease = 0;
  Path bestPath = Path(<Valve>[]);

  // // For the actual best flowrate (Test All)
  // sortedValveList.forEach((element) {
  //   allPaths.add(Path([element]));
  // });
  // // For the actual best flowrate (Test only valve `AQ`)
  allPaths.add(Path([sortedValveList[5]]));

  int minCost = double.maxFinite.toInt();
  sortedValveList.forEach((el1) {
    sortedValveList.forEach((el2) {
      if (el1 != el2) {
        int cost = findPathDepth(el1, el2);
        if (cost < minCost) {
          minCost = cost;
        }
      }
    });
  });

  // While there are still paths to check
  do {
    Path path = allPaths.removeAt(0);

    // Check if path is best
    if (path.release > maxRelease) {
      maxRelease = path.release;
      bestPath = path;
    }

    // Disregard paths that will never be the best
    int maxPossibleRelease = 0;
    int counter = -1;
    sortedValveList.forEach((valve) {
      if (!path.openValves.contains(valve)) {
        maxPossibleRelease += valve.flowRate *
            (actions - (path.getUsedActions() + minCost + counter));
        counter++;
      }
    });
    if (path.release + maxPossibleRelease < maxRelease) {
      continue;
    }

    // Try and go to every valve with a flowrate that is not already open
    sortedValveList.forEach((valve) {
      if (!path.openValves.contains(valve)) {
        int pathDepth = findPathDepth(path.valveList.last, valve);
        List<Valve> pathToValve =
            findPath(path.valveList.last, valve, pathDepth, <Valve>[]);

        // Go to valve if there are enough actions
        if (path.getUsedActions() + pathToValve.length <= actions) {
          Path subPath = Path([...path.valveList, ...pathToValve.sublist(1)]);

          // Update sub path
          subPath.openValves = [...path.openValves, valve];
          subPath.release = path.release +
              (valve.flowRate * (actions - subPath.getUsedActions()));

          allPaths.add(subPath);
        }
      }
    });
  } while (allPaths.length > 1);

  return bestPath;
}

List<Valve> findSortedValves(List<Valve> valveList) {
  List<Valve> sortedValveList = <Valve>[];
  // Only get valves that have a flowrate
  valveList.forEach((valve) {
    if (valve.flowRate > 0) {
      sortedValveList.add(valve);
    }
  });
  // Sort the valves by flowrate in descending order
  for (int i = 0; i < sortedValveList.length; i++) {
    for (int j = i + 1; j < sortedValveList.length; j++) {
      if (sortedValveList[i].flowRate < sortedValveList[j].flowRate) {
        Valve lowerValve = sortedValveList.removeAt(i);
        sortedValveList.insert(j, lowerValve);
      }
    }
  }
  return sortedValveList;
}

int findPathDepth(Valve startValve, Valve endValve) {
  int cost = 0;
  List<Valve> queue = <Valve>[startValve];

  while (true) {
    int queueLength = queue.length;
    cost++;
    for (int i = 0; i < queueLength; i++) {
      Valve currentValve = queue.removeAt(0);
      if (currentValve == endValve) {
        return cost - 1;
      }
      currentValve.connectedValveList.forEach((valve) {
        if (!queue.contains(valve)) {
          queue.add(valve);
        }
      });
    }
  }
}

List<Valve> findPath(
    Valve startValve, Valve endValve, int maxDepth, List<Valve> currentPath) {
  if (maxDepth < 0) {
    return <Valve>[];
  }
  if (startValve == endValve) {
    return <Valve>[endValve];
  }
  for (int i = 0; i < startValve.connectedValveList.length; i++) {
    Valve connectedValve = startValve.connectedValveList[i];
    if (!currentPath.contains(connectedValve)) {
      List<Valve> path = findPath(connectedValve, endValve, maxDepth - 1,
          <Valve>[...currentPath, startValve]);
      if (path.length > 0) {
        return <Valve>[startValve, ...path];
      }
    }
  }
  return <Valve>[];
}

List<Valve> parseValves(String rawInput) {
  List<Valve> valveList = <Valve>[];

  // Split the input into lines
  List<String> lines = rawInput.trim().split("\n");

  lines.forEach((line) {
    line = line.trim();
    List<String> words = line.split(" ");
    final String name = words[1];
    final int flowRate = int.parse(words[4].substring(5, words[4].length - 1));

    Valve valve;
    if (!Valve.existsInList(valveList, name)) {
      valve = Valve(name);
      valve.setFlowRate(flowRate);
      valveList.add(valve);
    } else {
      valve = valveList.firstWhere((v) => v.name == name);
      valve.setFlowRate(flowRate);
    }

    for (int i = 9; i < words.length; i++) {
      String connectionName = words[i].replaceAll(",", "").trim();
      Valve connectingValve;
      if (!Valve.existsInList(valveList, connectionName)) {
        connectingValve = Valve(connectionName);
        valveList.add(connectingValve);
      } else {
        connectingValve = valveList.firstWhere((v) => v.name == connectionName);
      }
      valve.connectTo(connectingValve);
    }
  });

  return valveList;
}
