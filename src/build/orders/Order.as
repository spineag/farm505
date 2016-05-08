/**
 * Created by user on 7/22/15.
 */
package build.orders {
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

public class Order extends WorldObject{
    private var _armature:Armature;
    private var _isOnHover:Boolean;

    public function Order (data:Object) {
        super (data);
        _isOnHover = false;
        if (!data) {
            Cc.error('no data for Order');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Order');
            return;
        }
        createOrderBuild();
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
            _source.releaseContDrag = true;
            _hitArea = g.managerHitArea.getHitArea(_source, 'orderBuild');
            _source.registerHitArea(_hitArea);
        }
    }

    public function createOrderBuild():void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _armature = g.allData.factory['order'].buildArmature("cat");
        _build.addChild(_armature.display as Sprite);
        _defaultScale = 1;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        if (_flip) _build.scaleX = -_defaultScale;
        _source.addChild(_build);
        WorldClock.clock.add(_armature);
        _armature.addEventListener(AnimationEvent.COMPLETE, makeAnimation);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, makeAnimation);
        makeAnimation();
    }

    private function onHover():void {
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        if (g.selectedBuild) return;
        if (!_isOnHover) {
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            var fEndOver:Function = function():void {
                _armature.removeEventListener(AnimationEvent.COMPLETE, fEndOver);
                _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
                _armature.addEventListener(AnimationEvent.COMPLETE, makeAnimation);
                _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, makeAnimation);
                makeAnimation();
            };
            _armature.removeEventListener(AnimationEvent.COMPLETE, makeAnimation);
            _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, makeAnimation);
            _armature.addEventListener(AnimationEvent.COMPLETE, fEndOver);
            _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlay('over');
            g.hint.showIt(_dataBuild.name);
        }
        _isOnHover = true;
    }

    private function onOut():void {
        g.hint.hideIt();
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        _source.filter = null;
        _isOnHover = false;
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.isTutorialBuilding(this)) {
                g.managerTutorial.checkTutorialCallback();
            } else return;
        }
        if (g.managerCutScenes.isCutScene) return;
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
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) return;
            if (g.user.level < _dataBuild.blockByLevel) {
                var p:Point = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,"Будет доступно на " + String(_dataBuild.blockByLevel) + ' уровне');
                return;
            }
            onOut();
            g.windowsManager.openWindow(WindowsManager.WO_ORDERS, null);
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        _armature.removeEventListener(AnimationEvent.COMPLETE, makeAnimation);
        _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, makeAnimation);
        WorldClock.clock.remove(_armature);
        _armature.dispose();
        super.clearIt();
    }

    private function makeAnimation(e:AnimationEvent=null):void {
        var k:Number = Math.random();
        if (k < .2)
            _armature.animation.gotoAndPlay('idle');
        else if (k < .4)
           _armature.animation.gotoAndPlay('idle2');
        else if (k < .6)
            _armature.animation.gotoAndPlay('idle3');
        else if (k < .8)
            _armature.animation.gotoAndPlay('idle4');
        else
            _armature.animation.gotoAndPlay('idle5');
    }
}
}
