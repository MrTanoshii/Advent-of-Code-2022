package AoC2022;

import AoC2022.Move.Direction;

/**
 * Base class for self-growing grid.
 * The top-left is the [0, 0] point;
 * The refPoint is the initial reference point of the grid before any growth.
 */
public class Grid {
    private int xLength;
    private int yLength;
    private Boolean[][] grid;
    private Vector2D refPoint;

    /**
     * Constructor.
     */
    public Grid() {
        this.xLength = 1;
        this.yLength = 1;
        this.grid = new Boolean[this.xLength][this.yLength];
        this.refPoint = new Vector2D(0, 0);
        setGridUnvisited();
    }

    /**
     * Constructor.
     * 
     * @param gridDims The dimensions of the grid.
     */
    public Grid(Vector2D gridDims) {
        this.xLength = gridDims.getX();
        this.yLength = gridDims.getY();
        this.grid = new Boolean[this.xLength][this.yLength];
        this.refPoint = new Vector2D(0, 0);
        setGridUnvisited();
    }

    /**
     * String representation.
     */
    public String toString() {
        String gridString = "";
        for (int y = 0; y < yLength; y++) {
            for (int x = 0; x < xLength; x++) {
                if (refPoint.getX() == x && refPoint.getY() == y)
                    gridString += "s";
                else {
                    gridString = grid[x][y] ? gridString + "#" : gridString + ".";
                }
            }
            gridString += "\n";
        }
        return gridString;
    }

    /**
     * Get the grid element visited state at the given position.
     * 
     * @param position The position of the grid element.
     * @return The visited state of the grid element.
     */
    public Boolean getVisited(Vector2D position) {
        return grid[position.getX()][position.getY()];
    }

    /**
     * Get the grid length in the x direction.
     * 
     * @return The grid length in the x direction.
     */
    public int getXLength() {
        return xLength;
    }

    /**
     * Get the grid length in the y direction.
     * 
     * @return The grid length in the y direction.
     */
    public int getYLength() {
        return yLength;
    }

    /**
     * Set all the grid elements to unvisited.
     */
    public void setGridUnvisited() {
        for (int x = 0; x < xLength; x++) {
            for (int y = 0; y < yLength; y++) {
                grid[x][y] = false;
            }
        }
    }

    /**
     * Set the grid element at the given position to visited.
     * 
     * @param position  The position of the grid element to set to visited.
     * @param direction The direction of the move that led to the position.
     */
    public void setVisited(Vector2D position, Direction direction) {
        Vector2D gridPosition = new Vector2D(this.refPoint.getX() + position.getX(),
                this.refPoint.getY() + position.getY());

        // Check if grid needs resizing
        if (gridPosition.getX() >= xLength ||
                gridPosition.getX() < 0 ||
                gridPosition.getY() >= yLength ||
                gridPosition.getY() < 0) {
            grow(direction);
            gridPosition = new Vector2D(this.refPoint.getX() + position.getX(),
                    this.refPoint.getY() + position.getY());
        }

        grid[gridPosition.getX()][gridPosition.getY()] = true;
    }

    /**
     * Grow the grid in the given direction.
     * 
     * @param direction The direction to grow the grid.
     */
    public void grow(Direction direction) {
        Vector2D gridExtension = new Vector2D(0, 0);
        Vector2D gridOffset = new Vector2D(0, 0);

        // Find the offset of the new grid compared to the old grid
        if (direction == Direction.UP ||
                direction == Direction.TOPLEFT ||
                direction == Direction.TOPRIGHT) {
            gridExtension.setY(1);
            gridOffset.setY(1);
        } else if (direction == Direction.DOWN ||
                direction == Direction.BOTTOMLEFT ||
                direction == Direction.BOTTOMRIGHT) {
            gridExtension.setY(1);
        }
        if (direction == Direction.RIGHT ||
                direction == Direction.TOPRIGHT ||
                direction == Direction.BOTTOMRIGHT) {
            gridExtension.setX(1);
        } else if (direction == Direction.LEFT ||
                direction == Direction.TOPLEFT ||
                direction == Direction.BOTTOMLEFT) {
            gridExtension.setX(1);
            gridOffset.setX(1);
        }

        Vector2D newGridDims = new Vector2D(xLength + gridExtension.getX(), yLength + gridExtension.getY());

        // Create a new grid from the old grid
        Grid newGrid = new Grid(newGridDims);
        for (int j = 0; j < yLength; j++) {
            for (int i = 0; i < xLength; i++) {
                newGrid.grid[gridOffset.getX() + i][gridOffset.getY() + j] = grid[i][j];
            }
        }

        // Replace the old grid by the new one
        this.xLength = newGrid.getXLength();
        this.yLength = newGrid.getYLength();
        this.grid = newGrid.grid;
        this.refPoint = new Vector2D(this.refPoint.getX() + gridOffset.getX(),
                this.refPoint.getY() + gridOffset.getY());
    }

    /**
     * Get the number of visited grid elements.
     * 
     * @return The number of visited grid elements.
     */
    public int getVisitedCount() {
        int visitedCount = 0;
        for (int x = 0; x < xLength; x++) {
            for (int y = 0; y < yLength; y++) {
                if (grid[x][y])
                    visitedCount++;
            }
        }
        return visitedCount;
    }
}
