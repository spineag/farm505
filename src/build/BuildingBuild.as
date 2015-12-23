/**
 * Created by user on 12/8/15.
 */
package build {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
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

    public function BuildingBuild(st:String) {
        source = new Sprite();
        armature = g.allData.factory['buildingBuild'].buildArmature("cat");
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
        armature.animation.dispose();
        armatureClip.dispose();
        armature.dispose();
        armatureClip = null;
        armature = null;
        source = null;
    }
}
}
