package windows.market {
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.DropShadowFilter;
import starling.text.TextField;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.DefaultVerticalScrollSprite;
import utils.CButton;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOMarketChoose extends WindowMain {
    public static const AMBAR:int = 1;
    public static const SKLAD:int = 2;

    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrCells:Array;
    private var _callback:Function;
    private var _btnSell:CButton;
    private var _tabAmbar:CSprite;
    private var _tabSklad:CSprite;
    private var _mainSprite:Sprite;
    private var _type:int;
    private var _birka:Birka;
    private var _countResourceBlock:CountBlock;
    private var _countMoneyBlock:CountBlock;
    private var _curResourceId:int;
    private var booleanPlus:Boolean;
    private var booleanMinus:Boolean;
    private var _woBG:WindowBackground;
    private var _defaultY:int = -232;
    private var _cartonAmbar:CartonBackground;
    private var _cartonSklad:CartonBackground;
    private var _carton:CartonBackground;
    private var _activetedItem:MarketItem;
    private var _txtCount:CTextField;
    private var _txtPrice:CTextField;
    private var _txtSellBtn:CTextField;
    private var _txtAmbar:CTextField;
    private var _txtSklad:CTextField;

    public function WOMarketChoose() {
        super();
        _windowType = WindowsManager.WO_MARKET_CHOOSE;
        _woWidth = 534;
        _woHeight = 570;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
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

        _txtCount = new CTextField(100, 30, 'Количество:');
        _txtCount.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtCount.x = -190;
        _txtCount.y = 145;
        _source.addChild(_txtCount);
        _txtPrice = new CTextField(150, 30, 'Цена продажи:');
        _txtPrice.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtPrice.x = -55;
        _txtPrice.y = 145;
        _source.addChild(_txtPrice);

        _btnSell = new CButton();
        _btnSell.addButtonTexture(108, 96, CButton.GREEN, true);
        var im:Image  = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_market'));
        im.x = 10;
        _btnSell.addChild(im);
        _txtSellBtn = new CTextField(108, 50, 'Выставить на продажу');
        _txtSellBtn.setFormat(CTextField.BOLD18, 15, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtSellBtn.leading = -2;
        _txtSellBtn.y = 45;
        _txtSellBtn.x = 2;
        _btnSell.addChild(_txtSellBtn);
        _btnSell.x = 160;
        _btnSell.y = 190;
        _source.addChild(_btnSell);
        _btnSell.clickCallback = onClickBtnSell;
        _callbackClickBG = onClickExit;
    }

    override public function showItParams(callback:Function, params:Array):void {
        _callback = callback;
        _activetedItem = params[0];
        if (g.user.lastVisitAmbar) _type = AMBAR;
        else _type = SKLAD;
        checkTypes();
        fillItems();
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
        _txtAmbar = new CTextField(90, 40, "Амбар");
        _txtAmbar.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtAmbar.touchable = true;
        _txtAmbar.x = 31;
        _txtAmbar.y = 2;
        _tabAmbar.addChild(_txtAmbar);
        _tabAmbar.x = -205;
        _tabAmbar.y = _defaultY;
        var fAmbar:Function = function():void {
            _type = AMBAR;
            updateItems();
            checkTypes();
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
        _txtSklad = new CTextField(90, 40, "Склад");
        _txtSklad.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtSklad.touchable = true;
        _txtSklad.x = 34;
        _txtSklad.y = 2;
        _tabSklad.addChild(_txtSklad);
        _tabSklad.x = -75;
        _tabSklad.y = _defaultY;
        var fSklad:Function = function():void {
            _type = SKLAD;
            updateItems();
            checkTypes();
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
        _carton = new CartonBackground(454, 435);
        _mainSprite.addChild(_carton);
        _mainSprite.filter = ManagerFilters.SHADOW;
        _mainSprite.x = -_woWidth/2 + 43;
        _mainSprite.y = -_woHeight/2 + 96;

        _source.addChild(_mainSprite);

        _scrollSprite = new DefaultVerticalScrollSprite(405, 303, 101, 101);
        _scrollSprite.source.x = 55 - _woWidth/2;
        _scrollSprite.source.y = 107 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(423, 0, 303, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
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
                _tabSklad.filter = ManagerFilters.SHADOW;
                _birka.updateText('Амбар');
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
                _tabAmbar.filter = ManagerFilters.SHADOW;
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
            g.windowsManager.uncasheWindow();
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woMarketChoose');
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
    }

    private function onClickExit(e:Event=null):void {
        if (_callback != null) {
            _callback.apply(null, [_activetedItem, 0]);
            _callback = null;
        }
        super.hideIt();
    }

    private function onCellClick(a:int):void {
        _curResourceId = a;
//        _btnSell.filter = null;
//        _countResourceBlock.btnNull();
        _countMoneyBlock.count = 0;
        _countResourceBlock.count = 0;
        booleanMinus = true;
        booleanPlus = true;
        _countResourceBlock._btnMinus.setEnabled = true;
        _countResourceBlock._btnPlus.setEnabled = true;
        _countMoneyBlock._btnPlus.setEnabled = true;
        _countMoneyBlock._btnMinus.setEnabled = true;
//        _countMoneyBlock.btnNull();
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
        _countMoneyBlock.maxValue = count * g.allData.resource[_curResourceId].costMax;
        _countMoneyBlock.minValue =  count * g.allData.resource[_curResourceId].costDefault;
        _countMoneyBlock.count =  count * g.allData.resource[_curResourceId].costDefault;
//        _countMoneyBlock._btnMinus.filter =  ManagerFilters.BUTTON_DISABLE_FILTER;
        _countMoneyBlock._btnMinus.setEnabled = false;
        if (countRes == 1) {
//            _countResourceBlock._btnPlus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
//            _countResourceBlock._btnMinus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
            _countResourceBlock._btnMinus.setEnabled = false;
            _countResourceBlock._btnPlus.setEnabled = false;
        } else if (_countResourceBlock.count == 10) {
//            _countResourceBlock._btnPlus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
            _countResourceBlock._btnPlus.setEnabled = false;
        }
        if ( _countMoneyBlock.count <= 0){
            _countMoneyBlock.count = 1;
        }
    }

    private function onChangeResourceCount(onPlus:Boolean):void {
        var countRes:int = g.userInventory.getCountResourceById(_curResourceId);
        _countMoneyBlock.maxValue = _countResourceBlock.count * g.allData.resource[_curResourceId].costMax;
        _countMoneyBlock.minValue =  _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault;
//        var count:Boolean;
//        _countMoneyBlock.btnNull();
        if (onPlus) {
//            _countMoneyBlock.count = _countResourceBlock.count * g.dataResource.objectResources[_curResourceId].costDefault;
//            if (_countResourceBlock.count == 10 || _countResourceBlock.count == countRes) {
//
//            }
            booleanMinus = true;
//            _countMoneyBlock._btnPlus.filter = null;
            _countMoneyBlock._btnPlus.setEnabled = true;
            if (countRes == 1) {
//                _countResourceBlock.btnNull();
                _countResourceBlock._btnPlus.setEnabled = true;
                _countResourceBlock._btnMinus.setEnabled = true;
                return;
            }
            if (booleanPlus == false) return; else {
                if (_countResourceBlock.count == 10 || _countResourceBlock.count == countRes) {
                    booleanPlus = false;
                    _countMoneyBlock.count = _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault;
//                    _countResourceBlock._btnPlus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                    _countResourceBlock._btnPlus.setEnabled = true;
                    if (_countMoneyBlock.count == _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault) {
//                        _countMoneyBlock._btnMinus.filter =  ManagerFilters.BUTTON_DISABLE_FILTER;
                        _countMoneyBlock._btnMinus.setEnabled = true;
                    }
                    return;
                } else _countResourceBlock._btnPlus.setEnabled = true; //_countResourceBlock._btnPlus.filter = null;
            }
            booleanPlus = true;
            _countMoneyBlock.count = _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault;
            if (_countMoneyBlock.count == _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault) {
//                _countMoneyBlock._btnMinus.filter =  ManagerFilters.BUTTON_DISABLE_FILTER;
                _countMoneyBlock._btnMinus.setEnabled = false;
            }
        } else {
            booleanPlus = true;
            if (_countMoneyBlock.count == _countResourceBlock.count * g.allData.resource[_curResourceId].costMax) {
//                _countMoneyBlock._btnPlus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                _countMoneyBlock._btnPlus.setEnabled = false;
                return;
            }
            if (countRes == 1) {
//                _countResourceBlock.btnNull();
                _countResourceBlock._btnPlus.setEnabled = true;
                _countResourceBlock._btnMinus.setEnabled = true;
                return;
            }
            if (booleanMinus == false) return; else {
                if (_countResourceBlock.count == 1) {
                    booleanMinus = false;
                    if (_countMoneyBlock.count == 1 || 0 >= _countMoneyBlock.count - g.allData.resource[_curResourceId].costDefault) {
                        _countMoneyBlock.count = _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault;
//                        _countResourceBlock._btnMinus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                        _countResourceBlock._btnMinus.setEnabled = false;
                        if (_countMoneyBlock.count == _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault) {
//                            _countMoneyBlock._btnMinus.filter =  ManagerFilters.BUTTON_DISABLE_FILTER;
                            _countMoneyBlock._btnMinus.setEnabled = false;

                        }
                        return;
                    }
                    _countMoneyBlock.count = _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault;
//                    _countResourceBlock._btnMinus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                    _countResourceBlock._btnMinus.setEnabled = false;
                    return;
                } else  _countResourceBlock._btnMinus.setEnabled = true; //_countResourceBlock._btnMinus.filter = null;
            }
            if (_countMoneyBlock.count == 1 || 0 >= _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault) {
                _countMoneyBlock.count = _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault;
                return;
            }
            booleanMinus = true;
            _countMoneyBlock.count = _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault;
            if (_countMoneyBlock.count == _countResourceBlock.count * g.allData.resource[_curResourceId].costDefault) {
//                _countMoneyBlock._btnMinus.filter =  ManagerFilters.BUTTON_DISABLE_FILTER;
                _countMoneyBlock._btnMinus.setEnabled = false;
            }
        }
    }

    private function onClickBtnSell(last:Boolean = false):void {
        if (_curResourceId > 0) {
            if (!last) {
                if (g.allData.resource[_curResourceId].buildType == BuildType.PLANT && _countResourceBlock.count == g.userInventory.getCountResourceById(_curResourceId) && !g.userInventory.checkLastResource(_curResourceId)) {
//                    g.windowsManager.secondCashWindow = _activetedItem.woMarket;
                    g.windowsManager.secondCashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, onClickBtnSell, {id: _curResourceId}, 'market');
                    return;
                }
            }
            var level:int = g.allData.resource[_curResourceId].blockByLevel;
            if (!level || level < 1) level = 1;
            if (_callback != null) {
                _callback.apply(null, [_activetedItem, _curResourceId, level, _countResourceBlock.count, _countMoneyBlock.count]);
                _callback = null;
            }
            if (isCashed) g.windowsManager.secondCashWindow = null;
            super.hideIt();
        }
    }

    override protected function deleteIt():void {
        if (!_scrollSprite) return;
        unfillItems();
        unfillItems();
        if (_txtAmbar) {
            _txtAmbar.deleteIt();
            _txtAmbar = null;
        }
        if (_txtSklad) {
            _txtSklad.deleteIt();
            _txtSklad = null;
        }
        if (_txtCount) {
            _txtCount.deleteIt();
            _txtCount = null;
        }
        if (_txtSellBtn) {
            _txtSellBtn.deleteIt();
            _txtSellBtn = null;
        }
        if (_txtPrice) {
            _txtPrice.deleteIt();
            _txtPrice = null;
        }
        _tabAmbar.filter = null;
        _tabSklad.filter = null;
        _mainSprite.filter = null;
        if (_source.contains(_tabAmbar)) _source.removeChild(_tabAmbar);
        if (_mainSprite.contains(_tabAmbar)) _mainSprite.removeChild(_tabAmbar);
        if (_source.contains(_tabSklad)) _source.removeChild(_tabSklad);
        if (_mainSprite.contains(_tabSklad)) _mainSprite.removeChild(_tabSklad);
        _mainSprite.removeChild(_carton);
        _carton.deleteIt();
        _carton = null;
        _source.removeChild(_btnSell);
        _btnSell.deleteIt();
        _btnSell = null;
        _source.removeChild(_countMoneyBlock.source);
        _countMoneyBlock.deleteIt();
        _countMoneyBlock = null;
        _source.removeChild(_countResourceBlock.source);
        _countResourceBlock.deleteIt();
        _countResourceBlock = null;
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
        _source.removeChild(_birka);
        _birka.deleteIt();
        _birka = null;
        super.deleteIt();
    }

}
}
