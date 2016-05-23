/**
 * Created by user on 4/27/16.
 */
package build.chestBonus {
import build.WorldObject;

import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import mouse.ToolsModifier;
import starling.display.Sprite;

import tutorial.TutorialAction;

import windows.WindowsManager;

public class Chest extends WorldObject{
    private var _timerAnimation:int;

    public function Chest(data:Object) {
        super (data);
        _source.endClickCallback = onClick;
        _source.releaseContDrag = true;
        createBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        animation();
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction != TutorialAction.TAKE_CHEST) return;
            if (!g.managerTutorial.isTutorialBuilding(this)) return;
        }
        if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES
                || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            try {
                g.windowsManager.openWindow(WindowsManager.WO_CHEST, deleteThisBuild);
                if (g.managerTutorial.isTutorial && g.managerTutorial.isTutorialBuilding(this)) {
                    g.managerTutorial.checkTutorialCallback();
                }
            } catch (e:Error) {
                Cc.error('Chest onClick error: ' + e.message);
            }
        }
    }

    private function deleteThisBuild():void {
        if (g.isAway) g.townArea.deleteAwayBuild(this);
        else g.townArea.deleteBuild(this);
    }

    private function animation():void {
        _timerAnimation = 5*Math.random();
        g.gameDispatcher.addToTimer(timerAnimation);
    }

    private function timerAnimation():void {
        _timerAnimation --;
        if (_timerAnimation <=0) {
            if(_armature == null) return;
            _armature.animation.gotoAndPlay('idle',0);
            g.gameDispatcher.removeFromTimer(timerAnimation);
            animation();
        }
    }
}
}
