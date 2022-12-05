/// Base class for move orders.
class MoveOrder {
  /// The amount of crates to move.
  final int amount;

  /// The stack id to move from.
  final int from;

  /// The stack id to move to.
  final int to;

  MoveOrder(this.amount, this.from, this.to);

  /// Return string representation.
  @override
  String toString() {
    return "Move $amount from $from to $to";
  }
}
