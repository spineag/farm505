/**
 * Created by user on 2/3/16.
 */
package build.wild {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import manager.Vars;
import starling.display.Sprite;
import starling.events.Event;

public class RemoveWildAnimation {
    private var _parent:Sprite;
    private var _callback:Function;
    private var _callbackTotal:Function;
    private var _countPlay:int;
    private var _armature:Armature;
    private var g:Vars = Vars.getInstance();

    public function RemoveWildAnimation(parent:Sprite, f:Function, fTotal:Function, instrumentId:int) {
        _callback = f;
        _callbackTotal = fTotal;
        _parent = parent;

        var _x:int;
        var _y:int;
        switch (instrumentId) {
            case 124: // saw
                _x = 46 * g.scaleFactor;
                _y = 0;
                _countPlay = 4;
                _armature = g.allData.factory['tools'].buildArmature("saw");
                break;
            case 1: // axe
                _x = 32 * g.scaleFactor;
                _y = -43 * g.scaleFactor;
                _countPlay = 3;
                _armature = g.allData.factory['tools'].buildArmature("axe");
                (_armature.display as StarlingArmatureDisplay).rotation = -Math.PI/2;
                break;
            case 125: // shovel
                _x = 38 * g.scaleFactor;
                _y = -22 * g.scaleFactor;
                _countPlay = 2;
                _armature = g.allData.factory['tools'].buildArmature("shovel");
                break;
            case 6: // pickaxe
                _x = 160 * g.scaleFactor;
                _y = 10 * g.scaleFactor;
                _countPlay = 3;
                _armature = g.allData.factory['tools'].buildArmature("pickaxe");
                break;
            case 5: // jackhammer
                _x = 5 * g.scaleFactor;
                _y = -23 * g.scaleFactor;
                _countPlay = 2;
                _armature = g.allData.factory['tools'].buildArmature("jackhammer");
                break;
        }
        WorldClock.clock.add(_armature);
        (_armature.display as StarlingArmatureDisplay).x = _x;
        (_armature.display as StarlingArmatureDisplay).y = _y;
        _parent.addChild(_armature.display as StarlingArmatureDisplay);
        playIt();
    }

    private function playIt(e:Event=null):void {
        if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, playIt);
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, playIt);

        _countPlay--;
        if (_countPlay < 0) {
            WorldClock.clock.remove(_armature);
            _parent.removeChild(_armature.display as Sprite);
            _armature = null;
            if (_callback != null) {
                _callback.apply();
                _callback = null;
            }
            showBoom();
        } else {
            _armature.addEventListener(EventObject.COMPLETE, playIt);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, playIt);
            _armature.animation.gotoAndPlayByFrame("work");
        }
    }

    private function showBoom():void {
        _armature = g.allData.factory['explode_gray'].buildArmature("expl");
        _parent.addChild(_armature.display as StarlingArmatureDisplay);
        WorldClock.clock.add(_armature);
        _armature.addEventListener(EventObject.COMPLETE, onBoom);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onBoom);
        _armature.animation.gotoAndPlayByFrame("start");
    }

    private function onBoom(e:Event=null):void {
        if (_callbackTotal != null) {
            _callbackTotal.apply();
            _callbackTotal = null;
        }
        if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, onBoom);
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, onBoom);
        WorldClock.clock.remove(_armature);
        _parent.removeChild(_armature.display as Sprite);
        _armature = null;
    }
}
}
