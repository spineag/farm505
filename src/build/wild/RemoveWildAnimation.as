/**
 * Created by user on 2/3/16.
 */
package build.wild {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;

import manager.Vars;

import starling.display.Sprite;

public class RemoveWildAnimation {
    private var _parent:Sprite;
    private var _callback:Function;
    private var _countPlay:int;
    private var _armature:Armature;
    private var g:Vars = Vars.getInstance();

    public function RemoveWildAnimation(parent:Sprite, f:Function, instrumentId:int) {
        _callback = f;
        _parent = parent;

        var _x:int;
        var _y:int;
        switch (instrumentId) {
            case 124: // saw
                _x = 46 * g.scaleFactor;
                _y = 0;
                _countPlay = 4;
                _armature = g.allData.factory['removeWild'].buildArmature("saw");
                break;
            case 1: // axe
                _x = 32 * g.scaleFactor;
                _y = -43 * g.scaleFactor;
                _countPlay = 3;
                _armature = g.allData.factory['removeWild'].buildArmature("axe");
                break;
            case 125: // shovel
                _x = 38 * g.scaleFactor;
                _y = -22 * g.scaleFactor;
                _countPlay = 2;
                _armature = g.allData.factory['removeWild'].buildArmature("shovel");
                break;
            case 6: // pickaxe
                _x = 160 * g.scaleFactor;
                _y = 10 * g.scaleFactor;
                _countPlay = 3;
                _armature = g.allData.factory['removeWild'].buildArmature("pickaxe");
                break;
            case 5: // jackhammer
                _x = 5 * g.scaleFactor;
                _y = -23 * g.scaleFactor;
                _countPlay = 2;
                _armature = g.allData.factory['removeWild'].buildArmature("jackhammer");
                break;
        }
        WorldClock.clock.add(_armature);
        _armature.display.x = _x;
        _armature.display.y = _y;
        _parent.addChild(_armature.display as Sprite);
        playIt();
    }

    private function playIt(e:AnimationEvent=null):void {
        if (_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.removeEventListener(AnimationEvent.COMPLETE, playIt);
        if (_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, playIt);

        _countPlay--;
        if (_countPlay < 0) {
            WorldClock.clock.remove(_armature);
            _parent.removeChild(_armature.display as Sprite);
            _armature.dispose();
            _armature = null;
            if (_callback != null) {
                _callback.apply();
                _callback = null;
            }
        } else {
            _armature.addEventListener(AnimationEvent.COMPLETE, playIt);
            _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, playIt);
            _armature.animation.gotoAndPlay("work");
        }
    }
}
}
