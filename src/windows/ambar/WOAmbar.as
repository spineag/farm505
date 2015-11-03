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

import ui.scrolled.DefaultVerticalScrollSprite;

import utils.CButton;
import utils.CSprite;

import windows.Window;

public class WOAmbar extends Window {
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

    public function WOAmbar() {
        super();
        _woHeight = 500;
        _woWidth = 534;
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('wo_ambar'));
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
        _scrollSprite.createScoll(440, 0, 300, g.allData.atlas['interfaceAtlas'].getTexture('scroll_line'), g.allData.atlas['interfaceAtlas'].getTexture('scroll_box'));

        _titleTxt = new TextField(150, 40, 'Амбар', "Arial", 30, Color.BLACK);
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
        _item1 = new UpdateItem(g.dataBuilding.objectBuilding[12].upInstrumentId1);
        _item2 = new UpdateItem(g.dataBuilding.objectBuilding[12].upInstrumentId2);
        _item3 = new UpdateItem(g.dataBuilding.objectBuilding[12].upInstrumentId3);
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
//        _updateSprite.hoverCallback = onHover;
//        _updateSprite.outCallback = onOut;

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
        var st:String = 'ВМЕСТИМОСТЬ: ' + g.userInventory.currentCountInAmbar + '/' + g.user.ambarMaxCount;
        _txtCount.text = st;
        _progress.setProgress(g.userInventory.currentCountInAmbar/g.user.ambarMaxCount,true);
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
            var arr:Array = g.userInventory.getResourcesForAmbar();
            arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
            for (var i:int = 0; i < arr.length; i++) {
                cell = new AmbarCell(arr[i]);
                _arrCells.push(cell);
                _scrollSprite.addNewCell(cell.source);
            }
        } catch(e:Error) {
            Cc.error('WOAmbar fillItems:: error ' + e.errorID + ' - ' + e.message);
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
        _txtMakeUpdate.text = 'Улучшить до ' + String(g.user.ambarMaxCount + g.dataBuilding.objectBuilding[12].deltaCountResources) + ' кг.';
        if (_item1.isFull && _item2.isFull && _item3.isFull) {
            _btnMakeUpdate.endClickCallback = onUpdate;
            _btnMakeUpdate.alpha = 1;
        } else {
            _btnMakeUpdate.endClickCallback = null;
            _btnMakeUpdate.alpha = .5;
        }
    }

    private function onUpdate():void {
        var needCountForUpdate:int = g.dataBuilding.objectBuilding[12].startCountInstrumets + g.dataBuilding.objectBuilding[12].deltaCountAfterUpgrade * (g.user.ambarLevel-1);
        g.userInventory.addResource(g.dataBuilding.objectBuilding[12].upInstrumentId1, - needCountForUpdate);
        g.userInventory.addResource(g.dataBuilding.objectBuilding[12].upInstrumentId2, - needCountForUpdate);
        g.userInventory.addResource(g.dataBuilding.objectBuilding[12].upInstrumentId3, - needCountForUpdate);
        g.user.ambarLevel++;
        g.user.ambarMaxCount += g.dataBuilding.objectBuilding[12].deltaCountResources;
        var st:String = 'ВМЕСТИМОСТЬ: ' + g.userInventory.currentCountInAmbar + '/' + g.user.ambarMaxCount;
        _progress.setProgress(g.userInventory.currentCountInAmbar/g.user.ambarMaxCount,true);
        _txtCount.text = st;
        _item1.updateIt();
        _item2.updateIt();
        _item3.updateIt();
        updateMakeUpdateBtn();
        if (g.useDataFromServer) g.directServer.updateUserAmbar(1, g.user.ambarLevel, g.user.ambarMaxCount, null);
        unfillItems();
        fillItems();
    }

//    private function onHover():void {
//        trace("loh");
//        g.resourceHint.showIt(g.dataBuilding.objectBuilding[12].upInstrumentId1,"",_source.x,_source.y,_source);
//    }
//
//    private function onOut():void {
//        g.resourceHint.hideIt();
//    }
}
}
