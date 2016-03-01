/**
 * Created by user on 2/29/16.
 */
package tutorial {
import manager.Vars;

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
    private var SHIFT:int = 30;
    private var PADDING:int = 20;
    private var _width:int;
    private var _height:int;
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _curType:int;

    public function DustRectangle(p:Sprite, w:int, h:int, _x:int, _y:int, type:int):void {
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
    }

    private function createParticles():void {
        // arrTop.length/arrRight.length == w/h  !!!!!
        var i:int;
        var dust:DustParticle;
        var color:int;
        _arrDustsTop = new Vector.<DustParticle>(_width);
        for (i=0; i<_width; i++) {
            color = _arrColors[int(9*Math.random())];  // 9 == _arrColors.length
            dust = new DustParticle(color, SIDE_TOP);
            _source.addChild(dust.source);
            _arrDustsTop[i] = dust;
        }
        _arrDustsBottom = new Vector.<DustParticle>(_width);
        for (i=0; i<_width; i++) {
            color = _arrColors[int(9*Math.random())];
            dust = new DustParticle(color, SIDE_BOTTOM);
            _source.addChild(dust.source);
            _arrDustsBottom[i] = dust;
        }
        _arrDustsLeft = new Vector.<DustParticle>(_height);
        for (i=0; i<_height; i++) {
            color = _arrColors[int(9*Math.random())];
            dust = new DustParticle(color, SIDE_LEFT);
            _source.addChild(dust.source);
            _arrDustsLeft[i] = dust;
        }
        _arrDustsRight = new Vector.<DustParticle>(_height);
        for (i=0; i<_height; i++) {
            color = _arrColors[int(9*Math.random())];
            dust = new DustParticle(color, SIDE_RIGHT);
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
        max = _width + 2*PADDING - SHIFT;
        for (i=0; i<count; i++){
            time = (Math.random() + 1)*.5;
            _x = -PADDING + int(Math.random() * max);
            _y = -int(Math.random()*PADDING);
            _arrDustsTop[i].setDefaults(_x, _y);
            _arrDustsTop[i].scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                _arrDustsTop[i].moveIt(_x + SHIFT, _y, 2*time, null);
        }

        count = _arrDustsBottom.length;
        max = _width + 2*PADDING - SHIFT;
        for (i=0; i<count; i++){
            time = (Math.random() + 1)*.5;
            _x = _width + PADDING - int(Math.random() * max);
            _y = _height + int(Math.random()*PADDING);
            _arrDustsBottom[i].setDefaults(_x, _y);
            _arrDustsBottom[i].scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                _arrDustsBottom[i].moveIt(_x - SHIFT, _y, 2*time, null);
        }

        count = _arrDustsRight.length;
        max = _height + 2*PADDING - SHIFT;
        for (i=0; i<count; i++){
            time = (Math.random() + 1)*.5;
            _x = _width + PADDING*Math.random();
            _y = -PADDING + int(Math.random()*max);
            _arrDustsRight[i].setDefaults(_x, _y);
            _arrDustsRight[i].scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                _arrDustsRight[i].moveIt(_x, _y + SHIFT, 2*time, null);
        }

        count = _arrDustsLeft.length;
        max = _height + 2*PADDING - SHIFT;
        for (i=0; i<count; i++){
            time = (Math.random() + 1)*.5;
            _x = PADDING*(Math.random() - 1);
            _y = _height + PADDING - int(Math.random()*max);
            _arrDustsLeft[i].setDefaults(_x, _y);
            _arrDustsLeft[i].scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                _arrDustsRight[i].moveIt(_x, _y - SHIFT, 2*time, null);
        }
    }

    private function onCallback(dust:DustParticle, side:int):void {
        var _x:int;
        var _y:int;
        var time:Number;

        if (side == SIDE_TOP) {
            time = (Math.random() + 1)*.5;
            _x = -PADDING + int(Math.random() * (_width + 2*PADDING - SHIFT));
            _y = -int(Math.random()*PADDING);
            dust.setDefaults(_x, _y);
            dust.scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                dust.moveIt(_x + SHIFT, _y, 2*time, null);
        } else if (side == SIDE_BOTTOM) {
            time = (Math.random() + 1)*.5;
            _x = _width + PADDING - int(Math.random() * (_width + 2*PADDING - SHIFT));
            _y = _height + int(Math.random()*PADDING);
            dust.setDefaults(_x, _y);
            dust.scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                dust.moveIt(_x - SHIFT, _y, 2*time, null);
        } else if (side == SIDE_RIGHT) {
            time = (Math.random() + 1)*.5;
            _x = _width + PADDING*Math.random();
            _y = -PADDING + int(Math.random() * (_height + 2*PADDING - SHIFT));
            dust.setDefaults(_x, _y);
            dust.scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                dust.moveIt(_x, _y + SHIFT, 2*time, null);
        } else if (side == SIDE_LEFT) {
            time = (Math.random() + 1)*.5;
            _x = PADDING*(Math.random() - 1);
            _y = _height + PADDING - int(Math.random() * (_height + 2*PADDING - SHIFT));
            dust.setDefaults(_x, _y);
            dust.scaleIt(time, onCallback);
            if (_curType == MOVE_RIGHT)
                dust.moveIt(_x, _y - SHIFT, 2*time, null);
        }
    }

    public function deleteIt():void {
        _parent.removeChild(_source);
    }

}
}
