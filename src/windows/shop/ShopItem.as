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
import manager.Vars;
import mouse.ToolsModifier;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class ShopItem {
    public var source:CSprite;
    private var _bg:Image;
    private var _im:Image;
    private var _nameTxt:TextField;
    private var _countTxt:TextField;
    private var _data:Object;
    private var _lockedSprite:Sprite;
    private var _lockedTxt:TextField;
    private var _countCost:int;
    private var _state:int;
    private const STATE_FROM_INVENTORY:int = 1;
    private const STATE_BUY:int = 2;

    private var g:Vars = Vars.getInstance();

    public function ShopItem(data:Object) {
        _data = data;
        if (!_data) {
            Cc.error('ShopItem:: empty _data');
            g.woGameError.showIt();
            return;
        }
        source = new CSprite();
        _bg = new Image(g.interfaceAtlas.getTexture('shop_item'));
        source.addChild(_bg);

        _nameTxt = new TextField(150, 70, '', "Arial", 20, Color.BLACK);
        _nameTxt.x = 7;
        _nameTxt.y = 140;
        source.addChild(_nameTxt);
        _countTxt = new TextField(122, 30, '', "Arial", 16, Color.WHITE);
        _countTxt.x = 22;
        _countTxt.y = 220;
        source.addChild(_countTxt);
        source.endClickCallback = onClick;

        _lockedSprite = new Sprite();
        _lockedTxt = new TextField(170, 70, '', "Arial", 16, Color.BLACK);
        _lockedTxt.y = -110;
        _lockedSprite.addChild(_lockedTxt);
        _lockedSprite.y = 110;
        source.addChild(_lockedSprite);

        setInfo();
    }

    private function setInfo():void {
        if (_data.image) {
            if (_data.url == "buildAtlas") {
                _im = new Image(g.tempBuildAtlas.getTexture(_data.image));
            } else if (_data.url == "treeAtlas") {
                _im = new Image(g.treeAtlas.getTexture(_data.image));
            } else if (_data.url == 'catAtlas') {
                _im = new Image(g.catAtlas.getTexture(_data.image));
            }
            if (!_im) {
                Cc.error('ShopItem:: no such image: ' + _data.image);
                g.woGameError.showIt();
                return;
            }
            MCScaler.scale(_im, 100, 100);
            _im.x = 35 + 50 - _im.width / 2;
            _im.y = 30 + 50 - _im.height / 2;
            source.addChildAt(_im, 1);
        } else {
            Cc.error('ShopItem:: no image in _data for _data.id: ' + _data.id);
            g.woGameError.showIt();
        }

        _nameTxt.text = String(_data.name);

        if (_data.buildType == BuildType.CAT) {
            _countCost = g.dataCats[g.managerCats.curCountCats].cost;
            _data.cost = _countCost;
        } else {
            _countCost = _data.cost;
        }
        _countTxt.text = String(_countCost);

        if ((_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE)
                && g.userInventory.decorInventory[_data.id]) {
            _state = STATE_FROM_INVENTORY;
            _countCost = 0;
            _countTxt.text = 'Активировать';
        } else {
            _state = STATE_BUY;
        }

        checkState();
    }

    private function checkState():void {
        var im:Image;
        var arr:Array;
        var i:int;
        var st:String = '';
        var maxCount:int;
        var curCount:int;
        var maxCountAtCurrentLevel:int = 0;
        if (_data.buildType == BuildType.FABRICA ){//|| _data.buildType == BuildType.FARM) {
            if (_data.blockByLevel) {
                arr = g.townArea.getCityObjectsById(_data.id);
                if (_data.blockByLevel[0] > g.user.level) {
                    im = new Image(g.interfaceAtlas.getTexture('shop_locked'));
                    st = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
                } else {
                    if (_data.blockByLevel.length == 1) {
                        if (arr.length == 0) {
                            st = '0/1';
                        } else {
                            im = new Image(g.interfaceAtlas.getTexture('shop_limit'));
                            st = '1/1';
                        }
                    } else {
                        for (i = 0; _data.blockByLevel.length; i++) {
                            if (_data.blockByLevel[i] < g.user.level) {
                                maxCountAtCurrentLevel++;
                            } else break;
                        }
                        if (maxCountAtCurrentLevel == arr.length) {
                            im = new Image(g.interfaceAtlas.getTexture('shop_limit'));
                            st = String(maxCountAtCurrentLevel) + '/' + String(maxCountAtCurrentLevel);
                        } else {
                            st = String(arr.length) + '/' + String(maxCountAtCurrentLevel);
                        }
                    }
                }
            }
        } else if (_data.buildType == BuildType.FARM) {
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                im = new Image(g.interfaceAtlas.getTexture('shop_locked'));
                st = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
            } else {
                arr = g.townArea.getCityObjectsById(_data.id);
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                if (maxCountAtCurrentLevel == arr.length) {
                    im = new Image(g.interfaceAtlas.getTexture('shop_limit'));
                    st = String(maxCountAtCurrentLevel) + '/' + String(maxCountAtCurrentLevel);
                } else {
                    st = String(arr.length) + '/' + String(maxCountAtCurrentLevel);
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
                    im = new Image(g.interfaceAtlas.getTexture('shop_locked'));
                    st = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
                } else {
                    st = '';
                    if (_state == STATE_FROM_INVENTORY) {
                        _countCost = 0;
                        _countTxt.text = 'Активировать';
                    } else {
                        _countCost = arr.length * _data.deltaCost + _data.cost;
                        _countTxt.text = String(_countCost);
                    }
                }
            }
        } else if (_data.buildType == BuildType.ANIMAL) {
            var dataFarm:Object = g.dataBuilding.objectBuilding[_data.buildId];
            if (dataFarm && dataFarm.blockByLevel) {
                if (g.user.level < dataFarm.blockByLevel[0]) {
                    im = new Image(g.interfaceAtlas.getTexture('shop_locked'));
                    st = 'Будет доступно на ' + String(dataFarm.blockByLevel[0]) + ' уровне';
                } else {
                    arr = g.townArea.getCityObjectsById(dataFarm.id);
                    maxCount = arr.length * dataFarm.maxAnimalsCount;
                    curCount = 0;
                    for (i=0; i<arr.length; i++) {
                        curCount += (arr[i] as Farm).arrAnimals.length;
                    }
                    if (maxCount == 0) {
                        st = 'Необходимо построить ' + String(dataFarm.name);
                    } else if (curCount == maxCount) {
                        im = new Image(g.interfaceAtlas.getTexture('shop_limit'));
                        st = String(maxCount) + '/' + String(maxCount);
                    } else {
                        st = String(curCount) + '/' + String(maxCount);
                    }
                }
            }
        } else if (_data.buildType == BuildType.TREE) {
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                im = new Image(g.interfaceAtlas.getTexture('shop_locked'));
                st = 'Будет доступно на ' + String(_data.blockByLevel[0]) + ' уровне';
            } else {
                arr = g.townArea.getCityObjectsById(_data.id);
                curCount = arr.length;
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                maxCount = maxCountAtCurrentLevel * _data.countUnblock;
                if (curCount == maxCount) {
                    im = new Image(g.interfaceAtlas.getTexture('shop_limit'));
                    st = String(maxCount) + '/' + String(maxCount);
                } else {
                    st = String(curCount) + '/' + String(maxCount);
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
                if (curCount == maxCount) {
                    im = new Image(g.interfaceAtlas.getTexture('shop_limit'));
                    st = String(maxCount) + '/' + String(maxCount);
                } else {
                    st = String(curCount) + '/' + String(maxCount);
                }
            }
        } else if (_data.buildType == BuildType.CAT) {
            curCount = g.managerCats.curCountCats;
            maxCount = g.managerCats.maxCountCats;
            if (curCount == maxCount) {
                im = new Image(g.interfaceAtlas.getTexture('shop_limit'));
                st = String(maxCount) + '/' + String(maxCount);
            } else {
                st = String(curCount) + '/' + String(maxCount);
            }
        }

        if (st != '') {
            _lockedTxt.text = st;
            if (im) {
                _lockedSprite.addChildAt(im, 0);
                source.endClickCallback = null;
            }
        } else {
            _lockedSprite.visible = false;
        }
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
        if (_data.buildType == BuildType.CAT) {
            _countCost = g.dataCats[g.managerCats.curCountCats].cost;
            _data.cost = _countCost;
        } else {
            _countCost = _data.cost;
        }
        if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
            var p:Point = new Point(source.x, source.y);
            p = source.parent.localToGlobal(p);
            new FlyMessage(p,"откроется на " + String(_data.blockByLevel) + " уровне");
            return;
        }
        if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE) {
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
        g.bottomPanel.cancelBoolean(true);

        if (_data.buildType == BuildType.RIDGE) {
//            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.woShop.onClickExit();
            g.toolsModifier.startMove(_data, afterMove);
        } else if (_data.buildType == BuildType.DECOR_TAIL) {
            g.woShop.onClickExit();
            if (_state == STATE_FROM_INVENTORY) {
                g.toolsModifier.startMoveTail(_data, afterMoveFromInventory, true);
            } else {
                g.toolsModifier.startMoveTail(_data, afterMove, true);
            }
        } else if (_data.buildType == BuildType.CAT) {
            g.bottomPanel.cancelBoolean(false);
            g.managerCats.onBuyCatFromShop();
            updateItem();
        } else if (_data.buildType != BuildType.ANIMAL) {
            g.woShop.onClickExit();
//            g.toolsModifier.modifierType = ToolsModifier.MOVE;
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
                    g.bottomPanel.cancelBoolean(false);
                    return;
                }
            }
            Cc.error('ShopItem:: no such Farm :(');
            g.bottomPanel.cancelBoolean(false);
        }
    }

    private function afterMove(_x:Number, _y:Number):void {
        if (_data.buildType == BuildType.ANIMAL || _data.buildType == BuildType.FARM || _data.buildType == BuildType.FABRICA
                || _data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE) {
            g.bottomPanel.cancelBoolean(false);
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
    }

    private function updateItem():void {
        var curCount:int;
        var maxCount:int;
        var im:Image;

        if (_data.buildType == BuildType.CAT) {
            curCount = g.managerCats.curCountCats;
            maxCount = g.managerCats.maxCountCats;
            if (curCount == maxCount) {
                im = new Image(g.interfaceAtlas.getTexture('shop_limit'));
                _lockedTxt.text = String(maxCount) + '/' + String(maxCount);
            } else {
                _lockedTxt.text = String(curCount) + '/' + String(maxCount);
            }
        }

        if (im) {
            _lockedSprite.addChildAt(im, 0);
            source.endClickCallback = null;
        }
    }
}
}
