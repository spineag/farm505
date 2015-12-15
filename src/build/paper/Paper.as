/**
 * Created by user on 7/24/15.
 */
package build.paper {
import build.AreaObject;

import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;

import starling.utils.Color;

public class Paper extends AreaObject{
    public function Paper(data:Object) {
        super (data);
        useIsometricOnly = false;
        if (!data) {
            Cc.error('no data for Paper');
            g.woGameError.showIt();
            return;
        }
        createBuild();
//        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
//        }
        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;
    }

    private function onHover():void {
        _source.filter = ManagerFilters.RED_STROKE;
        g.hint.showIt(_dataBuild.name);
    }

    private function onOut():void {
        _source.filter = null;
        g.hint.hideIt();
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.isActiveMapEditor) {
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) return;
            g.woPaper.showItMenu();
            g.hint.hideIt();
            _source.filter = null;
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }
}
}
