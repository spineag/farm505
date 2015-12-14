/**
 * Created by user on 7/23/15.
 */
package windows.train {
import build.train.Train;
import build.train.TrainCell;

import data.DataMoney;

import flash.geom.Point;

import resourceItem.DropItem;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import temp.DropResourceVariaty;

import ui.xpPanel.XPStar;

import utils.CSprite;

import windows.WOComponents.WOButtonTexture;

import windows.Window;

public class WOTrain extends Window {
    private var _arrItems:Array;
    private var _btn:CSprite;
    private var _btn1:CSprite;
    private var _activeItemIndex: int;
    private var _build:Train;
    private var _txt:TextField;
    private var _txtCounter:TextField;
    private var _counter:int;
    private var _idFree:int;
    private var _countFree:int;

    public function WOTrain() {
        super ();
        _woWidth = 500;
        _woHeight = 320;
        _activeItemIndex = -1;
        createTempBG();
        createExitButton(onClickExit);
        _arrItems = [];
        addItems();
        var bg:WOButtonTexture = new WOButtonTexture(130, 40, WOButtonTexture.BLUE);
        _btn = new CSprite();
        _btn.addChild(bg);
        _btn.x = 140;
        _btn.y = 70;
        var txt:TextField = new TextField(89,62,"Отправить","Arial",16,Color.BLACK);
        _btn.addChild(txt);
        _source.addChild(_btn);
        _btn.alpha = .5;
        bg = new WOButtonTexture(130, 40, WOButtonTexture.BLUE);
        bg.scaleX = .9;
        bg.scaleY = .7;
        _btn1 = new CSprite();
        _btn1.addChild(bg);
        _btn1.x = 150;
        _btn1.y = -15;
        var txt1:TextField = new TextField(80,50,"Загрузить","Arial",16,Color.BLACK);
        _btn1.addChild(txt1);
        _source.addChild(_btn1);
        _btn1.alpha = .5;

        _txt = new TextField(150, 40, '', "Arial", 16, Color.BLACK);
        _txt.x = 90;
        _txt.y = -130;
        _source.addChild(_txt);
        _txtCounter = new TextField(150, 40, '', "Arial", 16, Color.BLACK);
        _txtCounter.x = 90;
        _txtCounter.y = -100;
        _source.addChild(_txtCounter);

        callbackClickBG = onClickExit;
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
        showIt();
        checkBtn();
        if (!g.isAway) {
            if (state == Train.STATE_READY) {
                _txt.text = 'До отправления';

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
        for (var i:int = 0; i < 9; i++) {
            item = new WOTrainItem();
            item.source.x = i%3 * 110 - 240;
            if (i >= 6) {
                item.source.y = 60;
            } else if (i >= 3) {
                item.source.y = -40;
            } else {
                item.source.y = -140;
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
            _btn1.alpha = .5;
        } else {
            if (_arrItems[k].canFull()) {
                _btn1.alpha = 1;
                _btn1.endClickCallback = onResourceLoad;
            } else  {
                _btn1.alpha = .5;
                _btn1.endClickCallback = onClickBuy;
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
        _btn1.alpha = .5;
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
        _btn.endClickCallback = null;
        for (var i:int = 0; i<_arrItems.length; i++) {
            if (_arrItems[i].canFull) {
                _btn.alpha = 1;
                _btn.endClickCallback = freeTrain;
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
        _btn.endClickCallback = fullTrain;
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
