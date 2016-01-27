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

    public function Cave(data:Object) {
        super (data);
        useIsometricOnly = false;
        if (!data) {
            Cc.error('no data for Cave');
            g.woGameError.showIt();
            return;
        }
        checkCaveState();
        _source.releaseContDrag = true;
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
            addDoneBuilding();
        } else if (_stateBuild == STATE_BUILD) {
            addFoundationBuilding();
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
        if (g.selectedBuild) return;
        _isOnHover = true;
        _source.filter = ManagerFilters.BUILD_STROKE;
        g.hint.showIt(_dataBuild.name);
    }

    private function onOut():void {
        _isOnHover = false;
        if (_source) _source.filter = null;
        g.hint.hideIt();
        if (_stateBuild == STATE_BUILD) {
            g.timerHint.hideIt();
        }
    }

    private function onClick():void {
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
            g.timerHint.showIt(90,g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + _source.y * g.currentGameScale, _leftBuildTime,_dataBuild.priceSkipHard, _dataBuild.name,callbackSkip);
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
                            var p:Point = new Point(_source.x, _source.y);
                            p = _source.parent.localToGlobal(p);
                            new FlyMessage(p, "Склад заполнен");
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
//            var bone:Bone = _armature.getBone('craft');
//            _craftSprite.x = bone.display.x;
//            _craftSprite.y = bone.display.y;
            _craftSprite.x = 104*g.scaleFactor;
            _craftSprite.y = 109*g.scaleFactor;
            for (var i:int = 0; i < c; i++) {
                r = Math.random();
                if (r < l1) {
                    item = new ResourceItem();
                    item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[0]]);
                    craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                    craftItem.removeDefaultCallbacks();
                    craftItem.addParticle();
                    _arrCraftItems.push(craftItem);
                } else if (r < l2) {
                    item = new ResourceItem();
                    item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[1]]);
                    craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                    craftItem.removeDefaultCallbacks();
                    craftItem.addParticle();
                    _arrCraftItems.push(craftItem);
                } else if (r < l3) {
                    item = new ResourceItem();
                    item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[2]]);
                    craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                    craftItem.removeDefaultCallbacks();
                    craftItem.addParticle();
                    _arrCraftItems.push(craftItem);
                } else {
                    item = new ResourceItem();
                    item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[3]]);
                    craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
                    craftItem.removeDefaultCallbacks();
                    craftItem.addParticle();
                    _arrCraftItems.push(craftItem);
                }
            }
        };

        var fIn:Function = function():void {
            _armature.removeEventListener(AnimationEvent.COMPLETE, fIn);
            _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fIn);
            _armature.addEventListener(AnimationEvent.COMPLETE, fOut);
            _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fOut);
            _armature.animation.gotoAndPlay("out");
        };

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
