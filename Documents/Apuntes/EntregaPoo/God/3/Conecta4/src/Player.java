import java.util.Scanner;

public class Player {
    private final Color color;

    public Player(Color color) {
        this.color = color;
    }

    public int putToken() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Turn of Player " + color + "\nchoose a column: ");
        return scanner.nextInt();
    }

    public Color getColor() {
        return color;
    }
}
