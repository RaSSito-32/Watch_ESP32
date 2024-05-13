public class Board {
    private final Color[][] colors;
    private static final int ROW_MAX = 6;
    private static final int COLUM_MAX = 7;
    private final Coordinate coordinate;
    public Board() {
        this.colors = new Color[ROW_MAX][COLUM_MAX];
        for (int i = 0; i < ROW_MAX; i++) {
            for (int j = 0; j < COLUM_MAX; j++) {
                colors[i][j] = Color.NULL;
            }
        }
        coordinate=new Coordinate(0,0);
    }
    public Color[][] getColors(){
        return this.colors;
    }
    public int getColumnMax(){
        return COLUM_MAX;
    }
    public int getRowMax(){
        return ROW_MAX;
    }
    public Coordinate getCoordinate(){
        return this.coordinate;
    }
    public void show() {
        for (int i = 0; i < ROW_MAX; i++) {
            for (int j = 0; j < COLUM_MAX; j++) {
                if (colors[i][j] != Color.NULL) {
                    System.out.print("[" + colors[i][j] + "] ");
                } else System.out.print("[ ] ");
            }
            System.out.println();
        }
    }
    public boolean isEmpty() {
        for (int i = 0; i < COLUM_MAX; i++) {
            if (colors[0][i] == Color.NULL) {
                return true;
            }
        }
        return false;
    }
    public int putToken(int column, Color color) {
        if (column < 0 || COLUM_MAX <=  column) {
            return -1;
        }
        int validRow = ROW_MAX - 1;
        while (validRow >= 0 && colors[validRow][column] != Color.NULL) {
            validRow--;
        }
        if (validRow >= 0) {
            colors[validRow][column] = color;
            coordinate.setColumn(column);
            coordinate.setRow(validRow);
        }
        return validRow;
    }
}
