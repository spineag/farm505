/**
 * Created by user on 12/8/15.
 */
package build {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.factories.StarlingFactory;

import flash.events.Event;
import manager.EmbedAssets;
import starling.display.Sprite;

public class BuildingBuild {
    public var source:Sprite;
    private var factory:StarlingFactory;
    private var armature:Armature;
    private var armatureClip:Sprite;

    public function BuildingBuild(st:String) {
        source = new Sprite();
        factory = new StarlingFactory();
        var f1:Function = function (e:Event):void {
            armature = factory.buildArmature("cat");
            armatureClip = armature.display as Sprite;
            source.addChild(armatureClip);
            WorldClock.clock.add(armature);
            if (st == 'work') {
                workAnimation();
            } else {
                doneAnimation();
            }
        };
        factory.addEventListener(Event.COMPLETE, f1);
        factory.parseData(new EmbedAssets.BuildingBuild());
    }

    public function workAnimation():void {
        armature.animation.gotoAndPlay("work");
    }

    public function doneAnimation():void {
        armature.animation.gotoAndStop("done", 0);
    }

    public function deleteIt():void {
        while (source.numChildren) source.removeChildAt(0);
        armature.animation.dispose();
        armatureClip.dispose();
        armature.dispose();
        factory.dispose();
        armatureClip = null;
        armature = null;
        factory = null;
        source = null;
    }
}
}
