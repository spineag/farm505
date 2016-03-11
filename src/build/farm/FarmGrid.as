/**
 * Created by user on 9/28/15.
 */
package build.farm {
import flash.geom.Point;

import manager.Vars;

import utils.Point3D;

public class FarmGrid {
    private var _matrix:Array;
    private var FACTOR:int;
//    private const WIDTH_CELL:uint = FACTOR*Math.SQRT2;
    private const Y_CORRECT:Number = Math.cos(-Math.PI / 6) * Math.SQRT2;
    private var g:Vars = Vars.getInstance();
    private var COUNT:int = 8;

    public function FarmGrid() {
        _matrix = [];
        FACTOR = 30 * g.scaleFactor;

        for (var i:int = 0; i < COUNT; i++) {
            _matrix.push([]);
            for (var j:int = 0; j < COUNT; j++) {
                _matrix[i][j] = getXYFromIndex(new Point(i, j));
            }
        }
    }

     public function getZeroPoint():Point {
         return _matrix[0][0];
     }

    public function getRandomPoint(count:int = 0):Point {
        if (count <= 0) count = COUNT;
        var i:int = int(Math.random()*count);
        var j:int = int(Math.random()*count);
        return _matrix[i][j];
    }

    private function getXYFromIndex(point:Point):Point {
        var point3d:Point3D = new Point3D(point.x * FACTOR, 0, point.y * FACTOR);
        point = isoToScreen(point3d);
        point.y += 40;
        return point;
    }

    private function isoToScreen(pos:Point3D):Point {
        var screenX:Number = pos.x - pos.z;
        var screenY:Number = pos.y * Y_CORRECT + (pos.x + pos.z) * .5;
        return new Point(screenX, screenY);
    }

    public function screenToIso(point:Point):Point3D {
        var xpos:Number = point.y + point.x * .5;
        var ypos:Number = 0;
        var zpos:Number = point.y - point.x * .5;
        return new Point3D(xpos, ypos, zpos);
    }
}
}
