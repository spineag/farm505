/**
 * Created by user on 3/1/16.
 */
package tutorial {
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

    public function SimpleArrow(posType:int, parent:Sprite, scale:Number = 1) {
        _parent = parent;
        _source = new Sprite();
        _source.visible = false;
        _source.scaleX = _source.scaleY = scale;
        _armature = g.allData.factory['arrow'].buildArmature("arrow");
        _source.addChild(_armature.display as Sprite);
        switch (posType) {
            case POSITION_TOP: _source.rotation = 0; break;
            case POSITION_BOTTOM: _source.rotation = Math.PI/2; break;
            case POSITION_RIGHT: _source.rotation = Math.PI/4; break;
            case POSITION_LEFT: _source.rotation = -Math.PI/4; break;
        }
    }

    public function animateAtPosition(_x:int, _y:int):void {
        _source.x = _x;
        _source.y = _y;
        _source.visible = true;
        _parent.addChild(_source);
        animateIt();
    }

    private function animateIt():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlay('start');
    }

    public function deleteIt():void {
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
