package manager {
import build.lockedLand.LockedLand;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import starling.display.Image;

import utils.MCScaler;

import windows.WindowsManager;

public class AStar {
    protected var g:Vars = Vars.getInstance();
    private var matrix:Array;
    private var ln:int;
    private var startX:int;
    private var startY:int;
    private var endX:int;
    private var endY:int;
    private var openList:Array;
    private var closedList:Array;
    private var path:Array;
    private var callback:Function;
    private var diagonals:Object;

    public function AStar() {}

    public function getPath(sX:int, sY:int, eX:int, eY:int, f:Function):void {
        callback = f;
        startX = sX;
        startY = sY;
        endX = eX;
        endY = eY;
        openList = [];
        closedList = [];
        path = [];
        if (g.isAway) {
            matrix = g.townArea.townAwayMatrix;
            diagonals = g.townArea.awayDiagonalsObject;
        } else {
            matrix = g.townArea.townMatrix;
            diagonals = g.townArea.diagonalsObject;
        }
        ln = matrix.length;
        openList[startX + " " + startY] = new AStarNode(startX, startY, 0, 0, null);
//        showWallPoints();
        try {
            makeSearch();
        } catch (e:Error) {
            Cc.error('Error with makeSearch at AStar');
            if (callback != null) {
                callback.apply(null, [[new Point(startX, startY)]]);
                callback = null;
                path = [];
                callback = null;
                openList = [];
                closedList = [];
                matrix = [];
                diagonals = [];
                startX = startY = endX = endY = 0;
            }
        }
    }

    private function makeSearch():void {
        var curNode:AStarNode;
        var lowF:int = 100000;
        var curF:int;
        var finished:Boolean = false;
        var node:AStarNode;

        for each (node in openList) {  // !!! bad way
            curF = node.g + node.h;
            if (lowF > curF) {
                lowF = curF;
                curNode = node;
            }
        }

        if (curNode == null) {
            Cc.error('AStar makeSearch:: curNode == null');
            return;
        }

        delete openList[curNode.x + " " + curNode.y];
        closedList[curNode.x + " " + curNode.y] = curNode;

        if (curNode.x == endX && curNode.y == endY) {
            var endNode:AStarNode = curNode;
            finished = true;
        }

        //check each of the 8 adjacent squares
        var col:int;
        var row:int;
        var g:int;
        var h:int;
        var j:int;
        for (var i:int = -1; i < 2; i++) {
            for (j = -1; j < 2; j++) {
                col = curNode.x + i;
                row = curNode.y + j;

//                showVisitedPoint(col, row);
                if (matrix[row] && matrix[row][col]) {
                    if (matrix[row][col].isWall) {
                        closedList[col + " " + row] = 'wall';
//                        showWallPoint(col, row);
                        continue;
                    }

                    if ((col >= 0 && col < ln) && (row >= 0 && row < ln) && (i != 0 || j != 0)) {
                        // check not using buildings' diagonals
                        if (diagonals[String(curNode.x) +'-'+ String(curNode.y) +'-'+ String(col) +'-'+ String(row)]
                                || diagonals[String(col) +'-'+ String(row) +'-'+ String(curNode.x) +'-'+ String(curNode.y)]) continue;

                        if (closedList[col + " " + row] == null && openList[col + " " + row] == null) {
                            g = 10;
                            if (i != 0 && j != 0) {
//                                if (matrix[row][col].isFull) {
//                                    closedList[col + " " + row] = 'wall';
//                                    showWallPoint(col, row);
//                                    continue;
//                                }
                                if (matrix[row][col].build is LockedLand) {
                                    closedList[col + " " + row] = 'wall';
//                                    showWallPoint(col, row);
                                    continue;
                                }
                                g = 14;
                            }
                            h = (Math.abs(col - endX)) + (Math.abs(row - endY)) * 10;
                            node = new AStarNode(col, row, g, h, curNode);
                            openList[col + " " + row] = node;
                        }
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
                var arr:Array = [];
                var p:Point;
                for (var i:int = 0; i<path.length; i++) {
                    p = new Point(path[i].x, path[i].y);
                    arr.push(p);
                }
                arr.reverse();
                callback.apply(null, [arr]);
                path = [];
                callback = null;
                openList = [];
                closedList = [];
                startX = startY = endX = endY = 0;
                matrix = [];
                diagonals = [];
            }
        }
    }

    private function showWallPoints():void {
        while (g.cont.animationsCont.numChildren) g.cont.animationsCont.removeChildAt(0);
        var p:Point = new Point();
        var im:Image;
        for (var i:int = 0; i < ln; i++) {
            for (var j:int = 0; j < ln; j++) {
                if (matrix[i][j].isWall) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('help_icon'));
                    MCScaler.scale(im, 20, 20);
                    p.x = j;
                    p.y = i;
                    p = g.matrixGrid.getXYFromIndex(p);
                    im.x = p.x - 10;
                    im.y = p.y - 10;
                    g.cont.animationsCont.addChild(im);
                }
            }
        }
    }

    private function showWallPoint(_x:int, _y:int):void {
        var p:Point = new Point(_x, _y);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('help_icon'));
        MCScaler.scale(im, 20, 20);
        p = g.matrixGrid.getXYFromIndex(p);
        im.x = p.x - 10;
        im.y = p.y - 10;
        g.cont.animationsCont.addChild(im);
    }

    private function showVisitedPoint(_x:int, _y:int):void {
        var p:Point = new Point(_x, _y);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('help_icon'));
        MCScaler.scale(im, 20, 20);
        p = g.matrixGrid.getXYFromIndex(p);
        im.x = p.x - 10;
        im.y = p.y - 10;
        g.cont.animationsCont.addChild(im);
    }

}
}
