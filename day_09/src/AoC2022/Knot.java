package AoC2022;

import AoC2022.Move.Direction;

/**
 * Base class for knot.
 */
public class Knot {
    private String name;
    private Vector2D position;

    /**
     * Constructor.
     * 
     * @param name The name of the knot.
     */
    public Knot(String name) {
        this.name = name;
        this.position = new Vector2D(0, 0);
    }

    /**
     * Constructor.
     * 
     * @param name     The name of the knot.
     * @param position The position of the knot.
     */
    public Knot(String name, Vector2D position) {
        this.name = name;
        this.position = new Vector2D(position.getX(), position.getY());
    }

    /**
     * String representation.
     */
    public String toString() {
        return String.format("%s %s", name, position);
    }

    /**
     * Get the name of the knot.
     * 
     * @return The name of the knot.
     */
    public String getName() {
        return name;
    }

    /**
     * Get the position of the knot.
     * 
     * @return The position of the knot.
     */
    public Vector2D getPosition() {
        return position;
    }

    /**
     * Move the knot.
     * 
     * @param move The move to make.
     */
    public void Move(Move move) {
        Vector2D deltaPosition;

        if (move.getDirection() == Direction.UP) {
            deltaPosition = new Vector2D(0, -move.getDistance());
        } else if (move.getDirection() == Direction.DOWN) {
            deltaPosition = new Vector2D(0, move.getDistance());
        } else if (move.getDirection() == Direction.LEFT) {
            deltaPosition = new Vector2D(-move.getDistance(), 0);
        } else if (move.getDirection() == Direction.RIGHT) {
            deltaPosition = new Vector2D(move.getDistance(), 0);
        } else {
            deltaPosition = new Vector2D(0, 0);
        }

        position.set(position.getX() + deltaPosition.getX(), position.getY() + deltaPosition.getY());
    }

    /**
     * Move towards a target position by one step if the target position is more
     * than one step away.
     * 
     * @param target The target position to move to.
     */
    public Direction StepTowards(Vector2D target) {
        Vector2D deltaPosition = new Vector2D(target.getX() - position.getX(), target.getY() - position.getY());
        Direction direction = Direction.NONE;

        if ((Math.abs(deltaPosition.getX()) > 1 ||
                Math.abs(deltaPosition.getY()) > 1) &&
                this.position.getX() != target.getX() &&
                this.position.getY() != target.getY()) {
            // Diagonal move
            if (deltaPosition.getX() > 0) {
                deltaPosition.setX(1);
                direction = Direction.RIGHT;
            } else {
                deltaPosition.setX(-1);
                direction = Direction.LEFT;
            }

            if (deltaPosition.getY() > 0) {
                deltaPosition.setY(1);
                if (direction == Direction.RIGHT) {
                    direction = Direction.BOTTOMRIGHT;
                } else {
                    direction = Direction.BOTTOMLEFT;
                }
            } else {
                deltaPosition.setY(-1);
                if (direction == Direction.RIGHT) {
                    direction = Direction.TOPRIGHT;
                } else {
                    direction = Direction.TOPLEFT;
                }
            }
        } else {
            // Horizontal or vertical move
            if (deltaPosition.getX() > 1) {
                deltaPosition.setX(1);
                direction = Direction.RIGHT;
            } else if (deltaPosition.getX() < -1) {
                deltaPosition.setX(-1);
                direction = Direction.LEFT;
            } else {
                deltaPosition.setX(0);
            }

            if (deltaPosition.getY() > 1) {
                deltaPosition.setY(1);
                direction = Direction.DOWN;
            } else if (deltaPosition.getY() < -1) {
                deltaPosition.setY(-1);
                direction = Direction.UP;
            } else {
                deltaPosition.setY(0);
            }
        }

        position.set(position.getX() + deltaPosition.getX(), position.getY() + deltaPosition.getY());

        return direction;
    }
}
