/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.AreaObject;

import com.junkbyte.console.Cc;

import manager.ManagerFilters;
import manager.OwnEvent;

import mouse.ToolsModifier;

import starling.events.Event;

import starling.filters.BlurFilter;
import starling.utils.Color;

public class DecorTail extends AreaObject{
    public function DecorTail(_data:Object) {
        super(_data);
        createBuild();

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _source.releaseContDrag = true;
    }

    private function onHover():void {
        if (g.isActiveMapEditor) return;
        if (g.selectedBuild) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (g.selectedBuild) return;
            _source.filter = ManagerFilters.BUILD_STROKE;
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
                onOut();
                g.townArea.moveTailBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteTailBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (!g.selectedBuild) {
                g.directServer.addToInventory(_dbBuildingId, null);
                g.userInventory.addToDecorInventory(_dataBuild.id, _dbBuildingId);
                g.townArea.deleteTailBuild(this);
                g.event.dispatchEvent(new Event(OwnEvent.UPDATE_REPOSITORY));
            } else {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                }
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {

        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function onOut():void {
        if (g.isActiveMapEditor) return;
        _source.filter = null;
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

}
}
