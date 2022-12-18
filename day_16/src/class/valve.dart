/// Base class for valves.
class Valve {
  String name = "Undefined Valve";
  List<Valve> connectedValveList = [];
  int flowRate = 0;

  Valve(this.name);

  /// Return string representation.
  @override
  String toString() {
    return name;
    // return "Valve `$name` has flow rate=$flowRate; tunnels lead to valves: $connectedValves";
  }

  void connectTo(Valve valve) {
    connectedValveList.add(valve);
  }

  void disconnectFrom(Valve valve) {
    connectedValveList.remove(valve);
  }

  void setFlowRate(int flowRate) {
    this.flowRate = flowRate;
  }

  static bool existsInList(List<Valve> valveList, String valveName) {
    for (Valve v in valveList) {
      if (v.name == valveName) {
        return true;
      }
    }
    return false;
  }
}
