/**
 * Created by user on 7/23/15.
 */
package windows.train {
import build.train.Train;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.Window;

public class WOTrain extends Window {
    private var _arrItems:Array;
    private var _btn:CSprite;
    private var _btn1:CSprite;
    private var _activeItemIndex:int;
    private var _build:Train;

    public function WOTrain() {
        super ();
        _activeItemIndex = -1;
        createTempBG(500, 320, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x = 250;
        _btnExit.y = -160;
        _arrItems = [];
        addItems();
        var im:Image = new Image(g.interfaceAtlas.getTexture('btn4'));
        _btn = new CSprite();
        _btn.addChild(im);
        _btn.x = 140;
        _btn.y = 70;
        var txt:TextField = new TextField(89,62,"Отправить","Arial",16,Color.BLACK);
        _btn.addChild(txt);
        _source.addChild(_btn);
        _btn.alpha = .5;
        im = new Image(g.interfaceAtlas.getTexture('btn4'));
        im.scaleX = .9;
        im.scaleY = .7;
        _btn1 = new CSprite();
        _btn1.addChild(im);
        _btn1.x = 150;
        _btn1.y = -15;
        var txt1:TextField = new TextField(80,50,"Загрузить","Arial",16,Color.BLACK);
        _btn1.addChild(txt1);
        _source.addChild(_btn1);
        _btn1.visible = false;
        _btn1.endClickCallback = onResourceLoad;
    }

    private function onClickExit(e:Event):void {
        hideIt();
        clearItems();
    }

    public function showItWithParams(list:Array, b:Train):void {
        _build = b;
        for (var i:int = 0; i<list.length; i++) {
            _arrItems[i].fillIt(list[i], i);
            _arrItems[i].clickCallback = onItemClick;
        }
        showIt();
        checkBtn();
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
        if (_arrItems[k].isResourceLoaded) _btn1.visible = false;
         else {
            _arrItems[k].canBeFull() ? _btn1.visible = true : _btn1.visible = false;
        }
    }

    private function onResourceLoad():void {
        if (_activeItemIndex == -1) return;

        if (_arrItems[_activeItemIndex].canFull) {
            _arrItems[_activeItemIndex].fullIt();
        }

        checkBtn();
    }

    private function checkBtn():void {
        _btn.endClickCallback = null;
        for (var i:int = 0; i<_arrItems.length; i++) {
            if (!_arrItems[i].isResourceLoaded()) {
                _btn.alpha = .5;
                return;
            }
        }
        _btn.alpha = 1;
        _btn.endClickCallback = fullTrain;
    }

    private function fullTrain():void {
        hideIt();
        (_build as Train).fullTrain();
    }

    private function clearItems():void {
        for (var i:int = 0; i<_arrItems.length; i++) {
            _arrItems[i].clearIt();
        }
    }
}
}
