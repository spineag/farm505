/**
 * Created by andy on 5/28/15.
 */
package build.ambar {
import build.AreaObject;

import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import map.TownArea;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.utils.Color;

import windows.ambar.WOAmbars;

public class Sklad extends AreaObject{
    public function Sklad(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Sklad');
            g.woGameError.showIt();
            return;
        }
        createBuild();

        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;
    }

    private function onHover():void {
        _source.filter = ManagerFilters.RED_STROKE;
        g.hint.showIt(_dataBuild.name);
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            g.townArea.moveBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            onOut();
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            _source.filter = null;
            if (!_source.wasGameContMoved) g.woAmbars.showItWithParams(WOAmbars.SKLAD);
            onOut();
        } else {
            Cc.error('Ambar:: unknown g.toolsModifier.modifierType')
        }

    }

    private function onOut():void {
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
