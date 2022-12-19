import math


class Vector3D(object):
    def __init__(self, x: int, y: int, z: int):
        self.x: int = x
        self.y: int = y
        self.z: int = z

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y and self.z == other.z

    def __hash__(self):
        return hash((self.x, self.y, self.z))

    def __str__(self):
        return f"({self.x}, {self.y}, {self.z})"

    def __repr__(self):
        return self.__str__()

    def __add__(self, other):
        return Vector3D(self.x + other.x, self.y + other.y, self.z + other.z)

    def __sub__(self, other):
        return Vector3D(self.x - other.x, self.y - other.y, self.z - other.z)

    def __mul__(self, other):
        return Vector3D(self.x * other, self.y * other, self.z * other)

    def __truediv__(self, other):
        return Vector3D(self.x / other, self.y / other, self.z / other)

    def __floordiv__(self, other):
        return Vector3D(self.x // other, self.y // other, self.z // other)

    def __mod__(self, other):
        return Vector3D(self.x % other, self.y % other, self.z % other)

    # def __lt__(self, other):
    #     return self.x < other.x and self.y < other.y and self.z < other.z

    # def __le__(self, other):
    #     return self.x <= other.x and self.y <= other.y and self.z <= other.z

    # def __gt__(self, other):
    #     return self.x > other.x and self.y > other.y and self.z > other.z

    # def __ge__(self, other):
    #     return self.x >= other.x and self.y >= other.y and self.z >= other.z

    def __abs__(self):
        return Vector3D(abs(self.x), abs(self.y), abs(self.z))

    def __neg__(self):
        return Vector3D(-self.x, -self.y, -self.z)

    def __pos__(self):
        return Vector3D(+self.x, +self.y, +self.z)

    def __invert__(self):
        return Vector3D(~self.x, ~self.y, ~self.z)

    def __round__(self, n=None):
        return Vector3D(round(self.x, n), round(self.y, n), round(self.z, n))

    def __floor__(self):
        return Vector3D(math.floor(self.x), math.floor(self.y), math.floor(self.z))

    def __ceil__(self):
        return Vector3D(math.ceil(self.x), math.ceil(self.y), math.ceil(self.z))

    def __trunc__(self):
        return Vector3D(math.trunc(self.x), math.trunc(self.y), math.trunc(self.z))

    def __pow__(self, power, modulo=None):
        return Vector3D(self.x**power, self.y**power, self.z**power)

    def __radd__(self, other):
        return Vector3D(self.x + other, self.y + other, self.z + other)

    def __rsub__(self, other):
        return Vector3D(self.x - other, self.y - other, self.z - other)

    def __rmul__(self, other):
        return Vector3D(self.x * other, self.y * other, self.z * other)

    def __rtruediv__(self, other):
        return Vector3D(self.x / other, self.y / other, self.z / other)

    def __rfloordiv__(self, other):
        return Vector3D(self.x // other, self.y // other, self.z // other)

    def __rmod__(self, other):
        return Vector3D(self.x % other, self.y % other, self.z % other)

    def __rpow__(self, power, modulo=None):
        return Vector3D(self.x**power, self.y**power, self.z**power)
