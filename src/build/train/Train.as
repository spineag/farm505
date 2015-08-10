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
    private var TIME_READY:int = 1200; // время, которое ожидает поезд для загрузки продуктов
    private var TIME_WAIT:int = 600;  // время, на которое уезжает поезд

    public function Train(_data:Object) {
        super(_data);

       checkTrainState();
        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
        if (_stateBuild == STATE_WAIT_ACTIVATE) {
            addTempGiftIcon();
        } else if (_stateBuild == STATE_BUILD) {
            addTempBuildIcon();
        }

        _woBuy = new WOBuyCave();
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
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
            renderTrainWork();
        } else if (_stateBuild == STATE_READY) {
            if (int(ob.time_work) > TIME_READY) {
                _stateBuild = STATE_WAIT_BACK;
                g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
                _counter = TIME_WAIT;
                leaveTrain();
            } else {
                _counter = TIME_READY - int(ob.time_work);
            }
            renderTrainWork();
        } else {
            Cc.error('Train:: wrong state');
            return;
        }
        g.directServer.getTrainPack(fillList);
    }

    private function arriveTrain():void {
        _source.alpha = 1;
    }

    private function leaveTrain():void {
        _source.alpha = .3;
    }

    private function checkTrainState():void {
        if (g.user.userBuildingData[_dataBuild.id]) {
            if (g.user.userBuildingData[_dataBuild.id].isOpen) {        // уже построенно и открыто
                _stateBuild = STATE_ACTIVE;
                createBuild();
            } else {
                var time:Number = new Date().getTime();
                _leftBuildTime = time - Number(g.user.userBuildingData[_dataBuild.id].dateStartBuild);  // сколько времени уже строится
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
            createBuild();
        }
    }

    private function createBrokenTrain():void {
        var im:Image = new Image(g.tempBuildAtlas.getTexture('train'));
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
    }

    protected function renderBuildTrainProgress():void {
        _leftBuildTime--;
        if (_leftBuildTime <= 0) {
            g.gameDispatcher.removeFromTimer(renderBuildProgress);
            clearCraftSprite();
            addTempGiftIcon();
            _stateBuild = STATE_WAIT_ACTIVATE;
        }
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
        g.hint.showIt(_dataBuild.name, "0");

    }

    private function onClick():void {
        if (_stateBuild == STATE_ACTIVE || _stateBuild == STATE_READY || _stateBuild == STATE_WAIT_BACK) {
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
                g.townArea.moveBuild(this);
            } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
                g.townArea.deleteBuild(this);
            } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
                releaseFlip();
            } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

            } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
                // ничего не делаем вообще
            } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
                g.woTrain.showItWithParams(list, this);
                onOut();
            } else {
                Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
            }
        } else if (_stateBuild == STATE_UNACTIVE) {
            _source.filter = null;
            _woBuy.showItWithParams(_dataBuild, "Откройте поезд", onBuy);
            g.hint.hideIt();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (g.useDataFromServer) {
                g.directServer.openBuildedBuilding(this, onOpenTrain);
            }
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                new XPStar(start.x, start.y, _dataBuild.xpForBuild);
            }
            //_stateBuild = STATE_ACTIVE;
            _stateBuild = STATE_READY;
            g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
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
    }

    private function onBuy():void {
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, _dataBuild.cost);
        _stateBuild = STATE_BUILD;
        _dbBuildingId = 0;
        g.directServer.startBuildBuilding(this, null);
        addTempBuildIcon();
        g.gameDispatcher.addToTimer(renderBuildTrainProgress);
    }

    private function onOut():void {
        _source.filter = null;
        g.hint.hideIt();
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
            } else if (_stateBuild == STATE_WAIT_BACK) {
                _stateBuild = STATE_READY;
                g.directServer.updateUserTrainState(_stateBuild, _train_db_id, null);
                _counter = TIME_READY;
                arriveTrain();
            } else {
                Cc.error('renderTrainWork:: wrong _stateBuild');
            }
        }
    }

}
}
