/**
 * Created by user on 7/23/15.
 */
package build.dailyBonus {
import build.AreaObject;

import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;

import manager.ManagerFilters;

import mouse.ToolsModifier;

import starling.display.Sprite;

import starling.filters.BlurFilter;

import starling.utils.Color;

public class DailyBonus extends AreaObject{
    private var _armature:Armature;

    public function DailyBonus(data:Object) {
        super (data);
        useIsometricOnly = false;
        if (!data) {
            Cc.error('no data for DailyBonus');
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

    override public function createBuild(isImageClicked:Boolean = true):void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _armature = g.allData.factory[_dataBuild.image].buildArmature("building");
        _build.addChild(_armature.display as Sprite);
        _defaultScale = 1;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        if (_flip) _build.scaleX = -_defaultScale;
        _source.addChild(_build);
        _armature.animation.gotoAndStop('idle', 0);
    }

    private function onHover():void {
        if (g.selectedBuild) return;
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlay('work');
        g.hint.showIt(_dataBuild.name);
    }

    private function onOut():void {
        WorldClock.clock.remove(_armature);
        _armature.animation.gotoAndStop('idle', 0);
        g.hint.hideIt();
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                    onOut();
                }
            } else {
                if (g.isActiveMapEditor)
                    g.townArea.moveBuild(this);
            }
            return;
        }

        if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            _source.filter = null;
            if (!_source.wasGameContMoved) g.woDailyBonus.showItMenu();
            g.hint.hideIt();
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
