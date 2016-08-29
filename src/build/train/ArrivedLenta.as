/**
 * Created by user on 2/9/16.
 */
package build.train {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;

public class ArrivedLenta {
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _imLeft:Sprite;
    private var _imRight:Sprite;
    private var _isFront:Boolean;
    private var _korzina:Sprite;
    private var _callback:Function;
    private var _needStop:Boolean;

    public function ArrivedLenta(_x1:int, _y1:int, _x2:int, _y2:int, p:Sprite, isFront:Boolean) {
        _parent = p;
        _isFront = isFront;

        var im:Image = new Image(g.allData.atlas['buildAtlas'].getTexture('rope'));
        _imLeft = new Sprite();
        _imLeft.addChild(im);
        _imLeft.pivotY = _imLeft.height/2;
        _imLeft.x = _x2;
        _imLeft.y = _y2;
        _parent.addChild(_imLeft);

        im = new Image(g.allData.atlas['buildAtlas'].getTexture('rope'));
        _imRight = new Sprite();
        _imRight.addChild(im);
        _imRight.pivotX = _imRight.width;
        _imRight.pivotY = _imRight.height/2;
        _imRight.x = _x1;
        _imRight.y = _y1;
        _parent.addChild(_imRight);

        im = new Image(g.allData.atlas['buildAtlas'].getTexture('busket_2'));
        _korzina = new Sprite();
        im.x = -84*g.scaleFactor;
        im.y = -22*g.scaleFactor;
        _korzina.addChild(im);
    }

    public function setEmptyState():void {
        setRightToPoint(_imLeft.x, _imLeft.y);
        _imLeft.width = 1;
        _imLeft.visible = false;
    }

    private function setRightToPoint(_x:int, _y:int):void {
        var w:int = Math.sqrt((_imRight.x - _x)*(_imRight.x - _x) + (_imRight.y - _y)*(_imRight.y - _y));
        _imRight.width = w-4;
        var alpha:Number = Math.acos((_imRight.x - _x)/w);
        if ((alpha || alpha == 0) && Math.abs(alpha) < 1)
            _imRight.rotation = -alpha;
    }

    private function setLeftToPoint(_x:int, _y:int):void {
        var w:int = Math.sqrt((_imLeft.x - _x)*(_imLeft.x - _x) + (_imLeft.y - _y)*(_imLeft.y - _y));
        _imLeft.width = w;
        var alpha:Number = Math.asin((_y - _imLeft.y)/w);
        _imLeft.rotation = alpha;
    }

    public function startAnimateKorzina(f:Function, needStop:Boolean = false):void {
        _needStop = needStop;
        var tempX:int = (_imLeft.x + _imRight.x)/2;
        var tempY:int = (_imRight.y + _imLeft.y)/2 + 70*g.scaleFactor;
        _imLeft.visible = true;
        _imRight.visible = true;
        _callback = f;
        _parent.addChild(_korzina);
        if (_isFront) {
            _korzina.x = _imLeft.x;
            _korzina.y = _imLeft.y;
            new TweenMax(_korzina, 5, {bezier:[{x:tempX, y:tempY}, {x:_imRight.x, y:_imRight.y}], ease:Linear.easeOut ,onComplete: completeAnim});
            g.gameDispatcher.addEnterFrame(checkLentas);
        } else {
            _korzina.x = _imRight.x;
            _korzina.y = _imRight.y;
            new TweenMax(_korzina, 5, {bezier:[{x:tempX, y:tempY}, {x:_imLeft.x, y:_imLeft.y}], ease:Linear.easeOut ,onComplete: completeAnim});
            g.gameDispatcher.addEnterFrame(checkLentas);
        }
    }

    private function completeAnim():void {
        //setEmptyState();
        g.gameDispatcher.removeEnterFrame(checkLentas);
        _parent.removeChild(_korzina);
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
    }


    private function checkLentas():void {
        setLeftToPoint(_korzina.x, _korzina.y);
        setRightToPoint(_korzina.x, _korzina.y);
        if (_needStop) {
            if (_korzina.x > -160*g.scaleFactor) {
                TweenMax.killTweensOf(_korzina);
                g.gameDispatcher.removeEnterFrame(checkLentas);
                _needStop = false;
                if (_callback != null) {
                    _callback.apply();
                    _callback = null;
                }
            }
        }
    }

    public function showDirectKorzina():void {
        _korzina.x = -160*g.scaleFactor;
        _korzina.y = -178*g.scaleFactor;
        if (!_parent.contains(_korzina)) _parent.addChild(_korzina);
        _imLeft.visible = true;
        _imRight.visible = true;
        setLeftToPoint(_korzina.x, _korzina.y);
        setRightToPoint(_korzina.x, _korzina.y);
    }

    public function directAway(f:Function):void {
        _callback = f;
        if (!_parent.contains(_korzina))  _parent.addChild(_korzina);
        new TweenMax(_korzina, 1, {x:_imRight.x, y:_imRight.y, onComplete: onDirectAway});
        g.gameDispatcher.addEnterFrame(checkLentas);
    }

    private function onDirectAway():void {
        _imRight.visible = false;
        _parent.removeChild(_korzina);
        g.gameDispatcher.removeEnterFrame(checkLentas);
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
    }

    public function deleteIt():void {
        _parent.removeChild(_imLeft);
        _parent.removeChild(_imRight);
        if (_parent.contains(_korzina))  _parent.removeChild(_korzina);
        _imLeft.dispose();
        _imRight.dispose();
        _korzina.dispose();
        _parent = null;
    }
}
}
