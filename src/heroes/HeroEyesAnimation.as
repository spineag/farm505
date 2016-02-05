/**
 * Created by user on 11/30/15.
 */
package heroes {
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import dragonBones.factories.StarlingFactory;

import starling.display.Image;
import starling.display.Sprite;

public class HeroEyesAnimation {
    private var _armatureEyes:Armature;
    private var _armatureClip:Sprite;
    private var isAnimated:Boolean;

    public function HeroEyesAnimation(fact:StarlingFactory, catArmature:Armature, path:String, isWoman:Boolean = false) {
        isAnimated = false;
        _armatureEyes = fact.buildArmature("eyes");

        var headBone:Bone = catArmature.getBone('head');
        headBone.display.dispose();
        _armatureClip = _armatureEyes.display as Sprite;
        headBone.display = _armatureClip;

        var b:Bone;
        var im:Image;
        if (isWoman) {
            im = fact.getTextureDisplay(path) as Image;
            b = _armatureEyes.getBone('head');
            b.display.dispose();
            b.display = im;

            b = _armatureEyes.getBone('lid_r');
            im = fact.getTextureDisplay('eye/lid_r_w') as Image;
            b.display.dispose();
            b.display = im;
            b = _armatureEyes.getBone('lid_l');
            im = fact.getTextureDisplay('eye/lid_l_w') as Image;
            b.display.dispose();
            b.display = im;
        } else {
            if (path != 'heads/head_w') {
                im = fact.getTextureDisplay(path) as Image;
                b = _armatureEyes.getBone('head');
                b.display.dispose();
                b.display = im;
            }
            b = _armatureEyes.getBone('vii');
            _armatureEyes.removeBone(b);
        }

        //changeColorEyes(fact);
        startAnimations();
    }

    public function startAnimations():void {
        if (isAnimated) return;
        WorldClock.clock.add(_armatureEyes);
        isAnimated = true;
        _armatureEyes.addEventListener(dragonBones.events.AnimationEvent.LOOP_COMPLETE, armatureEventHandler);
        playIt();
    }

    private function armatureEventHandler(e:dragonBones.events.AnimationEvent):void {
        playIt();
    }

    private function playIt():void {
        var r:Number = Math.random();
        if (r < .2) {
            _armatureEyes.animation.gotoAndPlay("idle");
        } else if (r < .4) {
            _armatureEyes.animation.gotoAndPlay("idle1");
        } else if (r < .6) {
            _armatureEyes.animation.gotoAndPlay("idle2");
        } else if (r < .8) {
            _armatureEyes.animation.gotoAndPlay("idle3");
        } else {
            _armatureEyes.animation.gotoAndPlay("idle4");
        }
    }

    public function stopAnimations():void {
        if (!isAnimated) return;
        isAnimated  = false;
        _armatureEyes.removeEventListener(dragonBones.events.AnimationEvent.LOOP_COMPLETE, armatureEventHandler);
        _armatureEyes.animation.gotoAndStop("idle", 0);
        WorldClock.clock.remove(_armatureEyes);
    }

    private function changeColorEyes(fact:StarlingFactory):void {
        var arr:Array = new Array('eye/eye_l', 'eye/eye_l_blue', 'eye/eye_l_brown', 'eye/eye_l_green', 'eye/eye_l_grey');
        var k:int = int(Math.random()*arr.length);
        var im:Image = fact.getTextureDisplay(arr[k]) as Image;
        var im2:Image = fact.getTextureDisplay(arr[k]) as Image;
        var b:Bone = _armatureEyes.getBone('eye_l');
        b.display.dispose();
        b.display = im;
        b = _armatureEyes.getBone('eye_r');
        b.display.dispose();
        b.display = im2;
    }
}
}
