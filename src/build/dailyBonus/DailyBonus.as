/**
 * Created by user on 7/23/15.
 */
package build.dailyBonus {
import build.AreaObject;

import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;

import flash.geom.Point;

import hint.FlyMessage;

import manager.ManagerFilters;

import mouse.ToolsModifier;

import starling.display.Sprite;

import starling.filters.BlurFilter;

import starling.utils.Color;

import windows.WindowsManager;

public class DailyBonus extends AreaObject{
    private var _armature:Armature;
    private var _isOnHover:Boolean;

    public function DailyBonus(data:Object) {
        super (data);
        _isOnHover = false;
        useIsometricOnly = false;
        if (!data) {
            Cc.error('no data for DailyBonus');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for DailyBonus');
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
        _armature = g.allData.factory['daily_bonus'].buildArmature("cat");
        _build.addChild(_armature.display as Sprite);
        WorldClock.clock.add(_armature);
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
        if (!_isOnHover) {
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            var fEndOver:Function = function():void {
                _armature.removeEventListener(AnimationEvent.COMPLETE, fEndOver);
                _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndStop('idle', 0);
                showLights();

            };
            _armature.addEventListener(AnimationEvent.COMPLETE, fEndOver);
            _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlay('idle_2');
        }
        _isOnHover = true;
        g.hint.showIt(_dataBuild.name);
    }

    private function onOut():void {
        _source.filter = null;
        _isOnHover = false;
        g.hint.hideIt();
        if (g.managerDailyBonus.count > 0) hideLights();
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) return;
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
            if (!_source.wasGameContMoved) {
                if (g.user.level < _dataBuild.blockByLevel) {
                    var p:Point = new Point(_source.x, _source.y - 100);
                    p = _source.parent.localToGlobal(p);
                    new FlyMessage(p,"Будет доступно на " + String(_dataBuild.blockByLevel) + ' уровне');
                    return;
                }
                onOut();
                g.woDailyBonus.showItMenu();
            }
            g.hint.hideIt();
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    override public function clearIt():void {
        onOut();
        WorldClock.clock.remove(_armature);
        _armature.dispose();
        _source.touchable = false;
        super.clearIt();
    }

    public function showLights():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlay('work');
    }

    public function hideLights():void {
        _armature.animation.gotoAndStop('idle', 0);
        WorldClock.clock.remove(_armature);
    }
}
}
