package windows.market {

import starling.display.Image;
import starling.events.Event;
import starling.filters.ColorMatrixFilter;
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
    private var filter:ColorMatrixFilter;
    private var booleanPlus:Boolean;
    private var booleanMinus:Boolean;

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
        booleanPlus = true;
        booleanMinus = true;
        filter = new ColorMatrixFilter();
        filter.adjustSaturation(-1);

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
        _btnSell.filter = filter;
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
        g.woMarket.refreshMarket();
        _btnSell.filter = filter;
        _countResourceBlock.btnFilter();
        _countMoneyBlock.btnFilter();
        _countResourceBlock.count = 0;
        _countMoneyBlock.count = 0;
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
//        g.woMarket.refreshMarket();
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
        _btnSell.filter = null;
        _countResourceBlock.btnNull();
        _countMoneyBlock.btnNull();
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
        _countMoneyBlock.count =  count * g.dataResource.objectResources[_curResourceId].costMax / 3;
        if (countRes == 1) {
            _countResourceBlock._btnMinus.filter = filter;
            _countResourceBlock._btnPlus.filter = filter;
        } else if (_countResourceBlock.count == 10) {
            _countResourceBlock._btnPlus.filter = filter;
        }
        if ( _countMoneyBlock.count <= 0){
            _countMoneyBlock.count = 1;
        }
    }

    private function onChangeResourceCount(onPlus:Boolean):void {
        var countRes:int = g.userInventory.getCountResourceById(_curResourceId);
        _countMoneyBlock.maxValue = _countResourceBlock.count * g.dataResource.objectResources[_curResourceId].costMax;

//        var count:Boolean;
        _countMoneyBlock.btnNull();
        if (onPlus) {
            booleanMinus = true;
            _countMoneyBlock._btnPlus.filter = null;
            if (countRes == 1) {
                _countResourceBlock._btnMinus.filter = filter;
                _countResourceBlock._btnPlus.filter = filter;
                return;
            }
            if (booleanPlus == false) return; else {
                if (_countResourceBlock.count == 10 || _countResourceBlock.count == countRes) {
                    booleanPlus = false;
                    _countMoneyBlock.count = _countMoneyBlock.count + g.dataResource.objectResources[_curResourceId].costMax / 3;
                    _countResourceBlock._btnPlus.filter = filter;
                    return;
                } else _countResourceBlock._btnPlus.filter = null;
            }
            booleanPlus = true;
            _countMoneyBlock.count = _countMoneyBlock.count + g.dataResource.objectResources[_curResourceId].costMax / 3;
        } else {
            booleanPlus = true;
            if (_countMoneyBlock.count == _countResourceBlock.count * g.dataResource.objectResources[_curResourceId].costMax) {
                _countMoneyBlock._btnPlus.filter = filter;
                return;
            }
            if (countRes == 1) {
                _countResourceBlock._btnMinus.filter = filter;
                _countResourceBlock._btnPlus.filter = filter;
                return;
            }
            if (booleanMinus == false) return; else {
                if (_countResourceBlock.count == 1) {
                    booleanMinus = false;
                    if (_countMoneyBlock.count == 1 || 0 >= _countMoneyBlock.count - g.dataResource.objectResources[_curResourceId].costMax / 3 + 1) {
                        _countMoneyBlock.count = 1;
                        _countResourceBlock._btnMinus.filter = filter;
                        return;
                    }
                    _countMoneyBlock.count = _countMoneyBlock.count - g.dataResource.objectResources[_curResourceId].costMax / 3 + 1;
                    _countResourceBlock._btnMinus.filter = filter;
                    return;
                } else _countResourceBlock._btnMinus.filter = null;
            }
            if (_countMoneyBlock.count == 1 || 0 >= _countMoneyBlock.count - g.dataResource.objectResources[_curResourceId].costMax / 3 + 1) {
                _countMoneyBlock.count = 1;
                return;
            }
            booleanMinus = true;
            _countMoneyBlock.count = _countMoneyBlock.count - g.dataResource.objectResources[_curResourceId].costMax / 3 + 1;
        }

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
//            g.woMarket.refreshMarket();
            _countResourceBlock.count = 0;
            _countMoneyBlock.count = 0;
        }
    }

}
}
