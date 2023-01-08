public enum Directions {
    EAST(1, 0),
    WEST(-1, 0),
    SOUTH(0, 1),
    NORTH(0, -1),
    SOUTHEAST(1, 1),
    NORTHWEST(-1, -1),
    SOUTHWEST(-1, 1),
    NORTHEAST(1, -1);
    private final int x;
    private final int y;

    Directions(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getCardinalPointX() {
        return x;
    }

    public int getCardinalPointY() {
        return y;
    }

    public Directions getDirectionInverse() {
        if (this.x == 1 && this.y == 0) {
            return WEST;
        } else if (this.x == 0 && this.y == 1) {
            return NORTH;
        } else if (this.x == 1 && this.y == 1) {
            return NORTHWEST;
        } else if (this.x == -1 && this.y == 1) {
            return NORTHEAST;
        } else if (this.x == -1 && this.y == 0) {
            return EAST;
        } else if (this.x == 0 && this.y == -1) {
            return SOUTH;
        } else if (this.x == -1 && this.y == -1) {
            return SOUTHEAST;
        } else {
            return SOUTHWEST;
        }
    }
}
