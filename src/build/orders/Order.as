/**
 * Created by user on 7/22/15.
 */
package build.orders {
import build.WorldObject;
import com.junkbyte.console.Cc;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;

import media.SoundConst;
import mouse.ToolsModifier;
import starling.display.Sprite;
import starling.events.Event;

import tutorial.helpers.HelperReason;
import windows.WindowsManager;
import windows.orderWindow.WOOrder;

public class Order extends WorldObject{
    private var _isOnHover:Boolean;
    private var _smallHero:SmallHeroAnimation;

    public function Order (data:Object) {
        super (data);
        _isOnHover = false;
        if (!data) {
            Cc.error('no data for Order');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Order');
            return;
        }
        createAnimatedBuild(onCreateBuild);
        _source.releaseContDrag = true;
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _hitArea = g.managerHitArea.getHitArea(_source, 'order_area', ManagerHitArea.TYPE_LOADED);
            _source.registerHitArea(_hitArea);
        }
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        if (!g.user.isOpenOrder && !g.isAway) {
            _stateBuild = STATE_UNACTIVE;
            _armature.animation.gotoAndStopByFrame('top');
        } else {
            _stateBuild = STATE_ACTIVE;
            _armature.addEventListener(EventObject.COMPLETE, makeAnimation);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, makeAnimation);
            makeAnimation();
            createSmallHero();
        }
    }

    private function createSmallHero():void {
        if (!g.isAway) {
            _smallHero = new SmallHeroAnimation(this);
            _smallHero.armature = g.allData.factory[_dataBuild.url].buildArmature('table');
        } else {
            var b:Slot = _armature.getSlot('table');
            if (b.display) b.display.dispose();
            var s:Sprite = new Sprite();
            b.display = s;
        }
    }
    
    public function animateSmallHero(v:Boolean):void {
        if (_smallHero) {
            _smallHero.animateIt(v);
        }
    }

    public function showSmallHero(needShow:Boolean):void {
        if (_smallHero) {
            _smallHero.needShowIt(needShow);
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.isAway) {
            g.hint.showIt(_dataBuild.name);
            return;
        }
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        if (!_isOnHover) {
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            if (_stateBuild == STATE_ACTIVE) {
                var fEndOver:Function = function (e:Event = null):void {
                    _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                    _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                    _armature.addEventListener(EventObject.COMPLETE, makeAnimation);
                    _armature.addEventListener(EventObject.LOOP_COMPLETE, makeAnimation);
                    makeAnimation();
                };
                _armature.removeEventListener(EventObject.COMPLETE, makeAnimation);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, makeAnimation);
                _armature.addEventListener(EventObject.COMPLETE, fEndOver);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('over');
            }
            g.hint.showIt(_dataBuild.name);
        }
        _isOnHover = true;
    }

    override public function onOut():void {
        super.onOut();
        if (g.isAway){
            g.hint.hideIt();
            return;
        }
        g.hint.hideIt();
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        if (_source.filter) _source.filter.dispose();
        _source.filter = null;
        _isOnHover = false;
    }

    private function onClick():void {
        var p:Point;
        if (_stateBuild == STATE_UNACTIVE) {
            if (g.user.level < 3) {
                g.soundManager.playSound(SoundConst.EMPTY_CLICK);
                p = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,"Будет доступно на 3 уровне");
            } else {
                _stateBuild = STATE_ACTIVE;
                _armature.addEventListener(EventObject.COMPLETE, onOpenOrder);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, onOpenOrder);
                _armature.animation.gotoAndPlayByFrame('top_l');
                hideArrow();
                g.directServer.openUserOrder(null);
            }
            return;
        }
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
                g.soundManager.playSound(SoundConst.EMPTY_CLICK);
                p = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,"Будет доступно на " + String(_dataBuild.blockByLevel) + ' уровне');
                return;
            }
            onOut();
            if (g.managerHelpers && g.managerHelpers.isActiveHelper && g.managerHelpers.activeReason.reason == HelperReason.REASON_ORDER) {
                g.lateAction.releaseOnTimer(.7, showBtnCellArrow);
            }
            hideArrow();
            g.windowsManager.openWindow(WindowsManager.WO_ORDERS, null);
            if (g.managerMiniScenes.isMiniScene && g.managerMiniScenes.isMiniSceneBuilding(this)) g.managerMiniScenes.checkMiniSceneCallback();
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function onOpenOrder(e:Event=null):void {
        if (g.managerMiniScenes.isMiniScene && g.user.level == 3) g.managerMiniScenes.checkMiniSceneCallback();
        _armature.removeEventListener(EventObject.COMPLETE, onOpenOrder);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onOpenOrder);
        _armature.addEventListener(EventObject.COMPLETE, makeAnimation);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, makeAnimation);
        makeAnimation();
        createSmallHero();
        animateSmallHero(true);
    }
    
    private function showBtnCellArrow():void {
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_ORDERS) {
            (g.windowsManager.currentWindow as WOOrder).showBtnSellArrow();
        }
    }

    override public function clearIt():void {
        onOut();
        if (_smallHero) {
            _smallHero.deleteIt();
            _smallHero = null;
        }
        _source.touchable = false;
        _armature.removeEventListener(EventObject.COMPLETE, makeAnimation);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, makeAnimation);
        WorldClock.clock.remove(_armature);
//        _armature.dispose();
        super.clearIt();
    }

    private function makeAnimation(e:Event=null):void {
        var k:Number = Math.random();
        if (k < .2)
            _armature.animation.gotoAndPlayByFrame('idle');
        else if (k < .4)
           _armature.animation.gotoAndPlayByFrame('idle2');
        else if (k < .6)
            _armature.animation.gotoAndPlayByFrame('idle3');
        else if (k < .8)
            _armature.animation.gotoAndPlayByFrame('idle4');
        else
            _armature.animation.gotoAndPlayByFrame('idle5');
    }
}
}
