/**
 * Created by andy on 5/9/16.
 */
package additional.butterfly {
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;
import dragonBones.starling.StarlingFactory;

import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

public class ButterflyAnimation {
    private var _source:Sprite;
    private var _armature:Armature;
    private var _callback:Function;
    private var _playOnce:Boolean;
    private var _label:String;
    private var g:Vars = Vars.getInstance();

    public function ButterflyAnimation(type:int) {
        _source = new Sprite();
        _armature = (g.allData.factory['bfly'] as StarlingFactory).buildArmature("bfly");
        if (type != Butterfly.TYPE_PINK) {
            changeTexture(type);
        }
        _source.addChild(_armature.display as StarlingArmatureDisplay);
    }

    public function get source():Sprite {
        return _source;
    }

    private function changeTexture(type:int):void {
        if (type == Butterfly.TYPE_BLUE) {
            changeBoneTexture("body", "blue_2");
            changeBoneTexture("wing1", "blue_1");
            changeBoneTexture("wing2", "blue_1");
        } else {
            changeBoneTexture("body", "yellow_2");
            changeBoneTexture("wing1", "yellow_1");
            changeBoneTexture("wing2", "yellow_1");
        }
    }

    private function changeBoneTexture(oldName:String, newName:String):void {
        var im:Image = new Image(g.allData.atlas['customisationAtlas'].getTexture("butterfly_" + newName));
        var b:Slot = _armature.getSlot(oldName);
        if (im) {
            b.displayList = null;
            b.display = im;
        }
    }

    public function playIt(label:String, playOnce:Boolean = false, callback:Function = null):void {
        _callback = callback;
        _playOnce = playOnce;
        _label = label;
        if(_label == null || _label == '') _label = 'idle';

        removeListener();
        addListener();
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlayByFrame(_label);
    }

    private function addListener():void {
        if (!_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, onCompleteAnimation);
        if (!_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
    }

    private function removeListener():void {
        if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, onCompleteAnimation);
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
    }

    private function onCompleteAnimation(e:Event=null):void {
        if (_playOnce) {
            stopIt();
            if (_callback != null) {
                _callback.apply();
            }
        } else {
            _armature.animation.gotoAndPlayByFrame(_label);
        }
    }

    public function stopIt():void {
        removeListener();
        WorldClock.clock.remove(_armature);
    }

}
}
