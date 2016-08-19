/**
 * Created by user on 11/30/15.
 */
package heroes {
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingFactory;

import starling.display.Image;
import starling.display.Sprite;

public class HeroEyesAnimation {
    private var _armatureEyes:Armature;
    private var _armatureClip:Sprite;
    private var isAnimated:Boolean;

    public function HeroEyesAnimation(fact:StarlingFactory, catArmature:Armature, path:String, path2:String, isWoman:Boolean = false) {
        isAnimated = false;
        _armatureEyes = fact.buildArmature("eyes");

        var headBone:Slot = catArmature.getSlot('head');
        headBone.display.dispose();
        _armatureClip = _armatureEyes.display as Sprite;
        headBone.display = _armatureClip;

        var b:Slot;
        var im:Image;
        im = fact.getTextureDisplay(path) as Image;
        b = _armatureEyes.getSlot('head');
        b.display.dispose();
        b.display = im;

        b = _armatureEyes.getSlot('lid_r');
        im = fact.getTextureDisplay('eye/lid_r' + path2) as Image;
        b.display.dispose();
        b.display = im;
        b = _armatureEyes.getSlot('lid_l');
        im = fact.getTextureDisplay('eye/lid_l' + path2) as Image;
        b.display.dispose();
        b.display = im;

        if (!isWoman) {
            b = _armatureEyes.getSlot('vii1');
            _armatureEyes.removeSlot(b);
            b = _armatureEyes.getSlot('vii2');
            _armatureEyes.removeSlot(b);
        }

        //changeColorEyes(fact);
        startAnimations();
    }

    public function startAnimations():void {
        if (isAnimated) return;
        WorldClock.clock.add(_armatureEyes);
        isAnimated = true;
        _armatureEyes.addEventListener(EventObject.LOOP_COMPLETE, armatureEventHandler);
        playIt();
    }

    private function armatureEventHandler(e:EventObject):void {
        playIt();
    }

    private function playIt():void {
        var r:Number = Math.random();
        if (r < .2) {
            _armatureEyes.animation.gotoAndPlayByFrame("idle");
        } else if (r < .4) {
            _armatureEyes.animation.gotoAndPlayByFrame("idle1");
        } else if (r < .6) {
            _armatureEyes.animation.gotoAndPlayByFrame("idle2");
        } else if (r < .8) {
            _armatureEyes.animation.gotoAndPlayByFrame("idle3");
        } else {
            _armatureEyes.animation.gotoAndPlayByFrame("idle4");
        }
    }

    public function stopAnimations():void {
        if (!isAnimated) return;
        isAnimated  = false;
        _armatureEyes.removeEventListener(EventObject.LOOP_COMPLETE, armatureEventHandler);
        _armatureEyes.animation.stop("idle");
        WorldClock.clock.remove(_armatureEyes);
    }

    private function changeColorEyes(fact:StarlingFactory):void {
        var arr:Array = new Array('eye/eye_l', 'eye/eye_l_blue', 'eye/eye_l_brown', 'eye/eye_l_green', 'eye/eye_l_grey');
        var k:int = int(Math.random()*arr.length);
        var im:Image = fact.getTextureDisplay(arr[k]) as Image;
        var im2:Image = fact.getTextureDisplay(arr[k]) as Image;
        var b:Slot = _armatureEyes.getSlot('eye_l');
        b.display.dispose();
        b.display = im;
        b = _armatureEyes.getSlot('eye_r');
        b.display.dispose();
        b.display = im2;
    }
}
}
