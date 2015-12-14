/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import build.farm.Farm;

import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;

import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;

public class ShopItem {
    public var source:CSprite;
    private var _im:Image;
    private var _nameTxt:TextField;
    private var _data:Object;
    private var _lockedSprite:Sprite;
    private var _countCost:int;
    private var _state:int;
    private const STATE_FROM_INVENTORY:int = 1;
    private const STATE_BUY:int = 2;
    private var _btnBuyGreen:CButton;
    private var _btnBuyBlue:CButton;
    private var _btnActivationYellow:CButton;
    private var _txtBtnBuyBlue:TextField;
    private var _txtBtnBuyGreen:TextField;
    private var _txtAvailable:TextField;
    private var _shopLimitSprite:Sprite;

    private var g:Vars = Vars.getInstance();

    public function ShopItem(data:Object) {
        _data = data;
        if (!_data) {
            Cc.error('ShopItem:: empty _data');
            g.woGameError.showIt();
            return;
        }
        source = new CSprite();
        var bg:CartonBackgroundIn = new CartonBackgroundIn(145, 221);
        source.addChild(bg);

        _nameTxt = new TextField(145, 60, '', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _nameTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        source.addChild(_nameTxt);
        source.endClickCallback = onClick;

        _lockedSprite = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_lock'));
        _lockedSprite.addChild(im);
        _lockedSprite.x = 1;
        _lockedSprite.y = 75;
        source.addChild(_lockedSprite);
        _lockedSprite.visible = false;

        _txtAvailable = new TextField(145, 80, '', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtAvailable.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtAvailable.y = 135;
        source.addChild(_txtAvailable);

        _shopLimitSprite = new Sprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_limit'));
        im.x = -7;
        _shopLimitSprite.addChild(im);
        var txt:TextField = new TextField(145, 26, 'Достигнут лимит', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 33;
        _shopLimitSprite.addChild(txt);
        _shopLimitSprite.y = 130;
        source.addChild(_shopLimitSprite);
        _shopLimitSprite.visible = false;

        createButtons();
        setInfo();
    }

    private function createButtons():void {
        _btnBuyBlue = new CButton();
        _btnBuyBlue.addButtonTexture(126, 40, CButton.BLUE, true);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        MCScaler.scale(im, 35, 35);
        im.x = 85;
        im.y = 4;
        _btnBuyBlue.addChild(im);
        im.filter = ManagerFilters.SHADOW_TINY;
        _txtBtnBuyBlue = new TextField(85, 40, '', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtBtnBuyBlue.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btnBuyBlue.addChild(_txtBtnBuyBlue);
        _btnBuyBlue.x = 74;
        _btnBuyBlue.y = 180;
        source.addChild(_btnBuyBlue);
        _btnBuyBlue.visible = false;
        _btnBuyBlue.clickCallback = onClick;

        _btnBuyGreen = new CButton();
        _btnBuyGreen.addButtonTexture(126, 40, CButton.GREEN, true);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 35, 35);
        im.x = 85;
        im.y = 4;
        _btnBuyGreen.addChild(im);
        im.filter = ManagerFilters.SHADOW_TINY;
        _txtBtnBuyGreen = new TextField(85, 40, '', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtBtnBuyGreen.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btnBuyGreen.addChild(_txtBtnBuyGreen);
        _btnBuyGreen.x = 74;
        _btnBuyGreen.y = 180;
        source.addChild(_btnBuyGreen);
        _btnBuyGreen.visible = false;
        _btnBuyGreen.clickCallback = onClick;

        _btnActivationYellow = new CButton();
        _btnActivationYellow.addButtonTexture(126, 40, CButton.YELLOW, true);
        var txt:TextField = new TextField(125, 40, 'Активировать', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
        _btnActivationYellow.addChild(txt);
        _btnActivationYellow.x = 74;
        _btnActivationYellow.y = 180;
        source.addChild(_btnActivationYellow);
        _btnActivationYellow.visible = false;
        _btnActivationYellow.clickCallback = onClick;
    }

    private function setInfo():void {
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture) {
                texture = g.allData.atlas[_data.url].getTexture(_data.image);
            }
            //temp for trees
            if (!texture) {
                texture = g.allData.atlas[_data.url].getTexture(_data.imageGrowedBig);
            }
            _im = new Image(texture);
            if (!_im) {
                Cc.error('ShopItem:: no such image: ' + _data.image);
                g.woGameError.showIt();
                return;
            }
            MCScaler.scale(_im, 120, 120);
            _im.x = 72 - _im.width / 2;
            _im.y = 90 - _im.height / 2;
            source.addChildAt(_im, 1);
        } else {
            Cc.error('ShopItem:: no image in _data for _data.id: ' + _data.id);
            g.woGameError.showIt();
        }

        if (_data.buildType == BuildType.CAT) {
            _countCost = g.dataCats[g.managerCats.curCountCats].cost;
            _data.cost = _countCost;
        } else {
            _countCost = _data.cost;
        }

        if ((_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE)
                && g.userInventory.decorInventory[_data.id]) {
            _state = STATE_FROM_INVENTORY;
            _countCost = 0;
            _nameTxt.text = String(_data.name);
            _btnActivationYellow.visible = true;
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
        _lockedSprite.visible = false;
        _btnActivationYellow.visible = false;
        _btnBuyBlue.visible = false;
        _btnBuyGreen.visible = false;
        _shopLimitSprite.visible = false;

        if (_data.buildType == BuildType.FABRICA ) {
            if (_data.blockByLevel) {
                arr = g.townArea.getCityObjectsById(_data.id);
                if (_data.blockByLevel[0] > g.user.level) {
                    _lockedSprite.visible = true;
                    _txtAvailable.text = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
                    _nameTxt.text = _data.name;
                } else {
                    if (_data.blockByLevel.length == 1) {
                        if (arr.length == 0) {
                            _nameTxt.text = _data.name + ' 0/1';
                            _btnBuyBlue.visible = true;
                            _txtBtnBuyBlue.text = String(_countCost);
                        } else {
                            _shopLimitSprite.visible = true;
                            _nameTxt.text = _data.name + ' 1/1';
                        }
                    } else {
                        for (i = 0; _data.blockByLevel.length; i++) {
                            if (_data.blockByLevel[i] < g.user.level) {
                                maxCountAtCurrentLevel++;
                            } else break;
                        }
                        if (arr.length >= maxCountAtCurrentLevel) {
                            _shopLimitSprite.visible = true;
                            _nameTxt.text = _data.name + ' ' + String(maxCountAtCurrentLevel) + '/' + String(maxCountAtCurrentLevel);
                        } else {
                            _nameTxt.text = _data.name + ' ' +  String(arr.length) + '/' + String(maxCountAtCurrentLevel);
                            _btnBuyBlue.visible = true;
                            _txtBtnBuyBlue.text = String(_countCost);
                        }
                    }
                }
            }
        } else if (_data.buildType == BuildType.FARM) {
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                _lockedSprite.visible = true;
                _txtAvailable.text = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
                _nameTxt.text = _data.name;
            } else {
                arr = g.townArea.getCityObjectsById(_data.id);
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                if (arr.length >= maxCountAtCurrentLevel) {
                    _shopLimitSprite.visible = true;
                    _nameTxt.text = _data.name + ' ' + String(maxCountAtCurrentLevel) + '/' + String(maxCountAtCurrentLevel);
                } else {
                    _nameTxt.text = _data.name + ' ' + String(arr.length) + '/' + String(maxCountAtCurrentLevel);
                    _btnBuyBlue.visible = true;
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
                    _lockedSprite.visible = true;
                    _txtAvailable.text = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
                    _nameTxt.text = _data.name;
                } else {
                    if (_state == STATE_FROM_INVENTORY) {
                        _countCost = 0;
                        _nameTxt.text = _data.name;
                        _btnActivationYellow.visible = true;
                    } else {
                        _countCost = arr.length * _data.deltaCost + _data.cost;
                        _btnBuyBlue.visible  = true;
                        _txtBtnBuyBlue.text = String(_countCost);
                        _nameTxt.text = _data.name;
                    }
                }
            }
        } else if (_data.buildType == BuildType.ANIMAL) {
            var dataFarm:Object = g.dataBuilding.objectBuilding[_data.buildId];
            if (dataFarm && dataFarm.blockByLevel) {
                if (g.user.level < dataFarm.blockByLevel[0]) {
                    _lockedSprite.visible = true;
                    _txtAvailable.text = 'Будет доступно на ' + String(dataFarm.blockByLevel[0]) + ' уровне';
                    _nameTxt.text = _data.name;
                } else {
                    arr = g.townArea.getCityObjectsById(dataFarm.id);
                    maxCount = arr.length * dataFarm.maxAnimalsCount;
                    curCount = 0;
                    for (i=0; i<arr.length; i++) {
                        curCount += (arr[i] as Farm).arrAnimals.length;
                    }
                    if (maxCount == 0) {
                        _txtAvailable.text = 'Необходимо построить ' + String(dataFarm.name);
                        _nameTxt.text = _data.name;
                    } else if (curCount >= maxCount) {
                        _shopLimitSprite.visible = true;
                        _nameTxt.text = _data.name + " " + String(maxCount) + '/' + String(maxCount);
                        _countCost = 0;
                    } else {
                        _btnBuyBlue.visible = true;
                        _nameTxt.text = _data.name + ' ' + String(curCount) + '/' + String(maxCount);
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
                _lockedSprite.visible = true;
                _txtAvailable.text = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
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
                    _shopLimitSprite.visible = true;
                    _nameTxt.text = _data.name + ' ' + String(maxCount) + '/' + String(maxCount);
                } else {
                    _nameTxt.text = _data.name + ' ' + String(curCount) + '/' + String(maxCount);
                    _btnBuyBlue.visible = true;
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
                    _shopLimitSprite.visible = true;
                    _nameTxt.text = _data.name + ' ' + String(maxCount) + '/' + String(maxCount);
                } else {
                    _nameTxt.text = _data.name + ' ' + String(curCount) + '/' + String(maxCount);
                    _btnBuyBlue.visible = true;
                    _txtBtnBuyBlue.text = String(_countCost);
                }
            }
        } else if (_data.buildType == BuildType.CAT) {
            curCount = g.managerCats.curCountCats;
            maxCount = g.managerCats.maxCountCats;
            if (curCount >= maxCount) {
                _shopLimitSprite.visible = true;
                _nameTxt.text = _data.name + ' ' + String(maxCount) + '/' + String(maxCount);
            } else {
                _nameTxt.text = _data.name + ' ' + String(curCount) + '/' + String(maxCount);
                _btnBuyBlue.visible = true;
                _txtBtnBuyBlue.text = String(_countCost);
            }
        }

        if (_nameTxt.text == '') _nameTxt.text = _data.name;
    }

    public function clearIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
        if (_lockedSprite){
            while (_lockedSprite.numChildren) {
                _lockedSprite.removeChildAt(0);
            }
        }
        _lockedSprite = null;
        source = null;
    }

    private function onClick():void {
        if (_shopLimitSprite.visible) return;

        if (_data.buildType == BuildType.CAT) {
            _countCost = g.dataCats[g.managerCats.curCountCats].cost;
            _data.cost = _countCost;
        }
        if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
            var p:Point = new Point(source.x, source.y);
            p = source.parent.localToGlobal(p);
            new FlyMessage(p,"откроется на " + String(_data.blockByLevel) + " уровне");
            return;
        }
        if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE) {
            if (_data.currency == DataMoney.SOFT_CURRENCY) {
                if (g.user.softCurrencyCount < _countCost){
                    g.woNoResources.showItMoney(DataMoney.SOFT_CURRENCY,_countCost-g.user.softCurrencyCount,onClick);
                    return;
                }
            } else {
                if (g.user.hardCurrency < _countCost) {
                    g.woNoResources.showItMoney(DataMoney.SOFT_CURRENCY,_countCost-g.user.softCurrencyCount,onClick);
                    return;}
            }
        } else {
            if (g.user.softCurrencyCount < _countCost){
                g.woNoResources.showItMoney(DataMoney.SOFT_CURRENCY,_countCost-g.user.softCurrencyCount,onClick);
                return;
            }
        }

        if (_data.buildType == BuildType.RIDGE) {
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.ADD_NEW_RIDGE;
            g.woShop.onClickExit();
            g.toolsModifier.startMove(_data, afterMove);
        } else if (_data.buildType == BuildType.DECOR_TAIL) {
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.woShop.onClickExit();
            if (_state == STATE_FROM_INVENTORY) {
                g.toolsModifier.startMoveTail(_data, afterMoveFromInventory, true);
            } else {
                g.toolsModifier.startMoveTail(_data, afterMove, true);
            }
        } else if (_data.buildType == BuildType.CAT) {
            g.managerCats.onBuyCatFromShop();
            updateItem();
            g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_data.cost);
        } else if (_data.buildType != BuildType.ANIMAL) {
            g.woShop.onClickExit();
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            if (_state == STATE_FROM_INVENTORY) {
                g.toolsModifier.startMove(_data, afterMoveFromInventory, 1, 1, true);
            } else {
                g.toolsModifier.startMove(_data, afterMove, 1, 1, true);
            }
        } else {
            //додаємо на відповідну ферму
            var arr:Array = g.townArea.cityObjects;
            for (var i:int = 0; i < arr.length; i++) {
                if (arr[i] is Farm  &&  arr[i].dataBuild.id == _data.buildId  &&  !arr[i].isFull) {
                    (arr[i] as Farm).addAnimal();
                    g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-_data.cost);
                    checkState();
                    g.bottomPanel.cancelBoolean(false);
                    g.woShop.updateMoneyCounts();
                    return;
                }
            }
            Cc.error('ShopItem:: no such Farm :(');
        }
    }

    private function afterMove(_x:Number, _y:Number):void {
        if (_data.buildType == BuildType.ANIMAL || _data.buildType == BuildType.FARM || _data.buildType == BuildType.FABRICA
                || _data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE) {
            g.bottomPanel.cancelBoolean(false);
        }
        if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE) {
            var cont:Sprite = new Sprite();
            cont.x = _x;
            cont.y = _y;
            g.cont.gameCont.addChild(cont);
            var localPoint:Point = new Point( cont.x,cont.y);
            localPoint = cont.parent.localToGlobal(localPoint);
            new XPStar(localPoint.x, localPoint.y, _data.xpForBuild);
        }
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        g.townArea.createNewBuild(_data, _x, _y);
        g.userInventory.addMoney(_data.currency, -_countCost);
    }

    private function afterMoveFromInventory(_x:Number, _y:Number):void {
        g.bottomPanel.cancelBoolean(false);
        var dbId:int = g.userInventory.removeFromDecorInventory(_data.id);
        g.townArea.createNewBuild(_data, _x, _y, true, dbId);
        var p:Point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
        g.directServer.removeFromInventory(dbId, p.x, p.y, null);
        g.userInventory.addMoney(_data.currency, -_data.cost);
    }

    private function updateItem():void {
        var curCount:int;
        var maxCount:int;

        if (_data.buildType == BuildType.CAT) {
            curCount = g.managerCats.curCountCats;
            maxCount = g.managerCats.maxCountCats;
            if (curCount == maxCount) {
                _shopLimitSprite.visible = true;
                _btnBuyBlue.visible = false;
                _nameTxt.text = _data.name + ' ' + String(maxCount) + '/' + String(maxCount);
            } else {
                _nameTxt.text = _data.name + ' ' + String(curCount) + '/' + String(maxCount);
            }
        }
        g.woShop.updateMoneyCounts();
    }
}
}
