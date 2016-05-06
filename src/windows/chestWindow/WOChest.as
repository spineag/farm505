/**
 * Created by user on 4/27/16.
 */
package windows.chestWindow {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import starling.display.Sprite;
import starling.events.Event;

import windows.WindowMain;

public class WOChest  extends WindowMain{
    private var _armature:Armature;
    private var _woChestItem:WOChestItem;
    private var _woChestItemsTutorial:WOChestItemsTutorial;

    public function WOChest() {
        super();
        _armature = g.allData.factory['chest_interface'].buildArmature("box");
        _source.addChild(_armature.display as Sprite);
        WorldClock.clock.add(_armature);
        _armature.display.scaleX =_armature.display.scaleY = .6;
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        super.hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
        var fEndOver:Function = function():void {
            _armature.removeEventListener(AnimationEvent.COMPLETE, fEndOver);
            _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlay('item',0);
            if (g.managerChest.getCount <= 2) {
                if (g.managerTutorial.isTutorial) _woChestItemsTutorial = new WOChestItemsTutorial(_source, hideItTutorial);
                    else  _woChestItem = new WOChestItem(g.managerChest.dataPriseChest, _source, hideIt);
            } else createExitButton(onClickExit);  // need remake logic, make this checking at the Chest class
        };
        _armature.addEventListener(AnimationEvent.COMPLETE, fEndOver);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
        _armature.animation.gotoAndPlay('idle_1',0);
    }

    override public function hideIt():void {
        _armature.animation.gotoAndPlay('idle_2',0);
        super.hideIt();
    }

    private function hideItTutorial():void {
        g.managerTutorial.checkTutorialCallback();
        hideIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_armature.display as Sprite);
        WorldClock.clock.remove(_armature);
        _armature.dispose();
        _armature = null;
        _woChestItem = null;
        super.deleteIt();
    }
}
}
