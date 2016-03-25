package windows.market {

import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.Birka;

import windows.WOComponents.CartonBackground;

import windows.WOComponents.DefaultVerticalScrollSprite;

import utils.CButton;

import windows.WOComponents.WindowBackground;

import windows.Window;
import windows.WindowsManager;
import windows.ambar.AmbarCell;

public class WOMarketChoose extends Window {
    public static const AMBAR:int = 1;
    public static const SKLAD:int = 2;

    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrCells:Array;
    private var _callback:Function;
    private var _btnSell:CButton;

    private var _cloneTabAmbar:CSprite;
    private var _cloneTabSklad:CSprite;
    private var _cartonSprite:Sprite;
    private var _type:int;
    private var _tabAmbar:Sprite;
    private var _tabSklad:Sprite;
    private var _birka:Birka;


    private var _countResourceBlock:CountBlock;
    private var _countMoneyBlock:CountBlock;
    private var _curResourceId:int;
    private var _checkBox:MarketCheckBox;
    private var booleanPlus:Boolean;
    private var booleanMinus:Boolean;
    private var _woBG:WindowBackground;

    public function WOMarketChoose() {
        super();

        _woHeight = 570;
        _woWidth = 534;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        booleanPlus = true;
        booleanMinus = true;
        createWOElements();
        _birka = new Birka('Амбар', _source, _woWidth, _woHeight);
        _arrCells = [];
        _scrollSprite = new DefaultVerticalScrollSprite(405, 303, 101, 101);
        _scrollSprite.source.x = 55 - _woWidth/2;
        _scrollSprite.source.y = 107 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(423, 0, 303, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));

        _countResourceBlock = new CountBlock();
        _countResourceBlock.setWidth = 50;
        _countResourceBlock.source.x = -80;
        _countResourceBlock.source.y = 180;
        _countMoneyBlock = new CountBlock();
        _countMoneyBlock.setWidth = 50;
        _countMoneyBlock.source.x = 80;
        _countMoneyBlock.source.y = 180;
        _source.addChild(_countMoneyBlock.source);
        _source.addChild(_countResourceBlock.source);

        var t:TextField = new TextField(100, 30, 'Количество:',  g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        t.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        t.x = -190;
        t.y = 145;
        _source.addChild(t);
        t = new TextField(150, 30, 'Цена продажи:', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        t.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        t.x = -55;
        t.y = 145;
        _source.addChild(t);

        _btnSell = new CButton();
        _btnSell.addButtonTexture(108, 96, CButton.GREEN, true);
        var im:Image  = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_market'));
        im.x = 10;
        _btnSell.addChild(im);
        t = new TextField(100, 50, 'Выставить на продажу', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        t.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        t.y = 45;
        _btnSell.addChild(t);
        _btnSell.x = 160;
        _btnSell.y = 190;
        _source.addChild(_btnSell);
//        _btnSell.filter = filter;
        _btnSell.clickCallback = onClickBtnSell;

//        _checkBox = new MarketCheckBox();
//        _checkBox.source.x = -180;
//        _checkBox.source.y = 205;
//        _source.addChild(_checkBox.source);

        _callbackClickBG = onClickExit;
    }

    override public function showIt():void {
        _type = AMBAR;
        checkTypes();
        fillItems();
        super.showIt();
    }

    private function createWOElements():void {
        _cloneTabAmbar = new CSprite();
        carton = new CartonBackground(122, 80);
        _cloneTabAmbar.addChild(carton);
        var im:Image = new Image(g.allData.atlas['iconAtlas'].getTexture("ambar_icon"));
        MCScaler.scale(im, 41, 41);
        im.x = 12;
        im.y = 1;
        _cloneTabAmbar.addChild(im);
        var txt:TextField = new TextField(90, 40, "Амбар", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 31;
        txt.y = 2;
        _cloneTabAmbar.addChild(txt);
        _cloneTabAmbar.x = -_woWidth/2 + 73;
        _cloneTabAmbar.y = -_woHeight/2 + 51;
        carton.filter = ManagerFilters.SHADOW;
        _cloneTabAmbar.flatten();
        _source.addChild(_cloneTabAmbar);
        var fAmbar:Function = function():void {
            _type = AMBAR;
            updateItems();
            checkTypes();
//            updateItemsForUpdate();
        };
        _cloneTabAmbar.endClickCallback = fAmbar;

        _cloneTabSklad = new CSprite();
        carton = new CartonBackground(122, 80);
        _cloneTabSklad.addChild(carton);
        im = new Image(g.allData.atlas['iconAtlas'].getTexture("sklad_icon"));
        MCScaler.scale(im, 40, 40);
        im.x = 12;
        im.y = 2;
        _cloneTabSklad.addChild(im);
        txt = new TextField(90, 40, "Склад", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 34;
        txt.y = 2;
        _cloneTabSklad.addChild(txt);
        _cloneTabSklad.x = -_woWidth/2 + 202;
        _cloneTabSklad.y = -_woHeight/2 + 51;
        carton.filter = ManagerFilters.SHADOW;
        _cloneTabSklad.flatten();
        _source.addChild(_cloneTabSklad);
        var fSklad:Function = function():void {
            _type = SKLAD;
            updateItems();
            checkTypes();
//            updateItemsForUpdate();
        };
        _cloneTabSklad.endClickCallback = fSklad;

        _cartonSprite = new Sprite();
        var carton:CartonBackground = new CartonBackground(454, 435);
        _cartonSprite.addChild(carton);
        _cartonSprite.filter = ManagerFilters.SHADOW;
        _cartonSprite.x = -_woWidth/2 + 43;
        _cartonSprite.y = -_woHeight/2 + 96;

        _tabAmbar = new Sprite();
        carton = new CartonBackground(122, 80);
        _tabAmbar.addChild(carton);
        im = new Image(g.allData.atlas['iconAtlas'].getTexture("ambar_icon"));
        MCScaler.scale(im, 40, 40);
        im.x = 12;
        im.y = 2;
        _tabAmbar.addChild(im);
        txt = new TextField(90, 40, "Амбар", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 31;
        txt.y = 2;
        _tabAmbar.addChild(txt);
        _tabAmbar.x = 30;
        _tabAmbar.y = -48;
        _tabAmbar.flatten();
        _cartonSprite.addChild(_tabAmbar);

        _tabSklad = new Sprite();
        carton = new CartonBackground(122, 80);
        _tabSklad.addChild(carton);
        im = new Image(g.allData.atlas['iconAtlas'].getTexture("sklad_icon"));
        MCScaler.scale(im, 40, 40);
        im.x = 12;
        im.y = 2;
        _tabSklad.addChild(im);
        txt = new TextField(90, 40, "Склад", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 34;
        txt.y = 2;
        _tabSklad.addChild(txt);
        _tabSklad.x = 159;
        _tabSklad.y = -48;
        _tabSklad.flatten();
        _cartonSprite.addChild(_tabSklad);

        _source.addChild(_cartonSprite);

        _scrollSprite = new DefaultVerticalScrollSprite(405, 303, 101, 101);
        _scrollSprite.source.x = 55 - _woWidth/2;
        _scrollSprite.source.y = 107 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(423, 0, 303, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
    }

    private function checkTypes():void {
        switch (_type) {
            case AMBAR:
                _cloneTabAmbar.visible = false;
                _tabAmbar.visible = true;
                _cloneTabSklad.visible = true;
                _tabSklad.visible = false;
                _birka.updateText('Амбар');
                break;
            case SKLAD:
                _cloneTabSklad.visible = false;
                _tabSklad.visible = true;
                _cloneTabAmbar.visible = true;
                _tabAmbar.visible = false;
                _birka.updateText('Склад');
                break;
        }
    }

    private function fillItems():void {
        var cell:MarketCell;
        try {
            var arr:Array;
            if (_type == AMBAR) arr = g.userInventory.getResourcesForAmbar();
            else arr = g.userInventory.getResourcesForSklad();
            arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
            for (var i:int = 0; i < arr.length; i++) {
                cell = new MarketCell(arr[i]);
                cell.clickCallback = onCellClick;
                _arrCells.push(cell);
                _scrollSprite.addNewCell(cell.source);
            }
        } catch(e:Error) {
            Cc.error('WOAmbar fillItems:: error ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woMarketChoose');
        }
    }

    private function unfillItems():void {
        _scrollSprite.resetAll();
        for (var i:int = 0; i < _arrCells.length; i++) {
            _arrCells[i].clearIt();
        }
        _arrCells.length = 0;
    }

    private function updateItems():void {
        unfillItems();
        fillItems();
    }

//    private function updateItemsForUpdate():void {
//        if (_type == AMBAR) {
//            _item1.updateIt(g.dataBuilding.objectBuilding[12].upInstrumentId1, true);
//            _item2.updateIt(g.dataBuilding.objectBuilding[12].upInstrumentId2, true);
//            _item3.updateIt(g.dataBuilding.objectBuilding[12].upInstrumentId3, true);
//        } else {
//            _item1.updateIt(g.dataBuilding.objectBuilding[13].upInstrumentId1, false);
//            _item2.updateIt(g.dataBuilding.objectBuilding[13].upInstrumentId2, false);
//            _item3.updateIt(g.dataBuilding.objectBuilding[13].upInstrumentId3, false);
//        }
//        checkUpdateBtn();
//    }
//
//    private function showUsualState():void {
//        _scrollSprite.source.visible = true;
//        _btnShowUpdate.visible = true;
//        _updateSprite.visible = false;
//        _btnBackFromUpdate.visible = false;
//    }
//
//    private function checkUpdateBtn():void {
//        if (_item1.isFull && _item2.isFull && _item3.isFull) {
//            _btnMakeUpdate.setEnabled = true;
//        } else {
//            _btnMakeUpdate.setEnabled = false;
//        }
//    }

    public function set callback(f:Function):void {
        _callback = f;
    }

    private function onClickExit(e:Event=null):void {
        g.woMarket.refreshMarket();
//        _btnSell.filter = filter;
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



//    private function fillItems():void {
//        var cell:MarketCell;
//        var arr:Array = g.userInventory.getResourcesForAmbar();
//        var arr2:Array = g.userInventory.getResourcesForSklad();
//        arr = arr.concat(arr2);
//        arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
//        for (var i:int = 0; i < arr.length; i++) {
//            cell = new MarketCell(arr[i]);
//            cell.clickCallback = onCellClick;
//            _arrCells.push(cell);
//            _scrollSprite.addNewCell(cell.source);
//        }
//    }
//

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
        _countMoneyBlock.count =  count * g.dataResource.objectResources[_curResourceId].costDefault;
        if (countRes == 1) {
//            _countResourceBlock._btnMinus.filter = filter;
//            _countResourceBlock._btnPlus.filter = filter;
        } else if (_countResourceBlock.count == 10) {
//            _countResourceBlock._btnPlus.filter = filter;
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
//                _countResourceBlock._btnMinus.filter = filter;
//                _countResourceBlock._btnPlus.filter = filter;
                return;
            }
            if (booleanPlus == false) return; else {
                if (_countResourceBlock.count == 10 || _countResourceBlock.count == countRes) {
                    booleanPlus = false;
                    _countMoneyBlock.count = _countMoneyBlock.count + g.dataResource.objectResources[_curResourceId].costDefault;
//                    _countResourceBlock._btnPlus.filter = filter;
                    return;
                } else _countResourceBlock._btnPlus.filter = null;
            }
            booleanPlus = true;
            _countMoneyBlock.count = _countMoneyBlock.count + g.dataResource.objectResources[_curResourceId].costDefault;
        } else {
            booleanPlus = true;
            if (_countMoneyBlock.count == _countResourceBlock.count * g.dataResource.objectResources[_curResourceId].costMax) {
//                _countMoneyBlock._btnPlus.filter = filter;
                return;
            }
            if (countRes == 1) {
//                _countResourceBlock._btnMinus.filter = filter;
//                _countResourceBlock._btnPlus.filter = filter;
                return;
            }
            if (booleanMinus == false) return; else {
                if (_countResourceBlock.count == 1) {
                    booleanMinus = false;
                    if (_countMoneyBlock.count == 1 || 0 >= _countMoneyBlock.count - g.dataResource.objectResources[_curResourceId].costDefault) {
                        _countMoneyBlock.count = 1;
//                        _countResourceBlock._btnMinus.filter = filter;
                        return;
                    }
                    _countMoneyBlock.count = _countMoneyBlock.count - g.dataResource.objectResources[_curResourceId].costDefault;
//                    _countResourceBlock._btnMinus.filter = filter;
                    return;
                } else _countResourceBlock._btnMinus.filter = null;
            }
            if (_countMoneyBlock.count == 1 || 0 >= _countMoneyBlock.count - g.dataResource.objectResources[_curResourceId].costDefault) {
                _countMoneyBlock.count = 1;
                return;
            }
            booleanMinus = true;
            _countMoneyBlock.count = _countMoneyBlock.count - g.dataResource.objectResources[_curResourceId].costDefault;
        }

    }

    private function onClickBtnSell(resource:Boolean = false):void {
        g.woMarket.refreshMarket();
        if (_curResourceId > 0) {
            if (!resource) {
                if (g.dataResource.objectResources[_curResourceId].buildType == BuildType.PLANT && _countResourceBlock.count == g.userInventory.getCountResourceById(_curResourceId)) {
                    g.woLastResource.showItMarket(_curResourceId,onClickBtnSell);
                return;
                }
            }
            unfillItems();
            _scrollSprite.resetAll();
            hideIt();
            if (_callback != null) {
                _callback.apply(null, [_curResourceId, _countResourceBlock.count, _countMoneyBlock.count]);
                _callback = null;
            }
            _countResourceBlock.count = 0;
            _countMoneyBlock.count = 0;
        }
    }

}
}
