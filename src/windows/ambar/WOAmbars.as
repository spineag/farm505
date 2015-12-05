/**
 * Created by user on 11/24/15.
 */
package windows.ambar {
import com.junkbyte.console.Cc;

import flash.filters.GlowFilter;

import manager.ManagerFilters;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;

import windows.WOComponents.DefaultVerticalScrollSprite;
import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.WOButtonTexture;
import windows.Window;
import windows.WOComponents.WindowBackground;

public class WOAmbars extends Window {
    public static const AMBAR:int = 1;
    public static const SKLAD:int = 2;

    private var _cartonSprite:Sprite;
    private var _tabAmbar:Sprite;
    private var _tabSklad:Sprite;
    private var _cloneTabAmbar:CSprite;
    private var _cloneTabSklad:CSprite;
    private var _woBG:WindowBackground;
    private var _type:int;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrCells:Array;
    private var _birka:Birka;
    private var _progress:AmbarProgress;
    private var _txtCount:TextField;
    private var _btnShowUpdate:CSprite;
    private var _txtBtnShowUpdate:TextField;
    private var _btnBackFromUpdate:CSprite;
    private var _updateSprite:Sprite;
    private var _item1:UpdateItem;
    private var _item2:UpdateItem;
    private var _item3:UpdateItem;
    private var _btnMakeUpdate:CSprite;

    public function WOAmbars() {
        _woWidth = 538;
        _woHeight = 566;
        _arrCells = [];

        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('bt_close'), '');
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += _woWidth/2;
        _btnExit.y -= _woHeight/2;
        callbackClickBG = onClickExit;

        createWOElements();
        createWOUpdateElements();

        _birka = new Birka('Амбар', _source, _woWidth, _woHeight);
    }

    private function onClickExit(e:Event=null):void {
        unfillItems();
        hideIt();
    }

    public function showItWithParams(type:int):void {
        _type = type;
        showUsualState();
        checkTypes();
        fillItems();
        updateProgress();
        super.showIt();
    }

    private function createWOElements():void {
        _cloneTabAmbar = new CSprite();
        carton = new CartonBackground(122, 80);
        _cloneTabAmbar.addChild(carton);
        var im:Image = new Image(g.allData.atlas['buildAtlas'].getTexture("ambar"));
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
        _cloneTabAmbar.filter = ManagerFilters.SHADOW;
        _cloneTabAmbar.flatten();
        _source.addChild(_cloneTabAmbar);
        var fAmbar:Function = function():void {
           _type = AMBAR;
            updateItems();
            checkTypes();
            updateItemsForUpdate();
        };
        _cloneTabAmbar.endClickCallback = fAmbar;

        _cloneTabSklad = new CSprite();
        carton = new CartonBackground(122, 80);
        _cloneTabSklad.addChild(carton);
        im = new Image(g.allData.atlas['buildAtlas'].getTexture("sklad"));
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
        _cloneTabSklad.filter = ManagerFilters.SHADOW;
        _cloneTabSklad.flatten();
        _source.addChild(_cloneTabSklad);
        var fSklad:Function = function():void {
            _type = SKLAD;
            updateItems();
            checkTypes();
            updateItemsForUpdate();
        };
        _cloneTabSklad.endClickCallback = fSklad;

        _cartonSprite = new Sprite();
        var carton:CartonBackground = new CartonBackground(454, 332);
        _cartonSprite.addChild(carton);
        _cartonSprite.filter = ManagerFilters.SHADOW;
        _cartonSprite.x = -_woWidth/2 + 43;
        _cartonSprite.y = -_woHeight/2 + 96;

        _tabAmbar = new Sprite();
        carton = new CartonBackground(122, 80);
        _tabAmbar.addChild(carton);
        im = new Image(g.allData.atlas['buildAtlas'].getTexture("ambar"));
        MCScaler.scale(im, 41, 41);
        im.x = 12;
        im.y = 1;
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
        im = new Image(g.allData.atlas['buildAtlas'].getTexture("sklad"));
        MCScaler.scale(im, 40, 40);
        im.x = 10;
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

        _progress = new AmbarProgress();
        _progress.source.x = -_woWidth/2 + 271;
        _progress.source.y = -_woHeight/2 + 458;
        _source.addChild(_progress.source);

        _txtCount = new TextField(250, 67, "Вместимость: 888/8888", g.allData.fonts['BloggerBold'], 18, ManagerFilters.TEXT_ORANGE);
        _txtCount.hAlign = HAlign.LEFT;
        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
        _txtCount.x = -_woWidth/2 + 47;
        _txtCount.y = -_woHeight/2 + 473;
        _source.addChild(_txtCount);

        _btnShowUpdate = new CSprite();
        var t:Sprite = new WOButtonTexture(121, 40, WOButtonTexture.GREEN);
        _btnShowUpdate.addChild(t);
        _txtBtnShowUpdate = new TextField(90, 50, "Увеличить склад", g.allData.fonts['BloggerMedium'], 14, Color.WHITE);
        _txtBtnShowUpdate.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _txtBtnShowUpdate.x = 18;
        _txtBtnShowUpdate.y = -5;
        _btnShowUpdate.addChild(_txtBtnShowUpdate);
        _btnShowUpdate.x = -_woWidth/2 + 370;
        _btnShowUpdate.y = -_woHeight/2 + 489;
        _source.addChild(_btnShowUpdate);
        _btnShowUpdate.endClickCallback = showUpdateState;
    }

    private function createWOUpdateElements():void {
        _btnBackFromUpdate = new CSprite();
        var t:Sprite = new WOButtonTexture(121, 40, WOButtonTexture.GREEN);
        _btnBackFromUpdate.addChild(t);
        var txt:TextField = new TextField(90, 50, "Назад", g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        txt.x = 18;
        txt.y = -4;
        _btnBackFromUpdate.addChild(txt);
        _btnBackFromUpdate.x = -_woWidth/2 + 370;
        _btnBackFromUpdate.y = -_woHeight/2 + 489;
        _source.addChild(_btnBackFromUpdate);
        _btnBackFromUpdate.endClickCallback = showUsualState;

        _updateSprite = new Sprite();
        _item1 = new UpdateItem();
        _item2 = new UpdateItem();
        _item3 = new UpdateItem();
        _item1.onBuyCallback = checkUpdateBtn;
        _item2.onBuyCallback = checkUpdateBtn;
        _item3.onBuyCallback = checkUpdateBtn;
        _item1.source.x = 17;
        _item2.source.x = 150;
        _item3.source.x = 283;
        _item1.source.y = 20;
        _item2.source.y = 20;
        _item3.source.y = 20;
        _updateSprite.addChild(_item1.source);
        _updateSprite.addChild(_item2.source);
        _updateSprite.addChild(_item3.source);
        txt = new TextField(284,45,'Необходимые материалы',g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 59;
        txt.y = -35;
        _updateSprite.addChild(txt);

        _btnMakeUpdate = new CSprite();
        t = new WOButtonTexture(121, 40, WOButtonTexture.BLUE);
        _btnMakeUpdate.addChild(t);
        txt = new TextField(90, 50, "Увеличить", g.allData.fonts['BloggerMedium'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = 17;
        txt.y = -4;
        _btnMakeUpdate.addChild(txt);
        _btnMakeUpdate.x = 141;
        _btnMakeUpdate.y = 190;
        _updateSprite.addChild(_btnMakeUpdate);
        _btnMakeUpdate.endClickCallback = onUpdate;

        _updateSprite.x = - _updateSprite.width/2 - 10;
        _updateSprite.y = - 150;
        _source.addChild(_updateSprite);
    }

    private function checkTypes():void {
        switch (_type) {
            case AMBAR:
                _cloneTabAmbar.visible = false;
                _tabAmbar.visible = true;
                _cloneTabSklad.visible = true;
                _tabSklad.visible = false;
                _birka.updateText('Амбар');
                _txtBtnShowUpdate.text = 'Увеличить амбар';
                break;
            case SKLAD:
                _cloneTabSklad.visible = false;
                _tabSklad.visible = true;
                _cloneTabAmbar.visible = true;
                _tabAmbar.visible = false;
                _birka.updateText('Склад');
                _txtBtnShowUpdate.text = 'Увеличить склад';
                break;
        }
    }

    private function fillItems():void {
        var cell:AmbarCell;
        try {
            var arr:Array;
            if (_type == AMBAR) arr = g.userInventory.getResourcesForAmbar();
                else arr = g.userInventory.getResourcesForSklad();
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

    private function updateItems():void {
        unfillItems();
        fillItems();
        updateProgress();
    }

    public function updateProgress():void {
        var a:int;
        _progress.showAmbarIcon(_type == AMBAR);
        switch (_type) {
            case AMBAR:
                a = g.userInventory.currentCountInAmbar;
                _progress.setProgress(a/g.user.ambarMaxCount);
                _txtCount.text = 'Вместимость: ' + String(a) + '/' + String(g.user.ambarMaxCount);
                break;
            case SKLAD:
                a = g.userInventory.currentCountInSklad;
                _progress.setProgress(a/g.user.skladMaxCount);
                _txtCount.text = 'Вместимость: ' + String(a) + '/' + String(g.user.skladMaxCount);
                break;
        }
    }

    private function showUpdateState():void {
        _scrollSprite.source.visible = false;
        _btnShowUpdate.visible = false;
        _updateSprite.visible = true;
        _btnBackFromUpdate.visible = true;
        updateItemsForUpdate();
    }

    private function updateItemsForUpdate():void {
        if (_type == AMBAR) {
            _item1.updateIt(g.dataBuilding.objectBuilding[12].upInstrumentId1, true);
            _item2.updateIt(g.dataBuilding.objectBuilding[12].upInstrumentId2, true);
            _item3.updateIt(g.dataBuilding.objectBuilding[12].upInstrumentId3, true);
        } else {
            _item1.updateIt(g.dataBuilding.objectBuilding[13].upInstrumentId1, false);
            _item2.updateIt(g.dataBuilding.objectBuilding[13].upInstrumentId2, false);
            _item3.updateIt(g.dataBuilding.objectBuilding[13].upInstrumentId3, false);
        }
        checkUpdateBtn();
    }

    private function showUsualState():void {
        _scrollSprite.source.visible = true;
        _btnShowUpdate.visible = true;
        _updateSprite.visible = false;
        _btnBackFromUpdate.visible = false;
    }

    private function checkUpdateBtn():void {
        if (_item1.isFull && _item2.isFull && _item3.isFull) {
            _btnMakeUpdate.visible = true;
        } else {
            _btnMakeUpdate.visible = false;
        }
    }

    private function onUpdate():void {
        var needCountForUpdate:int;
        var st:String;
        if (_type == AMBAR) {
            needCountForUpdate = g.dataBuilding.objectBuilding[12].startCountInstrumets + g.dataBuilding.objectBuilding[12].deltaCountAfterUpgrade * (g.user.ambarLevel - 1);
            g.userInventory.addResource(g.dataBuilding.objectBuilding[12].upInstrumentId1, -needCountForUpdate);
            g.userInventory.addResource(g.dataBuilding.objectBuilding[12].upInstrumentId2, -needCountForUpdate);
            g.userInventory.addResource(g.dataBuilding.objectBuilding[12].upInstrumentId3, -needCountForUpdate);
            g.user.ambarLevel++;
            g.user.ambarMaxCount += g.dataBuilding.objectBuilding[12].deltaCountResources;
            st = 'ВМЕСТИМОСТЬ: ' + g.userInventory.currentCountInAmbar + '/' + g.user.ambarMaxCount;
            _progress.setProgress(g.userInventory.currentCountInAmbar / g.user.ambarMaxCount);
            g.directServer.updateUserAmbar(1, g.user.ambarLevel, g.user.ambarMaxCount, null);
        } else {
            needCountForUpdate = g.dataBuilding.objectBuilding[13].startCountInstrumets + g.dataBuilding.objectBuilding[13].deltaCountAfterUpgrade * (g.user.skladLevel - 1);
            g.userInventory.addResource(g.dataBuilding.objectBuilding[13].upInstrumentId1, -needCountForUpdate);
            g.userInventory.addResource(g.dataBuilding.objectBuilding[13].upInstrumentId2, -needCountForUpdate);
            g.userInventory.addResource(g.dataBuilding.objectBuilding[13].upInstrumentId3, -needCountForUpdate);
            g.user.skladLevel++;
            g.user.skladMaxCount += g.dataBuilding.objectBuilding[13].deltaCountResources;
            st = 'ВМЕСТИМОСТЬ: ' + g.userInventory.currentCountInSklad + '/' + g.user.skladMaxCount;
            _progress.setProgress(g.userInventory.currentCountInSklad / g.user.skladMaxCount);
            g.directServer.updateUserAmbar(2, g.user.skladLevel, g.user.skladMaxCount, null);
        }
        _txtCount.text = st;
        unfillItems();
        fillItems();
        updateItemsForUpdate();
    }

    public function smallUpdate():void {
        if (_type == SKLAD) {
            _txtCount.text = 'ВМЕСТИМОСТЬ: ' + g.userInventory.currentCountInSklad + '/' + g.user.skladMaxCount;
            _progress.setProgress(g.userInventory.currentCountInSklad / g.user.skladMaxCount);
            unfillItems();
            fillItems();
        }
    }
}
}
