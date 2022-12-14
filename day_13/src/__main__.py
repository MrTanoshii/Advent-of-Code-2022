from typing import Any, List, Union


class Packet:
    total: int = 0
    valid_pairs: int = 0
    invalid_pairs: int = 0
    unknown_pairs: int = 0
    sum_indices_pairs: int = 0

    def __init__(self, packets: list[Any]):
        """Constructor.

        Keyword arguments:
        packets -- the packets in a list
        """
        Packet.total += 1
        Packet.unknown_pairs += 1 if Packet.total % 2 == 0 else 0
        self.id: int = Packet.total
        self.pair_id: int = (Packet.total + 1) // 2
        self.packets: List[Any] = packets

    def __str__(self):
        """String representation."""
        return f"Packet #{self.id} of pair #{self.pair_id}: {self.packets}"

    def __lt__(self, other: "Packet"):
        """Less than.

        Keyword arguments:
        other -- the other packet
        """
        if compare_lists(self.packets, other.packets) < 0:
            return True
        return False

    def __le__(self, other: "Packet"):
        """Less than or equal.

        Keyword arguments:
        other -- the other packet
        """
        if compare_lists(self.packets, other.packets) <= 0:
            return True
        return False

    def __eq__(self, other: "Packet"):
        """Equal.

        Keyword arguments:
        other -- the other packet
        """
        if compare_lists(self.packets, other.packets) == 0:
            return True
        return False

    @classmethod
    def set_valid(cls, pair_id: int):
        """Set the packet pair as valid.

        Keyword arguments:
        pair_id -- the pair id
        """
        Packet.valid_pairs += 1
        Packet.unknown_pairs -= 1
        Packet.sum_indices_pairs += pair_id

    @classmethod
    def set_invalid(cls):
        """Set the packet pair as invalid."""
        Packet.invalid_pairs += 1
        Packet.unknown_pairs -= 1

    @classmethod
    def display_stats(cls):
        """Display the packet pair stats."""
        print(f"--- Packet Pair Stats ---")
        print(f"  Valid:      {cls.valid_pairs}")
        print(f"  Invalid:    {cls.invalid_pairs}")
        print(f"  Unknown:    {cls.unknown_pairs}")
        print(f"  Total:      {cls.total // 2}")
        print(f"  E(Indices): {cls.sum_indices_pairs}")
        print(f"-------------------------")


def compare_elements(
    left_el: Union[int, List[Any], None],
    right_el: Union[int, List[Any], None],
) -> int:
    """Compare two elements.

    Keyword arguments:
    left_el -- the left element
    right_el -- the right element
    """
    as_list = lambda a: a if type(a) == list else [a]
    if type(left_el) == int and type(right_el) == int:
        if left_el == right_el:
            return 0
        if left_el < right_el:
            return -1
        return 1
    elif type(left_el) == list or type(right_el) == list:
        return compare_lists(as_list(left_el), as_list(right_el))


def compare_lists(left_list: List[Any], right_list: List[Any]) -> int:
    """Compare two lists.

    Keyword arguments:
    left_list -- the left list
    right_list -- the right list
    """
    for i in range(len(left_list)):
        if len(right_list) <= i:
            return 1
        result = compare_elements(left_list[i], right_list[i])
        if result != 0:
            return result
    if len(left_list) < len(right_list):
        return -1
    return 0


if __name__ == "__main__":
    import sys

    file = open(sys.argv[1], "r")
    lines: List[str] = file.readlines()
    file.close()

    es = lambda a: eval(a.strip())
    packet_list: List[Packet] = []
    for i in range(0, len(lines), 3):
        packet_list.append(Packet(es(lines[i])))
        packet_list.append(Packet(es(lines[i + 1])))
        result = compare_lists(packet_list[-2].packets, packet_list[-1].packets)
        if result == 1:
            Packet.set_invalid()
        elif result == -1:
            Packet.set_valid(packet_list[-2].pair_id)

    Packet.display_stats()

    divider_list = [Packet([[2]]), Packet([[6]])]
    packet_list.extend(divider_list)
    sorted_packets = sorted(packet_list)

    # for packet in sorted_packets:
    #     print(packet)

    print(
        f"Decoder key: {(sorted_packets.index(divider_list[0]) + 1) * (sorted_packets.index(divider_list[1]) + 1)}"
    )
