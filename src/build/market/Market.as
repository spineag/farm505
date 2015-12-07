
package build.market {
import build.AreaObject;

import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import map.TownArea;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.utils.Color;

public class Market extends AreaObject{

    public function Market(_data:Object) {
        super(_data);
        useIsometricOnly = false;
        if (!_data) {
            Cc.error('no data for Market');
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
        g.hint.showIt(_dataBuild.name, "0");
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.isActiveMapEditor) {
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            if (g.isActiveMapEditor) {
                onOut();
                g.townArea.deleteBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            if (g.isActiveMapEditor) {
                releaseFlip();
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) return;
            g.woMarket.resetAll();
            if (g.isAway && g.visitedUser) {
                g.woMarket.curUser = g.visitedUser;
            } else {
                g.woMarket.curUser = g.user;
            }
            g.woMarket.showItWithParams();
            onOut();
            _source.filter = null;
        } else {
            Cc.error('Market:: unknown g.toolsModifier.modifierType')
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
