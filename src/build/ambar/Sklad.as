/**
 * Created by andy on 5/28/15.
 */
package build.ambar {
import build.WorldObject;
import com.junkbyte.console.Cc;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;

import mouse.ToolsModifier;

import starling.events.Event;

import windows.WindowsManager;
import windows.ambar.WOAmbars;

public class Sklad extends WorldObject{
    private var _isOnHover:Boolean;

    public function Sklad(_data:Object) {
        super(_data);
        _isOnHover = false;
        if (!_data) {
            Cc.error('no data for Sklad');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Sklad');
            return;
        }
        _dbBuildingId = _dataBuild.dbId;
        createAnimatedBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _hitArea = g.managerHitArea.getHitArea(_source, 'sklad', ManagerHitArea.TYPE_LOADED);
            _source.registerHitArea(_hitArea);
            WorldClock.clock.add(_armature);
        }
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;

        _source.releaseContDrag = true;
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.isAway) {
            g.hint.showIt(_dataBuild.name);
            return;
        }
        if (!_isOnHover) {
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            var fEndOver:Function = function(e:Event=null):void {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndStopByFrame('idle');
            };
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('over');
            _isOnHover = true;
            g.hint.showIt(_dataBuild.name,'sklad');
        }
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) return;
        if (g.managerCutScenes.isCutScene) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                onOut();
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            onOut();
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            onOut();
            g.user.visitAmbar = false;
            if (!_source.wasGameContMoved) g.windowsManager.openWindow(WindowsManager.WO_AMBAR, null, WOAmbars.SKLAD);
        } else {
            Cc.error('Ambar:: unknown g.toolsModifier.modifierType')
        }

    }

    override public function onOut():void {
        super.onOut();
        if (g.isAway) {
            g.hint.hideIt();
            return;
        }
        _isOnHover = false;
        if (_source.filter) _source.filter.dispose();
        _source.filter = null;
        g.hint.hideIt();
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

}
}
