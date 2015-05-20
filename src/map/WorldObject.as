package map {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Point;

import manager.Vars;

import utils.IsoUtils;
import utils.Point3D;

public class WorldObject {
    public var posX:int = 0;
    public var posY:int = 0;

    protected var _source:Sprite;
    protected var _build:DisplayObject;
    protected var _depth:Number = 0;
    protected var _isTint:Boolean = false;

    protected static var g:Vars = Vars.getInstance();

    public function WorldObject() {
    }

    public function get sizeX():uint {
        return 0;
    }

    public function get sizeY():uint {
        return 0;
    }

    public function get source():Sprite {
        return _source;
    }

    public function get build():DisplayObject {
        return _build;
    }

    public function get depth():Number {
        return _depth;
    }

    public function updateDepth():void {
        var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));

        point3d.x += MatrixGrid.FACTOR * sizeX * 0.5;
        point3d.z += MatrixGrid.FACTOR * sizeY * 0.5;

        _depth = point3d.x + point3d.z;
    }

    public function remove():void {

    }

    public function drawGrid():void {
        var i:int;
        var point:Point;

        _source.graphics.clear();
        _source.graphics.lineStyle(1, 0x0000FF);
        for (i = 0; i <= sizeY; i++) {
            point = g.matrixGrid.getXYFromIndex(new Point(0, i));
            _source.graphics.moveTo(point.x, point.y);
            point = g.matrixGrid.getXYFromIndex(new Point(sizeX, i));
            _source.graphics.lineTo(point.x, point.y);
        }
        for (i = 0; i <= sizeX; i++) {
            point = g.matrixGrid.getXYFromIndex(new Point(i, 0));
            _source.graphics.moveTo(point.x, point.y);
            point = g.matrixGrid.getXYFromIndex(new Point(i, sizeY));
            _source.graphics.lineTo(point.x, point.y);
        }
    }

    public function set enabled(value:Boolean):void {

    }

    public function get dataBaseId():uint {
        return 0;
    }
}
}