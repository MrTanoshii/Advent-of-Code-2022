package AoC2022;

public class Move {
    public enum Direction {
        UP, DOWN, RIGHT, LEFT, TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT, NONE
    };

    private Direction direction;
    private int distance;

    /**
     * Constructor.
     * 
     * @param direction The direction of the move.
     * @param distance  The distance to travel of the move.
     */
    public Move(Direction direction, int distance) {
        this.direction = direction;
        this.distance = distance;
    }

    /**
     * Constructor.
     * 
     * @param moveString The string representation of the move. Format "X Y" where X
     *                   is the direction and Y is the distance to travel.
     */
    public Move(String moveString) {
        // Parse direction
        String directionString = moveString.substring(0, 1);
        if (directionString.equals("U")) {
            this.direction = Direction.UP;
        } else if (directionString.equals("D")) {
            this.direction = Direction.DOWN;
        } else if (directionString.equals("R")) {
            this.direction = Direction.RIGHT;
        } else if (directionString.equals("L")) {
            this.direction = Direction.LEFT;
        } else {
            throw new IllegalArgumentException("Invalid direction: " + directionString);
        }

        // Parse distance
        this.distance = Integer.parseInt(moveString.substring(2));
    }

    /**
     * String representation.
     */
    public String toString() {
        return String.format("Move %s %d", direction, distance);
    }

    /**
     * Get the direction of the move.
     * 
     * @return The direction of the move.
     */
    public Direction getDirection() {
        return direction;
    }

    /**
     * Get the distance to travel of the move.
     * 
     * @return The distance to travel of the move.
     */
    public int getDistance() {
        return distance;
    }
}
