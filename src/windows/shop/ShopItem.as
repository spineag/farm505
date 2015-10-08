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
        if (_data.image) {
            if (_data.url == "buildAtlas") {
                _im = new Image(g.tempBuildAtlas.getTexture(_data.image));
            } else if (_data.url == "treeAtlas") {
                _im = new Image(g.treeAtlas.getTexture(_data.image));
            }
            if (!_im) {
                Cc.error('ShopItem:: no such image: ' + _data.image);
                g.woGameError.showIt();
                return;
            }
            MCScaler.scale(_im, 100, 100);
            _im.x = 35 + 50 - _im.width / 2;
            _im.y = 30 + 50 - _im.height / 2;
            source.addChild(_im);
        } else {
            Cc.error('ShopItem:: no image in _data for _data.id: ' + _data.id);
            g.woGameError.showIt();
        }

        _nameTxt = new TextField(150, 70, String(_data.name), "Arial", 20, Color.BLACK);
        _nameTxt.x = 7;
        _nameTxt.y = 140;
        source.addChild(_nameTxt);

        _countCost = _data.cost;
        _countTxt = new TextField(122, 30, String(_countCost), "Arial", 16, Color.WHITE);
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
        if (_data.buildType == BuildType.FABRICA || _data.buildType == BuildType.FARM) {
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
        } else if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE) {
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
                    _countCost = arr.length * _data.deltaCost + _data.cost;
                    _countTxt.text = String(_countCost);
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
        _countCost = _data.cost;
        if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
            var p:Point = new Point(source.x, source.y);
            p = source.parent.localToGlobal(p);
            new FlyMessage(p,"откроется на " + String(_data.blockByLevel) + " уровне");
            return;
        }
        if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE) {
            if (_data.currency == DataMoney.SOFT_CURRENCY) {
                if (!g.userInventory.checkSoftMoneyCount(_countCost)) return;
            } else {
                if (!g.userInventory.checkHardMoneyCount(_countCost)) return;
            }
        } else {
            if (!g.userInventory.checkMoney(_data)) return;
        }
        g.bottomPanel.cancelBoolean(true);
        if (_data.buildType == BuildType.RIDGE) {
//            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.woShop.onClickExit();
            g.toolsModifier.startMove(_data, afterMove);
        } else if (_data.buildType == BuildType.DECOR_TAIL) {
            g.woShop.onClickExit();
            g.toolsModifier.startMoveTail(_data, afterMove, true);
        } else if (_data.buildType != BuildType.ANIMAL) {
            g.woShop.onClickExit();
//            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.toolsModifier.startMove(_data, afterMove,1,true);
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
            trace('no such Farm :(');
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
}
}
