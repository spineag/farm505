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
    public static const WIDTH_CELL:uint = 60;
//    public static const WIDTH_CELL:uint = 30;
    public static const FACTOR:Number = WIDTH_CELL / Math.SQRT2;
    public static const DIAGONAL:Number = Math.sqrt(WIDTH_CELL * WIDTH_CELL + WIDTH_CELL * WIDTH_CELL);

    private var _offsetY:int = 0;
    private var _graf:V_GrafGrid;

    private var _matrix:Array;
    private var _matrixSize:int;
    private var _gridWhiteTexture:Texture;
    private var _gridRedTexture:Texture;
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

        var tempWidth:int = int(g.realGameTilesWidth / DIAGONAL + .5);
        var tempHeight:int = int(g.realGameTilesHeight / (DIAGONAL / 2) + .5);
        _matrixSize = tempWidth + tempHeight;

        _offsetY = 0 //_matrixSize*FACTOR/2 - g.realGameTilesHeight/2;  // 512

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
        if (p.x < -g.realGameTilesWidth/2 + DIAGONAL|| p.x > g.realGameTilesWidth/2) return false;
        if (p.y < _offsetY || p.y > g.realGameTilesHeight + _offsetY - FACTOR) return false;
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
        var bufX:int = int(point3d.x / FACTOR + 1/2);
        var bufY:int = int(point3d.z / FACTOR + 1/2);

        return new Point(bufX, bufY);
    }

    public function getStrongIndexFromXY(point:Point):Point {
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
                    drawGrid(j, i);
                }
            }
        }
        g.cont.gridDebugCont.flatten();
    }

    public function drawDebugPartGrid(posX:int, posY:int, width:int, height:int):void {
        createGridTexture();
        g.cont.gridDebugCont.unflatten();

        for (var i:int = posY; i < posY + height; i++) {
            for (var j:int = posX; j < posX + width; j++) {
                if (_matrix[i][j].inGame) {
                    drawGrid(j, i, false);
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

    private static var underTexture:Texture;
    public static function get buildUnderTexture():Texture {
        if (underTexture) return underTexture;

        var sp:flash.display.Shape = new flash.display.Shape();
        sp.graphics.lineStyle(1, Color.BLACK);
        sp.graphics.beginFill(0x990000, 1);
        sp.graphics.moveTo(DIAGONAL/2, 0);
        sp.graphics.lineTo(0, FACTOR/2);
        sp.graphics.lineTo(DIAGONAL/2, FACTOR);
        sp.graphics.lineTo(DIAGONAL, FACTOR/2);
        sp.graphics.lineTo(DIAGONAL/2, 0);
        sp.graphics.endFill();
        var BMP:BitmapData = new BitmapData(DIAGONAL, FACTOR, true, 0x00000000);
        BMP.draw(sp);
        underTexture = Texture.fromBitmapData(BMP,false, false);
        return underTexture;
    }


}
}
