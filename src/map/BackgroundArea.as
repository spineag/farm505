/**
 * Created by user on 5/14/15.
 */
package map {
import flash.geom.Point;

import manager.Vars;
import starling.display.Sprite;

import utils.IsoUtils;
import utils.Point3D;

public class BackgroundArea {
    private var _cont:Sprite;

    protected var g:Vars = Vars.getInstance();

    public function BackgroundArea() {
        _cont = g.cont.backgroundCont;

        fillBG();
    }

    private function fillBG():void {
        var arr:Array = g.matrixGrid.matrix;
        var arr2:Array;
        var tile:BackgroundTile;
        var p:Point;

        for (var i:int = 0; i < arr.length; i++) {
            arr2 = arr[i];
            for (var j:int = 0; j < arr2.length; j++) {
                tile = new BackgroundTile((i+j)%2 + 1);
                p = new Point(i, j);
                setTileFromIndex(tile, p);
                _cont.addChild(tile.graphicsSource);
            }
        }

        _cont.flatten();
    }

    private function setTileFromIndex(tile:BackgroundTile, point:Point):void {
        var pos:Point3D = new Point3D();
        pos.x = point.x * MatrixGrid.FACTOR;
        pos.z = point.y * MatrixGrid.FACTOR;
        var isoPoint:Point = IsoUtils.isoToScreen(pos);
        tile.graphicsSource.x = isoPoint.x;
        tile.graphicsSource.y = isoPoint.y;
        tile.posX = point.x;
        tile.posY = point.y;
    }
}
}
