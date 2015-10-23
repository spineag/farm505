package build.cave {
import build.AreaObject;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import com.junkbyte.console.Cc;

import data.BuildType;

import data.DataMoney;

import flash.geom.Point;

import hint.FlyMessage;


import mouse.ToolsModifier;

import resourceItem.CraftItem;

import resourceItem.RawItem;

import resourceItem.ResourceItem;

import starling.display.Image;

import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.textures.Texture;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import windows.cave.WOBuyCave;


public class Cave extends AreaObject{
    private var _woBuy:WOBuyCave;
    private var _isOnHover:Boolean;
    private var _count:int;
    private var _arrCraftItems:Array;

    public function Cave(data:Object) {
        super (data);
        if (!data) {
            Cc.error('no data for Cave');
            g.woGameError.showIt();
            return;
        }
        checkCaveState();
//        createIsoView();

        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;
        if (!g.isAway) {
            _woBuy = new WOBuyCave();
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
            _craftSprite = new Sprite();
            _source.addChild(_craftSprite);
            _arrCraftItems = [];
        }

        if (_stateBuild == STATE_WAIT_ACTIVATE) {
            addTempGiftIcon();
        } else if (_stateBuild == STATE_BUILD) {
            addTempBuildIcon();
        }
    }

    override public function clearIt():void {
        onOut();
        g.gameDispatcher.removeFromTimer(renderBuildCaveProgress);
        _source.touchable = false;
        _arrCraftItems = [];
        super.clearIt();
    }

    private function checkCaveState():void {
        try {
            if (g.isAway) {
                createBuild();
            } else {
                if (g.user.userBuildingData[_dataBuild.id]) {
                    if (g.user.userBuildingData[_dataBuild.id].isOpen) {        // уже построенно и открыто
                        _stateBuild = STATE_ACTIVE;
                        var im:Image = new Image(g.tempBuildAtlas.getTexture(_dataBuild.imageActive));
                        if (!im) {
                            Cc.error('no active cave image:' + _dataBuild.imageActive);
                            g.woGameError.showIt();
                            return;
                        }
                        im.x = _dataBuild.innerX;
                        im.y = _dataBuild.innerY;
                        _build.addChild(im);
                        _defaultScale = _build.scaleX;
                        _rect = _build.getBounds(_build);
                        _sizeX = _dataBuild.width;
                        _sizeY = _dataBuild.height;
                        (_build as Sprite).alpha = 1;
                        if (_flip) _build.scaleX = -_defaultScale;
                        _source.addChild(_build);
                    } else {
                        _leftBuildTime = Number(g.user.userBuildingData[_dataBuild.id].timeBuildBuilding);  // сколько времени уже строится
                        _leftBuildTime = _dataBuild.buildTime - _leftBuildTime;                                 // сколько времени еще до конца стройки
                        if (_leftBuildTime <= 0) {  // уже построенно, но не открыто
                            _stateBuild = STATE_WAIT_ACTIVATE;
                            createBuild();
                            addTempGiftIcon();
                        } else {  // еще строится
                            _stateBuild = STATE_BUILD;
                            createBuild();
                            addTempBuildIcon();
                            g.gameDispatcher.addToTimer(renderBuildCaveProgress);
                        }
                    }
                } else {
                    _stateBuild = STATE_UNACTIVE;
                    createBuild();
                }
            }
        } catch (e:Error) {
            Cc.error('cave error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    protected function renderBuildCaveProgress():void {
        _leftBuildTime--;
        if (_leftBuildTime <= 0) {
            g.gameDispatcher.removeFromTimer(renderBuildCaveProgress);
            clearCraftSprite();
            addTempGiftIcon();
            _stateBuild = STATE_WAIT_ACTIVATE;
        }
    }

    private function onHover():void {
        _isOnHover = true;
        _source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
        g.hint.showIt(_dataBuild.name, "0");
        if (_stateBuild == STATE_BUILD) {
            g.gameDispatcher.addEnterFrame(countEnterFrame);
        }
    }

    private function onOut():void {
        _isOnHover = false;
        if (_source) _source.filter = null;
        g.hint.hideIt();
        if (_stateBuild == STATE_BUILD) {
            g.gameDispatcher.addEnterFrame(countEnterFrame);
        }
    }

    private function onClick():void {
        if (_stateBuild == STATE_ACTIVE) {
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES
                    || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
                if (!_source.wasGameContMoved) {
                    if (_arrCraftItems.length) {
                        if (g.userInventory.currentCountInSklad + 1 >= g.user.skladMaxCount) {
                            var p:Point = new Point(_source.x, _source.y);
                            p = _source.parent.localToGlobal(p);
                            new FlyMessage(p, "Склад заполнен");
                            return;
                        }
                        _arrCraftItems.pop().flyIt();
                    } else {
                        _source.filter = null;
                        g.woCave.fillIt(_dataBuild.idResourceRaw, onItemClick);
                        g.woCave.showIt();
                        g.hint.hideIt();
                    }
                }
            } else {
                Cc.error('Cave:: unknown g.toolsModifier.modifierType')
            }
        } else if (_stateBuild == STATE_UNACTIVE) {
            _source.filter = null;
            if (!_source.wasGameContMoved) _woBuy.showItWithParams(_dataBuild, "Откройте пещеру", onBuy);
            g.hint.hideIt();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (_source.wasGameContMoved) return;
            if (g.useDataFromServer) {
                g.directServer.openBuildedBuilding(this, onOpenBuilded);
            }
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                new XPStar(start.x, start.y, _dataBuild.xpForBuild);
            }
            _stateBuild = STATE_ACTIVE;
            _source.filter = null;
            clearCraftSprite();
            while (_build.numChildren) {
                _build.removeChildAt(0);
            }
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            var im:Image = new Image(g.tempBuildAtlas.getTexture(_dataBuild.imageActive));
            im.x = _dataBuild.innerX;
            im.y = _dataBuild.innerY;
            _build.addChild(im);
            _defaultScale = _build.scaleX;
            _rect = _build.getBounds(_build);
            _sizeX = _dataBuild.width;
            _sizeY = _dataBuild.height;
            (_build as Sprite).alpha = 1;
            if (_flip) _build.scaleX = -_defaultScale;
            _source.addChild(_build);
            _source.addChild(_craftSprite);
        }
    }

    private function onOpenBuilded(value:Boolean):void { }

    private function onBuy():void {
        if (g.user.softCurrencyCount < _dataBuild.cost) {
            var p:Point = new Point(_source.x, _source.y);
            p = _source.parent.localToGlobal(p);
            new FlyMessage(p, "Недостаточно денег");
            return;
        }
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataBuild.cost);
        _stateBuild = STATE_BUILD;
        _dbBuildingId = 0;
        g.directServer.startBuildBuilding(this, onStartBuildingResponse);
        addTempBuildIcon();
        _leftBuildTime = _dataBuild.buildTime;
        g.gameDispatcher.addToTimer(renderBuildCaveProgress);
    }

    private function onStartBuildingResponse(value:Boolean):void {}

    private function onItemClick(id:int):void {
        g.userInventory.addResource(id, -1);
        var v:Number = _dataBuild.variaty[_dataBuild.idResourceRaw.indexOf(id)];
        var c:int = 2 + int(Math.random()*3);
        var l1:Number = v;
        var l2:Number = (1-l1)*v;
        var l3:Number = (1-l1-l2)/2;
        l3 += l2 + l1;
        l2 += l1;
        var r:Number;
        var craftItem:CraftItem;
        var item:ResourceItem;
        _arrCraftItems = [];
        for (var i:int = 0; i < c; i++) {
            r = Math.random();
            if (r < l1) {
                item = new ResourceItem();
                item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[0]]);
                craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                craftItem.removeDefaultCallbacks();
                _arrCraftItems.push(craftItem);
            } else if (r < l2) {
                item = new ResourceItem();
                item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[1]]);
                craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                craftItem.removeDefaultCallbacks();
                _arrCraftItems.push(craftItem);
            } else if (r < l3) {
                item = new ResourceItem();
                item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[2]]);
                craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                craftItem.removeDefaultCallbacks();
                _arrCraftItems.push(craftItem);
            } else {
                item = new ResourceItem();
                item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[3]]);
                craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                craftItem.removeDefaultCallbacks();
                _arrCraftItems.push(craftItem);
            }
        }
    }

    private function countEnterFrame():void {
        _count--;
        if(_count <=0){
            g.gameDispatcher.removeEnterFrame(countEnterFrame);
            if (_isOnHover == true) {
                g.timerHint.showIt(g.cont.gameCont.x + _source.x, g.cont.gameCont.y + _source.y, _leftBuildTime, _dataBuild.cost, _dataBuild.name);
            }
            if (_isOnHover == false) {
                _source.filter = null;
                g.timerHint.hideIt();
            }
        }
    }

}
}
