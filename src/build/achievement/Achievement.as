/**
 * Created by user on 4/13/17.
 */
package build.achievement {
import build.WorldObject;

import com.junkbyte.console.Cc;

import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;

import manager.ManagerFilters;

import manager.hitArea.ManagerHitArea;

import media.SoundConst;

import mouse.ToolsModifier;

import starling.events.Event;

import utils.Utils;

import windows.WindowsManager;

public class Achievement extends WorldObject{
    private var _isHover:Boolean;

    public function Achievement(_data:Object) {
        super(_data);
        useIsometricOnly = false;
        if (!_data) {
            Cc.error('no data for Cafe');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Cafe');
            return;
        }
        createAnimatedBuild(onCreateBuild);
        _isHover = false;
        _source.releaseContDrag = true;
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndStopByFrame('idle');
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _hitArea = g.managerHitArea.getHitArea(_source, 'achievement', ManagerHitArea.TYPE_LOADED);
            _source.registerHitArea(_hitArea);
        }
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        if (g.managerAchievement.checkAchievement()) onTimer();
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) return;
        if (g.managerCutScenes.isCutScene) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                    onOut();
                }
            } else {
                if (g.isActiveMapEditor)
                    g.townArea.moveBuild(this);
            }
            return;
        }

        if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            g.windowsManager.openWindow(WindowsManager.WO_ACHIEVEMENT,null);
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    override public function onHover():void {
        if (_isHover) return;
        super.onHover();
        if (g.isAway) {
            g.hint.showIt(_dataBuild.name);
            return;
        }
        if (!_isHover) {
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            var fEndOver:Function = function(e:Event=null):void {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('idle');
            };
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('over');
        }
        _isHover = true;
        g.hint.showIt(_dataBuild.name);
    }

    override public function onOut():void {
        super.onOut();
        if (g.isAway) {
            g.hint.hideIt();
            return;
        }
        if (_source.filter) _source.filter.dispose();
        _source.filter = null;
        _isHover = false;
        g.hint.hideIt();
    }

    public function onTimer():void {
        var f1:Function = function ():void {
            var fEndOver:Function = function(e:Event=null):void {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('idle');
                onTimer();
            };
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('idle_1');
        };
        Utils.createDelay(int(Math.random() * 2) + 2,f1);
    }
}
}
