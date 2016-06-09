/**
 * Created by user on 4/27/16.
 */
package build.chestBonus {
import build.WorldObject;
import com.junkbyte.console.Cc;
import dragonBones.animation.WorldClock;

import manager.ManagerFilters;

import mouse.ToolsModifier;
import tutorial.TutorialAction;
import windows.WindowsManager;

public class Chest extends WorldObject{
    private var _timerAnimation:int;
    private var _isOnHover:Boolean;

    public function Chest(data:Object) {
        super (data);
        _source.releaseContDrag = true;
        createAnimatedBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _hitArea = g.managerHitArea.getHitArea(_source, 'chest');
        _source.registerHitArea(_hitArea);
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

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (!_isOnHover) {
            makeOverAnimation();
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        }
        _isOnHover = true;
        g.hint.showIt(_dataBuild.name);
    }

    override public function onOut():void {
        if (_source) {
            super.onOut();
            _isOnHover = false;
            if (_source) _source.filter = null;
            g.hint.hideIt();
        }
    }
}
}
