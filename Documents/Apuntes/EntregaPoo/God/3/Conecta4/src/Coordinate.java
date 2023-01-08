public class Coordinate {
    public static final int DIMENSION_X = 6;

    public static final int DIMENSION_Y = 7;

    private int column;

    private int row;

    private static final int OBJECTIVE = 4;

    public Coordinate(int row, int column) {
        this.row = row;
        this.column = column;
    }

    public void setCoordinate(int row, int column) {
        this.row = row;
        this.column = column;
    }

    public int getDimensionX() {
        return DIMENSION_X;
    }

    public int getDimensionY() {
        return DIMENSION_Y;
    }

    public int getRow() {
        return this.row;
    }

    public int getColumn() {
        return this.column;
    }


    public boolean isValid() {
        return this.row < getDimensionX() && this.row >= 0 &&
                this.column < getDimensionY() && this.column >= 0;
    }

    public static int getOBJECTIVE() {
        return OBJECTIVE;
    }
}
