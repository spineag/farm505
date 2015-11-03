package build.train {
import build.AreaObject;

import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;

import flash.geom.Point;

import map.TownArea;

import mouse.ToolsModifier;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.utils.Color;

import temp.DropResourceVariaty;

import ui.xpPanel.XPStar;

import windows.cave.WOBuyCave;

public class Train extends AreaObject{
    public static var STATE_WAIT_BACK:int = 5;   // поезд в данный момент где-то ездит с продуктамы
    public static var STATE_READY:int = 6;  //  поезд ожидает загрузки продуктов

    private var list:Array;
    private var _woBuy:WOBuyCave;
    private var _counter:int;
    private var _dataPack:Object;
    private var _train_db_id:String; // id для поезда юзера в табличке user_train
    private var TIME_READY:int = 280; // время, которое ожидает поезд для загрузки продуктов
    private var TIME_WAIT:int = 280;  // время, на которое уезжает поезд
    private var _isOnHover:Boolean;
    private var _count:int;

    public function Train(_data:Object) {
        super(_data);
        useIsometricOnly = false;
        if (!_data) {
            Cc.error('no data for Train');
            g.woGameError.showIt();
            return;
        }

       checkTrainState();
        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
        if (_stateBuild == STATE_WAIT_ACTIVATE) {
            addTempGiftIcon();
        } else if (_stateBuild == STATE_BUILD) {
            addTempBuildIcon();
        }

        if (!g.isAway) {
            _woBuy = new WOBuyCave();
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;
    }

    public function fillFromServer(ob:Object):void {
        _train_db_id = ob.id;
        _stateBuild = int(ob.state);
        if (_stateBuild == STATE_WAIT_BACK) {
            if (int(ob.time_work) > TIME_WAIT) {
                _stateBuild = STATE_READY;
                g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
                _counter = TIME_READY;
                arriveTrain();
            } else {
                _counter = TIME_WAIT - int(ob.time_work);
            }
            g.directServer.getTrainPack(fillList);
            renderTrainWork();
        } else if (_stateBuild == STATE_READY) {
            if (int(ob.time_work) > TIME_READY) {
                _stateBuild = STATE_WAIT_BACK;
                g.directServer.updateUserTrainState(_stateBuild, _train_db_id, onNewStateWait);
                _counter = TIME_WAIT;
                leaveTrain();
            } else {
                _counter = TIME_READY - int(ob.time_work);
            }
            g.directServer.getTrainPack(fillList);
            renderTrainWork();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            // do nothing
        } else if (_stateBuild == STATE_BUILD) {
            // do nothing
        } else if (_stateBuild == STATE_UNACTIVE) {
            // do nothing
        } else {
            Cc.error('Train:: wrong state');
            return;
        }
    }

    private function onNewStateWait():void {
        g.directServer.releaseUserTrainPack(_train_db_id, onResetPack);
    }

    private function onResetPack():void {
        g.directServer.getTrainPack(fillList);
    }

    private function arriveTrain():void {
        _source.alpha = 1;
    }

    private function leaveTrain():void {
        _source.alpha = .3;
    }

    private function checkTrainState():void {
        try {
            if (g.isAway) {
                createBuild();
            } else {
                if (g.user.userBuildingData[_dataBuild.id]) {
                    if (g.user.userBuildingData[_dataBuild.id].isOpen) {        // уже построенно и открыто
                        _stateBuild = STATE_ACTIVE;
                        createBuild();
                    } else {
                        _leftBuildTime = Number(g.user.userBuildingData[_dataBuild.id].timeBuildBuilding);  // сколько времени уже строится
                        _leftBuildTime = _dataBuild.buildTime - _leftBuildTime;                                 // сколько времени еще до конца стройки
                        if (_leftBuildTime <= 0) {  // уже построенно, но не открыто
                            _stateBuild = STATE_WAIT_ACTIVATE;
                            createBrokenTrain();
                        } else {  // еще строится
                            _stateBuild = STATE_BUILD;
                            createBrokenTrain();
                            g.gameDispatcher.addToTimer(renderBuildTrainProgress);
                        }
                    }
                } else {
                    _stateBuild = STATE_UNACTIVE;
                    createBrokenTrain();
                }
            }
        } catch (e:Error) {
            Cc.error('checkTrainState:: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    private function createBrokenTrain():void {
        var im:Image = new Image(g.allData.atlas[_dataBuild.url].getTexture('train_broken'));
        if (!im) {
            Cc.error('no image "train_broken"');
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

        createIsoView();
    }

    protected function renderBuildTrainProgress():void {
        _leftBuildTime--;
        if (_leftBuildTime <= 0) {
            g.gameDispatcher.removeFromTimer(renderBuildTrainProgress);
            clearCraftSprite();
            addTempGiftIcon();
            _stateBuild = STATE_WAIT_ACTIVATE;
        }
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
        g.hint.showIt(_dataBuild.name, "0");
        _isOnHover = true;
        if (_stateBuild == STATE_BUILD) {
            g.gameDispatcher.addEnterFrame(countEnterFrame);
        }
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.isActiveMapEditor) {
                g.townArea.moveBuild(this);
            }
            return;
        }
        if (_stateBuild == STATE_ACTIVE || _stateBuild == STATE_READY || _stateBuild == STATE_WAIT_BACK) {
            if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
//                g.townArea.deleteBuild(this);
            } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
//                releaseFlip();
            } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

            } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
                // ничего не делаем вообще
            } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
                if (_source.wasGameContMoved) return;
                g.woTrain.showItWithParams(list, this, _stateBuild, _counter);
                onOut();
                _source.filter = null;
            } else {
                Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
            }
        } else if (_stateBuild == STATE_UNACTIVE) {
            if (_source.wasGameContMoved) return;
            _source.filter = null;
            _woBuy.showItWithParams(_dataBuild, "Откройте поезд", onBuy);
            g.hint.hideIt();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (_source.wasGameContMoved) return;
            if (g.useDataFromServer) {
                g.directServer.openBuildedBuilding(this, onOpenTrain);
            }
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                new XPStar(start.x, start.y, _dataBuild.xpForBuild);
            }
            _stateBuild = STATE_READY;
            _counter = TIME_READY;
            renderTrainWork();
            _source.filter = null;
            clearCraftSprite();
            while (_build.numChildren) {
                _build.removeChildAt(0);
            }
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            createBuild();
        }
    }

    private function onOpenTrain(value:Boolean):void {
        g.directServer.addUserTrain(onAddUserTrain);
    }

    private function onAddUserTrain(s_id:String):void {
        _train_db_id = s_id;
        g.directServer.updateUserTrainState(_stateBuild, _train_db_id, onUpdate);
    }

    private function onUpdate():void {
        g.directServer.getTrainPack(fillList);
    }

    private function onBuy():void {
        g.hint.hideIt();
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataBuild.cost);
        _stateBuild = STATE_BUILD;
        _dbBuildingId = 0;
        g.directServer.startBuildBuilding(this, null);
        addTempBuildIcon();
        _leftBuildTime = _dataBuild.buildTime;
        g.gameDispatcher.addToTimer(renderBuildTrainProgress);
    }

    private function onOut():void {
        _source.filter = null;
        g.hint.hideIt();
        _isOnHover = false;
        if (_stateBuild == STATE_BUILD) {
            g.timerHint.hideIt();
        }

    }

    private function fillList(ob:Object):void {
        _dataPack = ob;

        list = [];
        for (var i:int=0; i<_dataPack.items.length; i++) {
            list.push(new TrainCell(_dataPack.items[i]));
        }
    }

    public function fullTrain(p:Point):void {
        //fillList(_dataPack);
        //g.woTrain.showItWithParams(list, this);
        onOut();
        g.directServer.releaseUserTrainPack(_train_db_id, onReleasePack);

        new XPStar(p.x, p.y, _dataPack.count_xp);
        var prise:Object = {};
        prise.id = DataMoney.SOFT_CURRENCY;
        prise.type = DropResourceVariaty.DROP_TYPE_MONEY;
        prise.count = _dataPack.count_money;
        new DropItem(p.x, p.y, prise);
    }

    private function onReleasePack():void {
        _stateBuild = STATE_WAIT_BACK;
        g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
        _counter = TIME_WAIT;
        leaveTrain();
        list = [];
        g.directServer.getUserTrain(null);
    }

    private function renderTrainWork():void {
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
                g.woTrain.onClickExit();
            } else if (_stateBuild == STATE_WAIT_BACK) {
                _stateBuild = STATE_READY;
                g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
                _counter = TIME_READY;
                arriveTrain();
                g.woTrain.onClickExit();
            } else {
                Cc.error('renderTrainWork:: wrong _stateBuild');
            }
        }
    }

    private function countEnterFrame():void {
        _count--;
        if(_count <=0){
            g.gameDispatcher.removeEnterFrame(countEnterFrame);
            if (_isOnHover == true) {
                g.timerHint.showIt(g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + _source.y * g.currentGameScale, _leftBuildTime, 5, _dataBuild.name,callbackSkip);
            }
        }
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        g.gameDispatcher.removeEnterFrame(countEnterFrame);
        g.gameDispatcher.removeFromTimer(render);
        g.gameDispatcher.removeFromTimer(renderBuildTrainProgress);
        _dataPack = null;
        if (list) list.length = 0;
        super.clearIt();
    }

    private function callbackSkip():void {
        _stateBuild = STATE_WAIT_ACTIVATE;
        clearCraftSprite();
        addTempGiftIcon();
        createBuild();
    }
}
}
