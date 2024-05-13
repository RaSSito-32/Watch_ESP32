public class Goal {
    private final Board board;
    public Goal(Board board){
        this.board=board;
    }
    public boolean isConnect4(Coordinate coordinate, Color color){
        return isRow(coordinate,color)||isColumn(coordinate,color)||isDiagonal(coordinate,color)||isDiagonalInverse(coordinate,color);
    }
    private boolean isRow(Coordinate coordinate, Color color){
        int count=0;
        int columns=coordinate.getColumn();
        while (columns>=0&&board.getColors()[coordinate.getRow()][columns]==color){
            count++;
            columns--;
        }
        if (count<4){
            columns=coordinate.getColumn()+1;
            while (columns<board.getColumnMax()&&board.getColors()[coordinate.getRow()][columns]==color){
                count++;
                columns++;
            }
        }
        return count >= 4;
    }
    private boolean isColumn(Coordinate coordinate, Color color){
        int count=0;
        int rows=coordinate.getRow();
        while (rows>=0&&board.getColors()[rows][coordinate.getColumn()]==color){
            count++;
            rows--;
        }
        if (count<4){
            rows=coordinate.getRow()+1;
            while (rows<board.getRowMax()&&board.getColors()[rows][coordinate.getColumn()]==color){
                count++;
                rows++;
            }
        }
        return count>=4;
    }
    private boolean isDiagonal(Coordinate coordinate, Color color){
        int count=0;
        int columns=coordinate.getColumn();
        int rows=coordinate.getRow();
        while (rows<board.getRowMax() && columns<board.getColumnMax()&&board.getColors()[rows][columns]==color){
            count++;
            rows++;
            columns++;
        }
        if (count<4) {
            columns=coordinate.getColumn()-1;
            rows=coordinate.getRow()-1;
            while (rows >= 0 && columns >= 0 && board.getColors()[rows][columns] == color) {
                count++;
                rows--;
                columns--;
            }
        }
        return count>=4;
    }
    private boolean isDiagonalInverse(Coordinate coordinate,Color color){
        int count=0;
        int columns=coordinate.getColumn();
        int rows=coordinate.getRow();
        while (rows<board.getRowMax()&&columns>=0&&board.getColors()[rows][columns]==color){
            count++;
            rows++;
            columns--;
        }
        if (count<4){
            columns=coordinate.getColumn()+1;
            rows=coordinate.getRow()-1;
            while ((rows>=0&&columns<board.getColumnMax())&&board.getColors()[rows][columns]==color){
                count++;
                rows--;
                columns++;
            }
        }
        return count>=4;
    }
}
