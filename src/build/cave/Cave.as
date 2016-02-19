package build.cave {
import build.AreaObject;

import com.junkbyte.console.Cc;
import data.DataMoney;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import mouse.ToolsModifier;
import resourceItem.CraftItem;
import resourceItem.ResourceItem;
import starling.display.Sprite;
import ui.xpPanel.XPStar;
import windows.cave.WOBuyCave;


public class Cave extends AreaObject{
    private var _woBuy:WOBuyCave;
    private var _isOnHover:Boolean;
    private var _count:int;
    private var _arrCraftItems:Array;
    private var _armature:Armature;
    private var _isAnimate:Boolean;

    public function Cave(data:Object) {
        super (data);
        _isOnHover = false;
        useIsometricOnly = false;
        if (!data) {
            Cc.error('no data for Cave');
            g.woGameError.showIt();
            return;
        }
        checkCaveState();
        _isAnimate = false;
        _source.releaseContDrag = true;
        if (!g.isAway) {
            _woBuy = new WOBuyCave();
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
        _arrCraftItems = [];

        if (!g.isAway) {
            if (_stateBuild == STATE_WAIT_ACTIVATE) {
                addDoneBuilding();
            } else if (_stateBuild == STATE_BUILD) {
                addFoundationBuilding();
            }
        }
    }

    override public function clearIt():void {
        onOut();
        WorldClock.clock.remove(_armature);
        g.gameDispatcher.removeFromTimer(renderBuildCaveProgress);
        _source.touchable = false;
        _arrCraftItems = [];
        super.clearIt();
    }

    override public function createBuild(isImageClicked:Boolean = true):void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _armature = g.allData.factory[_dataBuild.image].buildArmature("building");
        _build.addChild(_armature.display as Sprite);
        WorldClock.clock.add(_armature);
        _defaultScale = 1;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        if (_flip) _build.scaleX = -_defaultScale;
        _source.addChild(_build);
    }

    private function checkCaveState():void {
        try {
            createBuild();
            if (g.isAway) {
                var ob:Object;
                var ar:Array = g.visitedUser.userDataCity.objects;
                for (var i:int=0; i<ar.length; i++) {
                    if (_dataBuild.id == ar[i].buildId) {
                        ob = ar[i];
                        break;
                    }
                }
                if (!ob) {
                    _stateBuild = STATE_UNACTIVE;
                    _armature.animation.gotoAndStop('close', 0);
                    return;
                }
                if (ob.isOpen) {        // уже построенно и открыто
                    _stateBuild = STATE_ACTIVE;
                    _armature.animation.gotoAndStop('open', 0);
                } else if (ob.isBuilded) {
                    _leftBuildTime = Number(ob.timeBuildBuilding);  // сколько времени уже строится
                    _leftBuildTime = _dataBuild.buildTime - _leftBuildTime;                                 // сколько времени еще до конца стройки
                    if (_leftBuildTime <= 0) {  // уже построенно, но не открыто
                        _stateBuild = STATE_WAIT_ACTIVATE;
                        addDoneBuilding();
                        _build.visible = false;
                    } else {  // еще строится
                        _stateBuild = STATE_BUILD;
                        addFoundationBuilding();
                        _build.visible = false;
                    }
                } else {
                    _stateBuild = STATE_UNACTIVE;
                    _armature.animation.gotoAndStop('close', 0);
                }
            } else {
                if (g.user.userBuildingData[_dataBuild.id]) {
                    if (g.user.userBuildingData[_dataBuild.id].isOpen) {        // уже построенно и открыто
                        _stateBuild = STATE_ACTIVE;
                        _armature.animation.gotoAndStop('open', 0);
                    } else {
                        _leftBuildTime = Number(g.user.userBuildingData[_dataBuild.id].timeBuildBuilding);  // сколько времени уже строится
                        _leftBuildTime = _dataBuild.buildTime - _leftBuildTime;                                 // сколько времени еще до конца стройки
                        if (_leftBuildTime <= 0) {  // уже построенно, но не открыто
                            _stateBuild = STATE_WAIT_ACTIVATE;
                            addDoneBuilding();
                            _build.visible = false;
                        } else {  // еще строится
                            _stateBuild = STATE_BUILD;
                            addFoundationBuilding();
                            _build.visible = false;
                            g.gameDispatcher.addToTimer(renderBuildCaveProgress);
                        }
                    }
                } else {
                    _stateBuild = STATE_UNACTIVE;
                    _armature.animation.gotoAndStop('close', 0);
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
            addDoneBuilding();
            _stateBuild = STATE_WAIT_ACTIVATE;
        }
    }

    private function onHover():void {
        if (_isAnimate) return;
        if (g.selectedBuild) return;
        if (_stateBuild == STATE_ACTIVE) {
            if (!_isOnHover) {
                _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            }
        } else if (_stateBuild == STATE_UNACTIVE) {
            if (!_isOnHover) {
                var fEndOver:Function = function():void {
                    _armature.removeEventListener(AnimationEvent.COMPLETE, fEndOver);
                    _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
                    _armature.animation.gotoAndStop('idle', 0);
                };
                _armature.addEventListener(AnimationEvent.COMPLETE, fEndOver);
                _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlay('over');
                _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            }
        } else if (_stateBuild == STATE_BUILD) {
            if (!_isOnHover) buildingBuildFoundationOver();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (!_isOnHover) buildingBuildDoneOver();
        }
        g.hint.showIt(_dataBuild.name);
        _isOnHover = true;
    }

    private function onOut():void {
        if (_isAnimate) return;
        _isOnHover = false;
        if (_source) _source.filter = null;
        g.hint.hideIt();
        if (_stateBuild == STATE_BUILD) {
            g.timerHint.hideIt();
        }
    }

    private function onClick():void {
        if (_isAnimate) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                }
            } else {
                if (g.isActiveMapEditor)
                    g.townArea.moveBuild(this);
            }
            return;
        }
        if (_stateBuild == STATE_BUILD) {
            g.timerHint.showIt(90,g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + _source.y * g.currentGameScale, _leftBuildTime,_dataBuild.priceSkipHard, _dataBuild.name,callbackSkip,onOut);
            g.hint.hideIt();
        }
        if (_stateBuild == STATE_ACTIVE) {
             if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
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
//                            var p:Point = new Point(_source.x, _source.y);
//                            p = _source.parent.localToGlobal(p);
//                            new FlyMessage(p, "Склад заполнен");
                            _source.filter = null;
                            g.woAmbarFilled.showAmbarFilled(false);
                            return;
                        }
                        _arrCraftItems.pop().flyIt();
                        if (!_arrCraftItems.length) {
                            _armature.animation.gotoAndStop('open', 0);
                        }
                    } else {
                        onOut();
                        g.woCave.fillIt(_dataBuild.idResourceRaw, onItemClick);
                        g.woCave.showIt();
                        g.hint.hideIt();
                    }
                }
            } else {
                Cc.error('Cave:: unknown g.toolsModifier.modifierType')
            }
        } else if (_stateBuild == STATE_UNACTIVE) {
            if (g.user.level < _dataBuild.blockByLevel) {
                var p1:Point = new Point(_source.x, _source.y - 100);
                p1 = _source.parent.localToGlobal(p1);
                new FlyMessage(p1,"Будет доступно на " + String(_dataBuild.blockByLevel) + ' уровне');
                return;
            }
            if (!_source.wasGameContMoved) _woBuy.showItWithParams(_dataBuild, "Откройте пещеру", onBuy,true);
            onOut();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (_source.wasGameContMoved) return;
            _armature.animation.gotoAndStop('open', 0);
            g.directServer.openBuildedBuilding(this, onOpenBuilded);
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                new XPStar(start.x, start.y, _dataBuild.xpForBuild);
            }
            _stateBuild = STATE_ACTIVE;
            onOut();
            clearCraftSprite();
            _build.visible = true;
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
        _build.visible = false;
        g.hint.hideIt();
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataBuild.cost);
        _stateBuild = STATE_BUILD;
        _dbBuildingId = 0;
        g.directServer.startBuildBuilding(this, onStartBuildingResponse);
        addFoundationBuilding();
        _leftBuildTime = _dataBuild.buildTime;
        g.gameDispatcher.addToTimer(renderBuildCaveProgress);
    }

    private function onStartBuildingResponse(value:Boolean):void {}

    private function onItemClick(id:int):void {
        var fOut:Function = function():void {
            _armature.removeEventListener(AnimationEvent.COMPLETE, fOut);
            _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fOut);
            _armature.animation.gotoAndStop('crafting', 0);
            g.userInventory.addResource(id, -1);
            var v:Number = _dataBuild.variaty[_dataBuild.idResourceRaw.indexOf(id)];
            var c:int = 2 + int(Math.random() * 3);
            var l1:Number = v;
            var l2:Number = (1 - l1) * v;
            var l3:Number = (1 - l1 - l2) / 2;
            l3 += l2 + l1;
            l2 += l1;
            var r:Number;
            var craftItem:CraftItem;
            var item:ResourceItem;
            _arrCraftItems = [];
            _craftSprite.x = 104*g.scaleFactor;
            _craftSprite.y = 109*g.scaleFactor;
            var arr:Array = [];
            for (var i:int=0; i<4; i++) {
                if (g.dataResource.objectResources[_dataBuild.idResource[i]].blockByLevel <= g.user.level)
                    arr.push(g.dataResource.objectResources[_dataBuild.idResource[i]]);
            }
            if (!arr.length) {
                Cc.error('no items for craft from cave:: arr.length = 0');
                return;
            }
            for (i = 0; i < c; i++) {
                r = Math.random();
                if (r < l1) {
                    item = new ResourceItem();
                    item.fillIt(arr[0]);
                    craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                    craftItem.removeDefaultCallbacks();
                    craftItem.addParticle();
                    _arrCraftItems.push(craftItem);
                } else if (r < l2) {
                    item = new ResourceItem();
                    if (arr.length >= 2) {
                        item.fillIt(arr[1]);
                    } else {
                        item.fillIt(arr[0]);
                    }
                    craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                    craftItem.removeDefaultCallbacks();
                    craftItem.addParticle();
                    _arrCraftItems.push(craftItem);
                } else if (r < l3) {
                    item = new ResourceItem();
                    if (arr.length >= 3) {
                        item.fillIt(arr[2]);
                    } else {
                        item.fillIt(arr[int(Math.random()*arr.length)]);
                    }
                    craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                    craftItem.removeDefaultCallbacks();
                    craftItem.addParticle();
                    _arrCraftItems.push(craftItem);
                } else {
                    item = new ResourceItem();
                    if (arr.length > 3) {
                        item.fillIt(arr[3]);
                    } else {
                        item.fillIt(arr[int(Math.random()*arr.length)]);
                    }
                    craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                    craftItem.removeDefaultCallbacks();
                    craftItem.addParticle();
                    _arrCraftItems.push(craftItem);
                }
            }
            _isAnimate = false;
        };

        var fIn:Function = function():void {
            _armature.removeEventListener(AnimationEvent.COMPLETE, fIn);
            _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fIn);
            _armature.addEventListener(AnimationEvent.COMPLETE, fOut);
            _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fOut);
            _armature.animation.gotoAndPlay("out");
        };

        _isAnimate = true;
        _armature.addEventListener(AnimationEvent.COMPLETE, fIn);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fIn);
        _armature.animation.gotoAndPlay("in");
    }

    private function callbackSkip():void {
        _stateBuild = STATE_WAIT_ACTIVATE;
        _leftBuildTime = 0;
        renderBuildProgress();
    }

}
}
