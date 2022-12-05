import 'crate.dart';

export 'crate.dart';

/// Base class for crate stacks.
class CrateStack {
  final int id;
  final List<Crate> crates;

  CrateStack(this.id, this.crates);

  /// Return string representation.
  @override
  String toString() {
    String result = 'CrateStack{id: $id, crates: [';
    for (Crate crate in crates) {
      result += '${crate.name}, ';
    }
    result = result.substring(0, result.length - 2); // Remove last comma
    result += ']}';
    return result;
  }

  /// Add crate to stack.
  void addCrate(Crate crate) {
    crates.add(crate);
  }

  /// Remove top crate from stack and return it.
  Crate removeCrate() {
    return crates.removeLast();
  }

  /// Get the top crate.
  Crate getTop() {
    return crates.last;
  }

  /// Remove a stack of crates from the top of the stack.
  List<Crate> removeCrateStack(int amount) {
    List<Crate> result = [];

    for (int i = 0; i < amount; i++) {
      result.add(crates.removeLast());
    }

    return result;
  }
}
