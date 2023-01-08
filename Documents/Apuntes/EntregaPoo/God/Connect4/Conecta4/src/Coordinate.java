public class Coordinate {
    private int column;
    private int row;
    public Coordinate(int column, int row){
        this.row=row;
        this.column=column;
    }
    public int getColumn() {
        return column;
    }
    public int getRow(){
        return row;
    }
    public void setColumn(int column) {
        this.column = column;
    }
    public void setRow(int row){
        this.row=row;
    }
}
