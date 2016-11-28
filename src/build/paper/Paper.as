/**
 * Created by user on 7/24/15.
 */
package build.paper {
import build.WorldObject;
import com.junkbyte.console.Cc;
import dragonBones.animation.WorldClock;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;

import media.SoundConst;
import mouse.ToolsModifier;
import windows.WindowsManager;

public class Paper extends WorldObject{
    private var _isOnHover:Boolean;

    public function Paper(data:Object) {
        super (data);
        useIsometricOnly = false;
        _isOnHover = false;
        if (!data) {
            Cc.error('no data for Paper');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Papper');
            return;
        }
        createAnimatedBuild(onCreateBuild);
        _source.releaseContDrag = true;
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndStopByFrame('idle');
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _hitArea = g.managerHitArea.getHitArea(_source, 'newspaper', ManagerHitArea.TYPE_LOADED);
        _source.registerHitArea(_hitArea);
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (!_isOnHover) {
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        }
        if (_isOnHover) return;
        _armature.animation.gotoAndPlayByFrame('idle_2');
        _isOnHover = true;
        g.hint.showIt(_dataBuild.name);
    }

    override public function onOut():void {
        super.onOut();
        _isOnHover = false;
        if (_source.filter) _source.filter.dispose();
        _source.filter = null;
        g.hint.hideIt();
    }

    private function onClick():void {
        if (g.managerTutorial.isBlockForTutorial) return;
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
                g.soundManager.playSound(SoundConst.EMPTY_CLICK);
                var p:Point = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,"Будет доступно на " + String(_dataBuild.blockByLevel) + ' уровне');
                return;
            }
            g.windowsManager.openWindow(WindowsManager.WO_PAPPER, null);
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
