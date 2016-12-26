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

import manager.ManagerFilters;

import manager.hitArea.ManagerHitArea;

import mouse.ToolsModifier;

import starling.events.Event;

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
        g.directServer.deleteUserWild(_dbBuildingId, null);
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {

            if (g.isActiveMapEditor) {
                if (_curLockedLand) {
                    _curLockedLand.activateOnMapEditor(null,null, this);
                    _curLockedLand = null;
                }
                onOut();
                g.townArea.moveBuild(this);
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
            onOut();
            releaseFlip();
            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {

        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function deleteThisBuild():void {
       g.townArea.deleteBuild(this);
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


    override public function clearIt():void {
        WorldClock.clock.remove(_armature);
        super.clearIt();
    }
}
}
