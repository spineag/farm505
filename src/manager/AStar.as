package manager {
import flash.geom.Point;

public class AStar {
    protected var g:Vars = Vars.getInstance();
    private var matrix:Array;
    private var matrixXY:Array;
    private var ln:int;
    private var startX:int;
    private var startY:int;
    private var endX:int;
    private var endY:int;
    private var openList:Array;
    private var closedList:Array;
    private var path:Array;
    private var callback:Function;

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

    public function getPath(sX:int, sY:int, eX:int, eY:int, f:Function):void {
        callback = f;
        startX = sX;
        startY = sY;
        endX = eX;
        endY = eY;
        openList = [];
        closedList = [];
        path = [];
        openList[startX + " " + startY] = new AStarNode(startX, startY, 0, 0, null);
        makeSearch();
    }

    private function makeSearch():void {
        var curNode:AStarNode;
        var lowF:int = 100000;
        var curF:int;
        var finished:Boolean = false;

        for each (var node in openList) {  // !!! bad way
            curF = node.g + node.h;
            if (lowF > curF) {
                lowF = curF;
                curNode = node;
            }
        }

        if (curNode == null) {return;}

        delete openList[curNode.x + " " + curNode.y];
        closedList[curNode.x + " " + curNode.y] = curNode;

        if (curNode.x == endX && curNode.y == endY) {
            var endNode:AStarNode = curNode;
            finished = true;
        }

        //check each of the 8 adjacent squares
        for (var i:int = -1; i < 2; i++) {
            for (var j:int = -1; j < 2; j++) {
                var col:int = curNode.x + i;
                var row:int = curNode.y + j;

                if ((col >= 0 && col <= ln) && (row >= 0 && row <= ln) && (i != 0 || j != 0)) {
                    if (!matrix[row][col].isWall && closedList[col + " " + row] == null && openList[col + " " + row] == null) {
                        var g:int = 10;
                        if (i != 0 && j != 0) {
                            g = 14;
                        }
                        var h:int = (Math.abs(col - endX)) + (Math.abs(row - endY)) * 10;
                        var node:AStarNode = new AStarNode(col, row, g, h, curNode);
                        openList[col + " " + row] = node;
                    }
                }
            }
        }

        if (finished) {
            retracePath(endNode);
        } else {
            makeSearch();
        }
    }

    private function retracePath(node:AStarNode):void {
        var step:Point = new Point(node.x, node.y);
        path.push(step);

        if (node.g > 0) {
            retracePath(node.parentNode);
        } else {
            if (callback != null) {
                callback.apply(null, [path]);
                callback = null;
                openList = [];
                closedList = [];
                startX = startY = endX = endY = 0;
            }
        }
    }

}
}
