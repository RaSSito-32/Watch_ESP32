import java.util.Scanner;

public class Board {
    private String[][] board;
    public Board(String[][] array){
        this.board = array;
    }

    public void Show() {
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 7; j++) {
                System.out.print(this.board[i][j] + " ");}
            System.out.println();
        }
    }
    public void Start (){
        System.out.println("--CONNECT 4--");
        System.out.println("-------------");
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 7; j++) {
                this.board[i][j] = "-";}}}
    public void PutToken (int Column,Color color){
        System.out.println("Turn of Player " + color);
        for (int i = 6-1; i > -1;i--) {
            if (SquareIsEmpty(i,Column-1)){
                this.board[i][Column-1] = String.valueOf(color);
                i = -1;
            } else if (SquareIsOccupied(0,Column-1)){
                System.out.println("Column " + Column + " is full");
                i = -1;}
            }
        }
    public boolean BoardIsEmpty() {
        boolean result = false;
        for (int j = 0; j < 7; j++) {
            if (SquareIsEmpty(0, j))
                result = true;}
        return result;
    }
    public int GetColumn(){
        int Column;
        Scanner scan = new Scanner(System.in);
        do {
            System.out.print("Column:");
            Column = scan.nextInt();
        } while ((Column > 7 || Column <= 0) && this.BoardIsEmpty());
        return Column;
    }

    public Color GetColor (int row,int column){
        if (SquareIsEmpty(row,column))
            return Color.NULL;
        else if (this.board[row][column].equals("X"))
            return Color.X;
        else
            return Color.O;
    }

    private boolean SquareIsOccupied (int row,int column){
        return this.board[row][column].equals("X") || this.board[row][column].equals("O");}
    private boolean SquareIsEmpty(int row,int column){
        return !SquareIsOccupied(row,column);
    }
}