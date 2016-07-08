package build.train {
import analytic.AnalyticManager;

import build.WorldObject;
import com.junkbyte.console.Cc;
import data.DataMoney;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.ManagerWallPost;

import media.SoundConst;

import mouse.ToolsModifier;
import resourceItem.DropItem;
import starling.core.Starling;
import starling.display.Sprite;
import temp.DropResourceVariaty;
import tutorial.managerCutScenes.ManagerCutScenes;
import ui.xpPanel.XPStar;
import windows.WindowsManager;

public class Train extends WorldObject{
    public static var STATE_WAIT_BACK:int = 5;   // поезд в данный момент где-то ездит с продуктамы
    public static var STATE_READY:int = 6;  //  поезд ожидает загрузки продуктов

    private var list:Array;
    private var _counter:int;
    private var _dataPack:Object;
    private var _train_db_id:String; // id для поезда юзера в табличке user_train
    private var TIME_READY:int = 8*60*60; // время, которое ожидает поезд для загрузки продуктов
    private var TIME_WAIT:int = 8*60*60;  // время, на которое уезжает поезд
    private var _isOnHover:Boolean;
    private var _armatureOpenBoom:Armature;
    private var _arriveAnim:ArrivedAnimation;
//    private var _countTimer:int;
    private var _bolAnimation:Boolean;

    public function Train(_data:Object) {
        super(_data);
        useIsometricOnly = false;
        _isOnHover = false;
        list = [];
        _counter = 0;
        if (!_data) {
            Cc.error('no data for Train');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Train');
            return;
        }

        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
       checkTrainState();
        _source.releaseContDrag = true;
    }

    public function fillItDefault():void {
        createAnimatedBuild(onCreateBuild);
    }

    public function fillFromServer(ob:Object):void {
        if (!g.isAway) {
            _train_db_id = ob.id;
            if (int(ob.state)) _stateBuild = int(ob.state);
            if (_stateBuild == STATE_WAIT_BACK) {
                if (int(ob.time_work) > TIME_WAIT) {
                    _stateBuild = STATE_READY;
                    g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
                    _counter = TIME_READY;
                } else {
                    _counter = TIME_WAIT - int(ob.time_work);
                }
                g.directServer.getTrainPack(g.user.userSocialId, fillList);
                createAnimatedBuild(onCreateBuild);
            } else if (_stateBuild == STATE_READY) {
                if (int(ob.time_work) > TIME_READY) {
                    _stateBuild = STATE_WAIT_BACK;
                    g.directServer.updateUserTrainState(_stateBuild, _train_db_id, onNewStateWait);
                    _counter = TIME_WAIT;
                } else {
                    _counter = TIME_READY - int(ob.time_work);
                }
                g.directServer.getTrainPack(g.user.userSocialId, fillList);
                createAnimatedBuild(onCreateBuild);
            } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
                // do nothing
            } else if (_stateBuild == STATE_BUILD) {
                // do nothing
            } else if (_stateBuild == STATE_UNACTIVE) {
                // do nothing
            } else {
                Cc.error('Train:: wrong state');
            }
        }
    }

    private function onNewStateWait():void {
        g.directServer.releaseUserTrainPack(_train_db_id, onResetPack);
    }

    private function onResetPack():void {
        g.directServer.getTrainPack(g.user.userSocialId, fillList);
    }

    private function arriveTrain():void {
        if (_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.removeEventListener(AnimationEvent.COMPLETE, makeIdleAnimation);
        if (_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, makeIdleAnimation);
        _armature.animation.gotoAndPlay('work');
        _arriveAnim.makeArriveKorzina(afterWork);
        _bolAnimation = true;
    }

    private function leaveTrain():void {
        if (_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.removeEventListener(AnimationEvent.COMPLETE, makeIdleAnimation);
        if (_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, makeIdleAnimation);
        _armature.animation.gotoAndPlay('work');
        _arriveAnim.makeAwayKorzina(afterWork);
        _bolAnimation = true;
    }

    private function afterWork():void {
        makeIdleAnimation();
    }

    private function makeIdleAnimation(e:AnimationEvent=null):void {
        _bolAnimation = false;
        if (_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.removeEventListener(AnimationEvent.COMPLETE, makeIdleAnimation);
        if (_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, makeIdleAnimation);
        _armature.addEventListener(AnimationEvent.COMPLETE, makeIdleAnimation);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, makeIdleAnimation);
        var n:Number = Math.random();
        if (n < .55) {
            _armature.animation.gotoAndPlay('idle_1');
        } else if (n < .7) {
            _armature.animation.gotoAndPlay('idle_2');
        } else if (n < .85) {
            _armature.animation.gotoAndPlay('idle_3');
        } else {
            _armature.animation.gotoAndPlay('idle_4');
        }
    }

    private function checkTrainState():void {
//        try {
            if (g.isAway) {
                if (g.visitedUser) {
                    var ar:Array = g.visitedUser.userDataCity.objects;
                    for (var i:int=0; i<ar.length; i++) {
                        if (_dataBuild.id == ar[i].buildId) {
                            _stateBuild = int(ar[i].state);
                            break;
                        }
                    }
                    createAnimatedBuild(onCreateBuild);
                }
            } else {
                if (g.user.userBuildingData[_dataBuild.id]) {
                    if (g.user.userBuildingData[_dataBuild.id].isOpen) {        // уже построенно и открыто
                        _stateBuild = STATE_ACTIVE;
                    } else {
                        _leftBuildTime = Number(g.user.userBuildingData[_dataBuild.id].timeBuildBuilding);  // сколько времени уже строится
                        _leftBuildTime = _dataBuild.buildTime[0] - _leftBuildTime;                                 // сколько времени еще до конца стройки
                        if (_leftBuildTime <= 0) {  // уже построенно, но не открыто
                            _stateBuild = STATE_WAIT_ACTIVATE;
                            _build.visible = false;
                            addDoneBuilding();
                            if (_arriveAnim) _arriveAnim.visible = false;
                        } else {  // еще строится
                            _stateBuild = STATE_BUILD;
                            addFoundationBuilding();
                            if (_arriveAnim) _arriveAnim.visible = false;
                            _build.visible = false;
                            g.gameDispatcher.addToTimer(renderBuildTrainProgress);
                        }
                    }
                } else {
                    _stateBuild = STATE_UNACTIVE;
                }
            }
//        } catch (e:Error) {
//            Cc.error('checkTrainState:: ' + e.errorID + ' - ' + e.message);
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'checkTrainState');
//        }
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _hitArea = g.managerHitArea.getHitArea(_build, 'trainBuild');
        _source.registerHitArea(_hitArea);
        if (g.isAway) {
            if (_stateBuild == STATE_UNACTIVE) {
                createBrokenTrain();
                _arriveAnim = new ArrivedAnimation(_source);
            } else if (_stateBuild == STATE_READY) {
                _arriveAnim = new ArrivedAnimation(_source);
                onArrivedKorzina();
            } else if (_stateBuild == STATE_WAIT_BACK) {
                _arriveAnim = new ArrivedAnimation(_source);
                makeIdleAnimation();
            }
        } else {
            if (_stateBuild == STATE_UNACTIVE) {
                createBrokenTrain();
                _arriveAnim = new ArrivedAnimation(_source);
            } else if (_stateBuild == STATE_READY) {
                _arriveAnim = new ArrivedAnimation(_source);
                onArrivedKorzina();
                startRenderTrainWork();
            } else if (_stateBuild == STATE_WAIT_BACK) {
                _arriveAnim = new ArrivedAnimation(_source);
                makeIdleAnimation();
                startRenderTrainWork();
            }
        }
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
    }

    private function createBrokenTrain():void {
        _build.visible = true;
        if (_armature) _armature.animation.gotoAndStop('close', 0);
    }

    protected function renderBuildTrainProgress():void {
        _leftBuildTime--;
        if (_leftBuildTime <= 0) {
            g.gameDispatcher.removeFromTimer(renderBuildTrainProgress);
            clearCraftSprite();
            addDoneBuilding();
            _stateBuild = STATE_WAIT_ACTIVATE;
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (_isOnHover) return;
        _build.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        if (_stateBuild == STATE_UNACTIVE) {
            var fEndOver:Function = function():void {
                _armature.removeEventListener(AnimationEvent.COMPLETE, fEndOver);
                _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndStop('close', 0);
            };
            _armature.addEventListener(AnimationEvent.COMPLETE, fEndOver);
            _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlay('over');
        } else if (_stateBuild == STATE_BUILD) {
            _craftSprite.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            buildingBuildFoundationOver();
//            _countTimer = 5;
//            g.gameDispatcher.addEnterFrame(countEnterFrame);
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            _craftSprite.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            buildingBuildDoneOver();
        }
        g.hint.showIt(_dataBuild.name);
        _isOnHover = true;
    }

//    private function countEnterFrame():void {
//        _countTimer--;
//        if (_countTimer <= 0) {
//            g.gameDispatcher.removeEnterFrame(countEnterFrame);
//            if (_isOnHover == true) {
//                g.timerHint.showIt(90,g.cont.gameCont.x + _source.x * g.currentGameScale,  g.cont.gameCont.y + (_source.y - _source.height/9) * g.currentGameScale, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name,callbackSkip,onOut);
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
        if (_bolAnimation) return;
//        if (g.isAway) {
//            if (g.user.level >= _dataBuild.blockByLevel[0]) return;
//            if (_stateBuild == STATE_READY) {
//                onOut();
//                if (list.length) {
//                    if (_stateBuild == Train.STATE_READY) {
//                        g.windowsManager.openWindow(WindowsManager.WO_TRAIN, null, list, this, _stateBuild, _counter);
//                    } else {
//                        g.windowsManager.openWindow(WindowsManager.WO_TRAIN_ORDER, null, list, this, _counter);
//                    }
//                } else {
//                    var f1:Function = function(ob:Object):void {
//                        fillList(ob);
//                        if (_stateBuild == Train.STATE_READY) {
//                            g.windowsManager.openWindow(WindowsManager.WO_TRAIN, null, list, this, _stateBuild, _counter);
//                        } else {
//                            g.windowsManager.openWindow(WindowsManager.WO_TRAIN_ORDER, backTrain, list, this, _counter);
//                        }
//                    };
//                    g.directServer.getTrainPack(g.visitedUser.userSocialId, f1);
//                }
//            }
//            return;
//        }

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
            g.timerHint.showIt(90,g.cont.gameCont.x + _source.x * g.currentGameScale,  g.cont.gameCont.y + (_source.y - _source.height/9) * g.currentGameScale, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name,callbackSkip,onOut);
            g.hint.hideIt();
        }
        if (_stateBuild == STATE_ACTIVE || _stateBuild == STATE_READY || _stateBuild == STATE_WAIT_BACK) {
            if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
                if (list.length) {
                        onOut();
                    if (_stateBuild == Train.STATE_READY) {
                        g.windowsManager.openWindow(WindowsManager.WO_TRAIN, null, list, this, _stateBuild, _counter);
                        if (g.managerCutScenes.isCutScene && g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_OPEN_TRAIN)) g.managerCutScenes.checkCutSceneCallback();
                    } else {
                        g.windowsManager.openWindow(WindowsManager.WO_TRAIN_ORDER, backTrain, list, this, _counter);
                    }
                } else {
                    onOut();
                    var f2:Function = function(ob:Object):void {
                        fillList(ob);
                        if (_stateBuild == Train.STATE_READY) {
                            g.windowsManager.openWindow(WindowsManager.WO_TRAIN, null, list, this, _stateBuild, _counter);
                            if (g.managerCutScenes.isCutScene && g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_OPEN_TRAIN)) g.managerCutScenes.checkCutSceneCallback();
                        } else {
                            g.windowsManager.openWindow(WindowsManager.WO_TRAIN_ORDER, backTrain, list, this, _counter);
                        }
                    };
                    g.directServer.getTrainPack(g.user.userSocialId, f2);
                 }
            } else {
                Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
            }
        } else if (_stateBuild == STATE_UNACTIVE) {
            if (_source.wasGameContMoved) {
                onOut();
                return;
            }
            if (g.user.level < _dataBuild.blockByLevel[0]) {
                g.soundManager.playSound(SoundConst.EMPTY_CLICK);
                var p:Point = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,"Будет доступно на " + String(_dataBuild.blockByLevel[0]) + ' уровне');
                return;
            }
            onOut();
            if (!_source.wasGameContMoved) g.windowsManager.openWindow(WindowsManager.WO_BUY_CAVE, onBuy, _dataBuild, "Откройте поезд", false);
            g.hint.hideIt();
            if (g.managerCutScenes.isCutScene && g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_TRAIN_AVAILABLE)) g.managerCutScenes.checkCutSceneCallback();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (_source.wasGameContMoved) {
                onOut();
                return;
            }
            g.directServer.openBuildedBuilding(this, onOpenTrain);
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                new XPStar(start.x, start.y, _dataBuild.xpForBuild);
            }
            _stateBuild = STATE_READY;
            _counter = TIME_READY;
            g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
            startRenderTrainWork();
            onOut();
            clearCraftSprite();
            while (_build.numChildren) {
                _build.removeChildAt(0);
            }
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            createAnimatedBuild(onJustOpenedTrain);
            showBoom();
            g.soundManager.playSound(SoundConst.OPEN_BUILD);
        }
    }

    private function openHint():void {
        g.timerHint.showIt(90,g.cont.gameCont.x + _source.x * g.currentGameScale,  g.cont.gameCont.y + (_source.y - _source.height/9) * g.currentGameScale, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name,callbackSkip,onOut);
        g.hint.hideIt();
    }

    private function onJustOpenedTrain():void {
        _build.visible = true;
        if (!_arriveAnim) _arriveAnim = new ArrivedAnimation(_source);
        _arriveAnim.visible = true;
        _arriveAnim.makeArriveKorzina(onArrivedKorzina);
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlay('work');
        _bolAnimation = true;
    }

    private function onOpenTrain(value:Boolean):void {
        g.directServer.addUserTrain(onAddUserTrain);
    }

    private function onAddUserTrain(s_id:String):void {
        _train_db_id = s_id;
        g.directServer.updateUserTrainState(_stateBuild, _train_db_id, onUpdate);
    }

    private function onUpdate():void {
        g.directServer.getTrainPack(g.user.userSocialId, fillList);
    }

    private function onBuy():void {
        if (_arriveAnim) _arriveAnim.visible = false;
        _build.visible = false;
        g.hint.hideIt();
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataBuild.cost);
        _stateBuild = STATE_BUILD;
        _dbBuildingId = 0;
        g.directServer.startBuildBuilding(this, null);
        addFoundationBuilding();
        g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
        _leftBuildTime = _dataBuild.buildTime[0];
        g.gameDispatcher.addToTimer(renderBuildTrainProgress);
    }

    override public function onOut():void {
        super.onOut();
        _craftSprite.filter = null;
        _build.filter = null;
        g.hint.hideIt();
        _isOnHover = false;
//        if (_stateBuild == STATE_BUILD) {
//            g.gameDispatcher.addEnterFrame(countEnterFrame);
////            g.timerHint.hideIt();
//        }
    }

    public function get allXPCount():int {
        if (_dataPack) {
            return int(_dataPack.count_xp);
        } else {
            return 0;
        }
    }

    public function get allCoinsCount():int {
        if (_dataPack) {
            return int(_dataPack.count_money);
        } return 0;
    }

    private function fillList(ob:Object):void {
        _dataPack = ob;

        list = [];
        for (var i:int=0; i<_dataPack.items.length; i++) {
            list.push(new TrainCell(_dataPack.items[i]));
        }
    }

    public function fullTrain(free:Boolean):void {
        //fillList(_dataPack);
        //g.woTrain.showItWithParams(list, this);
        onOut();
        g.directServer.releaseUserTrainPack(_train_db_id, onReleasePack);
        if (free) return;
        new XPStar(Starling.current.nativeStage.stageWidth/2, Starling.current.nativeStage.stageHeight/2, _dataPack.count_xp);
        var prise:Object = {};
        var priseCoupone:Object = {};
        prise.id = DataMoney.SOFT_CURRENCY;
        prise.type = DropResourceVariaty.DROP_TYPE_MONEY;
        prise.count = _dataPack.count_money;
        new DropItem(Starling.current.nativeStage.stageWidth/2, Starling.current.nativeStage.stageHeight/2, prise);
        priseCoupone.id = int(Math.random() * 4) + 3;
        priseCoupone.type = DropResourceVariaty.DROP_TYPE_MONEY;
        priseCoupone.count = 1;
        new DropItem(Starling.current.nativeStage.stageWidth/2, Starling.current.nativeStage.stageHeight/2, priseCoupone);
        if (g.user.wallTrainItem) {
            g.windowsManager.openWindow(WindowsManager.POST_DONE_TRAIN);
            g.directServer.updateWallTrainItem(null);
            g.user.wallTrainItem = false;
        }
    }

    private function onReleasePack():void {
        _stateBuild = STATE_WAIT_BACK;
        g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
        _counter = TIME_WAIT;
        leaveTrain();
        list = [];
        g.directServer.getUserTrain(null);
    }

    private function startRenderTrainWork():void {
        g.gameDispatcher.addToTimer(render);
    }

    private function render():void {
        _counter--;
        if (_counter <= 0) {
            if (_stateBuild == STATE_READY) {
                _stateBuild = STATE_WAIT_BACK;
                g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
                _counter = TIME_WAIT;
                leaveTrain();
                g.windowsManager.hideWindow(WindowsManager.WO_TRAIN);
            } else if (_stateBuild == STATE_WAIT_BACK) {
                _stateBuild = STATE_READY;
                g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
                _counter = TIME_READY;
                arriveTrain();
                g.windowsManager.hideWindow(WindowsManager.WO_TRAIN_ORDER);
            } else {
                Cc.error('renderTrainWork:: wrong _stateBuild');
            }
        }
    }

    override public function clearIt():void {
        onOut();
        if (_arriveAnim) _arriveAnim.deleteIt();
        _source.touchable = false;
        WorldClock.clock.remove(_armature);
        g.timerHint.hideIt();
        g.gameDispatcher.removeFromTimer(render);
        g.gameDispatcher.removeFromTimer(renderBuildTrainProgress);
        _dataPack = null;
        if (list) list.length = 0;
        _armature.dispose();
        _armature = null;
        super.clearIt();
    }

    private function callbackSkip():void {
        _stateBuild = STATE_WAIT_ACTIVATE;
        _leftBuildTime = 0;
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_BUILDING_BUILD_ID, info: _dataBuild.id});
        renderBuildProgress();
    }

    private function onArrivedKorzina():void {
        _arriveAnim.showKorzina();
        makeIdleAnimation();
        g.managerCutScenes.checkCutScene(ManagerCutScenes.REASON_OPEN_TRAIN);
        _bolAnimation = false;
    }

    private function backTrain():void {
        _counter = 0;
        list.length = 0;
        g.directServer.getTrainPack(g.user.userSocialId, fillList);
        render();
    }

    private function showBoom():void {
        _armatureOpenBoom = g.allData.factory['explode'].buildArmature("expl");
        _source.addChild(_armatureOpenBoom.display as Sprite);
        WorldClock.clock.add(_armatureOpenBoom);
        _armatureOpenBoom.addEventListener(AnimationEvent.COMPLETE, onBoom);
        _armatureOpenBoom.addEventListener(AnimationEvent.LOOP_COMPLETE, onBoom);
        _armatureOpenBoom.animation.gotoAndPlay("start");
    }

    private function onBoom(e:AnimationEvent=null):void {
        if (_armatureOpenBoom.hasEventListener(AnimationEvent.COMPLETE)) _armatureOpenBoom.removeEventListener(AnimationEvent.COMPLETE, onBoom);
        if (_armatureOpenBoom.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armatureOpenBoom.removeEventListener(AnimationEvent.LOOP_COMPLETE, onBoom);
        WorldClock.clock.remove(_armatureOpenBoom);
        _source.removeChild(_armatureOpenBoom.display as Sprite);
        _armatureOpenBoom.dispose();
        _armatureOpenBoom = null;
        g.windowsManager.openWindow(WindowsManager.POST_OPEN_TRAIN);
    }
}
}
