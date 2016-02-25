/**
 * Created by user on 12/8/15.
 */
package build {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import dragonBones.factories.StarlingFactory;

import flash.events.Event;
import manager.EmbedAssets;
import manager.Vars;

import starling.display.Sprite;

public class BuildingBuild {
    public var source:Sprite;
    private var armature:Armature;
    private var armatureClip:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _isOverAnim:Boolean;

    public function BuildingBuild(st:String) {
        _isOverAnim = false;
        source = new Sprite();
        armature = g.allData.factory['buildingBuild'].buildArmature("building");
        armatureClip = armature.display as Sprite;
        source.addChild(armatureClip);
        WorldClock.clock.add(armature);
        if (st == 'work') {
            workAnimation();
        } else {
            doneAnimation();
        }
    }

    public function workAnimation():void {
        armature.animation.gotoAndPlay("work");
    }

    public function doneAnimation():void {
        armature.animation.gotoAndStop("done", 0);
    }

    public function deleteIt():void {
        WorldClock.clock.remove(armature);
        while (source.numChildren) source.removeChildAt(0);
        armatureClip.dispose();
        armature.dispose();
        armatureClip = null;
        armature = null;
        source = null;
    }

    public function overItFoundation():void {
        if (armature && !_isOverAnim) {
            _isOverAnim = true;
            armature.addEventListener(AnimationEvent.COMPLETE, onOverFoundation);
            armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onOverFoundation);
            armature.animation.gotoAndPlay('over2');
        }
    }

    private function onOverFoundation(e:AnimationEvent):void {
        armature.removeEventListener(AnimationEvent.COMPLETE, onOverFoundation);
        armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onOverFoundation);
        _isOverAnim = false;
        workAnimation();
    }

    public function overItDone():void {
        if (armature && !_isOverAnim) {
            _isOverAnim = true;
            armature.addEventListener(AnimationEvent.COMPLETE, onOverDone);
            armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onOverDone);
            armature.animation.gotoAndPlay('over');
        }
    }

    private function onOverDone(e:AnimationEvent):void {
        armature.removeEventListener(AnimationEvent.COMPLETE, onOverDone);
        armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onOverDone);
        _isOverAnim = false;
        doneAnimation();
    }
}
}
