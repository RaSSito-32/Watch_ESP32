import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Line {
    private final List<Coordinate> coordinates;
    private Iterator<Coordinate> iterator;

    public Line(Directions direction, Coordinate initialPoint){
        this.coordinates=new ArrayList<>();
        for (int i = 0; i < Coordinate.getOBJECTIVE(); i++) {
            Coordinate addCoordinate = new Coordinate(initialPoint.getRow() + (direction.getCardinalPointY() * (Coordinate.getOBJECTIVE() - 1 - i)),
                    initialPoint.getColumn() + (direction.getCardinalPointX() * (Coordinate.getOBJECTIVE() - 1 - i)));
            this.coordinates.add(addCoordinate);
        }
        this.iterator=this.coordinates.iterator();
    }

    public void displacementCoordinates(Directions direction) {
        for (Coordinate value : this.coordinates) {
            value.setCoordinate(value.getRow() + direction.getCardinalPointY(),
                    value.getColumn() + direction.getCardinalPointX());
        }
        this.iterator=this.coordinates.iterator();
    }

    public boolean hasNext(){
        return this.iterator.hasNext();
    }

    public Coordinate next(){
        return this.iterator.next();
    }
}
