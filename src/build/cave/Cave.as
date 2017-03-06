package build.cave {
import analytic.AnalyticManager;

import build.WorldObject;
import com.junkbyte.console.Cc;
import data.DataMoney;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;

import media.SoundConst;
import mouse.ToolsModifier;
import resourceItem.CraftItem;
import resourceItem.ResourceItem;
import starling.display.Sprite;
import starling.events.Event;

import ui.xpPanel.XPStar;
import windows.WindowsManager;

public class Cave extends WorldObject{
    private var _isOnHover:Boolean;
//    private var _countTimer:int;
    private var _arrCrafted:Array;
    private var _armatureOpen:Armature;
    private var _isAnimate:Boolean;

    public function Cave(data:Object) {
        super (data);
        _isOnHover = false;
        useIsometricOnly = false;
        if (!data) {
            Cc.error('no data for Cave');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Cave');
            return;
        }
        _isAnimate = false;
        _source.releaseContDrag = true;
        _craftSprite = new Sprite();
        if (g.isAway) {
            g.cont.craftAwayCont.addChild(_craftSprite);
        } else {
            g.cont.craftCont.addChild(_craftSprite);
        }
        _buildingBuildSprite = new Sprite();
        _source.addChild(_buildingBuildSprite);
        createAnimatedBuild(checkCaveState);
        _arrCrafted = [];

        if (!g.isAway) {
            if (_stateBuild == STATE_WAIT_ACTIVATE) {
                addDoneBuilding();
            } else if (_stateBuild == STATE_BUILD) {
                addFoundationBuilding();
            }
            _source.endClickCallback = onClick;
        }
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
    }
    
    override public function afterPasteBuild():void {
        _craftSprite.x = 104*g.scaleFactor + _source.x;
        _craftSprite.y = 109*g.scaleFactor + _source.y;
        super.afterPasteBuild();
    }

    override public function clearIt():void {
        onOut();
        WorldClock.clock.remove(_armature);
        g.gameDispatcher.removeFromTimer(renderBuildCaveProgress);
        _source.touchable = false;
        _arrCrafted = [];
        super.clearIt();
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _hitArea = g.managerHitArea.getHitArea(_source, 'mine', ManagerHitArea.TYPE_LOADED);
        _source.registerHitArea(_hitArea);
    }

    public function addAnimForCraftItem(v:Boolean):void {
        if (_arrCrafted.length) {
            var i:int;
            if (v) {
                for (i=0; i<_arrCrafted.length; i++) {
                    (_arrCrafted[i] as CraftItem).animIt();
                }
            } else {
                for (i=0; i<_arrCrafted.length; i++) {
                    (_arrCrafted[i] as CraftItem).removeAnimIt();
                }
            }
        }
    }

    private function checkCaveState():void {
//        try {
            onCreateBuild();
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
                    _armature.animation.gotoAndStopByFrame('close');
                    return;
                }
                if (ob.isOpen) {        // уже построенно и открыто
                    _stateBuild = STATE_ACTIVE;
                    _armature.animation.gotoAndStopByFrame('open');
                } else if (ob.isBuilded) {
                    _leftBuildTime = Number(ob.timeBuildBuilding);  // сколько времени уже строится
                    _leftBuildTime = _dataBuild.buildTime[0] - _leftBuildTime;                                 // сколько времени еще до конца стройки
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
                    _armature.animation.gotoAndStopByFrame('close');
                }
            } else {
                if (g.user.userBuildingData[_dataBuild.id]) {
                    if (g.user.userBuildingData[_dataBuild.id].isOpen) {        // уже построенно и открыто
                        _stateBuild = STATE_ACTIVE;
                        _armature.animation.gotoAndStopByFrame('open');
                        g.directServer.getUserCave(fillFromServer);
                    } else {
                        _leftBuildTime = Number(g.user.userBuildingData[_dataBuild.id].timeBuildBuilding);  // сколько времени уже строится
                        _leftBuildTime = _dataBuild.buildTime[0] - _leftBuildTime;                                 // сколько времени еще до конца стройки
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
                    _armature.animation.gotoAndStopByFrame('close');
                }
            }
//        } catch (e:Error) {
//            Cc.error('cave checkCaveState error: ' + e.errorID + ' - ' + e.message);
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'Cave checkCaveState');
//        }
    }

    private function fillFromServer(ar:Array):void {
        if (ar.length == 0 || ar == null) return;
        var item:ResourceItem;
        var craftItem:CraftItem;
        for (var i:int = 0; i <ar.length; i++) {
            item = new ResourceItem();
            item.fillIt(g.allData.getResourceById(ar[i].resource_id));
            craftItem = new CraftItem(0, 0, item, _craftSprite, ar[i].count);
            craftItem.removeDefaultCallbacks();
            craftItem.addParticle();
            craftItem.animIt();
            _arrCrafted.push(craftItem);
        }
    }

    protected function renderBuildCaveProgress():void {
        _leftBuildTime--;
        if (_leftBuildTime <= 0) {
            g.gameDispatcher.removeFromTimer(renderBuildCaveProgress);
            clearBuildingBuildSprite();
            addDoneBuilding();
            _stateBuild = STATE_WAIT_ACTIVATE;
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.isAway) {
            g.hint.showIt(_dataBuild.name);
            return;
        }

        if (_isAnimate) return;
        if (_stateBuild == STATE_ACTIVE) {
            if (!_isOnHover && !_isAnimate) {
                var fEndOver2:Function = function(e:Event=null):void {
                    _armature.removeEventListener(EventObject.COMPLETE, fEndOver2);
                    _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver2);
                    _armature.animation.gotoAndStopByFrame('open');
                };
                _armature.addEventListener(EventObject.COMPLETE, fEndOver2);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver2);
                _armature.animation.gotoAndPlayByFrame('over2');
                _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            }
        } else if (_stateBuild == STATE_UNACTIVE) {
            if (!_isOnHover) {
                var fEndOver:Function = function(e:Event=null):void {
                    _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                    _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                    _armature.animation.gotoAndStopByFrame('close');
                };
                _armature.addEventListener(EventObject.COMPLETE, fEndOver);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('over');
                _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            }
        } else if (_stateBuild == STATE_BUILD) {
            if (!_isOnHover) buildingBuildFoundationOver();
//            _countTimer = 7;
//            g.gameDispatcher.addEnterFrame(countEnterFrame);
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (!_isOnHover) buildingBuildDoneOver();
        }
        if (!_isOnHover) g.hint.showIt(_dataBuild.name);
        _isOnHover = true;
    }

    override public function onOut():void {
        super.onOut();
        if (g.isAway) {
            g.hint.hideIt();
            return;
        }
        _isOnHover = false;
        if (_source) {
            if (_source.filter) _source.filter.dispose();
            _source.filter = null;
        }
        if (_isAnimate) return;
//        g.hint.hideIt();
//        if (_stateBuild == STATE_BUILD) {
//            g.gameDispatcher.addEnterFrame(countEnterFrame);
////            g.timerHint.hideIt();
//        }
    }

//    private function countEnterFrame():void {
//        _countTimer--;
//        if (_countTimer <= 0) {
//            g.gameDispatcher.removeEnterFrame(countEnterFrame);
//            if (_isOnHover == true) {
//                g.timerHint.showIt(90,g.cont.gameCont.x + _source.x * g.currentGameScale,  g.cont.gameCont.y + (_source.y - _source.height/3) * g.currentGameScale, _leftBuildTime,_dataBuild.priceSkipHard, _dataBuild.name,callbackSkip,onOut);
//                g.hint.hideIt();
//            }
//            if (_isOnHover == false) {
//                _source.filter = null;
//                g.timerHint.hideIt();
//                g.gameDispatcher.removeEnterFrame(countEnterFrame);
//            }
//        }
//    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
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
            if (g.timerHint.isShow) {
                g.timerHint.managerHide(openHint);
                return;
            }
            else if (g.wildHint.isShow){
                g.wildHint.managerHide(openHint);
                return;
            }
            else if (g.treeHint.isShow) {
                g.treeHint.managerHide(openHint);
                return;
            }
            g.timerHint.showIt(90,g.cont.gameCont.x + _source.x * g.currentGameScale,  g.cont.gameCont.y + (_source.y - _source.height/3) * g.currentGameScale,_dataBuild.buildTime, _leftBuildTime,_dataBuild.priceSkipHard, _dataBuild.name,callbackSkip,onOut);
            g.hint.hideIt();
        } else if (_stateBuild == STATE_ACTIVE) {
             if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES
                    || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
                if (!_source.wasGameContMoved) {
                    if (_arrCrafted.length) {
                        if (g.userInventory.currentCountInSklad >= g.user.skladMaxCount) {
                            _source.filter = null;
                            g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, false);
                            return;
                        }
                        g.directServer.craftUserCave(_arrCrafted[_arrCrafted.length-1].resourceId,null);
                        _arrCrafted.pop().flyIt();

//                        g.directServer.craftUserCave();
                        if (!_arrCrafted.length) {
                            _armature.animation.gotoAndStopByFrame('open');
                        }
                    } else {
                        onOut();
//                        if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
                        g.windowsManager.openWindow(WindowsManager.WO_CAVE, onItemClick, _dataBuild.idResourceRaw);
                        g.hint.hideIt();
                    }
                }
            } else {
                Cc.error('Cave:: unknown g.toolsModifier.modifierType')
            }
        } else if (_stateBuild == STATE_UNACTIVE) {
            if (g.user.level < _dataBuild.blockByLevel) {
                g.soundManager.playSound(SoundConst.EMPTY_CLICK);
                var p1:Point = new Point(_source.x, _source.y - 100);
                p1 = _source.parent.localToGlobal(p1);
                new FlyMessage(p1,"Будет доступно на " + String(_dataBuild.blockByLevel) + ' уровне');
                return;
            }
            if (!_source.wasGameContMoved) g.windowsManager.openWindow(WindowsManager.WO_BUY_CAVE, onBuy, _dataBuild, "Откройте пещеру", 'cave');
            onOut();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (_source.wasGameContMoved) return;
            _armature.animation.gotoAndStopByFrame('open');
            g.directServer.openBuildedBuilding(this, onOpenBuilded);
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                new XPStar(start.x, start.y, _dataBuild.xpForBuild);
            }
            _stateBuild = STATE_ACTIVE;
            onOut();
            clearBuildingBuildSprite();
            _build.visible = true;
            _rect = _build.getBounds(_build);
            showBoom();
            g.soundManager.playSound(SoundConst.OPEN_BUILD);
        }
    }

    private function openHint():void {
        g.timerHint.showIt(90,g.cont.gameCont.x + _source.x * g.currentGameScale,  g.cont.gameCont.y + (_source.y - _source.height/3) * g.currentGameScale,_dataBuild.buildTime, _leftBuildTime,_dataBuild.priceSkipHard, _dataBuild.name,callbackSkip,onOut);
        g.hint.hideIt();
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
        var fOut:Function = function(e:Event=null):void {
            _armature.removeEventListener(EventObject.COMPLETE, fOut);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fOut);
            _armature.animation.gotoAndStopByFrame('crafting');
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
            _arrCrafted = [];
            var arr:Array = [];
            for (var i:int=0; i<4; i++) {
                if (g.allData.getResourceById(_dataBuild.idResource[i]).blockByLevel <= g.user.level)
                    arr.push(g.allData.getResourceById(_dataBuild.idResource[i]));
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
                    craftItem.animIt();
                    _arrCrafted.push(craftItem);
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
                    craftItem.animIt();
                    _arrCrafted.push(craftItem);
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
                    craftItem.animIt();
                    _arrCrafted.push(craftItem);
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
                    craftItem.animIt();
                    _arrCrafted.push(craftItem);
                }
                g.directServer.addUserCave(item.resourceID,craftItem.count,null);
            }
            _isAnimate = false;
        };

        var fIn:Function = function(e:Event=null):void {
            _armature.removeEventListener(EventObject.COMPLETE, fIn);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fIn);
            _armature.addEventListener(EventObject.COMPLETE, fOut);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fOut);
            _armature.animation.gotoAndPlayByFrame("out");
        };

        _isAnimate = true;
        _armature.addEventListener(EventObject.COMPLETE, fIn);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, fIn);
        _armature.animation.gotoAndPlayByFrame("in");

    }

    private function callbackSkip():void {
        _stateBuild = STATE_WAIT_ACTIVATE;
        _leftBuildTime = 0;
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_BUILDING_BUILD_ID, info: _dataBuild.id});
        renderBuildProgress();
    }

    private function showBoom():void {
        _armatureOpen = g.allData.factory['explode'].buildArmature("expl");
        _source.addChild(_armatureOpen.display as StarlingArmatureDisplay);
        WorldClock.clock.add(_armatureOpen);
        _armatureOpen.addEventListener(EventObject.COMPLETE, onBoom);
        _armatureOpen.addEventListener(EventObject.LOOP_COMPLETE, onBoom);
        _armatureOpen.animation.gotoAndPlayByFrame("start");
    }

    private function onBoom(e:Event=null):void {
        if (_armatureOpen.hasEventListener(EventObject.COMPLETE)) _armatureOpen.removeEventListener(EventObject.COMPLETE, onBoom);
        if (_armatureOpen.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureOpen.removeEventListener(EventObject.LOOP_COMPLETE, onBoom);
        WorldClock.clock.remove(_armatureOpen);
        _source.removeChild(_armatureOpen.display as Sprite);
        _armatureOpen = null;
        g.windowsManager.openWindow(WindowsManager.POST_OPEN_CAVE);
    }

}
}
