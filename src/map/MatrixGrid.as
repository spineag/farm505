/**
 * Created by user on 5/14/15.
 */
package map {
import build.WorldObject;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Stage3D;
import flash.geom.Matrix;
import flash.geom.Point;

import manager.Vars;

import pathFinder.V_GrafGrid;

import starling.display.DisplayObject;
import starling.display.Image;

import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;

import utils.IsoUtils;

import utils.Point3D;

public class MatrixGrid {
    public static const WIDTH_CELL:uint = 30;
    public static const FACTOR:Number = WIDTH_CELL / Math.SQRT2;
    public static const DIAGONAL:Number = Math.sqrt(WIDTH_CELL * WIDTH_CELL + WIDTH_CELL * WIDTH_CELL);

    private var _offsetY:int = 0;
    private var _graf:V_GrafGrid;

    private var _matrix:Array;
    private var _matrixSize:int;
    private var _gridTexture:Texture;
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
        _matrixSize = tempWidth + tempHeight;

        _offsetY = _matrixSize*FACTOR/2 - g.realGameHeight/2;

        for (var i:int = 0; i < _matrixSize; i++) {
            _matrix.push([]);
            for (var j:int = 0; j < _matrixSize; j++) {
                _matrix[i][j] = {id: 0, sources: [], inGame: isTileInGame(i, j), findId: 0};
            }
        }

        _graf.buildGraf(_matrix);
    }

    private function isTileInGame(i:int, j:int):Boolean { // перевіряємо чи тайл попадає в ігрову зону, якщо ні - то його не використовуємо
        var p:Point = getXYFromIndex(new Point(i,j));
        if (p.x < -g.realGameWidth/2 + DIAGONAL|| p.x > g.realGameWidth/2) return false;
        if (p.y < _offsetY || p.y > g.realGameHeight + _offsetY - FACTOR) return false;
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

    public function setSpriteFromIndex(sp:DisplayObject, point:Point):void {
        var pos:Point3D = new Point3D();
        pos.x = point.x * FACTOR;
        pos.z = point.y * FACTOR;
        var isoPoint:Point = IsoUtils.isoToScreen(pos);
        sp.x = isoPoint.x;
        sp.y = isoPoint.y;
    }

    public function getLengthMatrix():int {
        return _matrix.length;
    }

    public function get offsetY():int {
        return _offsetY;
    }

    public function get matrixSize():int {
        return _matrixSize;
    }

    public function get matrix():Array {
        return _matrix;
    }

    public function getIndexFromXY(point:Point):Point {
        var point3d:Point3D = IsoUtils.screenToIso(point);
        var bufX:int = int(point3d.x / FACTOR);
        var bufY:int = int(point3d.z / FACTOR);

        return new Point(bufX, bufY);
    }

    public function getXYFromIndex(point:Point):Point {
        var point3d:Point3D = new Point3D(point.x * FACTOR, 0, point.y * FACTOR);
        point = IsoUtils.isoToScreen(point3d);

        return point;
    }

    public function drawDebugGrid():void {
        createGridTexture();

        for (var i:int = 0; i < _matrixSize; i++) {
            for (var j:int = 0; j < _matrixSize; j++) {
                if (_matrix[i][j].inGame) {
                    drawGrid(i, j);
                }
            }
        }
        g.cont.gridDebugCont.flatten();
    }

    public function deleteDebugGrid():void {
        g.cont.gridDebugCont.unflatten();
        while (g.cont.gridDebugCont.numChildren) {
            g.cont.gridDebugCont.removeChildAt(0);
        }
    }

    private function drawGrid(i:int, j:int):void {
        var im:Image;
        im = new Image(_gridTexture);
        im.alpha = .5;
        im.pivotX = im.width/2;
        setSpriteFromIndex(im, new Point(i, j));
        g.cont.gridDebugCont.addChild(im);
    }

    private function createGridTexture():void {
        var sp:flash.display.Shape = new flash.display.Shape();
        sp.graphics.lineStyle(1, Color.WHITE);
        sp.graphics.moveTo(DIAGONAL/2, 0);
        sp.graphics.lineTo(0, FACTOR/2);
        sp.graphics.lineTo(DIAGONAL/2, FACTOR);
        sp.graphics.lineTo(DIAGONAL, FACTOR/2);
        sp.graphics.lineTo(DIAGONAL/2, 0);
        var BMP:BitmapData = new BitmapData(DIAGONAL, FACTOR, true, 0x00000000);
        BMP.draw(sp);
        _gridTexture = Texture.fromBitmapData(BMP,false, false);
    }


}
}
