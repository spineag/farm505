/**
 * Created by user on 12/26/16.
 */
package build.chestYellow {
import analytic.AnalyticManager;

import build.WorldObject;
import build.lockedLand.LockedLand;

import com.junkbyte.console.Cc;

import data.OwnEvent;

import dragonBones.Bone;

import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;

import manager.ManagerFilters;

import manager.hitArea.ManagerHitArea;

import mouse.ToolsModifier;

import starling.events.Event;

import windows.WindowsManager;

public class ChestYellow extends WorldObject{
    private var _curLockedLand:LockedLand;
    private var _isOnHover:Boolean;

    public function ChestYellow(data:Object) {
        super (data);
        createAnimatedBuild(onCreateBuild);
        _isOnHover = false;
    }

    private function onCreateBuild():void {
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _hitArea = g.managerHitArea.getHitArea(_source, 'chest', ManagerHitArea.TYPE_LOADED);
        _source.registerHitArea(_hitArea);
        WorldClock.clock.add(_armature);
    }

    public function setLockedLand(l:LockedLand):void {
        _curLockedLand = l;
    }

    public function get isAtLockedLand():Boolean {
        if (_curLockedLand) return true;
        else return false;
    }

    public function removeLockedLand():void {
        _curLockedLand = null;
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.isActiveMapEditor) {
                if (_curLockedLand) {
                    _curLockedLand.activateOnMapEditor(null,null, this);
                    _curLockedLand = null;
                }
            } else if (!_curLockedLand) {
                onOut();
                if (g.selectedBuild) {
                    if (g.selectedBuild == this) {
                        g.toolsModifier.onTouchEnded();
                    } else return;
                } else {
                    g.townArea.moveBuild(this);
                }
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            if (g.isActiveMapEditor) {
                if (_curLockedLand) {
                    _curLockedLand.activateOnMapEditor(null,null,this);
                    _curLockedLand = null;
                }
                onOut();
                g.directServer.ME_removeWild(_dbBuildingId, null);
                g.townArea.deleteBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (!g.allData.factory['chest_interface_yellow']) g.loadAnimation.load('animations_json/chest_interface_yellow', 'chest_interface_yellow', onLoad);
            else onLoad();
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function onLoad():void {
        g.directServer.getChestYellow(dataBuild.chestId,openCallback);
    }

    private function openCallback(ob:Object):void {
        g.windowsManager.openWindow(WindowsManager.WO_CHEST_YELLOW, deleteThisBuild,ob);
    }

    private function deleteThisBuild():void {
        g.townArea.deleteBuild(this);
        g.directServer.deleteUserWild(_dbBuildingId, null);
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        if (_isOnHover) return;
        super.onHover();
        var fEndOver:Function = function(e:Event=null):void {
            _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('idle');
        };
        _armature.addEventListener(EventObject.COMPLETE, fEndOver);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
        _armature.animation.gotoAndPlayByFrame('over');
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        _isOnHover = true;
    }

    override public function onOut():void {
        super.onOut();
        _isOnHover = false;
        if (_source) {
            _source.filter = null;
        }
    }


    override public function clearIt():void {
        WorldClock.clock.remove(_armature);
        super.clearIt();
    }
}
}
