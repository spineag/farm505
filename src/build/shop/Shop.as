package build.shop {
import build.AreaObject;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import hint.FlyMessage;

import manager.ManagerFilters;

import map.TownArea;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.utils.Color;

public class Shop extends AreaObject{


    public function Shop(_data:Object) {
        super(_data);
        useIsometricOnly = false;
        if (!_data) {
            Cc.error('no data for Shop');
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
    }

    private function onHover():void {
        if (g.selectedBuild) return;
        _source.filter = ManagerFilters.BUILD_STROKE;
        g.hint.showIt(_dataBuild.name);
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                onOut();
                if (g.isActiveMapEditor)
                    g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) return;
            _source.filter = null;
            if (g.user.level < _dataBuild.blockByLevel) {
                var p:Point = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,"Будет доступно на " + String(_dataBuild.blockByLevel) + ' уровне');
                return;
            }
            g.woShop.showIt();
            g.hint.hideIt();
        } else {
            Cc.error('Shop:: unknown g.toolsModifier.modifierType')
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
