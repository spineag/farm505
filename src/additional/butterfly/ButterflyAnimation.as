/**
 * Created by andy on 5/9/16.
 */
package additional.butterfly {
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import manager.Vars;
import starling.display.Image;

public class ButterflyAnimation {
    private var _armature:Armature;
    private var _callback:Function;
    private var _playOnce:Boolean;
    private var _label:String;
    private var g:Vars = Vars.getInstance();

    public function ButterflyAnimation(type:int) {
        _armature = g.allData.factory['butterfly'].buildArmature("bfly");
        if (type != Butterfly.TYPE_PINK) {
            changeTexture(type);
        }
    }

    private function changeTexture(type:int):void {
        if (type == Butterfly.TYPE_BLUE) {
            changeBoneTexture("body", "blue2");
            changeBoneTexture("wing1", "blue1");
            changeBoneTexture("wing2", "blue1");
        } else {
            changeBoneTexture("body", "yellow2");
            changeBoneTexture("wing1", "yellow1");
            changeBoneTexture("wing2", "yellow1");
        }
    }

    private function changeBoneTexture(oldName:String, newName:String):void {
        var im:Image = g.allData.factory['butterfly'].getTextureDisplay(newName) as Image;
        var b:Bone = _armature.getBone(oldName);
        b.display.dispose();
        b.display = im;
    }

    public function playIt(label:String, playOnce:Boolean = false, callback:Function = null):void {
        _callback = callback;
        _playOnce = playOnce;
        _label = label;
        if(_label == null || _label == '') _label = 'idle';

        removeListener();
        addListener();
        WorldClock.clock.add(_armature);
    }

    private function addListener():void {
        if (!_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.addEventListener(AnimationEvent.COMPLETE, onCompleteAnimation);
        if (!_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onCompleteAnimation);
    }

    private function removeListener():void {
        if (_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.removeEventListener(AnimationEvent.COMPLETE, onCompleteAnimation);
        if (_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onCompleteAnimation);
    }

    private function onCompleteAnimation(e:AnimationEvent):void {
        if (_playOnce) {
            stopIt();
            if (_callback != null) {
                _callback.apply();
            }
        }
    }

    public function stopIt():void {
        removeListener();
        WorldClock.clock.remove(_armature);
    }

}
}
