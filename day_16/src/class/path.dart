import 'valve.dart';

class Path {
  List<Valve> valveList = <Valve>[];
  List<Valve> openValves = <Valve>[];
  int release = 0;

  Path(this.valveList);

  /// Return string representation.
  @override
  String toString() {
    return "Path: $valveList; release: $release";
  }

  int getScore(int actions) {
    return valveList.last.flowRate * (actions - valveList.length);
  }

  void addOpenValve(Valve valve) {
    openValves.add(valve);
  }

  int getUsedActions() {
    return valveList.length + openValves.length - 1;
  }
}
