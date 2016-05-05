/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import build.AreaObject;
import build.WorldObject;
import build.decor.DecorTail;
import build.fabrica.Fabrica;
import build.farm.Farm;
import build.tree.Tree;
import com.greensock.TweenMax;
import com.greensock.easing.Quad;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;
import resourceItem.UseMoneyMessage;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import tutorial.SimpleArrow;
import tutorial.TutorialAction;
import tutorial.managerCutScenes.ManagerCutScenes;

import ui.xpPanel.XPStar;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;
import windows.WindowsManager;

public class ShopItem {
    public var source:CSprite;
    private var _im:Image;
    private var _imCont:Sprite;
    private var _nameTxt:TextField;
    private var _countTxt:TextField;
    private var _countBoxTxt:TextField;
    private var _data:Object;
    private var _lockedSprite:Sprite;
    private var _countCost:int;
    private var _state:int;
    private const STATE_FROM_INVENTORY:int = 1;
    private const STATE_BUY:int = 2;
    private var _btnBuyGreen:CButton;
    private var _btnBuyBlue:CButton;
    private var _btnBuyCoupone:CButton;
    private var _btnActivationYellow:CButton;
    private var _txtBtnBuyBlue:TextField;
    private var _txtBtnBuyGreen:TextField;
    private var _txtAvailable:TextField;
    private var _shopLimitSprite:Sprite;
    private var _wo:WOShop;
    private var _bg:CartonBackgroundIn;
    private var _positionInList:int;
    private var g:Vars = Vars.getInstance();

    public function ShopItem(data:Object, wo:WOShop, pos:int) {
        _positionInList = pos;
        _wo = wo;
        _data = data;
        if (!_data) {
            Cc.error('ShopItem:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'shopItem');
            return;
        }
        source = new CSprite();
        _bg = new CartonBackgroundIn(145, 221);
        source.addChild(_bg);

        _nameTxt = new TextField(145, 60, '', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _nameTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        source.addChild(_nameTxt);
        _nameTxt.touchable = false;

        _countTxt = new TextField(145, 60, '', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _countTxt.y = 120;
        _countTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        source.addChild(_countTxt);
        _countTxt.visible = false;
        _countTxt.touchable = false;

        _countBoxTxt = new TextField(100, 30, '', g.allData.fonts['BloggerBold'], 12, Color.YELLOW);
        _countBoxTxt.y = 130;
        _countBoxTxt.x = 20;
        _countBoxTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        source.addChild(_countBoxTxt);
        _countBoxTxt.visible = false;
        _countBoxTxt.touchable = false;

        _txtAvailable = new TextField(145, 80, '', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtAvailable.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtAvailable.y = 135;
        source.addChild(_txtAvailable);
        _txtAvailable.visible = false;
        _txtAvailable.touchable = false;

        source.endClickCallback = onClick;
        setInfo();
    }

    public function get position():int {
        return _positionInList;
    }

    private function createLockedSprite():void {
        if (_lockedSprite) return;
        _lockedSprite = new Sprite();
        _lockedSprite.touchable = false;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_lock'));
        _lockedSprite.addChild(im);
        _lockedSprite.x = 1;
        _lockedSprite.y = 75;
        source.addChild(_lockedSprite);
    }

    private function createShopLimitSprite():void {
        if (_shopLimitSprite) return;
        _shopLimitSprite = new Sprite();
        _shopLimitSprite.touchable = false;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_limit'));
        im.x = -7;
        _shopLimitSprite.addChild(im);
        var txt:TextField = new TextField(145, 26, 'Достигнут лимит', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 33;
        _shopLimitSprite.addChild(txt);
        _shopLimitSprite.y = 150;
        source.addChild(_shopLimitSprite);
    }

    private function createButtons(type:String):void {
        var im:Image;
        switch (type) {
            case 'blue':
                if (_btnBuyBlue) return;
                _btnBuyBlue = new CButton();
                _btnBuyBlue.addButtonTexture(126, 40, CButton.BLUE, true);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                MCScaler.scale(im, 35, 35);
                im.x = 85;
                im.y = 4;
                _btnBuyBlue.addChild(im);
                im.filter = ManagerFilters.SHADOW_TINY;
                _txtBtnBuyBlue = new TextField(85, 40, '', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
                _txtBtnBuyBlue.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
                _btnBuyBlue.addChild(_txtBtnBuyBlue);
                _btnBuyBlue.x = 74;
                _btnBuyBlue.y = 190;
                source.addChild(_btnBuyBlue);
                break;
            case 'green':
                if (_btnBuyGreen) return;
                _btnBuyGreen = new CButton();
                _btnBuyGreen.addButtonTexture(126, 40, CButton.GREEN, true);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                MCScaler.scale(im, 35, 35);
                im.x = 85;
                im.y = 4;
                _btnBuyGreen.addChild(im);
                im.filter = ManagerFilters.SHADOW_TINY;
                _txtBtnBuyGreen = new TextField(85, 40, '', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
                _txtBtnBuyGreen.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
                _btnBuyGreen.addChild(_txtBtnBuyGreen);
                _btnBuyGreen.x = 74;
                _btnBuyGreen.y = 190;
                source.addChild(_btnBuyGreen);
                break;
            case 'yellow':
                if (_btnActivationYellow) return;
                _btnActivationYellow = new CButton();
                _btnActivationYellow.addButtonTexture(126, 40, CButton.YELLOW, true);
                var txt:TextField = new TextField(125, 40, 'УСТАНОВИТЬ', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
                txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
                _btnActivationYellow.addChild(txt);
                _btnActivationYellow.x = 74;
                _btnActivationYellow.y = 190;
                source.addChild(_btnActivationYellow);
                break;
        }
    }

    private function createCouponeButtons():void {
        var txt:TextField;
        var im:Image;
        var i:int;
        _btnBuyCoupone = new CButton();
        if (_data.currency.length == 3){
            _btnBuyCoupone.addButtonTexture(136, 40, CButton.GREEN, true);
        } else {
            _btnBuyCoupone.addButtonTexture(126, 40, CButton.GREEN, true);
        }
        for (i = 0; i <_data.currency.length; i++) {
            switch (_data.currency[i]) {
                case DataMoney.BLUE_COUPONE:
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone'));
                    MCScaler.scale(im, 30, 30);
                    im.filter = ManagerFilters.SHADOW_TINY;
                    _btnBuyCoupone.addChild(im);
                    txt = new TextField(85, 40, String(_data.cost[i]), g.allData.fonts['BloggerBold'], 18, Color.WHITE);
                    txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
                    _btnBuyCoupone.addChild(txt);
                    break;
                case DataMoney.GREEN_COUPONE:
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone'));
                    MCScaler.scale(im, 30, 30);
                    im.filter = ManagerFilters.SHADOW_TINY;
                    _btnBuyCoupone.addChild(im);
                    txt = new TextField(85, 40, String(_data.cost[i]), g.allData.fonts['BloggerBold'], 18, Color.WHITE);
                    txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
                    _btnBuyCoupone.addChild(txt);
                    break;
                case DataMoney.RED_COUPONE:
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone'));
                    MCScaler.scale(im, 30, 30);
                    im.filter = ManagerFilters.SHADOW_TINY;
                    _btnBuyCoupone.addChild(im);
                    txt = new TextField(85, 40, String(_data.cost[i]), g.allData.fonts['BloggerBold'], 18, Color.WHITE);
                    txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
                    _btnBuyCoupone.addChild(txt);
                    break;
                case DataMoney.YELLOW_COUPONE:
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone'));
                    MCScaler.scale(im, 30, 30);
                    im.filter = ManagerFilters.SHADOW_TINY;
                    _btnBuyCoupone.addChild(im);
                    txt = new TextField(85, 40, String(_data.cost[i]), g.allData.fonts['BloggerBold'], 18, Color.WHITE);
                    txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
                    _btnBuyCoupone.addChild(txt);
                    break;
            }
            im.y = 4;
            im.x = (50 * i) + 35;
            txt.x = (50 * i) - 20;
        }

        if (_data.currency.length == 1) {
            im.x = 85;
            im.y = 4;
            txt.x = 0;
            _countCost = _data.cost;
        }
        _btnBuyCoupone.x = 74;
        _btnBuyCoupone.y = 190;
        source.addChild(_btnBuyCoupone);
        _btnBuyCoupone.clickCallback = onClick;
    }

    private function setInfo():void {
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture) {
                texture = g.allData.atlas[_data.url].getTexture(_data.image);
            }
            _im = new Image(texture);
            if (!_im) {
                Cc.error('ShopItem:: no such image: ' + _data.image);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'shopItem');
                return;
            }
            MCScaler.scale(_im, 120, 120);
            _imCont = new Sprite();
            _im.x = - _im.width / 2;
            _im.y = - _im.height / 2;
            _imCont.addChild(_im);
            _imCont.x = 72;
            _imCont.y = 90;
//            _imCont.touchable = false;
            source.addChildAt(_imCont, 1);
        } else {
            Cc.error('ShopItem:: no image in _data for _data.id: ' + _data.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'shopItem');
        }

        if (_data.buildType == BuildType.CAT) {
            if (g.managerCats.curCountCats < g.managerCats.maxCountCats) {
                _countCost = g.dataCats[g.managerCats.curCountCats].cost;
                _data.cost = _countCost;
            }
        } else {
            _countCost = _data.cost;
        }
        if ((_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE)
                && g.userInventory.decorInventory[_data.id]) {
            _state = STATE_FROM_INVENTORY;
            _countCost = 0;
            _nameTxt.text = String(_data.name);
           createButtons('yellow');
        } else {
            _state = STATE_BUY;
        }
        checkState();
    }

    private function checkState():void {
        var arr:Array;
        var i:int;
        var maxCount:int;
        var curCount:int;
        var maxCountAtCurrentLevel:int = 0;
        _nameTxt.text = '';
        _countTxt.text = '';
        _countBoxTxt.text = '';

        if (!_data) return;
        if (_data.buildType == BuildType.FABRICA ) {
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                createLockedSprite();
                _txtAvailable.visible = true;
                _txtAvailable.text = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
                _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                _nameTxt.text = _data.name;
            } else {
                arr = g.townArea.getCityObjectsById(_data.id);
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                        _countCost = _data.cost[i];
                    } else break;
                }
                if (arr.length == _data.blockByLevel.length) {
                    createShopLimitSprite();
                    _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                    _nameTxt.text = _data.name;
                    _countTxt.visible = true;
                    _countTxt.text = String(maxCountAtCurrentLevel) + '/' + String(maxCountAtCurrentLevel);
                } else if (arr.length >= maxCountAtCurrentLevel) {
                    _nameTxt.text = _data.name;
                    _txtAvailable.visible = true;
                    _txtAvailable.text = 'Будет доступно на ' + String(_data.blockByLevel[maxCountAtCurrentLevel]) + ' уровне';
                    _countTxt.visible = true;
                    _countTxt.text = String(arr.length) + '/' + String(_data.blockByLevel.length);
                    createShopLimitSprite();
                    _shopLimitSprite.y = 50;
                } else {
                    _nameTxt.text = _data.name;
                    _countTxt.visible = true;
                    _countTxt.text = String(arr.length) + '/' + String(maxCountAtCurrentLevel);
                    createButtons('blue');
                    _txtBtnBuyBlue.text = String(_countCost);
                }
            }
        } else if (_data.buildType == BuildType.FARM) {
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                createLockedSprite();
                _txtAvailable.visible = true;
                _txtAvailable.text = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
                _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                _nameTxt.text = _data.name;
            } else {
                arr = g.townArea.getCityObjectsById(_data.id);
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                if (arr.length >= maxCountAtCurrentLevel) {
                    createShopLimitSprite();
                    _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                    _nameTxt.text = _data.name;
                    _countTxt.visible = true;
                    _countTxt.text = String(maxCountAtCurrentLevel) + '/' + String(maxCountAtCurrentLevel);
                } else {
                    _nameTxt.text = _data.name;
                    _countTxt.visible = true;
                    _countTxt.text = String(arr.length) + '/' + String(maxCountAtCurrentLevel);
                    createButtons('blue');
                    _txtBtnBuyBlue.text = String(_countCost);
                }
            }
        } else if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE) {
            if (_data.blockByLevel) {
                if (_data.buildType == BuildType.DECOR_TAIL) {
                    arr = g.townArea.getCityTailObjectsById(_data.id);
                } else {
                    arr = g.townArea.getCityObjectsById(_data.id);
                }
                if (_data.blockByLevel[0] > g.user.level) {
                    createLockedSprite();
                    _txtAvailable.visible = true;
                    _txtAvailable.text = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
                    _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                    _nameTxt.text = _data.name;
                } else {
                    if (_state == STATE_FROM_INVENTORY) {
                        _countCost = 0;
                        _nameTxt.text = _data.name;
                        _countBoxTxt.visible = true;
                        _countBoxTxt.text = 'В ИНВЕНТАРЕ: ' + String(g.userInventory.decorInventory[_data.id].count);
                        createButtons('yellow');
                    } else {
                        _countCost = (arr.length * _data.deltaCost) + int(_data.cost);
                            if(_data.currency[0] == DataMoney.SOFT_CURRENCY) {
                                createButtons('blue');
                                _txtBtnBuyBlue.text = String(_countCost);
                            } else if(_data.currency[0] == DataMoney.HARD_CURRENCY) {
                                _countCost = _data.cost;
                                createButtons('green');
                                _txtBtnBuyGreen.text = String(_countCost);
                            } else {
                                createCouponeButtons();
                            }
                        _nameTxt.text = _data.name;
                    }
                }
            }
        } else if (_data.buildType == BuildType.ANIMAL) {
            var dataFarm:Object = g.dataBuilding.objectBuilding[_data.buildId];
            if (dataFarm && dataFarm.blockByLevel) {
                if (g.user.level < dataFarm.blockByLevel[0]) {
                    createLockedSprite();
                    _txtAvailable.visible = true;
                    _txtAvailable.text = 'Будет доступно на ' + String(dataFarm.blockByLevel[0]) + ' уровне';
                    _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                    _nameTxt.text = _data.name;
                } else {
                    arr = g.townArea.getCityObjectsById(dataFarm.id);
                    maxCount = arr.length * dataFarm.maxAnimalsCount;
                    curCount = 0;
                    for (i=0; i<arr.length; i++) {
                        curCount += (arr[i] as Farm).arrAnimals.length;
                    }
                    if (maxCount == curCount) {
                        _txtAvailable.visible = true;
                        _txtAvailable.text = 'Необходимо построить: ' + String(dataFarm.name);
                        _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                        _nameTxt.text = _data.name;
                        if (_btnBuyBlue) {
                            source.removeChild(_btnBuyBlue);
                            _btnBuyBlue.deleteIt();
                            _btnBuyBlue = null;
                        }
                    } else if (curCount > maxCount) {
                        createShopLimitSprite();
                        _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                        _nameTxt.text = _data.name;
                        _countTxt.visible = true;
                        _countTxt.text = String(maxCount) + '/' + String(maxCount);
                        _countCost = 0;
                    } else {
                        createButtons('blue');
                        _nameTxt.text = _data.name;
                        _countTxt.visible = true;
                        _countTxt.text = String(curCount) + '/' + String(maxCount);
                        if (curCount < dataFarm.maxAnimalsCount) {
                            _txtBtnBuyBlue.text = _data.cost;
                        } else if (curCount < 2*dataFarm.maxAnimalsCount) {
                            _txtBtnBuyBlue.text = _data.cost2;
                        } else {
                            _txtBtnBuyBlue.text = _data.cost3;
                        }
                    }
                }
            }
        } else if (_data.buildType == BuildType.TREE) {
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                createLockedSprite();
                _txtAvailable.visible = true;
                _txtAvailable.text = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
                _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
            } else {
                arr = g.townArea.getCityTreeById(_data.id, true);
                curCount = arr.length;
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                maxCount = maxCountAtCurrentLevel * _data.countUnblock;
                if (curCount >= maxCount) {
                    createShopLimitSprite();
                    _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                    _nameTxt.text = _data.name;
                    _countTxt.visible = true;
                    _countTxt.text = String(maxCount) + '/' + String(maxCount);
                } else {
                    _nameTxt.text = _data.name;
                    _countTxt.visible = true;
                    _countTxt.text = String(curCount) + '/' + String(maxCount);
                    createButtons('blue');
                    _txtBtnBuyBlue.text = String(_countCost);
                }
            }
        } else if (_data.buildType == BuildType.RIDGE) {
            if (_data.blockByLevel) {
                arr = g.townArea.getCityObjectsById(_data.id);
                curCount = arr.length;
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                maxCount = maxCountAtCurrentLevel * _data.countUnblock;
                if (curCount >= maxCount) {
                    createShopLimitSprite();
                    _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                    _nameTxt.text = _data.name;
                    _countTxt.visible = true;
                    _countTxt.text = String(maxCount) + '/' + String(maxCount);
                } else {
                    _nameTxt.text = _data.name;
                    _countTxt.visible = true;
                    _countTxt.text = String(curCount) + '/' + String(maxCount);
                    createButtons('blue');
                    _txtBtnBuyBlue.text = String(_countCost);
                }
            }
        } else if (_data.buildType == BuildType.CAT) {
            curCount = g.managerCats.curCountCats;
            maxCount = g.managerCats.maxCountCats;
            if (curCount >= maxCount) {
                createShopLimitSprite();
                _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                _nameTxt.text = _data.name;
                _countTxt.visible = true;
                _countTxt.text = String(maxCount) + '/' + String(maxCount);
            } else {
                _nameTxt.text = _data.name;
                _countTxt.visible = true;
                _countTxt.text = String(curCount) + '/' + String(maxCount);
                createButtons('blue');
                _txtBtnBuyBlue.text = String(_countCost);
            }
        }

        if (_nameTxt.text == '') _nameTxt.text = _data.name;
    }

    private function onClick():void {
        var i:int;
        if (_shopLimitSprite) return;
        if (_txtAvailable.visible) {
            if (_data.blockByLevel) {
                for (i = 0; i < _data.blockByLevel.length; i++) {
                    if (g.user.level < _data.blockByLevel[i]) {
                        var p:Point = new Point(source.x, source.y);
                        p = source.parent.localToGlobal(p);
                        new FlyMessage(p, "откроется на " + String(_data.blockByLevel[i]) + " уровне");
                        return;
                    }
                }
            } else return;
        }
        if (_data.buildType == BuildType.CAT) {
            _countCost = g.dataCats[g.managerCats.curCountCats].cost;
            _data.cost = _countCost;
        }

        if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE) {
            if (g.managerTutorial.isTutorial) return;
            if (g.managerCutScenes.isCutScene) {
                if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_BUY_DECOR) && g.managerCutScenes.isCutSceneResource(_data.id)) {
                    g.managerCutScenes.checkCutSceneCallback();
                } else return;
            }
            if (_data.currency.length == 1) {
                if (_data.currency == DataMoney.SOFT_CURRENCY) {
                    if (g.user.softCurrencyCount < _countCost) {
                        var ob:Object = {};
                        ob.currency = DataMoney.SOFT_CURRENCY;
                        ob.count = _countCost - g.user.softCurrencyCount;
                        g.windowsManager.cashWindow = _wo;
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClick, 'money', ob);
                        return;
                    }
                } else if (_data.currency == DataMoney.HARD_CURRENCY) {
                    if (g.user.hardCurrency < _countCost) {
                        g.windowsManager.cashWindow = _wo;
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
                        return;
                    }
                } else if (_data.currency == DataMoney.BLUE_COUPONE && g.user.blueCouponCount < _countCost) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                    return;
                } else if (_data.currency == DataMoney.RED_COUPONE && g.user.redCouponCount < _countCost) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                    return;
                } else if (_data.currency == DataMoney.GREEN_COUPONE && g.user.greenCouponCount < _countCost) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                        return;
                } else if (_data.currency == DataMoney.YELLOW_COUPONE && g.user.yellowCouponCount < _countCost) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                    return;
                }
            } else {
                for (i = 0; i < _data.currency.length; i++) {
                    if (_data.currency[i] == DataMoney.BLUE_COUPONE && g.user.blueCouponCount < _data.cost[i]) {
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                        return;
                    } else if (_data.currency[i] == DataMoney.RED_COUPONE && g.user.redCouponCount < _data.cost[i]) {
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                        return;
                    } else if (_data.currency[i] == DataMoney.GREEN_COUPONE && g.user.greenCouponCount < _data.cost[i]) {
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                        return;
                    } else if (_data.currency[i] == DataMoney.YELLOW_COUPONE && g.user.yellowCouponCount < _data.cost[i]) {
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                        return;
                    }
                }
            }
        } else {
            if (g.user.softCurrencyCount < _countCost){
                var ob2:Object = {};
                ob2.currency = DataMoney.SOFT_CURRENCY;
                ob2.count = _countCost - g.user.softCurrencyCount;
                g.windowsManager.cashWindow = _wo;
                _wo.hideIt();
                g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClick, 'money', ob2);
                return;
            }
        }
        if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE) {
            if (_data.currency == DataMoney.SOFT_CURRENCY) {
                g.buyHint.showIt(_countCost);
            }
        }
        var build:AreaObject;
        if (_data.buildType == BuildType.RIDGE) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.NEW_RIDGE) return;
            build = g.townArea.createNewBuild(_data);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.ADD_NEW_RIDGE;
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE) {
                g.managerTutorial.checkTutorialCallback();
            }
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP);
            (build as AreaObject).countShopCost = _countCost;
            g.townArea.startMoveAfterShop(build as AreaObject);
        } else if (_data.buildType == BuildType.DECOR_TAIL) {
            if (g.managerTutorial.isTutorial) return;
            build = g.townArea.createNewBuild(_data);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP);
            if (_state == STATE_FROM_INVENTORY) {
                g.townArea.startMoveAfterShop(build as AreaObject, true);
                g.buyHint.hideIt();
            } else {
                (build as AreaObject).countShopCost = _countCost;
                g.townArea.startMoveAfterShop(build as AreaObject);
//                g.toolsModifier.startMoveTail(build, _countCost, true);
            }
        } else if (_data.buildType == BuildType.CAT) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.BUY_CAT) return;
            g.managerCats.onBuyCatFromShop();
            updateItem();
            g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -int(_data.cost));
            showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(_data.cost));
            if (g.managerTutorial.isTutorial) {
                if (g.managerTutorial.currentAction == TutorialAction.BUY_CAT) {
                    g.managerTutorial.checkTutorialCallback();
                }
            }
        } else if (_data.buildType != BuildType.ANIMAL) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.BUY_FABRICA && g.managerTutorial.currentAction != TutorialAction.BUY_FARM) return;
            build = g.townArea.createNewBuild(_data);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            if(_data.buildType == BuildType.FARM) {
                _wo.setAnimalClick = true;
            }
            if (build is Tree) (build as Tree).showShopView();
            if (build is Fabrica) (build as Fabrica).showShopView();
            if (g.managerTutorial.isTutorial) {
                if (g.managerTutorial.currentAction == TutorialAction.BUY_FABRICA && g.managerTutorial.isTutorialResource(_data.id)) {
                    g.managerTutorial.checkTutorialCallback();
                } else if (g.managerTutorial.currentAction == TutorialAction.BUY_FARM && g.managerTutorial.isTutorialResource(_data.id)) {
                    g.managerTutorial.checkTutorialCallback();
                }
            }
            if (_state == STATE_FROM_INVENTORY) {
                g.townArea.startMoveAfterShop(build as AreaObject, true);
                g.buyHint.hideIt();
            } else {
                (build as AreaObject).countShopCost = _countCost;
                g.townArea.startMoveAfterShop(build as AreaObject);
//                g.toolsModifier.startMove(build, _countCost, true);
            }
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP);
        } else {
            if (g.managerTutorial.isTutorial) {
                if (g.managerTutorial.currentAction != TutorialAction.BUY_ANIMAL) return;
                if (!g.managerTutorial.isTutorialResource(_data.id)) return;
            }
            //додаємо на відповідну ферму
            var dataFarm:Object = g.dataBuilding.objectBuilding[_data.buildId];
            var curCount:int = 0;
            var arr:Array = g.townArea.cityObjects;
            var arrPat:Array = g.townArea.getCityObjectsById(dataFarm.id);
            for (i=0; i<arrPat.length; i++) {
                curCount += (arrPat[i] as Farm).arrAnimals.length;
            }
            if (curCount < dataFarm.maxAnimalsCount) {
                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(_data.cost));
                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(_data.cost));
            } else if (curCount < 2*dataFarm.maxAnimalsCount) {
                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(_data.cost2));
                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(_data.cost2));
            } else {
                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(_data.cost3));
                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(_data.cost3));
            }
            for (i = 0; i < arr.length; i++) {
                if (arr[i] is Farm  &&  arr[i].dataBuild.id == _data.buildId  &&  !arr[i].isFull) {
                    (arr[i] as Farm).addAnimal();
                    checkState();
                    g.bottomPanel.cancelBoolean(false);
                    _wo.updateMoneyCounts();
                }
            }
            if (g.managerTutorial.isTutorial) {
                if (g.managerTutorial.currentAction == TutorialAction.BUY_ANIMAL && g.managerTutorial.isTutorialResource(_data.id)) {
                    g.managerTutorial.checkTutorialCallback();
                } else {
                    return;
                }
            }
            Cc.error('ShopItem:: no such Farm :(');
        }
    }

    private function updateItem():void {
        var curCount:int;
        var maxCount:int;

        if (_data.buildType == BuildType.CAT) {
            curCount = g.managerCats.curCountCats;
            maxCount = g.managerCats.maxCountCats;
            if (curCount == maxCount) {
                createShopLimitSprite();
                _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                _btnBuyBlue.visible = false;
                _nameTxt.text = _data.name;
                _countTxt.text = String(maxCount) + '/' + String(maxCount);
//                _txtBtnBuyBlue.text = String(g.dataCats[g.managerCats.curCountCats].cost);
            } else {
                _nameTxt.text = _data.name;
                _countTxt.text = String(curCount) + '/' + String(maxCount);
                _txtBtnBuyBlue.text = String(g.dataCats[g.managerCats.curCountCats].cost);
            }
        }
        _wo.updateMoneyCounts();
    }

    private function showSmallAnimations(moneyType:int, count:int):void {
        if (_imCont) {
            _imCont.scaleX = _imCont.scaleY = 1;
            TweenMax.to(_imCont, .3, {scaleX: 1.3, scaleY: 1.3, ease: Quad.easeOut, onComplete: showSmallAnimations2});
            var p:Point = new Point(_imCont.x, _imCont.y + 20);
            p = source.localToGlobal(p);
            new UseMoneyMessage(p, moneyType, count, .3);
        }
    }

    private function showSmallAnimations2():void {
        TweenMax.to(_imCont, .3, {scaleX: 1, scaleY:1, ease:Quad.easeIn});
    }

    public function deleteIt():void {
        if (_imCont) {
            TweenMax.killTweensOf(_imCont);
        }
        _im = null;
        _imCont = null;
        _nameTxt = null;
        _countTxt = null;
        _countBoxTxt = null;
        _data = null;
        _lockedSprite = null;
        if (_btnBuyGreen) {
            source.removeChild(_btnBuyGreen);
            _btnBuyGreen.deleteIt();
            _btnBuyGreen = null;
        }
        if (_btnBuyBlue) {
            source.removeChild(_btnBuyBlue);
            _btnBuyBlue.deleteIt();
            _btnBuyBlue = null;
        }
        if (_btnBuyCoupone) {
            source.removeChild(_btnBuyCoupone);
            _btnBuyCoupone.deleteIt();
            _btnBuyCoupone = null;
        }
        if (_btnActivationYellow) {
            source.removeChild(_btnActivationYellow);
            _btnActivationYellow.deleteIt();
            _btnActivationYellow = null;
        }
        _txtBtnBuyBlue = null;
        _txtBtnBuyGreen = null;
        _txtAvailable = null;
        _shopLimitSprite = null;
        _wo = null;
        source.removeChild(_bg);
        _bg.deleteIt();
        _bg = null;
        source.deleteIt();
        source = null;
    }
}
}
