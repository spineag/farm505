package windows.market {

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import ui.scrolled.DefaultVerticalScrollSprite;

import utils.CButton;

import windows.Window;

public class WOMarketChoose extends Window {
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrCells:Array;
    private var _callback:Function;
    private var _btnSell:CButton;
    private var _countResourceBlock:CountBlock;
    private var _countMoneyBlock:CountBlock;
    private var _curResourceId:int;
    private var _checkBox:MarketCheckBox;

    public function WOMarketChoose() {
        super();
        _woHeight = 500;
        _woWidth = 534;
        _bg = new Image(g.interfaceAtlas.getTexture('wo_ambar'));
        _bg.pivotX = _bg.width/2;
        _bg.pivotY = _bg.height/2;
        _source.addChild(_bg);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.x -= 28;
        _btnExit.y += 40;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);

        _arrCells = [];
        _scrollSprite = new DefaultVerticalScrollSprite(395, 297, 99, 99);
        _scrollSprite.source.x = 40 - _woWidth/2;
        _scrollSprite.source.y = 79 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(440, 0, 300, g.interfaceAtlas.getTexture('scroll_line'), g.interfaceAtlas.getTexture('scroll_box'));

        _countResourceBlock = new CountBlock();
        _countResourceBlock.setWidth = 50;
        _countResourceBlock.source.x = -100;
        _countResourceBlock.source.y = 190;
        _countMoneyBlock = new CountBlock();
        _countMoneyBlock.setWidth = 50;
        _countMoneyBlock.source.x = 80;
        _countMoneyBlock.source.y = 190;
        _source.addChild(_countMoneyBlock.source);
        _source.addChild(_countResourceBlock.source);

        var t:TextField = new TextField(100, 30, 'Количество:', "Arial", 14, Color.BLACK);
        t.x = -155;
        t.y = 145;
        _source.addChild(t);
        t = new TextField(150, 30, 'Цена продажи:', "Arial", 14, Color.BLACK);
        t.x = 10;
        t.y = 145;
        _source.addChild(t);

        _btnSell = new CButton(g.interfaceAtlas.getTexture('btn100500'), '', g.interfaceAtlas.getTexture('btn100500'));
        _btnSell.x = 170;
        _btnSell.y = 140;
        _source.addChild(_btnSell);
        _btnSell.endClickCallback = onClickBtnSell;

        _checkBox = new MarketCheckBox();
        _checkBox.source.x = -150;
        _checkBox.source.y = 205;
        _source.addChild(_checkBox.source);

        callbackClickBG = onClickExit;
    }

    public function set callback(f:Function):void {
        _callback = f;
    }

    private function onClickExit(e:Event=null):void {
        _curResourceId = 0;
        unfillItems();
        _scrollSprite.resetAll();
        hideIt();
        if (_callback != null) {
            _callback.apply(null, [0]);
            _callback = null;
        }
    }

    override public function showIt():void {
        fillItems();
        super.showIt();
    }

    private function fillItems():void {
        var cell:MarketCell;
        var arr:Array = g.userInventory.getResourcesForAmbar();
        var arr2:Array = g.userInventory.getResourcesForSklad();
        arr = arr.concat(arr2);
        arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
        for (var i:int = 0; i < arr.length; i++) {
            cell = new MarketCell(arr[i]);
            cell.clickCallback = onCellClick;
            _arrCells.push(cell);
            _scrollSprite.addNewCell(cell.source);
        }
    }

    private function unfillItems():void {
        for (var i:int = 0; i < _arrCells.length; i++) {
            _arrCells[i].clearIt();
        }
        _arrCells.length = 0;
    }

    private function onCellClick(a:int):void {
        _curResourceId = a;
        for (var i:int = 0; i < _arrCells.length; i++) {
            _arrCells[i].activateIt(false);
        }
        var countRes:int = g.userInventory.getCountResourceById(a);
        var count:int = int(countRes/2 + .5);
        if (countRes > 20) {
            count = 10;
            countRes = 10;
        } else if (countRes > 10) {
            countRes = 10;
        }
        _countResourceBlock.maxValue = countRes;
        _countResourceBlock.minValue = 1;
        _countResourceBlock.count = count;
        _countResourceBlock.onChangeCallback = onChangeResourceCount;
        _countMoneyBlock.maxValue = count * g.dataResource.objectResources[_curResourceId].costMax;
        _countMoneyBlock.minValue = 1;
        _countMoneyBlock.count = count * g.dataResource.objectResources[_curResourceId].costMin;
    }

    private function onChangeResourceCount(onPlus:Boolean):void {
        _countMoneyBlock.maxValue = _countResourceBlock.count * g.dataResource.objectResources[_curResourceId].costMax;
//        if (onPlus) {   // дописать автоувеличение/уменьшение
//            _countMoneyBlock.count = _countMoneyBlock.count + g.dataResource.objectResources[_curResourceId].costMin;
//        }
    }

    private function onClickBtnSell():void {
        if (_curResourceId > 0) {
            unfillItems();
            _scrollSprite.resetAll();
            hideIt();
            if (_callback != null) {
                _callback.apply(null, [_curResourceId, _countResourceBlock.count, _countMoneyBlock.count, _checkBox.isChecked]);
                _callback = null;
            }
            _countResourceBlock.count = 0;
            _countMoneyBlock.count = 0;
        }
    }

}
}
