/**
 * Created by andy on 8/3/17.
 */
package windows.acceptSentGift {
import flash.events.Event;

import manager.ManagerFilters;

import starling.utils.Color;

import utils.CButton;
import utils.CTextField;

import windows.WOComponents.DefaultVerticalScrollSprite;

import windows.WOComponents.WindowBackground;

import windows.WindowMain;
import windows.WindowsManager;

public class WOAcceptSentGift extends WindowMain {
    private var _woBG:WindowBackground;
    private var _btnAcceptAll:CButton;
    private var _btnSentAll:CButton;
    private var _txtDescription:CTextField;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _friendItems:Array;
    
    public function WOAcceptSentGift() {
        _friendItems = [];
        _windowType = WindowsManager.WO_ACCEPT_SENT_GIFT;
        _woWidth = 622;
        _woHeight = 562;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        _txtDescription = new CTextField(200, 60, "Подарки");
        _txtDescription.setFormat(CTextField.BOLD30, 30, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        _txtDescription.x = -100;
        _txtDescription.y = -260;
        _source.addChild(_txtDescription);

        _btnAcceptAll = new CButton();
        _btnAcceptAll.addButtonTexture(170, 40, CButton.BLUE, true);
        _btnAcceptAll.x = 110;
        _btnAcceptAll.y = 265;
        var t:CTextField = new CTextField(170, 37, 'Принять все');
        t.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _btnAcceptAll.addChild(t);
        _source.addChild(_btnAcceptAll);
        _btnAcceptAll.clickCallback = onClickAcceptAll;

        _btnSentAll = new CButton();
        _btnSentAll.addButtonTexture(170, 40, CButton.GREEN, true);
        _btnSentAll.x = -110;
        _btnSentAll.y = 265;
        t = new CTextField(170, 37, 'Подарить все');
        t.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btnSentAll.addChild(t);
        _source.addChild(_btnSentAll);
        _btnSentAll.clickCallback = onClickSentAll;

        _scrollSprite = new DefaultVerticalScrollSprite(520, 450, 520, 90);
        _scrollSprite.createScoll(550, 0, 450, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        _scrollSprite.source.x = -250;
        _scrollSprite.source.y = -200;
        _source.addChild(_scrollSprite.source);
    }

    override public function showItParams(callback:Function, params:Array):void {
        updateItems();
        if (!_friendItems.length) {
            super.hideIt();
            return;
        }
        super.showIt();
    }

    private function clearItems():void {
        _scrollSprite.resetAll();
        for (var i:int=0; i<_friendItems.length; i++) {
            (_friendItems[i] as WOAcceptSentGiftItem).deleteIt();
        }
        _friendItems.length = 0;
    }

    private function updateItems():void {
        var ar:Array = g.managerAskGift.possibleArrayForAcceptSentGifts;
        var item:WOAcceptSentGiftItem;
        for (var i:int=0; i<ar.length; i++) {
            item = new WOAcceptSentGiftItem(ar[i], hideItem);
            _friendItems.push(item);
            _scrollSprite.addNewCell(item.source);
        }
    }

    private function hideItem(item:WOAcceptSentGiftItem):void {
        _friendItems.removeAt(_friendItems.indexOf(item));
        _scrollSprite.removeCell_OneColumn(item.source);
        item.deleteIt();
        if (!_friendItems.length) onClickExit();
    }

    private function onClickAcceptAll():void {
        var t:Number = 0;
        for (var i:int=0; i<_friendItems.length; i++) {
            if ((_friendItems[i] as WOAcceptSentGiftItem).dataGift.forAsk) {
                (_friendItems[i] as WOAcceptSentGiftItem).acceptGiftResource(true, t);
                t += .1;
            }
        }
        clearItems();
        g.managerAskGift.acceptAllGifts();
        updateItems();
        if (!_friendItems.length) onClickExit();
    }

    private function onClickSentAll():void {
        clearItems();
        g.managerAskGift.sentAllGifts();
        updateItems();
        if (!_friendItems.length) onClickExit();
    }

    private function onClickExit(e:Event=null):void {
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (!_source) return;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;

        super.deleteIt();
    }
}
}
