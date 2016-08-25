/**
 * Created by user on 11/24/15.
 */
package windows.ambar {
import com.junkbyte.console.Cc;
import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Sprite;
import starling.filters.DropShadowFilter;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import windows.WOComponents.DefaultVerticalScrollSprite;
import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOAmbars extends WindowMain {
    public static const AMBAR:int = 1;
    public static const SKLAD:int = 2;

    private var _mainSprite:Sprite;
    private var _tabAmbar:CSprite;
    private var _tabSklad:CSprite;
    private var _cartonAmbar:CartonBackground;
    private var _cartonSklad:CartonBackground;
    private var _cartonBG:CartonBackground;
    private var _woBG:WindowBackground;
    private var _type:int;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrCells:Array;
    private var _birka:Birka;
    private var _progress:AmbarProgress;
    private var _txtCount:TextField;
    private var _btnShowUpdate:CButton;
    private var _txtBtnShowUpdate:TextField;
    private var _btnBackFromUpdate:CButton;
    private var _updateSprite:Sprite;
    private var _item1:UpdateItem;
    private var _item2:UpdateItem;
    private var _item3:UpdateItem;
    private var _btnMakeUpdate:CButton;
    private var _defaultY:int = -232;
    private var _SHADOW:DropShadowFilter;

    public function WOAmbars() {
        super();
        _windowType = WindowsManager.WO_AMBAR;
        _woWidth = 538;
        _woHeight = 566;
        _arrCells = [];
        _SHADOW = ManagerFilters.NEW_SHADOW;

        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        createWOElements();
        createWOUpdateElements();

        _birka = new Birka('Амбар', _source, _woWidth, _woHeight);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _type = params[0];
        showUsualState();
        checkTypes();
        fillItems();
        updateProgress();
        if (params[1]) { // if params[1] exist - its mean show updateState
            showUpdateState();
        }
        super.showIt();
    }

    private function createWOElements():void {
        _tabAmbar = new CSprite();
        _cartonAmbar = new CartonBackground(122, 80);
        _tabAmbar.addChild(_cartonAmbar);
        var im:Image = new Image(g.allData.atlas['iconAtlas'].getTexture("ambar_icon"));
        MCScaler.scale(im, 41, 41);
        im.x = 12;
        im.y = 1;
        _tabAmbar.addChild(im);
        var txt:TextField = new TextField(90, 40, "Амбар");
        txt.format.setTo(g.allData.bFonts['BloggerBold18'], 18, Color.WHITE);
        txt.x = 31;
        txt.y = 2;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_BROWN_COLOR);
        _tabAmbar.addChild(txt);
        _tabAmbar.x = -205;
        _tabAmbar.y = _defaultY;
        var fAmbar:Function = function():void {
           _type = AMBAR;
            updateItems();
            checkTypes();
            updateItemsForUpdate();
            g.user.visitAmbar = true;
        };
        var hAmbar:Function = function():void {
            _tabAmbar.y = _defaultY + 3;
        };
        var oAmbar:Function = function():void {
            _tabAmbar.y = _defaultY + 10;
        };
        _tabAmbar.endClickCallback = fAmbar;
        _tabAmbar.hoverCallback = hAmbar;
        _tabAmbar.outCallback = oAmbar;

        _tabSklad = new CSprite();
        _cartonSklad = new CartonBackground(122, 80);
        _tabSklad.addChild(_cartonSklad);
        im = new Image(g.allData.atlas['iconAtlas'].getTexture("sklad_icon"));
        MCScaler.scale(im, 40, 40);
        im.x = 12;
        im.y = 2;
        _tabSklad.addChild(im);
        txt = new TextField(90, 40, "Склад");
        txt.format.setTo(g.allData.bFonts['BloggerBold18'], 18, Color.WHITE);
        txt.x = 34;
        txt.y = 2;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_BROWN_COLOR);
        _tabSklad.addChild(txt);
        _tabSklad.x = -75;
        _tabSklad.y = _defaultY;
        var fSklad:Function = function():void {
            _type = SKLAD;
            updateItems();
            checkTypes();
            updateItemsForUpdate();
            g.user.visitAmbar = false;
        };

        var hSklad:Function = function():void {
            _tabSklad.y = _defaultY + 3;
        };
        var oSklad:Function = function():void {
            _tabSklad.y = _defaultY + 10;
        };
        _tabSklad.endClickCallback = fSklad;
        _tabSklad.hoverCallback = hSklad;
        _tabSklad.outCallback = oSklad;

        _mainSprite = new Sprite();
        _cartonBG = new CartonBackground(454, 332);
        _mainSprite.addChild(_cartonBG);
        _mainSprite.filter = _SHADOW;
        _mainSprite.x = -_woWidth/2 + 43;
        _mainSprite.y = -_woHeight/2 + 96;

        _source.addChild(_mainSprite);

        _scrollSprite = new DefaultVerticalScrollSprite(405, 303, 101, 101);
        _scrollSprite.source.x = 55 - _woWidth/2;
        _scrollSprite.source.y = 107 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(423, 0, 303, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));

        _progress = new AmbarProgress();
        _progress.source.x = -_woWidth/2 + 271;
        _progress.source.y = -_woHeight/2 + 458;
        _source.addChild(_progress.source);

        _txtCount = new TextField(250, 67, "Вместимость: 0/0");
        _txtCount.format.setTo(g.allData.bFonts['BloggerBold18'], 18, ManagerFilters.TEXT_ORANGE_COLOR);
        _txtCount.format.horizontalAlign = Align.LEFT;
        _txtCount.x = -_woWidth/2 + 47;
        _txtCount.y = -_woHeight/2 + 473;
        ManagerFilters.setStrokeStyle(_txtCount, Color.WHITE);
        _source.addChild(_txtCount);

        _btnShowUpdate = new CButton();
        _btnShowUpdate.addButtonTexture(120, 40, CButton.GREEN, true);
        _btnShowUpdate.x = -_woWidth/2 + 430;
        _btnShowUpdate.y = -_woHeight/2 + 514;
        _txtBtnShowUpdate = new TextField(90, 50, "Увеличить склад");
        _txtBtnShowUpdate.format.setTo(g.allData.bFonts['BloggerMedium14'], 14, Color.WHITE);
        _txtBtnShowUpdate.x = 18;
        _txtBtnShowUpdate.y = -5;
        ManagerFilters.setStrokeStyle(_txtBtnShowUpdate, ManagerFilters.TEXT_GREEN_COLOR);
        _btnShowUpdate.addChild(_txtBtnShowUpdate);
        _source.addChild(_btnShowUpdate);
        _btnShowUpdate.clickCallback = showUpdateState;
    }

    private function createWOUpdateElements():void {
        _btnBackFromUpdate = new CButton();
        _btnBackFromUpdate.addButtonTexture(120, 40, CButton.BLUE, true);
        var txt:TextField = new TextField(90, 50, "Назад");
        txt.format.setTo(g.allData.bFonts['BloggerMedium18'], 16, Color.WHITE);
        txt.x = 18;
        txt.y = -4;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_BLUE_COLOR);
        _btnBackFromUpdate.addChild(txt);
        _btnBackFromUpdate.x = -_woWidth/2 + 430;
        _btnBackFromUpdate.y = -_woHeight/2 + 514;
        _source.addChild(_btnBackFromUpdate);
        _btnBackFromUpdate.clickCallback = showUsualState;

        _updateSprite = new Sprite();
        _item1 = new UpdateItem(this);
        _item2 = new UpdateItem(this);
        _item3 = new UpdateItem(this);
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
        txt = new TextField(284,45,'Необходимые материалы');
        txt.format.setTo(g.allData.bFonts['BloggerMedium18'],18,Color.WHITE);
        txt.x = 59;
        txt.y = -35;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_BROWN_COLOR);
        _updateSprite.addChild(txt);

        _btnMakeUpdate = new CButton();
        _btnMakeUpdate.addButtonTexture(120, 40, CButton.BLUE, true);
        txt = new TextField(90, 50, "Увеличить");
        txt.format.setTo(g.allData.bFonts['BloggerMedium18'], 18, Color.WHITE);
        txt.x = 17;
        txt.y = -4;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_BLUE_COLOR);
        _btnMakeUpdate.addChild(txt);
        _btnMakeUpdate.x = 201;
        _btnMakeUpdate.y = 220;
        _updateSprite.addChild(_btnMakeUpdate);
        _btnMakeUpdate.registerTextField(txt);
        _btnMakeUpdate.clickCallback = onUpdate;

        _updateSprite.x = - _updateSprite.width/2 - 10;
        _updateSprite.y = - 155;
        _source.addChild(_updateSprite);
    }

    private function checkTypes():void {
        _tabAmbar.filter = null;
        _tabSklad.filter = null;
        if (_source.contains(_tabAmbar)) _source.removeChild(_tabAmbar);
        if (_mainSprite.contains(_tabAmbar)) _mainSprite.removeChild(_tabAmbar);
        if (_source.contains(_tabSklad)) _source.removeChild(_tabSklad);
        if (_mainSprite.contains(_tabSklad)) _mainSprite.removeChild(_tabSklad);
        switch (_type) {
            case AMBAR:
                _mainSprite.addChild(_tabAmbar);
                _tabAmbar.x = -205 - _mainSprite.x;
                _tabAmbar.y = _defaultY - _mainSprite.y;
                _tabAmbar.isTouchable = false;
                _source.addChildAt(_tabSklad, _source.getChildIndex(_mainSprite)-1);
                _tabSklad.x = -75;
                _tabSklad.y = _defaultY + 10;
                _tabSklad.isTouchable = true;
                _tabSklad.filter = _SHADOW;
                _birka.updateText('Амбар');
                _txtBtnShowUpdate.text = 'Увеличить амбар';
                break;
            case SKLAD:
                _mainSprite.addChild(_tabSklad);
                _tabSklad.x = -75 - _mainSprite.x;
                _tabSklad.y = _defaultY - _mainSprite.y;
                _tabSklad.isTouchable = false;
                _source.addChildAt(_tabAmbar, _source.getChildIndex(_mainSprite)-1);
                _tabAmbar.x = -205;
                _tabAmbar.y = _defaultY + 10;
                _tabAmbar.isTouchable = true;
                _tabAmbar.filter = _SHADOW;
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
//                /////// AHTUNG AAAAAAAHHHHHHTUUUUUUNNGGGGGGGGGGGGGGGG_@#)#$@#)$@_#$)2#_$) Костыль минусовое число обнуляет !!!!!!!!!!!! АХТУНГГГГГГГГГГГГ
//                if (arr[i].count < 0) {
//                    g.userInventory.addResource(arr[i].id, -arr[i].count);
//                } else { //////////////////// ДО ЭТОГО МОМЕНТААААА АХТУУУУУУНННННГГГГ
                    cell = new AmbarCell(arr[i]);
                    _arrCells.push(cell);
                    _scrollSprite.addNewCell(cell.source);
//                }
            }
        } catch(e:Error) {
            Cc.error('WOAmbar fillItems:: error ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woAmbar');
        }
    }

    private function unfillItems():void {
        _scrollSprite.resetAll();
        for (var i:int = 0; i < _arrCells.length; i++) {
            _arrCells[i].deleteIt();
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

    public function showUpdateState():void {
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
            _btnMakeUpdate.setEnabled = true;
        } else {
            _btnMakeUpdate.setEnabled = false;
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

        if (_type == AMBAR) {
            g.updateAmbarIndicator();
        }
    }

    public function smallUpdate():void {  // after buy resources for update
        if (_type == SKLAD) {
            _txtCount.text = 'ВМЕСТИМОСТЬ: ' + g.userInventory.currentCountInSklad + '/' + g.user.skladMaxCount;
            _progress.setProgress(g.userInventory.currentCountInSklad / g.user.skladMaxCount);
            unfillItems();
            fillItems();
        }
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        unfillItems();
        _tabAmbar.filter = null;
        _tabSklad.filter = null;
        _mainSprite.filter = null;
        if (_source.contains(_tabAmbar)) _source.removeChild(_tabAmbar);
        if (_mainSprite.contains(_tabAmbar)) _mainSprite.removeChild(_tabAmbar);
        if (_source.contains(_tabSklad)) _source.removeChild(_tabSklad);
        if (_mainSprite.contains(_tabSklad)) _mainSprite.removeChild(_tabSklad);
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _tabAmbar.removeChild(_cartonAmbar);
        _cartonAmbar.deleteIt();
        _cartonAmbar = null;
        _tabAmbar.deleteIt();
        _tabAmbar = null;
        _tabSklad.removeChild(_cartonSklad);
        _cartonSklad.deleteIt();
        _cartonSklad = null;
        _tabSklad.deleteIt();
        _tabSklad = null;
        _source.removeChild(_scrollSprite.source);
        _scrollSprite.deleteIt();
        _scrollSprite = null;
        _source.removeChild(_progress.source);
        _progress.deleteIt();
        _progress = null;
        _source.removeChild(_btnShowUpdate);
        _btnShowUpdate.deleteIt();
        _btnShowUpdate = null;
        _updateSprite.removeChild(_item1.source);
        _updateSprite.removeChild(_item2.source);
        _updateSprite.removeChild(_item3.source);
        _item1.deleteIt();
        _item2.deleteIt();
        _item3.deleteIt();
        _item1 = null;
        _item2 = null;
        _item3 = null;
        _source.removeChild(_btnBackFromUpdate);
        _btnBackFromUpdate.deleteIt();
        _btnBackFromUpdate = null;
        _updateSprite.removeChild(_btnMakeUpdate);
        _btnMakeUpdate.deleteIt();
        _btnMakeUpdate = null;
        _source.removeChild(_birka);
        _birka.deleteIt();
        _birka = null;
        super.deleteIt();
    }
}
}
