/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.WorldObject;

import com.junkbyte.console.Cc;

import manager.ManagerFilters;
import data.OwnEvent;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.events.Event;

import windows.WindowsManager;

// для забора как в Птичем Городке
public class DecorFence extends WorldObject {
    public function DecorFence(_data:Object) {
        super(_data);
        createAtlasBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _source.hoverCallback = onHover;
            _source.outCallback = onOut;
            _hitArea = g.managerHitArea.getHitArea(_source, 'decorFence' + _dataBuild.image);
            _source.registerHitArea(_hitArea);
        }
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
                releaseFlip();
                g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (!g.selectedBuild) {
                g.directServer.addToInventory(_dbBuildingId, null);
                g.userInventory.addToDecorInventory(_dataBuild.id, _dbBuildingId);
                g.townArea.deleteBuild(this);
                g.event.dispatchEvent(new Event(OwnEvent.UPDATE_REPOSITORY));
            } else {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                }
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.PLANT_TREES;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            // ничего не делаем
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    override public function clearIt():void {
        _source.touchable = false;
        super.clearIt();
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        _source.filter = ManagerFilters.BUILD_STROKE;
    }

    override public function onOut():void {
        super.onOut();
        if (g.isActiveMapEditor) return;
        _source.filter = null;
    }
}
}
