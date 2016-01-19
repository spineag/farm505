package build {

import flash.geom.Point;
import flash.geom.Rectangle;

import manager.Vars;
import map.MatrixGrid;
import starling.display.DisplayObject;
import starling.display.Sprite;

import utils.IsoUtils;
import utils.Point3D;
import utils.CSprite;

public class WorldObject {
    public static var STATE_UNACTIVE:int = 1;       // только для стандартных зданий
    public static var STATE_BUILD:int = 2;          // состояние стройки
    public static var STATE_WAIT_ACTIVATE:int = 3;  // построенное, но еще не открытое
    public static var STATE_ACTIVE:int = 4;         // активное состояние, после стройки

    protected var _dataBuild:Object;
    protected var _flip:Boolean;
    protected var _defaultScale:Number;
    public var posX:int = 0;
    public var posY:int = 0;
    public var useIsometricOnly:Boolean = true;
    protected var _sizeX:int;
    protected var _sizeY:int;
    protected var _source:CSprite;
    protected var _build:Sprite;
    protected var _isoView:Sprite;
    protected var _craftSprite:Sprite;
    protected var _depth:Number = 0;
    protected var _rect:Rectangle;
    protected var _dbBuildingId:int = 0;   // id в таблице user_building
    protected var _stateBuild:int;  // состояние постройки (активное, в процесе стройки..)

    protected static var g:Vars = Vars.getInstance();

    public function WorldObject() {
    }

    public function get sizeX():uint {
        return _flip ? _sizeY : _sizeX;
    }

    public function get sizeY():uint {
        return _flip ? _sizeX : _sizeY;
    }

    public function get source():CSprite {
        return _source;
    }

    public function get build():DisplayObject {
        return _build;
    }

    public function get depth():Number {
        return _depth;
    }

    public function get dataBuild():Object{
        return _dataBuild;
    }

    public function get dbBuildingId():int{
        return _dbBuildingId;
    }

    public function set dbBuildingId(a:int):void{
        _dbBuildingId = a;
    }

    public function get stateBuild():int{
        return _stateBuild;
    }

    public function set stateBuild(a:int):void{
        _stateBuild = a;
    }

    public function addXP():void {}

    public function get craftSprite():Sprite {
        return _craftSprite;
    }

    public function updateDepth():void {
        var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));

        point3d.x += g.matrixGrid.FACTOR * _sizeX * 0.5;
        point3d.z += g.matrixGrid.FACTOR * _sizeY * 0.5;

        _depth = point3d.x + point3d.z;
    }

    public function set enabled(value:Boolean):void { }

    public function get flip():Boolean {
        return _flip;
    }

    public function makeFlipBuilding():void {
        if (_flip)
            _source.scaleX = -_defaultScale;
        else
            _source.scaleX = _defaultScale;
    }

    public function releaseFlip():void {
        if (_sizeX == _sizeY) {
            _flip = !_flip;
            makeFlipBuilding();
            _dataBuild.isFlip = _flip;
            return;
        }

        _flip = !_flip;
        if (_flip) {
            g.townArea.unFillMatrix(posX, posY, _sizeY, _sizeX);
            if (g.toolsModifier.checkFreeGrids(posX, posY, _sizeX, _sizeY)) {
                _flip = false;
                _source.scaleX = _defaultScale;
                g.townArea.fillMatrix(posX, posY, _sizeX, _sizeY, this);
            } else {
                g.townArea.fillMatrix(posX, posY, _sizeY, _sizeX, this);
            }
        } else {
            g.townArea.unFillMatrix(posX, posY, _sizeX, _sizeY);
            if (g.toolsModifier.checkFreeGrids(posX, posY, _sizeY, _sizeX)) {
                _flip = true;
                _source.scaleX = -_defaultScale;
                g.townArea.fillMatrix(posX, posY, _sizeY, _sizeX, this);
            } else {
                g.townArea.fillMatrix(posX, posY, _sizeX, _sizeY, this);
            }
        }
        makeFlipBuilding();
        _dataBuild.isFlip = _flip;
    }

    public function isContDrag():Boolean {
        return _source.isContDrag;
    }
}
}