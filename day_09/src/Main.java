import java.io.FileInputStream;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.List;

import AoC2022.Grid;
import AoC2022.Move;
import AoC2022.Move.Direction;
import AoC2022.Knot;
import AoC2022.Vector2D;

public class Main {
    public static void main(String[] args) throws Exception {
        // Open file handlers
        FileInputStream fileReader = new FileInputStream(args[0]);
        Scanner scanner = new Scanner(fileReader);

        List<Move> moves = new ArrayList<Move>();

        // Read file line by line
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            moves.add(new Move(line));
        }

        // Close file handlers
        scanner.close();
        fileReader.close();

        // Initialise grid and rope ends
        Grid grid = new Grid();
        Knot head = new Knot("head");
        Knot tail = new Knot("tail");

        // Loop through moves
        for (Move move : moves) {
            for (int i = 0; i < move.getDistance(); i++) {
                head.Move(new Move(move.getDirection(), 1));
                Direction tailMoveDirection = tail.StepTowards(head.getPosition());
                grid.setVisited(tail.getPosition(), tailMoveDirection);
                // System.out.println(grid);
            }
        }

        System.out.printf("PART 1 | Visited position count: %d\n", grid.getVisitedCount());

        // PART 2
        Grid gridSecond = new Grid();
        Knot headSecond = new Knot("head");
        List<Knot> followers = new ArrayList<Knot>(9);
        for (int i = 0; i < 9; i++) {
            followers.add(new Knot("follower" + i));
        }

        // Loop through moves
        for (Move move : moves) {
            for (int i = 0; i < move.getDistance(); i++) {
                headSecond.Move(new Move(move.getDirection(), 1));
                for (int j = 0; j < followers.size(); j++) {
                    Vector2D targetPosition = headSecond.getPosition();
                    if (j > 0) {
                        targetPosition = followers.get(j - 1).getPosition();
                    }
                    Direction followerMoveDirection = followers.get(j).StepTowards(targetPosition);
                    if (j == followers.size() - 1) {
                        gridSecond.setVisited(followers.get(j).getPosition(), followerMoveDirection);
                    }
                }
                // System.out.println(grid);
            }
        }

        System.out.printf("PART 2 | Visited position count: %d\n", gridSecond.getVisitedCount());
    }
}
