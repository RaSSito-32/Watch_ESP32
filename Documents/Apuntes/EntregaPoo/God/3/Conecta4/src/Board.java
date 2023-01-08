import java.util.ArrayList;
import java.util.List;

public class Board {
    private final Color[][] colors;

    private final Coordinate coordinate;

    public Board() {
        coordinate = new Coordinate(0, 0);
        this.colors = new Color[coordinate.getDimensionX()][coordinate.getDimensionY()];
        for (int i = 0; i < coordinate.getDimensionX(); i++) {
            for (int j = 0; j < coordinate.getDimensionY(); j++) {
                colors[i][j] = Color.NULL;
            }
        }
    }

    public void show() {
        for (int i = 0; i < coordinate.getDimensionX(); i++) {
            for (int j = 0; j < coordinate.getDimensionY(); j++) {
                if (colors[i][j] != Color.NULL) {
                    System.out.print("[" + colors[i][j] + "] ");
                } else System.out.print("[ ] ");
            }
            System.out.println();
        }
    }

    public boolean isEmpty() {
        for (int i = 0; i < coordinate.getDimensionX(); i++) {
            if (colors[0][i] == Color.NULL) {
                return true;
            }
        }
        return false;
    }

    public int putToken(int column, Color color) {
        if (column < 0 || coordinate.getDimensionY() <= column) {
            return -1;
        }
        int validRow = coordinate.getDimensionX() - 1;
        while (validRow >= 0 && colors[validRow][column] != Color.NULL) {
            validRow--;
        }
        if (validRow >= 0) {
            colors[validRow][column] = color;
            coordinate.setCoordinate(validRow, column);
        }
        return validRow;
    }

    public boolean isConnect4() {
        List<Directions> directions = this.getDirections();
        Color lastColor= this.colors[this.coordinate.getRow()][this.coordinate.getColumn()];
        for (Directions direction : directions) {
            Line line = new Line(direction,this.coordinate);
            if (detectConnect(line,direction)) {
                System.out.println("THE WINNER IS " + lastColor);
                return true;
            }
        }
        return false;
    }

    private boolean detectConnect(Line line, Directions directions) {
        for (int i=0;i<Coordinate.getOBJECTIVE();i++){
            if (detectInArray(line)){
                return true;
            }
            else {
                line.displacementCoordinates(directions.getDirectionInverse());
            }
        }
        return false;
    }

    private boolean detectInArray(Line line) {
        int cont = 0;
        Color colorPlayer= colors[this.coordinate.getRow()][this.coordinate.getColumn()];
        while (line.hasNext()) {
            Coordinate square = line.next();
            if (!square.isValid()||colorPlayer != colors[square.getRow()][square.getColumn()]){
                return false;
            }
            else {
                cont++;
            }
        }
        return cont >= Coordinate.getOBJECTIVE();
    }

    private List<Directions> getDirections() {
        List<Directions> directions = new ArrayList<>();
        directions.add(Directions.EAST);
        directions.add(Directions.NORTH);
        directions.add(Directions.SOUTHEAST);
        directions.add(Directions.SOUTHWEST);
        return directions;
    }

}
