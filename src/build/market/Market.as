
package build.market {


import build.AreaObject;

import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.Bone;

import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;

import flash.geom.Point;

import hint.FlyMessage;

import manager.ManagerFilters;

import map.TownArea;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.utils.Color;

import tutorial.TutorialAction;

import utils.MCScaler;

import windows.WindowsManager;

public class Market extends AreaObject{
    private var _arrItem:Array;
    private var _isOnHover:Boolean;
    private var _armature:Armature;
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
        createBuild();

            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _arrItem = [];
        marketState();
    }

    override public function createBuild(isImageClicked:Boolean = true):void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _armature = g.allData.factory['market'].buildArmature('road_shop');
        _build.addChild(_armature.display as Sprite);
        WorldClock.clock.add(_armature);
        _defaultScale = 1;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        if (_flip) _build.scaleX = -_defaultScale;
        _source.addChild(_build);
        _armature.animation.gotoAndStop('work', 0);
        _fruits1 = _armature.getBone('fr');
        _fruits2 = _armature.getBone('fr2');
        _coins = _armature.getBone('coins');
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
            if (g.user.level < _dataBuild.blockByLevel) {
                var p:Point = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,"Будет доступно на " + String(_dataBuild.blockByLevel) + ' уровне');
                return;
            }
            if (g.isAway && g.visitedUser) {
                g.windowsManager.openWindow(WindowsManager.WO_MARKET, null, g.visitedUser);
                if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.VISIT_NEIGHBOR) {
                    g.managerTutorial.checkTutorialCallback();
                }
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
