/**
 * Created by user on 6/17/15.
 */
package windows.ambar {
import com.junkbyte.console.Cc;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import windows.WOComponents.DefaultVerticalScrollSprite;

import utils.CButton;
import utils.CSprite;

import windows.Window;

public class WOSklad extends Window {
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrCells:Array;
    private var _titleTxt:TextField;
    private var _progress:AmbarProgress;
    private var _btnUpdate:CButton;
    private var _btnBack:CButton;
    private var _txtCount:TextField;
    private var _updateSprite:Sprite;
    private var _item1:UpdateItem;
    private var _item2:UpdateItem;
    private var _item3:UpdateItem;
    private var _btnMakeUpdate:CSprite;
    private var _txtMakeUpdate:TextField;

    public function WOSklad() {
        super();
        _woHeight = 500;
        _woWidth = 534;
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus'));
        _bg.pivotX = _bg.width/2;
        _bg.pivotY = _bg.height/2;
        _source.addChild(_bg);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('btn_exit'), '', g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_click'), g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_hover'));
        _btnExit.x -= 28;
        _btnExit.y += 40;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);

        _arrCells = [];
        _scrollSprite = new DefaultVerticalScrollSprite(395, 297, 99, 99);
        _scrollSprite.source.x = 40 - _woWidth/2;
        _scrollSprite.source.y = 79 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(440, 0, 300, g.allData.atlas['interfaceAtlas'].getTexture('plus'), g.allData.atlas['interfaceAtlas'].getTexture('plus'));

        _titleTxt = new TextField(150, 40, 'Склад', "Arial", 30, Color.BLACK);
        _titleTxt.x = 189 - _woWidth/2;
        _titleTxt.y = 5 - _woHeight/2;
        _source.addChild(_titleTxt);

        _progress = new AmbarProgress();
        _progress.source.x = 0;
        _progress.source.y = 220;
        _source.addChild(_progress.source);

        _btnUpdate = new CButton(g.allData.atlas['interfaceAtlas'].getTexture('btn2'), 'Увеличить');
        _btnUpdate.x = 50;
        _btnUpdate.y = 153;
        _source.addChild(_btnUpdate);
        _btnUpdate.addEventListener(Event.TRIGGERED, onBtnUpdate);

        _btnBack = new CButton(g.allData.atlas['interfaceAtlas'].getTexture('btn2'), 'Вернуться');
        _btnBack.x = 50;
        _btnBack.y = 153;
        _source.addChild(_btnBack);
        _btnBack.addEventListener(Event.TRIGGERED, onBtnBack);

        _txtCount = new TextField(200, 40, '', "Arial", 16, Color.BLACK);
        _txtCount.x = -205;
        _txtCount.y = 150;
        _source.addChild(_txtCount);

        _updateSprite = new Sprite();
        _item1 = new UpdateItem(g.dataBuilding.objectBuilding[13].upInstrumentId1, false);
        _item2 = new UpdateItem(g.dataBuilding.objectBuilding[13].upInstrumentId2, false);
        _item3 = new UpdateItem(g.dataBuilding.objectBuilding[13].upInstrumentId3, false);
        _item1.onBuyCallback = updateMakeUpdateBtn;
        _item2.onBuyCallback = updateMakeUpdateBtn;
        _item3.onBuyCallback = updateMakeUpdateBtn;
        _item2.source.x = 110;
        _item3.source.x = 220;
        _updateSprite.addChild(_item1.source);
        _updateSprite.addChild(_item2.source);
        _updateSprite.addChild(_item3.source);
        _updateSprite.x = - _updateSprite.width/2 - 10;
        _updateSprite.y = - 150;
        _source.addChild(_updateSprite);

        _btnMakeUpdate = new CSprite();
        var m:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('btn3'));
        _btnMakeUpdate.addChild(m);
        _txtMakeUpdate = new TextField(m.width, m.height, '', "Arial", 18, Color.WHITE);
        _btnMakeUpdate.addChild(_txtMakeUpdate);
        _btnMakeUpdate.x = 70;
        _btnMakeUpdate.y = 220;
        _updateSprite.addChild(_btnMakeUpdate);

        callbackClickBG = hideIt;
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    override public function hideIt():void {
        unfillItems();
        _scrollSprite.resetAll();
        super.hideIt();
    }

    override public function showIt():void {
        var st:String = 'ВМЕСТИМОСТЬ: ' + g.userInventory.currentCountInSklad + '/' + g.user.skladMaxCount;
        _txtCount.text = st;
        _progress.setProgress(g.userInventory.currentCountInSklad/g.user.skladMaxCount);
        _btnBack.visible = false;
        _btnUpdate.visible = true;
        _updateSprite.visible = false;
        _scrollSprite.source.visible = true;
        fillItems();
        super.showIt();
    }

    private function fillItems():void {
        var cell:AmbarCell;
        try {
            var arr:Array = g.userInventory.getResourcesForSklad();
            arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
            for (var i:int = 0; i < arr.length; i++) {
                cell = new AmbarCell(arr[i]);
                _arrCells.push(cell);
                _scrollSprite.addNewCell(cell.source);
            }
        } catch(e:Error) {
            Cc.error('WOSklad fillItems:: error ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    private function unfillItems():void {
        _scrollSprite.resetAll();
        for (var i:int = 0; i < _arrCells.length; i++) {
            _arrCells[i].clearIt();
        }
        _arrCells.length = 0;
    }

    public function showUpdate():void {
        showIt();
        _btnBack.visible = true;
        _btnUpdate.visible = false;
        _scrollSprite.source.visible = false;
        _updateSprite.visible = true;
        _item1.updateIt();
        _item2.updateIt();
        _item3.updateIt();
        updateMakeUpdateBtn();
    }

    private function onBtnUpdate(e:Event):void {
        _btnBack.visible = true;
        _btnUpdate.visible = false;
        _scrollSprite.source.visible = false;
        _updateSprite.visible = true;
        _item1.updateIt();
        _item2.updateIt();
        _item3.updateIt();
        updateMakeUpdateBtn();
    }

    private function onBtnBack(e:Event):void {
        _btnBack.visible = false;
        _btnUpdate.visible = true;
        _scrollSprite.source.visible = true;
        _updateSprite.visible = false;
    }

    private function updateMakeUpdateBtn():void {
        _txtMakeUpdate.text = 'Улучшить до ' + String(g.user.skladMaxCount + g.dataBuilding.objectBuilding[13].deltaCountResources) + ' кг.';
        if (_item1.isFull && _item2.isFull && _item3.isFull) {
            _btnMakeUpdate.endClickCallback = makeUpdate;
            _btnMakeUpdate.alpha = 1;
        } else {
            _btnMakeUpdate.endClickCallback = null;
            _btnMakeUpdate.alpha = .5;
        }
    }

    public function updateTxtCount():void {
        var st:String = 'ВМЕСТИМОСТЬ: ' + g.userInventory.currentCountInSklad + '/' + g.user.skladMaxCount;
        _txtCount.text = st;
    }

    private function makeUpdate():void {
        var needCountForUpdate:int = g.dataBuilding.objectBuilding[13].startCountInstrumets + g.dataBuilding.objectBuilding[13].deltaCountAfterUpgrade * (g.user.skladLevel-1);
        g.userInventory.addResource(g.dataBuilding.objectBuilding[13].upInstrumentId1, - needCountForUpdate);
        g.userInventory.addResource(g.dataBuilding.objectBuilding[13].upInstrumentId2, - needCountForUpdate);
        g.userInventory.addResource(g.dataBuilding.objectBuilding[13].upInstrumentId3, - needCountForUpdate);
        g.user.skladLevel++;
        g.user.skladMaxCount += g.dataBuilding.objectBuilding[13].deltaCountResources;
        updateTxtCount();
        _progress.setProgress(g.userInventory.currentCountInSklad/g.user.skladMaxCount);
        _item1.updateIt();
        _item2.updateIt();
        _item3.updateIt();
        updateMakeUpdateBtn();
        if (g.useDataFromServer) g.directServer.updateUserAmbar(2, g.user.skladLevel, g.user.skladMaxCount, null);
        unfillItems();
        fillItems();
    }

    public function smallUpdate():void {
        updateTxtCount();
        _progress.setProgress(g.userInventory.currentCountInSklad/g.user.skladMaxCount);
        unfillItems();
        fillItems();
    }
}
}
