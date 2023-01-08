public class Turn {
    private final Board board;
    private static final int num_Players = 2;
    private final Player[] players;

    public Turn(Board board) {
        this.board = board;
        this.players = new Player[Turn.num_Players];
        this.players[0] = new Player(Color.X);
        this.players[1] = new Player(Color.O);
    }

    public void play() {
        int currentPlayer = 1;
        do {
            currentPlayer = (currentPlayer + 1) % 2;
            this.putToken(currentPlayer);
            board.show();
        } while (!board.isConnect4() && board.isEmpty());
    }

    private void putToken(int currentPlayer) {
        int error;
        do {
            int selectedColumn = players[currentPlayer].putToken() - 1;
            error = board.putToken(selectedColumn, players[currentPlayer].getColor());
            if (error < 0) {
                System.out.println("ERROR PLACING THE TOKEN");
            }
        } while (error < 0);
    }
}