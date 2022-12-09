package AoC2022;

public class Vector2D {
    private int x;
    private int y;

    /**
     * Constructor.
     * 
     * @param x The x coordinate.
     * @param y The y coordinate.
     */
    public Vector2D(int x, int y) {
        this.x = x;
        this.y = y;
    }

    /**
     * String representation.
     */
    public String toString() {
        return String.format("[%d, %d]", x, y);
    }

    /**
     * Get the x coordinate.
     * 
     * @return The x coordinate.
     */
    public int getX() {
        return x;
    }

    /**
     * Get the y coordinate.
     * 
     * @return The y coordinate.
     */
    public int getY() {
        return y;
    }

    /**
     * Set the x coordinate.
     * 
     * @param x The new x coordinate.
     */
    public void setX(int x) {
        this.x = x;
    }

    /**
     * Set the y coordinate.
     * 
     * @param y The new y coordinate.
     */
    public void setY(int y) {
        this.y = y;
    }

    /**
     * Set the x and y coordinates.
     * 
     * @param x The new x coordinate.
     * @param y The new y coordinate.
     */
    public void set(int x, int y) {
        this.x = x;
        this.y = y;
    }
}
