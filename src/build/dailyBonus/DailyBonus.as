/**
 * Created by user on 7/23/15.
 */
package build.dailyBonus {
import build.WorldObject;
import com.junkbyte.console.Cc;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import mouse.ToolsModifier;
import starling.display.Sprite;
import windows.WindowsManager;

public class DailyBonus extends WorldObject{
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
        createAnimatedBuild(onCreateBuild);
        _source.releaseContDrag = true;
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndStop('idle', 0);
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
            _hitArea = g.managerHitArea.getHitArea(_source, 'dailyBonusBuild');
            _source.registerHitArea(_hitArea);
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
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
            hoverIdle();
        }
        _isOnHover = true;
        g.hint.showIt(_dataBuild.name);
    }

    override public function onOut():void {
        super.onOut();
        _source.filter = null;
        _isOnHover = false;
        g.hint.hideIt();
        hoverout();
        g.managerDailyBonus.checkDailyBonusStateBuilding();
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) return;
        if (g.managerCutScenes.isCutScene) return;
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
                g.windowsManager.openWindow(WindowsManager.WO_DAILY_BONUS, null);
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
        if (_armature) _armature.animation.gotoAndPlay('work');
    }

    private function hoverIdle():void {
        WorldClock.clock.add(_armature);
        if (_armature) _armature.animation.gotoAndPlay('idle_2');
    }

    private function hoverout():void {
        if (_armature) _armature.animation.gotoAndStop('idle', 0);
        WorldClock.clock.remove(_armature);
    }

    public function hideLights():void {
        if (_armature)  _armature.animation.gotoAndStop('idle', 0);
        WorldClock.clock.remove(_armature);
    }


}
}
