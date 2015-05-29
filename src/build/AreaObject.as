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

//        _build.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
//        _build.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
//        _build.addEventListener(MouseEvent.MOUSE_UP, mouseUp);

        _source.addChild(_build);
    }

    public function createArrow(seconds:uint = 10000):void {
//        if (_arrow) {
//            return;
//        }
//        _secondsArrow = seconds;
//        _arrow = (g.pKey['arrow'] as PKey).create() as MovieClip;
//        _arrow.mouseChildren = _arrow.mouseEnabled = false;
//        _arrow['time'] = getTimer();
//        _arrow['fon'].rotation = 0;
//        _arrow.alpha = 0;
//        g.area.addChild(_arrow);
//        resizeArrow();
//        TweenLite.to(_arrow, 0.25, {alpha: 1, onComplete: completeArrow, ease: Linear.easeNone});
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
//        if (!_arrow) {
//            return;
//        }
//        TweenLite.killTweensOf(_arrow);
//        g.area.areaDispatcher.removeEnterFrame(renderArrow);
//        g.area.removeChild(_arrow);
//        (g.pKey['arrow'] as PKey).remove(_arrow);
//        _arrow.alpha = 1;
//        _arrow = null;
    }

    override public function remove():void {
//        if (!_build) {
//            return;
//        }
//
//        _build.scaleX = _oldScale;
//        _source.alpha = 1;
//        _build.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
//        _build.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
//        _build.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
//         g.area.unFillMatrix(posX, posY, sizeX, sizeY, this);
//
//        while (_source.numChildren > 0) {
//            _source.removeChildAt(0);
//        }
//
//        (g.pKey[key] as PKey).remove(_build);
//        removeArrow();
//        if (_handler) {
//            _handler.unShowHint();
//        }
//        _handler = null;
//        _build = null;
//        _source = null;
    }

    override public function get sizeX():uint {
        return _flip ? _sizeY : _sizeX;
    }

    override public function get sizeY():uint {
        return _flip ? _sizeX : _sizeY;
    }

    public function set flip(value:Boolean):void {
        _flip = value;
        if (_flip) {
            _build.scaleX = -_defaultScale;
        } else {
            _build.scaleX = _defaultScale;
        }
        //updatePositionPointIcon();
    }

    public function get flip():Boolean {
        return _flip;
    }

//    public function isPaste(isSelect:Boolean = true):Boolean {
//        var temp:Boolean = true;
//        var arr:Array;
//
//        if (g.area.isOverLeftRight) {
//            select = SELECT_RED;
//            return false;
//        }
//
//        for (var i:int = posY; i < (posY + sizeY); i++) {
//            for (var j:int = posX; j < (posX + sizeX); j++) {
//                var data:Object = g.area.getElementMatrix(j, i);
//
//                if (!data) {
//                    temp = false;
//                    if (isSelect) {
//                        select = SELECT_RED;
//                    }
//                } else {
//                    if (data.id > 0 || !data.isNorm) {
//                        temp = false;
//                        if (isSelect) {
//                            select = SELECT_RED;
//                            arr = data.sources;
//                            for (var k:int = 0; k < arr.length; k++) {
//                                if (arr[k]) {
//                                    (arr[k] as AreaObject).select = SELECT_RED;
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        return temp;
//    }

    public function set selectAlpha(value:Boolean):void {
        if (!_source) {
            return;
        }
        if (value) {
            _source.alpha = 0.7;
        } else {
            _source.alpha = 1;
        }
    }

    public function get rect():Rectangle {
        return _rect;
    }

//    protected function mouseOver(e:MouseEvent):void {
//
//        if (_handler) {
//            _handler.mouseOver(e);
//        }
//    }
//
//    protected function mouseOut(e:MouseEvent):void {
//        if (_handler) {
//            _handler.mouseOut(e);
//        }
//    }
//
//    protected function mouseUp(e:MouseEvent):void {
//        _handler.mouseUp(e);
//    }

//    protected function setFilterForObject(object:DisplayObject):void {
//        var color:uint;
//
//        if (!object) {
//            return;
//        }
//
//        if (_select == SELECT_NULL) {
//            object.filters = [];
//            return;
//        }
//
//        if (_select == SELECT_GREEN) {
//            color = 0x00FF00;
//        } else if (_select == SELECT_RED) {
//            color = 0xFF0000;
//        } else if (_select == SELECT_YELLOW) {
//            color = 0xFFFF00;
//        } else if (_select == SELECT_BLUE) {
//            color = 0x00FFFF;
//        }
//
//        _glowFilter.color = color;
//        object.filters = [_glowFilter];
//    }

//    protected function updatePositionPointIcon():void {
//        if (_iconPoint) {
//            _pointIcon.y = _iconPoint.y;
//            if (_flip) {
//                _pointIcon.x = -_iconPoint.x;
//                if (_handler) {
//                    _handler.updatePositionIcon(this);
//                }
//            } else {
//                _pointIcon.x = _iconPoint.x;
//            }
//        }
//    }

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
