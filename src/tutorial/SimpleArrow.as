/**
 * Created by user on 3/1/16.
 */
package tutorial {
import com.greensock.TweenMax;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;

import manager.Vars;
import starling.display.Sprite;

public class SimpleArrow {
    public static const POSITION_TOP:int=1;
    public static const POSITION_BOTTOM:int=2;
    public static const POSITION_LEFT:int=3;
    public static const POSITION_RIGHT:int=4;

    private var _source:Sprite;
    private var _parent:Sprite;
    private var _armature:Armature;
    private var g:Vars = Vars.getInstance();

    public function SimpleArrow(posType:int, parent:Sprite) {
        _parent = parent;
        _source = new Sprite();
        _source.visible = false;
        _source.touchable = false;
        _armature = g.allData.factory['arrow'].buildArmature("arrow");
        _source.addChild(_armature.display as Sprite);
        _source.scaleX = _source.scaleY = .7;
        switch (posType) {
            case POSITION_TOP: _source.rotation = 0; break;
            case POSITION_BOTTOM: _source.rotation = Math.PI; break;
            case POSITION_RIGHT: _source.rotation = Math.PI/2; break;
            case POSITION_LEFT: _source.rotation = -Math.PI/2; break;
        }
    }

    public function scaleIt(n:Number):void {
        _source.scaleX = _source.scaleY = n;
    }

    public function animateAtPosition(_x:int, _y:int):void {
        _source.x = _x;
        _source.y = _y;
        _source.visible = true;
        _parent.addChild(_source);
        _source.alpha = 0;
        TweenMax.to(_source, .5, {alpha:1});
        animateIt();
    }

    public function changeY(_y:int):void {
        _source.y = _y;
    }

    public function set visible(v:Boolean):void {
        _source.visible = v;
    }

    private function animateIt():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlay('start');
    }

    public function deleteIt():void {
        TweenMax.killTweensOf(_source);
        if (_parent.contains(_source)) _parent.removeChild(_source);
        WorldClock.clock.remove(_armature);
        _armature.dispose();
        _source.dispose();
        _armature = null;
        _source = null;
        _parent = null;
    }

}
}
