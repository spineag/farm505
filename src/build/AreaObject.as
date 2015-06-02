package build {
import flash.geom.Rectangle;

import starling.display.DisplayObject;

import starling.display.Image;

import starling.display.Sprite;

import utils.CSprite;

public class AreaObject extends WorldObject {
    protected var _dataBuild:Object;
    protected var _flip:Boolean;
    protected var _defaultScale:Number;

    public function AreaObject(dataBuild:Object) {
        _source = new CSprite();
        _build = new Sprite();
        _dataBuild = dataBuild;
        _flip = false;
        _sizeX = 0;
        _sizeY = 0;

        createBuild();
    }

    public function createBuild():void {
        var im:Image;

        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
        }

        if (_dataBuild.url == "buildAtlas") {
            im  = new Image(g.tempBuildAtlas.getTexture(_dataBuild.image));
            im.x = _dataBuild.innerX;
            im.y = _dataBuild.innerY;
        } else {
            im  = new Image(g.mapAtlas.getTexture(_dataBuild.image));
            im.x = -im.width/2;
        }

        _build.addChild(im);
        _defaultScale = _build.scaleX;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;

        (_build as Sprite).alpha = 1;
        if (_flip) {
            _build.scaleX = -_defaultScale;
        }

        _source.addChild(_build);
    }

    public function createArrow(seconds:uint = 10000):void {
    }

    override public function set enabled(value:Boolean):void {
//        if (_build) {
//            if (_handler && _handler.icon) {
//                _handler.icon.source.mouseEnabled = value;
//            }
//            (_build as Sprite).mouseEnabled = value;
//        }
    }

    public function removeArrow():void {
    }

    override public function get sizeX():uint {
        return _flip ? _sizeY : _sizeX;
    }
    public function get dataBuild():Object{
        return _dataBuild;
    }

    override public function get sizeY():uint {
        return _flip ? _sizeX : _sizeY;
    }

//    public function set flip(value:Boolean):void {
//        _flip = value;
//        if (_flip) {
//            _build.scaleX = -_defaultScale;
//        } else {
//            _build.scaleX = _defaultScale;
//        }
//    }

    public function get flip():Boolean {
        return _flip;
    }

    public function get rect():Rectangle {
        return _rect;
    }


//    private function renderArrow():void {
//        if ((getTimer() - _arrow['time']) < _secondsArrow) {
//            return;
//        }
//        g.area.areaDispatcher.removeEnterFrame(renderArrow);
//        TweenLite.to(_arrow, 0.25, {alpha: 0, onComplete: removeArrow, ease: Linear.easeNone});
//    }
//
//    private function completeArrow():void {
//        g.area.areaDispatcher.addEnterFrame(renderArrow);
//    }
}
}
