import sys
import time
from typing import List

from .classes.graph import Graph, Vector3D

if __name__ == "__main__":
    start_time = time.time()

    # Read the input file
    file = open(sys.argv[1], "r")
    lines: List[str] = file.readlines()
    file.close()

    cell_vec_list = []

    x_size = y_size = z_size = 0
    for line in lines:
        coords = line.strip().split(",")
        cell_vec_list.append(Vector3D(int(coords[0]), int(coords[1]), int(coords[2])))
        x_size = max(x_size, int(coords[0]))
        y_size = max(y_size, int(coords[1]))
        z_size = max(z_size, int(coords[2]))

    graph = Graph(Vector3D(x_size, y_size, z_size))

    for cell_vec in cell_vec_list:
        graph.set_cell(cell_vec, 1)

    # Part 1
    print(f"Part 1 | The surface area is: {graph.get_surface_area()}")
    print(f"       | Found in {time.time() - start_time} seconds.")

    # Part 2
    print(f"Part 2 | The surface area is: {graph.get_external_surface_area()}")
    print(f"       | Found in {time.time() - start_time} seconds.")
