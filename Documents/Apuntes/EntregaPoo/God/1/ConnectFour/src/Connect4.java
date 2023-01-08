

public class Connect4 {

    public static void main(String[] args) {
        String[][] arrays = new String[6][7];
        Board tablero = new Board(arrays);

        tablero.Start();
        tablero.Show();
        do {
            tablero.PutToken(tablero.GetColumn(), Color.X);
            tablero.Show();
            tablero.PutToken(tablero.GetColumn(), Color.O);
            tablero.Show();
        }while(tablero.BoardIsEmpty());
    }





}

