/**
 * Created by user on 2/29/16.
 */
package tutorial {
import manager.Vars;

import starling.display.Quad;

import starling.display.Sprite;

public class DustRectangle {
    public static const MOVE_RIGHT:int = 1;
    public static const MOVE_BOTTOM:int = 2;
    public static const MOVE_LEFT:int = 3;
    public static const MOVE_TOP:int = 4;
    public static const MOVE_NONE:int = 5;

    private const SIDE_RIGHT:int = 1;
    private const SIDE_BOTTOM:int = 2;
    private const SIDE_LEFT:int = 3;
    private const SIDE_TOP:int = 4;

    private var _source:Sprite;
    private var _arrDustsTop:Vector.<DustParticle>;
    private var _arrDustsBottom:Vector.<DustParticle>;
    private var _arrDustsRight:Vector.<DustParticle>;
    private var _arrDustsLeft:Vector.<DustParticle>;
    private var _arrColors:Array = [0xe8eecf, 0xffffff, 0xc3ec1d, 0xfbc92f, 0xd6c6ff, 0xffa6d8, 0xe9a6ff, 0xa6fffa, 0xa6ffce];
    private var SHIFT_DUST_MOVING:int = 20;
    private var PADDING:int = 5;
    private var _width:int;
    private var _height:int;
    private var _parent:Sprite;
    private var _curType:int;

    public function DustRectangle(p:Sprite, w:int, h:int, _x:int, _y:int, type:int = MOVE_RIGHT):void {
        _parent = p;
        _width = w;
        _height = h;
        _source = new Sprite();
        _source.x = _x;
        _source.y = _y;
        _parent.addChild(_source);
        _source.touchable = false;
        _curType = type;

        createParticles();
        startTweenIt();

//        var q:Quad = new Quad(w, h);
//        q.x = _x;
//        q.y = _y;
//        p.addChild(q);
    }

    private function createParticles():void {
        // arrTop.length/arrRight.length == w/h  !!!!!
        var i:int;
        var dust:DustParticle;
        var color:int;
        var count:int = int(_width/10);
        _arrDustsTop = new Vector.<DustParticle>(count);
        for (i=0; i<count; i++) {
            color = _arrColors[int(9*Math.random())];  // 9 == _arrColors.length
            dust = new DustParticle(color);
            dust.side = SIDE_TOP;
            _source.addChild(dust.source);
            _arrDustsTop[i] = dust;
        }
        _arrDustsBottom = new Vector.<DustParticle>(count);
        for (i=0; i<count; i++) {
            color = _arrColors[int(9*Math.random())];
            dust = new DustParticle(color);
            dust.side = SIDE_BOTTOM;
            _source.addChild(dust.source);
            _arrDustsBottom[i] = dust;
        }
        count = int(_height/10);
        _arrDustsLeft = new Vector.<DustParticle>(count);
        for (i=0; i<count; i++) {
            color = _arrColors[int(9*Math.random())];
            dust = new DustParticle(color);
            dust.side = SIDE_LEFT;
            _source.addChild(dust.source);
            _arrDustsLeft[i] = dust;
        }
        _arrDustsRight = new Vector.<DustParticle>(count);
        for (i=0; i<count; i++) {
            color = _arrColors[int(9*Math.random())];
            dust = new DustParticle(color);
            dust.side = SIDE_RIGHT;
            _source.addChild(dust.source);
            _arrDustsRight[i] = dust;
        }
    }

    private function startTweenIt():void {
        var i:int;
        var _x:int;
        var _y:int;
        var max:int;
        var time:Number;

        var count:int = _arrDustsTop.length;
        max = _width + 2*PADDING - SHIFT_DUST_MOVING;
        for (i=0; i<count; i++){
            time = (Math.random() + 1)*.5;
            _x = -PADDING + int(Math.random() * max);
            _y = -int(Math.random()*PADDING);
            _arrDustsTop[i].setDefaults(_x, _y);
            _arrDustsTop[i].scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                _arrDustsTop[i].moveIt(_x + SHIFT_DUST_MOVING, _y, 2*time, null);
        }

        count = _arrDustsBottom.length;
        max = _width + 2*PADDING - SHIFT_DUST_MOVING;
        for (i=0; i<count; i++){
            time = (Math.random() + 1)*.5;
            _x = _width + PADDING - int(Math.random() * max);
            _y = _height + int(Math.random()*PADDING);
            _arrDustsBottom[i].setDefaults(_x, _y);
            _arrDustsBottom[i].scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                _arrDustsBottom[i].moveIt(_x - SHIFT_DUST_MOVING, _y, 2*time, null);
        }

        count = _arrDustsRight.length;
        max = _height + 2*PADDING - SHIFT_DUST_MOVING;
        for (i=0; i<count; i++){
            time = (Math.random() + 1)*.5;
            _x = _width + PADDING*Math.random();
            _y = -PADDING + int(Math.random()*max);
            _arrDustsRight[i].setDefaults(_x, _y);
            _arrDustsRight[i].scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                _arrDustsRight[i].moveIt(_x, _y + SHIFT_DUST_MOVING, 2*time, null);
        }

        count = _arrDustsLeft.length;
        max = _height + 2*PADDING - SHIFT_DUST_MOVING;
        for (i=0; i<count; i++){
            time = (Math.random() + 1)*.5;
            _x = PADDING*(Math.random() - 1);
            _y = _height + PADDING - int(Math.random()*max);
            _arrDustsLeft[i].setDefaults(_x, _y);
            _arrDustsLeft[i].scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                _arrDustsRight[i].moveIt(_x, _y - SHIFT_DUST_MOVING, 2*time, null);
        }
    }

    private function onCallback(dust:DustParticle, side:int):void {
        var _x:int;
        var _y:int;
        var time:Number;

        if (side == SIDE_TOP) {
            time = (Math.random() + 1)*.5;
            _x = -PADDING + int(Math.random() * (_width + 2*PADDING - SHIFT_DUST_MOVING));
            _y = -int(Math.random()*PADDING);
            dust.setDefaults(_x, _y);
            dust.scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                dust.moveIt(_x + SHIFT_DUST_MOVING, _y, 2*time, null);
        } else if (side == SIDE_BOTTOM) {
            time = (Math.random() + 1)*.5;
            _x = _width + PADDING - int(Math.random() * (_width + 2*PADDING - SHIFT_DUST_MOVING));
            _y = _height + int(Math.random()*PADDING);
            dust.setDefaults(_x, _y);
            dust.scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                dust.moveIt(_x - SHIFT_DUST_MOVING, _y, 2*time, null);
        } else if (side == SIDE_RIGHT) {
            time = (Math.random() + 1)*.5;
            _x = _width + PADDING*Math.random();
            _y = -PADDING + int(Math.random() * (_height + 2*PADDING - SHIFT_DUST_MOVING));
            dust.setDefaults(_x, _y);
            dust.scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                dust.moveIt(_x, _y + SHIFT_DUST_MOVING, 2*time, null);
        } else if (side == SIDE_LEFT) {
            time = (Math.random() + 1)*.5;
            _x = PADDING*(Math.random() - 1);
            _y = _height + PADDING - int(Math.random() * (_height + 2*PADDING - SHIFT_DUST_MOVING));
            dust.setDefaults(_x, _y);
            dust.scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                dust.moveIt(_x, _y - SHIFT_DUST_MOVING, 2*time, null);
        }
    }

    public function deleteIt():void {
        _parent.removeChild(_source);

        var i:int;
        var count:int = _arrDustsTop.length;
        for (i=0; i<count; i++) {
            if (_source.contains(_arrDustsTop[i].source)) _source.removeChild(_arrDustsTop[i].source);
            _arrDustsTop[i].deleteIt();
        }

        count = _arrDustsBottom.length;
        for (i=0; i<count; i++){
            if (_source.contains(_arrDustsBottom[i].source)) _source.removeChild(_arrDustsBottom[i].source);
            _arrDustsBottom[i].deleteIt();
        }

        count = _arrDustsRight.length;
        for (i=0; i<count; i++){
            if (_source.contains(_arrDustsRight[i].source)) _source.removeChild(_arrDustsRight[i].source);
            _arrDustsRight[i].deleteIt();
        }

        count = _arrDustsLeft.length;
        for (i=0; i<count; i++){
            if (_source.contains(_arrDustsLeft[i].source)) _source.removeChild(_arrDustsLeft[i].source);
            _arrDustsLeft[i].deleteIt();
        }

        _arrDustsTop.fixed = false;
        _arrDustsTop.length = 0;
        _arrDustsBottom.fixed = false;
        _arrDustsBottom.length = 0;
        _arrDustsRight.fixed = false;
        _arrDustsRight.length = 0;
        _arrDustsLeft.fixed = false;
        _arrDustsLeft.length = 0;

        _source.dispose();
        _source = null;
        _arrColors.length = 0;
        _parent = null;
    }


//    v.fixed = false;
//    v.length = 1000;
//    v.fixed = true;

}
}
