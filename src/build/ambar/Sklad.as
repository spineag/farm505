/**
 * Created by andy on 5/28/15.
 */
package build.ambar {
import build.AreaObject;

import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;

import manager.ManagerFilters;

import map.TownArea;

import mouse.ToolsModifier;

import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.utils.Color;

import windows.ambar.WOAmbars;

public class Sklad extends AreaObject{
    private var _armature:Armature;
    private var _isOnHover:Boolean;

    public function Sklad(_data:Object) {
        super(_data);
        _isOnHover = false;
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
        _dbBuildingId = _data.dbId;
        _dataBuild.isFlip = _flip;
    }

    private function onHover():void {
        if (g.selectedBuild) return;
        if (!_isOnHover) {
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            var fEndOver:Function = function():void {
                _armature.removeEventListener(AnimationEvent.COMPLETE, fEndOver);
                _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndStop('idle', 0);
            };
            _armature.addEventListener(AnimationEvent.COMPLETE, fEndOver);
            _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlay('over');
            _isOnHover = true;
            g.hint.showIt(_dataBuild.name);
        }
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                onOut();
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            onOut();
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            onOut();
            if (!_source.wasGameContMoved) g.woAmbars.showItWithParams(WOAmbars.SKLAD);
        } else {
            Cc.error('Ambar:: unknown g.toolsModifier.modifierType')
        }

    }

    private function onOut():void {
        _isOnHover = false;
        _source.filter = null;
        g.hint.hideIt();
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

    override public function createBuild(isImageClicked:Boolean = true):void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _armature = g.allData.factory['sklad'].buildArmature("fabrica");
        _build.addChild(_armature.display as Sprite);
        WorldClock.clock.add(_armature);
        _defaultScale = 1;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        if (_flip) _build.scaleX = -_defaultScale;
        _source.addChild(_build);
    }

}
}
