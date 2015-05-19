/**
 * Created by user on 5/14/15.
 */
package map {
import flash.geom.Point;

import manager.Vars;

import pathFinder.V_GrafGrid;

import starling.display.Sprite;

import utils.IsoUtils;

import utils.Point3D;

public class MatrixGrid {
    public static const WIDTH_CELL:uint = 30;
    public static const FACTOR:Number = WIDTH_CELL / Math.SQRT2;
    public static const DIAGONAL:Number = Math.sqrt(WIDTH_CELL * WIDTH_CELL + WIDTH_CELL * WIDTH_CELL);

    private var _offsetY:int = 0;
    private var _graf:V_GrafGrid;

    private var _matrix:Array;
//    private var _finder:V_Finder;
//    private var _hev:V_HevristicToTarget;

    protected var g:Vars = Vars.getInstance();

    public function MatrixGrid() {
        _graf = new V_GrafGrid();
    }

    public function createMatrix():void {
        //var arr:Array = g.maps[id].rectangle;
        //_rectanglesArray = arr.slice();

        _matrix = [];

        var tempWidth:int = int(g.realGameWidth / DIAGONAL + .5);
        var tempHeight:int = int(g.realGameHeight / (DIAGONAL / 2) + .5);
        var size:int = tempWidth + tempHeight;

        _offsetY = size*FACTOR/2 - g.realGameHeight/2;

        for (var i:int = 0; i < size; i++) {
            _matrix.push([]);
            for (var j:int = 0; j < size; j++) {
                _matrix[i][j] = {id: 0, sources: [], inGame: isTileInGame(i, j), findId: 0};
//                if (matrix[i][j].isNorm) {
//                    matrix[i][j].findId = 0;
//                }
            }
        }

        _graf.buildGraf(_matrix);
    }

    private function isTileInGame(i:int, j:int):Boolean { // перевіряємо чи тайл попадає в ігрову зону, якщо ні - то його не використовуємо
        var p:Point = getXYFromIndex(new Point(i,j));
        if (p.x < -g.realGameWidth/2 || p.x > g.realGameWidth/2) return false;
        if (p.y < _offsetY || p.y > g.realGameHeight + _offsetY) return false;
        return true;
    }

    public function setBuildFromIndex(cityObject:WorldObject, point:Point):void {
        var pos:Point3D = new Point3D();
        pos.x = point.x * FACTOR;
        pos.z = point.y * FACTOR;
        var isoPoint:Point = IsoUtils.isoToScreen(pos);
        cityObject.source.x = isoPoint.x;
        cityObject.source.y = isoPoint.y;
        cityObject.posX = point.x;
        cityObject.posY = point.y;
    }

    public function getLengthMatrix():int {
        return _matrix.length;
    }

    public function get offsetY():int {
        return _offsetY;
    }

    public function get matrix():Array {
        return _matrix;
    }

    public function getIndexFromXY(point:Point):Point {  //martix[i][j] => Point(i,j) - це індекс
        var point3d:Point3D = IsoUtils.screenToIso(point);
        var bufX:int = Math.round(point3d.x / FACTOR);
        var bufY:int = Math.round(point3d.z / FACTOR);

        return new Point(bufX, bufY);
    }

    public function getXYFromIndex(point:Point):Point {
        var point3d:Point3D = new Point3D(point.x * FACTOR, 0, point.y * FACTOR);
        point = IsoUtils.isoToScreen(point3d);

        return point;
    }

    public function drawDebugGrid():void {
        var cont:Sprite = g.cont.gridDebugCont;


    }

    public function deleteDebugGrid():void {

    }
}
}
