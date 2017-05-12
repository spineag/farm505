/**
 * Created by user on 4/27/16.
 */
package build.chestBonus {
import build.WorldObject;
import com.junkbyte.console.Cc;
import dragonBones.animation.WorldClock;

import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;

import mouse.ToolsModifier;
import tutorial.TutorialAction;

import utils.SimpleArrow;

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
        _hitArea = g.managerHitArea.getHitArea(_source, 'chest', ManagerHitArea.TYPE_LOADED);
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
        _timerAnimation = int(5*Math.random());
        g.gameDispatcher.addToTimer(timerAnimation);
    }

    private function timerAnimation():void {
        _timerAnimation --;
        if (_timerAnimation <=0) {
            if(_armature == null) return;
            _armature.animation.gotoAndPlayByFrame('idle',0);
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
            if (_source) {
                if (_source.filter) _source.filter.dispose();
                _source.filter = null;
            }
            g.hint.hideIt();
        }
    }

    override  public function showArrow(t:Number = 0, id:int = 0):void {
        super.hideArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
        _arrow.animateAtPosition(0, -34 * g.scaleFactor);
        if (t>0) _arrow.activateTimer(t, super.hideArrow);
    }
    
    override public function clearIt():void {
        WorldClock.clock.remove(_armature);
        g.gameDispatcher.removeFromTimer(timerAnimation);
        super.clearIt();
    }
}
}
