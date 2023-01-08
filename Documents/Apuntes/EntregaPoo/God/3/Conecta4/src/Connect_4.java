import java.util.Objects;
import java.util.Scanner;

public class Connect_4 {
    private Turn turn;
    private Board board;

    public static void main(String[] args) {
        Connect_4 connect_4 = new Connect_4();
        connect_4.playGame();
    }

    public Connect_4() {
        this.board = new Board();
        this.turn = new Turn(this.board);
    }

    public void playGame() {
        System.out.println("---------CONNECT 4---------");
        do {
            this.board.show();
            this.turn.play();
        } while (reset());
    }

    private boolean reset() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Play another game? (Y/N) ");
        String option = scanner.next();
        if (Objects.equals(option, "Y") || Objects.equals(option, "y")) {
            this.board = new Board();
            this.turn = new Turn(this.board);
            return true;
        } else {
            return false;
        }
    }
}
