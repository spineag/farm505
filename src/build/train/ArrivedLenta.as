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
    private var _imLenta:Sprite;
    private var _isFront:Boolean;
    private var _korzina:Sprite;
    private var _callback:Function;
    private var _needStop:Boolean;
    private var _xEnd:int;
    private var _yEnd:int;

    public function ArrivedLenta(_x1:int, _y1:int, _x2:int, _y2:int, p:Sprite, isFront:Boolean) {
        _parent = p;
        _isFront = isFront;

        var im:Image = new Image(g.allData.atlas['buildAtlas'].getTexture('rope'));
        _imLenta = new Sprite();
        _imLenta.addChild(im);
        _imLenta.pivotY = _imLenta.height/2;
        _imLenta.x = _x2;
        _imLenta.y = _y2;
        _parent.addChild(_imLenta);
        _xEnd = _x1;
        _yEnd = _y1;

        var w:int = Math.sqrt((_x2 - _x1)*(_x2 - _x1) + (_y2 - _y1)*(_y2 - _y1));
        _imLenta.width = w;
        var alpha:Number = Math.asin((_y1 - _y2)/w);
        _imLenta.rotation = alpha;

        im = new Image(g.allData.atlas['buildAtlas'].getTexture('busket_2'));
        _korzina = new Sprite();
        im.x = -84*g.scaleFactor;
        im.y = -22*g.scaleFactor;
        _korzina.addChild(im);
    }

    public function startAnimateKorzina(f:Function, needStop:Boolean = false):void {
        _needStop = needStop;
        _callback = f;
        _parent.addChild(_korzina);
        if (_isFront) {
            _korzina.x = _imLenta.x;
            _korzina.y = _imLenta.y;
            new TweenMax(_korzina, 10, {x:_xEnd-160*g.scaleFactor, y:_yEnd + 40, ease:Linear.easeOut ,onComplete: completeAnim});
        } else {
            _korzina.x = _xEnd;
            _korzina.y = _yEnd;
            new TweenMax(_korzina, 10, {x:_imLenta.x, y:_imLenta.y, ease:Linear.easeOut ,onComplete: completeAnim});
        }
    }

    private function completeAnim():void {
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
    }

    public function showDirectKorzina():void {
        _korzina.x = -160*g.scaleFactor;
        _korzina.y = -186*g.scaleFactor;
        if (!_parent.contains(_korzina)) _parent.addChild(_korzina);
    }

    public function directAway(f:Function):void {
        _callback = f;
        if (!_parent.contains(_korzina))  _parent.addChild(_korzina);
        new TweenMax(_korzina, .85, {x:_xEnd, y:_yEnd, onComplete: onDirectAway, ease:Linear.easeOut});
    }

    private function onDirectAway():void {
        _parent.removeChild(_korzina);
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
    }

    public function deleteIt():void {
        _parent.removeChild(_imLenta);
        if (_parent.contains(_korzina))  _parent.removeChild(_korzina);
        _imLenta.dispose();
        _korzina.dispose();
        _parent = null;
    }
}
}
