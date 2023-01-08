public class Turn {

    public Turn() {}

    String[][] arrays = new String[6][7];
    Board tablero = new Board(arrays);

    void StarTurn (Color color){
        tablero.PutToken(tablero.GetColumn(), color);
        tablero.Show();
    }

}
