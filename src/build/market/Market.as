
package build.market {
import build.WorldObject;
import com.junkbyte.console.Cc;
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import mouse.ToolsModifier;
import starling.display.Image;
import starling.display.Sprite;
import tutorial.TutorialAction;
import windows.WindowsManager;

public class Market extends WorldObject{
    private var _arrItem:Array;
    private var _isOnHover:Boolean;
    private var _fruits1:Bone;
    private var _fruits2:Bone;
    private var _coins:Bone;
    public function Market(_data:Object) {
        super(_data);
        _isOnHover = false;
        useIsometricOnly = false;
        if (!_data) {
            Cc.error('no data for Market');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Market');
            return;
        }
        createAnimatedBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndStop('work', 0);
        _fruits1 = _armature.getBone('fr');
        _fruits2 = _armature.getBone('fr2');
        _coins = _armature.getBone('coins');
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _arrItem = [];
        marketState();
        _hitArea = g.managerHitArea.getHitArea(_source, 'marketBuild');
        _source.registerHitArea(_hitArea);
    }

    private function onHover():void {
        if (g.selectedBuild) return;
        if (_isOnHover)  return;
        var fEndOver:Function = function():void {
            _armature.removeEventListener(AnimationEvent.COMPLETE, fEndOver);
            _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
//            fillIt();
        };
        _armature.addEventListener(AnimationEvent.COMPLETE, fEndOver);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
        _armature.animation.gotoAndPlay('idle_2');
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        _isOnHover = true;
        g.hint.showIt(_dataBuild.name);

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
            var isNotAway:int = 1;
            if (g.isAway) isNotAway = 0;
            if (g.user.level < int(_dataBuild.blockByLevel) + isNotAway) {
                var p:Point = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,"Будет доступно на " + String(int(_dataBuild.blockByLevel) + isNotAway) + ' уровне');
                return;
            }
            if (g.isAway && g.visitedUser) {
                if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.VISIT_NEIGHBOR) return;
                g.windowsManager.openWindow(WindowsManager.WO_MARKET, null, g.visitedUser);
                if (g.managerTutorial.isTutorial) g.managerTutorial.checkTutorialCallback();
            } else {
                g.windowsManager.openWindow(WindowsManager.WO_MARKET, fillIt, g.user);
            }

            onOut();
        } else {
            Cc.error('Market:: unknown g.toolsModifier.modifierType')
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

    public function marketState():void {
        g.directServer.getUserMarketItem(g.user.userSocialId,fillIt);
    }

    private function fillIt():void {
        _arrItem = g.user.marketItems;
        var coins:int = 0;
        var res:int = 0;
        for (var i:int = 0; i < _arrItem.length; i++) {
            if (g.user.marketItems[i].buyerId != '0') {
                coins++;
            } else {
                res ++;
            }
        }
        var b:Bone;
        var im:Image;
        _armature.animation.gotoAndStop('work', 0);
        if (coins <= 0) {
            b = _armature.getBone('coins');
            if (b != null) _armature.removeBone(b,true);
//            b.display.visible = false;
//            _armature.getBones(false);

        } else {
//            b = _armature.getBone('coins');
            _armature.addBone(_coins);
        }
        if (res <= 0) {
                b = _armature.getBone('fr');
            if (b != null) {
                _armature.removeBone(b,true);

                b = _armature.getBone('fr2');
                _armature.removeBone(b,true);
            }
//            b.display.visible = false;
//            b = _armature.getBone('fr2');
//            b.display.dispose();
//            b.display.visible = false;

        } else {
            _armature.addBone(_fruits1);
            _armature.addBone(_fruits2);
        }
    }
}
}
