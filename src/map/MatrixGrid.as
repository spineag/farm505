/**
 * Created by user on 5/14/15.
 */
package map {
import build.WorldObject;

import flash.display.BitmapData;
import flash.geom.Point;

import manager.Vars;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.textures.Texture;
import starling.utils.Color;

import utils.IsoUtils;
import utils.Point3D;

public class MatrixGrid {
    public var WIDTH_CELL:uint;
    public var FACTOR:Number;
    public var DIAGONAL:Number;
    private var _offsetY:int = 0;
    private var _matrix:Array;
    private var _matrixSize:int;
    private var _gridWhiteTexture:Texture;
    private var _gridRedTexture:Texture;

    protected var g:Vars = Vars.getInstance();

    public function MatrixGrid() {
        WIDTH_CELL = 60 * g.scaleFactor;
        FACTOR = WIDTH_CELL / Math.SQRT2;
        DIAGONAL = Math.sqrt(WIDTH_CELL * WIDTH_CELL + WIDTH_CELL * WIDTH_CELL);
    }

    public function createMatrix():void {
        _matrix = [];
        _matrixSize = 80;
        _offsetY = g.realGameHeight/2 - g.realGameTilesHeight/2;

        for (var i:int = 0; i < _matrixSize; i++) {
            _matrix.push([]);
            for (var j:int = 0; j < _matrixSize; j++) {
                _matrix[i][j] = {id: 0, sources: [], inGame: true, findId: 0};
            }
        }
    }

//    private function isTileInGame(i:int, j:int):Boolean { // перевіряємо чи тайл попадає в ігрову зону, якщо ні - то його не використовуємо
//        var p:Point = getXYFromIndex(new Point(i,j));
//        if (p.x < -g.realGameTilesWidth/2 + DIAGONAL|| p.x > g.realGameTilesWidth/2) return false;
//        if (p.y < _offsetY || p.y > g.realGameTilesHeight + _offsetY - FACTOR) return false;
//        return true;
//    }

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
        return _matrixSize;
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
        var bufX:int = int(point3d.x / FACTOR + 1/2);
        var bufY:int = int(point3d.z / FACTOR + 1/2);
        if (bufX < 0) bufX = 0;
        if (bufY < 0) bufY = 0;
        if (bufX > _matrixSize) bufX = _matrixSize;
        if (bufY > _matrixSize) bufY = _matrixSize;
        return new Point(bufX, bufY);
    }

    public function getStrongIndexFromXY(point:Point):Point {
        var point3d:Point3D = IsoUtils.screenToIso(point);
        var bufX:int = int(point3d.x / FACTOR);
        var bufY:int = int(point3d.z / FACTOR);
        if (bufX < 0) bufX = 0;
        if (bufY < 0) bufY = 0;
        if (bufX > _matrixSize) bufX = _matrixSize;
        if (bufY > _matrixSize) bufY = _matrixSize;
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
                    drawGrid(j, i);
                }
            }
        }
    }

    public function drawDebugPartGrid(posX:int, posY:int, width:int, height:int):void {
        createGridTexture();

        for (var i:int = posY; i < posY + height; i++) {
            for (var j:int = posX; j < posX + width; j++) {
                if (_matrix[i][j].inGame) {
                    drawGrid(j, i, false);
                }
            }
        }
    }

    public function deleteDebugGrid():void {
        while (g.cont.gridDebugCont.numChildren) {
            g.cont.gridDebugCont.removeChildAt(0);
        }
    }

    private function drawGrid(x:int, y:int, isWhite:Boolean = true):void {
        var im:Image;
        isWhite ? im = new Image(_gridWhiteTexture) : im = new Image(_gridRedTexture);
        isWhite ? im.alpha = .5 : im.alpha = 1;
        im.pivotX = im.width/2;
        setSpriteFromIndex(im, new Point(x, y));
        g.cont.gridDebugCont.addChild(im);
    }

    private function createGridTexture():void {
        if (_gridWhiteTexture) return;

        var sp:flash.display.Shape = new flash.display.Shape();
        sp.graphics.lineStyle(1, Color.WHITE);
        sp.graphics.moveTo(DIAGONAL/2, 0);
        sp.graphics.lineTo(0, FACTOR/2);
        sp.graphics.lineTo(DIAGONAL/2, FACTOR);
        sp.graphics.lineTo(DIAGONAL, FACTOR/2);
        sp.graphics.lineTo(DIAGONAL/2, 0);
        var BMP:BitmapData = new BitmapData(DIAGONAL, FACTOR, true, 0x00000000);
        BMP.draw(sp);
        _gridWhiteTexture = Texture.fromBitmapData(BMP,false, false);

        sp.graphics.clear();
        sp.graphics.lineStyle(1, Color.RED);
        sp.graphics.moveTo(DIAGONAL/2, 0);
        sp.graphics.lineTo(0, FACTOR/2);
        sp.graphics.lineTo(DIAGONAL/2, FACTOR);
        sp.graphics.lineTo(DIAGONAL, FACTOR/2);
        sp.graphics.lineTo(DIAGONAL/2, 0);
        var BMP2:BitmapData = new BitmapData(DIAGONAL, FACTOR, true, 0x00000000);
        BMP2.draw(sp);
        _gridRedTexture = Texture.fromBitmapData(BMP2,false, false);
    }

//    private var underTexture:Texture;
//    public function get buildUnderTexture():Texture {
//        if (underTexture) return underTexture;
//
//        var sp:flash.display.Shape = new flash.display.Shape();
//        sp.graphics.lineStyle(1, Color.BLACK);
//        sp.graphics.beginFill(0x990000, 1);
//        sp.graphics.moveTo(DIAGONAL/2, 0);
//        sp.graphics.lineTo(0, FACTOR/2);
//        sp.graphics.lineTo(DIAGONAL/2, FACTOR);
//        sp.graphics.lineTo(DIAGONAL, FACTOR/2);
//        sp.graphics.lineTo(DIAGONAL/2, 0);
//        sp.graphics.endFill();
//        var BMP:BitmapData = new BitmapData(DIAGONAL, FACTOR, true, 0x00000000);
//        BMP.draw(sp);
//        underTexture = Texture.fromBitmapData(BMP,false, false);
//        return underTexture;
//    }



}
}
