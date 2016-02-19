
package build.market {
import build.AreaObject;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import hint.FlyMessage;

import manager.ManagerFilters;

import map.TownArea;

import mouse.ToolsModifier;

import starling.display.Image;

import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.MCScaler;

public class Market extends AreaObject{
    private var _imCoins:Image;
    private var _imItemOne:Image;
    private var _imItemTwo:Image;
    private var _arrItem:Array;
    private var _isOnHover:Boolean;
    public function Market(_data:Object) {
        super(_data);
        _isOnHover = false;
        useIsometricOnly = false;
        if (!_data) {
            Cc.error('no data for Market');
            g.woGameError.showIt();
            return;
        }
        createBuild();

            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _imCoins = new Image(g.allData.atlas['interfaceAtlas'].getTexture('market_l1'));
        _imCoins.x = 19;
        _imCoins.y = 7;
        MCScaler.scale(_imCoins,55,55);
        _imItemOne = new Image(g.allData.atlas['interfaceAtlas'].getTexture('market_l2'));
        _imItemOne.x = -12;
        _imItemOne.y = -14;
        MCScaler.scale(_imItemOne,55,55);
        _imItemTwo = new Image(g.allData.atlas['interfaceAtlas'].getTexture('market_l3'));
        _imItemTwo.x = -45;
        _imItemTwo.y = -27;
        MCScaler.scale(_imItemTwo,55,55);
        _source.addChild(_imItemTwo);
        _source.addChild(_imItemOne);
        _source.addChild(_imCoins);
        _imItemTwo.visible = false;
        _imItemOne.visible = false;
        _imCoins.visible = false;
        _arrItem = [];
        marketState();
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
            g.woMarket.resetAll();
            if (g.isAway && g.visitedUser) {
                g.woMarket.showItPapper(g.visitedUser);
            } else {
                g.woMarket.curUser = g.user;
                g.woMarket.showItWithParams(fillIt);
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

        if (coins > 0) {
            _imCoins.visible = true;
        } else {
            _imCoins.visible = false;
        }
        if (res > 0) {
            _imItemOne.visible = true;
            _imItemTwo.visible = true;
        } else {
            _imItemOne.visible = false;
            _imItemTwo.visible = false;
        }
    }
}
}
