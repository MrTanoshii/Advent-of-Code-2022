from typing import List

from .vector3d import Vector3D


class Graph(object):
    ADJACENT = [
        Vector3D(1, 0, 0),
        Vector3D(-1, 0, 0),
        Vector3D(0, 1, 0),
        Vector3D(0, -1, 0),
        Vector3D(0, 0, 1),
        Vector3D(0, 0, -1),
    ]

    def __init__(self, size_vec: Vector3D):
        print(f"Generating graph with size {size_vec.x}x{size_vec.y}x{size_vec.z}...")

        self.graph: List[int] = [
            [[0 for _z in range(size_vec.z + 1)] for _y in range(size_vec.y + 1)]
            for _x in range(size_vec.x + 1)
        ]
        self.surface_area: int = 0

    def get_cell(self, cell_vec: Vector3D) -> int:
        return self.graph[cell_vec.x][cell_vec.y][cell_vec.z]

    def set_cell(self, cell_vec: Vector3D, value: int):
        self.graph[cell_vec.x][cell_vec.y][cell_vec.z] = value
        self.surface_area += 6 + self.get_touching_sides_count(cell_vec) * -2

    def get_surface_area(self) -> int:
        return self.surface_area

    def get_touching_sides_count(self, cell_vec: Vector3D) -> int:
        count: int = 0

        for a in Graph.ADJACENT:
            adj_cell_vec = cell_vec + a
            if self._is_valid_coords(adj_cell_vec) and self.get_cell(adj_cell_vec):
                count += 1

        return count

    def _try_escape_from_cell(self, cell_vec: Vector3D) -> bool:
        queue = [cell_vec]
        visited = [
            [
                [False for _z in range(len(self.graph[cell_vec.x][cell_vec.y]))]
                for _y in range(len(self.graph[cell_vec.x]))
            ]
            for _z in range(len(self.graph))
        ]
        visited[cell_vec.x][cell_vec.y][cell_vec.z] = True

        while len(queue) > 0:
            current = queue.pop()

            for a in Graph.ADJACENT:
                adj_cell_vec = current + a
                if self._is_valid_coords(adj_cell_vec):
                    if not visited[adj_cell_vec.x][adj_cell_vec.y][
                        adj_cell_vec.z
                    ] and not self.get_cell(adj_cell_vec):
                        queue.append(adj_cell_vec)
                        visited[adj_cell_vec.x][adj_cell_vec.y][adj_cell_vec.z] = True
                    elif (
                        adj_cell_vec.x == len(self.graph)
                        or adj_cell_vec.y == len(self.graph[cell_vec.x])
                        or adj_cell_vec.z == len(self.graph[cell_vec.x][cell_vec.y])
                    ):
                        return True

            # Check if graph edge is reached
            if (
                current.x == 0
                or current.x == len(self.graph) - 1
                or current.y == 0
                or current.y == len(self.graph[cell_vec.x]) - 1
                or current.z == 0
                or current.z == len(self.graph[cell_vec.x][cell_vec.y]) - 1
            ):
                # print("Escaped at ", current)
                return True

        return False

    def _is_valid_coords(self, cell_vec: Vector3D) -> bool:
        return (
            cell_vec.x >= 0
            and cell_vec.x < len(self.graph)
            and cell_vec.y >= 0
            and cell_vec.y < len(self.graph[cell_vec.x])
            and cell_vec.z >= 0
            and cell_vec.z < len(self.graph[cell_vec.x][cell_vec.y])
        )

    def get_external_surface_area(self) -> int:
        count: int = 0

        for x in range(1, len(self.graph)):
            for y in range(1, len(self.graph[x])):
                for z in range(1, len(self.graph[x][y])):
                    cell_vec = Vector3D(x, y, z)
                    if self.get_cell(cell_vec):
                        for a in Graph.ADJACENT:
                            adj_cell_vec = cell_vec + a
                            if (
                                self._is_valid_coords(adj_cell_vec)
                                and not self.get_cell(adj_cell_vec)
                                and not self._try_escape_from_cell(adj_cell_vec)
                            ):
                                count += 1
        return self.surface_area - count
