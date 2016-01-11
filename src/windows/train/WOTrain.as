/**
 * Created by user on 7/23/15.
 */
package windows.train {
import build.train.Train;
import build.train.TrainCell;

import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import temp.DropResourceVariaty;

import ui.xpPanel.XPStar;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;
import utils.TimeUtils;

import windows.WOComponents.Birka;

import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;

import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOTrain extends Window {

    public static var CELL_RED:int = 1;
    public static var CELL_GREEN:int = 2;
    public static var CELL_BLUE:int = 3;
    public static var CELL_GRAY:int = 4;

    private var _woBG:WindowBackground;
    private var _rightBlock:Sprite;
    private var _leftBlock:Sprite;
    private var _arrItems:Array;
    private var _btn:CButton;
//    private var _btn1:CSprite;
    private var _btnLoad:CButton;
    private var _btnHelp:CButton;
    private var _activeItemIndex: int;
    private var _build:Train;
    private var _txt:TextField;
    private var _txtCounter:TextField;
    private var _txtHelp:TextField;
    private var _counter:int;
    private var _idFree:int;
    private var _countFree:int;
    private var _txtCostItem:TextField;
    private var _txtXpItem:TextField;
    private var _txtCostAll:TextField;
    private var _txtXpAll:TextField;
    public var _imageItem:Image;
    public function WOTrain() {
        super ();
        _woWidth = 727;
        _woHeight = 529;
        _activeItemIndex = -1;
//        createTempBG();
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        createRightBlock();
        createLeftBlock();
        _arrItems = [];
        addItems();
        _btn = new CButton();
        _btn.addButtonTexture(144, 50, CButton.GREEN, true);
        _btn.x = _woWidth/2 - 109;
        _btn.y = 205;
        var txt:TextField = new TextField(89,62,"Отправить",g.allData.fonts['BloggerBold'],16,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        txt.x = 50;
        txt.y = -5;
        _btn.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_kor_ico'));
        im.y = -10;
        _btn.addDisplayObject(im);
        _source.addChild(_btn);
        _btn.alpha = .5;
        _txt = new TextField(150, 40, '', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txt.x = 110;
        _txt.y = 110;
        _source.addChild(_txt);
        _txtCounter = new TextField(150, 40, '', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtCounter.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtCounter.x = 100;
        _txtCounter.y = 130;
        _source.addChild(_txtCounter);
        _txtHelp = new TextField(150, 50, '', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtHelp.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _source.addChild(_txtHelp);
        callbackClickBG = onClickExit;
        new Birka('Погрузка вагона', _source, _woWidth, _woHeight);
    }

    private function createRightBlock():void {
        var txt:TextField;
        var im:Image;
        var carton:CartonBackgroundIn;
        _rightBlock = new Sprite();
        _rightBlock.y = -205;
        _rightBlock.x = 35;
        _source.addChild(_rightBlock);
        var bg:CartonBackground = new CartonBackground(287, 375);
        bg.filter = ManagerFilters.SHADOW;
        _rightBlock.addChild(bg);
        txt = new TextField(240, 50, 'Загрузите контейнер товаром и получите награду', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 15;
        txt.y = 15;
        _rightBlock.addChild(txt);
        carton = new CartonBackgroundIn(267, 68);
        carton.y = 250;
        carton.x = 10;
        _rightBlock.addChild(carton);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_clock'));
        im.y = 330;
        im.x = 20;
        _rightBlock.addChild(im);
        _btnLoad = new CButton();
        _btnLoad.addButtonTexture(140, 36, CButton.YELLOW, true);
        txt = new TextField(80,30,'Загрузить', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 30;
        _btnLoad.addChild(txt);
        _btnLoad.x = 200;
        _btnLoad.y = 150;
        _rightBlock.addChild(_btnLoad);
        _btnHelp = new CButton();
        _btnHelp.addButtonTexture(240,52,CButton.BLUE,true);
        txt = new TextField(80,30,'', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btnHelp.addChild(txt);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_rup_ico'));
        im.y = -10;
        _btnHelp.addDisplayObject(im);
        _btnHelp.x = 140;
        _btnHelp.y = 210;
        _rightBlock.addChild(_btnHelp);
        txt = new TextField(150,50,'Награда за загрузку всех контейнеров:', g.allData.fonts['BloggerBold'], 15, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 245;
        txt.x = 68;
        _rightBlock.addChild(txt);
        _txtCostItem = new TextField(50,30,'', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtCostItem.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtCostItem.x = 70;
        _txtCostItem.y = 270;
        _txtXpItem = new TextField(50,30,'', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtXpItem.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtXpItem.x = 100;
        _txtXpItem.y = 270;
        _txtCostAll = new TextField(50,30,'', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtCostAll.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtCostAll.x = 100;
        _txtCostAll.y = 100;
        _txtXpAll = new TextField(50,30,'', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtXpAll.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtXpAll.x = 100;
        _txtXpAll.y = 140;

        _rightBlock.addChild(_txtCostItem);
        _rightBlock.addChild(_txtXpItem);
        _rightBlock.addChild(_txtCostAll);
        _rightBlock.addChild(_txtXpAll);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        im.x = 70;
        im.y = 290;
        MCScaler.scale(im,22,22);
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        im.x = 130;
        im.y = 290;
        MCScaler.scale(im,22,22);
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_cup_ico'));
        im.x = 190;
        im.y = 290;
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        im.x = 130;
        im.y = 70;
        MCScaler.scale(im,22,22);
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        im.x = 130;
        im.y = 100;
        MCScaler.scale(im,22,22);
        _rightBlock.addChild(im);
        txt = new TextField(20,20,'1',g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 290;
        txt.x = 210;
        _rightBlock.addChild(txt);
        carton = new CartonBackgroundIn(90, 90);
        carton.x = 20;
        carton.y = 70;
        _rightBlock.addChild(carton);

    }

    private function createLeftBlock():void {
        _leftBlock = new Sprite();
        var bg:CartonBackground = new CartonBackground(325, 430);
        bg.filter = ManagerFilters.SHADOW;
        _leftBlock.addChild(bg);
        _leftBlock.y = -205;
        _leftBlock.x = -_woWidth/2 + 40;
        _source.addChild(_leftBlock);
        var txt:TextField = new TextField(200,30,'Требуются продукты:', g.allData.fonts['BloggerBold'], 19, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 15;
        txt.x = 60;
        _leftBlock.addChild(txt);
    }

    public function onClickExit(e:Event=null):void {
        _txt.text = '';
        _counter = 0;
        _txtCounter.text = '';
        g.gameDispatcher.removeFromTimer(checkCounter);
        hideIt();
        clearItems();
    }

    public function showItWithParams(list:Array, b:Train, state:int, counter:int):void {
        _build = b;
        for (var i:int = 0; i<list.length; i++) {
            _arrItems[i].fillIt(list[i], i);
            _arrItems[i].clickCallback = onItemClick;
        }
//        _txtCostAll.text = String(_build.allCoinsCount);
//        _txtXpAll.text = String(_build.allXPCount);
        _txtCostAll.text = String(-1);
        _txtXpAll.text = String(-1);
        showIt();
        checkBtn();
        if (!g.isAway) {
            if (state == Train.STATE_READY) {
                _txt.text = 'Отправляется через:';

            } else {
                _txt.text = 'До прибытия';
                g.woTrainOrder.showItWO(list, counter);
            }
            _counter = counter;
            _txtCounter.text = String(_counter);
            g.gameDispatcher.addToTimer(checkCounter);
        }
    }

    private function checkCounter():void {
        _counter--;
        _txtCounter.text = String(_counter);
    }

    private function addItems():void {
        var item:WOTrainItem;
        for (var i:int = 0; i < 12; i++) {
            if(i >= 9) {
                item = new WOTrainItem(CELL_GRAY);
            } else if (i >= 6) {
                item = new WOTrainItem(CELL_GREEN);
            } else if (i >= 3) {
                item = new WOTrainItem(CELL_BLUE);
            } else {
                item = new WOTrainItem(CELL_RED);
            }
            item.source.x = i%3 * 100 - 310;
            if(i >= 9) {
              item.source.y = 110;
            } else if (i >= 6) {
                item.source.y = 20;
            } else if (i >= 3) {
                item.source.y = -70;
            } else {
                item.source.y = -160;
            }
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function onItemClick(k:int):void {
        _activeItemIndex = k;
        for (var i:int = 0; i<_arrItems.length; i++) {
            _arrItems[i].setAlpha();
        }
        if (_arrItems[k].isResourceLoaded) {
            _btnLoad.alpha = .5;
        } else {
            if (_arrItems[k].canFull()) {
                _btnLoad.alpha = 1;
                _btnLoad.clickCallback = onResourceLoad;
            } else  {
                _btnLoad.alpha = .5;
                _btnLoad.clickCallback = onClickBuy;
               _idFree = _arrItems[k].idFree;
               _countFree = _arrItems[k].countFree;
            }
        }
    }

    private function onResourceLoad():void {
        if (_activeItemIndex == -1) return;

        if (_arrItems[_activeItemIndex].canFull) {
            _arrItems[_activeItemIndex].fullIt();
        }
        _btnLoad.alpha = .5;
        checkBtn();
    }

    private function onClickBuy():void {
//        g.woNoResources.showItTrain(_idFree,_countFree - g.userInventory.getCountResourceById(_idFree),onClickBuy);   - need remake
    }

    private function checkBtn():void {
        if (g.isAway) {
            _btn.visible = false;
            return;
        }
        _btn.visible = true;
        _btn.clickCallback = null;
        for (var i:int = 0; i<_arrItems.length; i++) {
            if (_arrItems[i].canFull) {
                _btn.alpha = 1;
                _btn.clickCallback = freeTrain;
                return;
            }
        }
        for (i = 0; i<_arrItems.length; i++) {
            if (!_arrItems[i].isResourceLoaded) {
                _btn.alpha = .5;
                return;
            }
        }
        _btn.alpha = 1;
        _btn.clickCallback = fullTrain;
    }

    private function fullTrain():void {
        var p:Point = new Point(_btn.width/2, _btn.height/2);
        p = _btn.localToGlobal(p);
        (_build as Train).fullTrain(p);
        onClickExit();
    }

    private function clearItems():void {
        for (var i:int = 0; i<_arrItems.length; i++) {
            _arrItems[i].clearIt();
        }
    }

    private function freeTrain():void {
        onClickExit();
    }
}
}
