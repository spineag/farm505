/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import build.farm.Farm;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;

import manager.ManagerFilters;
import manager.Vars;
import starling.animation.Tween;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;

public class ShopList {
    private var _currentShopArr:Array;
    private var _arrItems:Array;
    private var _decor:Boolean;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _shift:int;
    private var _source:Sprite;
    private var _itemsSprite:Sprite;
    private var _txtPageNumber:TextField;
    private var _wo:WOShop;
    private var _parent:Sprite;

    private var g:Vars = Vars.getInstance();

    public function ShopList(parent:Sprite, wo:WOShop) {
        _wo = wo;
        _arrItems = [];
        _source = new Sprite();
        _source.x = 32;
        _source.y = 23;
        _source.clipRect = new Rectangle(0, -200, 605, 450);
        _parent = parent;
        _parent.addChild(_source);
        _itemsSprite = new Sprite();
        _source.addChild(_itemsSprite);
        addArrows(parent);

        _txtPageNumber = new TextField(100, 40, '657', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtPageNumber.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtPageNumber.x = 283;
        _txtPageNumber.y = 268;
        parent.addChild(_txtPageNumber);
    }

    private function addArrows(parent:Sprite):void {
        var im:Image;

        _leftArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.x = im.width;
        _leftArrow.addDisplayObject(im);
        _leftArrow.setPivots();
        _leftArrow.x = -22 + _leftArrow.width/2;
        _leftArrow.y = 94 + _leftArrow.height/2;
        parent.addChild(_leftArrow);
        _leftArrow.clickCallback = onLeftClick;

        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.scaleX = -1;
        _rightArrow.addDisplayObject(im);
        _rightArrow.setPivots();
        _rightArrow.x = 664 + _leftArrow.width/2;
        _rightArrow.y = 94 + _leftArrow.height/2;
        parent.addChild(_rightArrow);
        _rightArrow.clickCallback = onRightClick;
    }

    public function fillIt(arr:Array):void {
        var maxCount:int;
        var curCount:int;
        var item:ShopItem;
        var arAdded:Array;
        var i:int;
        var j:int;
        _currentShopArr = [];
        if (!arr.length) {
            Cc.error('ShopList:: fillIt: empty arr');
        }
        _decor = false;
        if (arr[0].buildType == BuildType.FABRICA) {
            for (j = 0; j < arr.length; j++) {
                arAdded = g.townArea.getCityObjectsById(arr[j].id);
                maxCount = 0;
                for (i = 0; arr[j].blockByLevel.length; i++) {
                    if (arr[j].blockByLevel[i] <= g.user.level) {
                        maxCount++;
                    } else break;
                }
                curCount = arAdded.length;
                if (curCount == arr[j].blockByLevel.length) {
                    arr[j].indexQueue = arr[j].blockByLevel[0] + 1000;
                } else if (curCount >= maxCount) {
                    arr[j].indexQueue = arr[j].blockByLevel[maxCount] + 500;
                } else {
                    arr[j].indexQueue = int(arr[j].blockByLevel[curCount]);
                }
            }
            arr.sortOn("indexQueue", Array.NUMERIC);
        } else if (arr[0].buildType == BuildType.TREE) {
            for (j = 0; j < arr.length; j++) {
                arAdded = g.townArea.getCityObjectsById(arr[j].id);
                maxCount = 0;
                for (i = 0; arr[j].blockByLevel.length; i++) {
                    if (arr[j].blockByLevel[i] <= g.user.level) {
                        maxCount += arr[j].countUnblock;
                    } else break;
                }
                curCount = arAdded.length;
                if (curCount >= maxCount) {
                    if (i == arr[j].blockByLevel.length) {
                        arr[j].indexQueue = arr[j].blockByLevel[0] + 1000;
                    } else {
                        arr[j].indexQueue = arr[j].blockByLevel[i] + 500;
                    }
                } else {
                    arr[j].indexQueue = int(arr[j].blockByLevel[i]);
                }
            }
            arr.sortOn("indexQueue", Array.NUMERIC);
        } else if (arr[0].buildType == BuildType.ANIMAL) {
            var dataFarm:Object;
            var arrFarm:Array;
            for (j = 0; j < arr.length; j++) {
                dataFarm = g.dataBuilding.objectBuilding[arr[j].buildId];
                arrFarm = g.townArea.getCityObjectsById(dataFarm.id);
                maxCount = arrFarm.length * dataFarm.maxAnimalsCount;
                curCount = 0;
                for (i = 0; i < arrFarm.length; i++) {
                    curCount += (arrFarm[i] as Farm).arrAnimals.length;
                }
                if (curCount >= maxCount) {
                    if (arrFarm.length >= dataFarm.blockByLevel.length) {
                        arr[j].indexQueue = dataFarm.blockByLevel[0] + 1000;
                    } else {
                        arr[j].indexQueue = dataFarm.blockByLevel[arrFarm.length] + 500;
                    }
                } else {
                    arr[j].indexQueue = int(dataFarm.blockByLevel[arrFarm.length]);
                }
            }
            arr.sortOn("indexQueue", Array.NUMERIC);
        } else if (arr[0].buildType == BuildType.FARM || arr[0].buildType == BuildType.CAT || arr[0].buildType == BuildType.RIDGE) {
            for (j = 0; j < arr.length; j++) {
                if (arr[j].buildType == BuildType.FARM) {
                    arAdded = g.townArea.getCityObjectsById(arr[j].id);
                    maxCount = 0;
                    for (i = 0; arr[j].blockByLevel.length; i++) {
                        if (arr[j].blockByLevel[i] <= g.user.level) {
                            maxCount++;
                        } else break;
                    }
                    curCount = arAdded.length;
                    if (curCount == arr[j].blockByLevel.length) {
                        arr[j].indexQueue = arr[j].blockByLevel[0] + 1000;
                    } else if (curCount >= maxCount) {
                        arr[j].indexQueue = arr[j].blockByLevel[maxCount] + 500;
                    } else {
                        arr[j].indexQueue = int(arr[j].blockByLevel[curCount]);
                    }
                } else if (arr[j].buildType == BuildType.CAT) {
                    arr[j].indexQueue = 0;
                } else {
                    arr[j].indexQueue = 1;
                }
            }
            arr.sortOn("indexQueue", Array.NUMERIC);
        } else if (arr[0].buildType == BuildType.DECOR || arr[0].buildType == BuildType.DECOR_FULL_FENСE ||
                arr[0].buildType == BuildType.DECOR_POST_FENCE || arr[0].buildType == BuildType.DECOR_TAIL) {
            for (j = 0; j < arr.length; j++) {
                arr[j].indexQueue = int(arr[j].blockByLevel[0]);
            }
            arr.sortOn("indexQueue", Array.NUMERIC);
        }

        _currentShopArr = arr;
        var l:int = _currentShopArr.length;
        if (l>4) l=4;
        for (i = 0; i < l; i++) {
            item = new ShopItem(_currentShopArr[i], _wo, i);
            item.source.x = 153*i;
            _itemsSprite.addChild(item.source);
            _arrItems.push(item);
        }

        checkArrows();
        _txtPageNumber.text = String(Math.ceil(_shift/4) + 1) + '/' + String(Math.ceil(_currentShopArr.length/4));
    }

    public function clearIt(b:Boolean = false):void {  // need remake
        while (_itemsSprite.numChildren) {
            _itemsSprite.removeChildAt(0);
        }

        if (!b && !_decor) {
            _shift = 0;
            animList();
        } else if (b && _decor){
            animList();
        } else if (b && !_decor) {
            _shift = 0;
            animList();
        }
        for (var i:int=0; i<_arrItems.length; i++) {
            _itemsSprite.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
    }

    private function checkArrows():void {
        _leftArrow.visible = true;
        _rightArrow.visible = true;

        if (_currentShopArr && _currentShopArr.length > 4) {
            if (_shift <= 0) {
                _leftArrow.setEnabled = false;
            } else {
                _leftArrow.setEnabled = true;
            }
            if (_shift >= _currentShopArr.length - 4) {
                _rightArrow.setEnabled = false;
            } else {
                _rightArrow.setEnabled = true;
            }
        } else {
            _leftArrow.visible = false;
            _rightArrow.visible = false;
        }
    }

    private function onLeftClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        var newCount:int = 4;
        if (_shift - newCount < 0) newCount = _shift;
        _shift -= newCount;

        var item:ShopItem;
        for (var i:int=0; i<newCount; i++) {
            item = new ShopItem(_currentShopArr[_shift + i], _wo, _shift + i);
            item.source.x = 153*(_shift + i);
            _itemsSprite.addChild(item.source);
            _arrItems.unshift(item);
        }
        _arrItems.sortOn('position', Array.NUMERIC);
        var f:Function = function():void {
            for (i=0; i<newCount; i++) {
                item = _arrItems.pop();
                _itemsSprite.removeChild(item.source);
                item.deleteIt();
            }
        };
        animList(f);
    }

    private function onRightClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        var newCount:int = 4;
        if (_shift + newCount + 4 >= _currentShopArr.length) newCount = _currentShopArr.length - _shift - 4;

        var item:ShopItem;
        for (var i:int=0; i<newCount; i++) {
            if (_currentShopArr[_shift + 4 + i]) {
                item = new ShopItem(_currentShopArr[_shift + 4 + i], _wo, _shift + 4 + i);
                item.source.x = 153 * (_shift + 4 + i);
                _itemsSprite.addChild(item.source);
                _arrItems.push(item);
            }
        }
        _shift += newCount;
        _arrItems.sortOn('position', Array.NUMERIC);
        var f:Function = function():void {
            for (i=0; i<newCount; i++) {
                item = _arrItems.shift();
                _itemsSprite.removeChild(item.source);
                item.deleteIt();
            }
        };
        animList(f);
    }

    private function animList(callback:Function = null):void {
        var tween:Tween = new Tween(_itemsSprite, .5);
        tween.moveTo(-_shift*153, _itemsSprite.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            if (callback != null) callback.apply();
        };
        g.starling.juggler.add(tween);
        checkArrows();
        if(_currentShopArr)_txtPageNumber.text = String(Math.ceil(_shift/4) + 1) + '/' + String(Math.ceil(_currentShopArr.length/4));
    }

    public function getShopItemProperties(_id:int, addArrow:Boolean):Object {
        var ob:Object = {};
        var place:int=0;
        for (var i:int=0; i<_currentShopArr.length; i++) {
            if (_currentShopArr[i].id == _id) {
                place = i;
                break;
            }
        }
        ob.x = (_arrItems[place] as ShopItem).source.x;
        ob.y = (_arrItems[place] as ShopItem).source.y;
        var p:Point = new Point(ob.x, ob.y);
        p = _itemsSprite.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = 145;
        ob.height = 221;
        return ob;
    }

    public function getShopDirectItemProperties(a:int):Object {
        var ob:Object = {};
        ob.x = (_arrItems[_shift + a-1] as ShopItem).source.x;
        ob.y = (_arrItems[_shift + a-1] as ShopItem).source.y;
        var p:Point = new Point(ob.x, ob.y);
        p = _source.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = 145; //(_arrItems[_shift + a-1] as ShopItem).source.width;
        ob.height = 221; //(_arrItems[_shift + a-1] as ShopItem).source.height;
        return ob;
    }

    public function openOnResource(_id:int):void {
        var place:int = -1;
        for (var i:int=0; i<_currentShopArr.length; i++) {
            if (_currentShopArr[i].id == _id) {
                place = i;
                break;
            }
        }
        if (place != -1) {
            _shift = int(place/4);
            if (_shift >= _currentShopArr.length - 4) _shift = _currentShopArr.length - 4;
            if (_shift < 0) _shift = 0;
            var item:ShopItem;
            for (i=0; i< _arrItems.length; i++) {
                item = _arrItems[i];
                _itemsSprite.removeChild(item.source);
                item.deleteIt();
            }
            _arrItems.length = 0;
            for (i=0; i<4; i++) {
                if (_currentShopArr[_shift + i]) {
                    item = new ShopItem(_currentShopArr[_shift + i], _wo, _shift + i);
                    item.source.x = 153 * (_shift + i);
                    _itemsSprite.addChild(item.source);
                    _arrItems.push(item);
                }
            }

            _itemsSprite.x = -_shift*153;
            _txtPageNumber.text = String(Math.ceil(_shift/4) + 1) + '/' + String(Math.ceil(_currentShopArr.length/4));
            checkArrows();
        } else {
            Cc.error();
        }
    }

    public function deleteIt():void {
        _wo = null;
        _currentShopArr.length = 0;
        for (var i:int=0; i<_arrItems.length; i++) {
            _itemsSprite.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        _source.removeChild(_leftArrow);
        _leftArrow.deleteIt();
        _leftArrow = null;
        _source.removeChild(_rightArrow);
        _rightArrow.deleteIt();
        _rightArrow = null;
        _parent.removeChild(_source);
        _source.dispose();
        _parent = null;
        _source = null;
    }
}
}
