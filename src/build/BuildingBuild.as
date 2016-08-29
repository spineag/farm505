/**
 * Created by user on 12/8/15.
 */
package build {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import manager.Vars;

import starling.display.Sprite;
import starling.events.Event;

public class BuildingBuild {
    public var source:Sprite;
    private var armature:Armature;
    private var armatureClip:StarlingArmatureDisplay;
    private var g:Vars = Vars.getInstance();
    private var _isOverAnim:Boolean;

    public function BuildingBuild(st:String) {
        _isOverAnim = false;
        source = new Sprite();
        armature = g.allData.factory['buildingBuild'].buildArmature("building");
        armatureClip = armature.display as StarlingArmatureDisplay;
        source.addChild(armatureClip);
        WorldClock.clock.add(armature);
        if (st == 'work') {
            workAnimation();
        } else {
            doneAnimation();
        }
    }

    public function workAnimation():void {
        armature.animation.gotoAndPlayByFrame("work");
    }

    public function doneAnimation():void {
        armature.animation.stop("done");
    }

    public function deleteIt():void {
        WorldClock.clock.remove(armature);
        while (source.numChildren) source.removeChildAt(0);
//        armatureClip.dispose();
//        armature.dispose();
        armatureClip = null;
        armature = null;
        source = null;
    }

    public function overItFoundation():void {
        if (armature && !_isOverAnim) {
            _isOverAnim = true;
            armature.addEventListener(EventObject.COMPLETE, onOverFoundation);
            armature.addEventListener(EventObject.LOOP_COMPLETE, onOverFoundation);
            armature.animation.gotoAndPlayByFrame('over2');
        }
    }

    private function onOverFoundation(e:Event=null):void {
        armature.removeEventListener(EventObject.COMPLETE, onOverFoundation);
        armature.removeEventListener(EventObject.LOOP_COMPLETE, onOverFoundation);
        _isOverAnim = false;
        workAnimation();
    }

    public function overItDone():void {
        if (armature && !_isOverAnim) {
            _isOverAnim = true;
            armature.addEventListener(EventObject.COMPLETE, onOverDone);
            armature.addEventListener(EventObject.LOOP_COMPLETE, onOverDone);
            armature.animation.gotoAndPlayByFrame('over');
        }
    }

    private function onOverDone(e:Event=null):void {
        armature.removeEventListener(EventObject.COMPLETE, onOverDone);
        armature.removeEventListener(EventObject.LOOP_COMPLETE, onOverDone);
        _isOverAnim = false;
        doneAnimation();
    }
}
}
