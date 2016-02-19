/**
 * Created by user on 7/24/15.
 */
package build.paper {
import build.AreaObject;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import hint.FlyMessage;

import manager.ManagerFilters;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;

import starling.utils.Color;

public class Paper extends AreaObject{
    private var _isOnHover:Boolean;
    public function Paper(data:Object) {
        super (data);
        useIsometricOnly = false;
        _isOnHover = false;
        if (!data) {
            Cc.error('no data for Paper');
            g.woGameError.showIt();
            return;
        }
        createBuild();
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        _source.releaseContDrag = true;
    }

    private function onHover():void {
        if (g.selectedBuild) return;
        if (!_isOnHover) {
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            makeOverAnimation();
        }
        _isOnHover = true;
        g.hint.showIt(_dataBuild.name);
    }

    private function onOut():void {
        _isOnHover = false;
        _source.filter = null;
        g.hint.hideIt();
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                if (g.isActiveMapEditor)
                    g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            onOut();
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) {
                onOut();
                return;
            }
            if (g.user.level < _dataBuild.blockByLevel) {
                var p:Point = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,"Будет доступно на " + String(_dataBuild.blockByLevel) + ' уровне');
                return;
            }
            g.woPaper.showItMenu();
            onOut();
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
