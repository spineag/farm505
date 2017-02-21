/**
 * Created by andy on 2/14/17.
 */
package particle.tuts {
import flash.geom.Point;

import starling.display.Sprite;

import utils.Utils;

public class DustLikeRectangle {
    private var _source:Sprite;
    private var _arrParticleImages:Array = ['p_1', 'p_2', 'p_3', 'p_4', 'p_5', 'p_6', 'p_7', 'p_8', 'p_9', 'p_10', 'p_11', 'p_12'];
    private var _arrDusts:Vector.<DustLikeParticle>;
    private var PADDING:int = 0;
    private var TIME:int = 10;
    private var _width:int;
    private var _height:int;
    private var _parent:Sprite;
    private var _LTpoint:Point;
    private var _RTpoint:Point;
    private var _LBpoint:Point;
    private var _RBpoint:Point;

    public function DustLikeRectangle(p:Sprite, w:int, h:int, _x:int, _y:int) {
        _parent = p;
        _width = w;
        _height = h;
        _source = new Sprite();
        _source.x = _x;
        _source.y = _y;
        _parent.addChild(_source);
        _source.touchable = false;
        _LTpoint = new Point(-PADDING, -PADDING);
        _RTpoint = new Point(w + PADDING, -PADDING);
        _RBpoint = new Point(w + PADDING, h + PADDING);
        _LBpoint = new Point(-PADDING, h + PADDING);

        createParticles();
        setPreStartPositions();
        setPreStartAimations(.3);
        Utils.createDelay(.3, simpleAnimateParticles);
    }

    private function createParticles():void {
        var fullLength:int = 2*_width + 2*_height + 8*PADDING;
        var count:int = 2*int((_width + _height + 4*PADDING)/25); //  we want distance between dusts ~25 px
        var dustShift:int = int(fullLength/count); //  real distance between dusts
        _arrDusts = new Vector.<DustLikeParticle>(count);
        var dust:DustLikeParticle;
        var j:int;
        var numQuarter:int;
        var x:int;
        var y:int;
        for (var i:int=0; i<count; i++) {
            dust = new DustLikeParticle(_LTpoint, _RTpoint, _RBpoint, _LBpoint, _source, TIME, _arrParticleImages[int(Math.random()*12)]);
            _arrDusts.push(dust);
            j = i*dustShift;
            if (j < _width + 2*PADDING) {
                numQuarter = 1; // at top
                x = _LTpoint.x + j;
                y = _LTpoint.y;
            } else if (j < _width + _height + 4*PADDING) {
                numQuarter = 2; // at right
                x = _RTpoint.x;
                y = _RTpoint.y + (j - _width - 2*PADDING);
            } else if (j <2*_width + _height + 6*PADDING) {
                numQuarter = 3; // at bottom
                x = 2*_width + _height + 5*PADDING - j;
                y = _RBpoint.y;
            } else {
                numQuarter = 4; // at left
                x = _LTpoint.x;
                y = _LTpoint.y + 8*PADDING + 2*_height + 2*_width - j;
            }
            dust.setPosition(x, y, numQuarter);
        }
    }

    private function setPreStartPositions():void {
        var c:int = _arrDusts.length;
        var pCenter:Point = new Point(_width/2, _height/2);
        for (var i:int=0; i<c; i++) {
            if (_arrDusts[i]) _arrDusts[i].setPreStartPositions(pCenter);
        }
    }

    private function setPreStartAimations(t:Number):void {
        var c:int = _arrDusts.length;
        for (var i:int=0; i<c; i++) {
            if (_arrDusts[i]) _arrDusts[i].preStartAnimations(t);
        }
    }

    private function simpleAnimateParticles():void {
        var c:int = _arrDusts.length;
        for (var i:int=0; i<c; i++) {
            if (_arrDusts[i]) _arrDusts[i].simpleAnimate();
        }
    }

    public function deleteIt():void {
        if (!_source) return;
        _parent.removeChild(_source);
        var c:int = _arrDusts.length;
        for (var i:int=0; i<c; i++) {
            if (_arrDusts[i]) _arrDusts[i].deleteIt();
        }
        _arrDusts.fixed = false;
        _arrDusts.length = 0;
        _source.dispose();
        _source = null;
        _parent = null;
    }
}
}
