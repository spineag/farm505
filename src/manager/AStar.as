package manager {
import flash.geom.Point;

public class AStar {
    protected var g:Vars = Vars.getInstance();
    private var matrix:Array;
    private var matrixXY:Array;
    private var ln:int;

    public function AStar() {
        matrix = g.townArea.townMatrix;
        ln = matrix.length;
        matrixXY = [];
        var p:Point = new Point();
        for (var i:int=0; i<ln; i++) {
            matrixXY[i] = [];
            for (var j:int=0; j<ln; j++) {
                p.x = i;
                p.y = j;
                p = g.matrixGrid.getXYFromIndex(p);
                matrixXY[i][j] = {x:p.x, y:p.y};
            }
        }
    }

}
}
