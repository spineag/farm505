/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import build.farm.Farm;

import data.BuildType;

import flash.filters.GlowFilter;
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
    private var _arrItems:Array;
    private var _decor:Boolean;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _shift:int;
    private var _source:Sprite;
    private var _itemsSprite:Sprite;
    private var _txtPageNumber:TextField;

    private var g:Vars = Vars.getInstance();

    public function ShopList(parent:Sprite) {
        _arrItems = [];
        _source = new Sprite();
        _source.x = 32;
        _source.y = 23;
        _source.clipRect = new Rectangle(0, 0, 605, 245);
        parent.addChild(_source);
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
        var item:ShopItem;
        var arLocked:Array = [];
        var ar:Array = [];
        var ar2:Array = [];
        var obj:Object;
        var b:Boolean;
        _decor = false;
        for (var j:int = 0; j < arr.length; j++) {
            var maxCount:int = 0;
            var curCount:int = 0;
            if (arr[j].buildType == BuildType.FABRICA) {
                arLocked = g.townArea.getCityObjectsById(arr[j].id);
                b = true;
                if (arLocked.length == 1) {
                    ar2.push(arr[j]);
                } else {
                    ar.push(arr[j]);
                }
            } else if (arr[j].buildType == BuildType.RIDGE || arr[j].buildType == BuildType.FARM || arr[j].buildType == BuildType.PET_HOUSE || arr[j].buildType == BuildType.CAT) {

                b = false;
                if(arr[j].buildType == BuildType.FARM) {
                    arLocked = g.townArea.getCityObjectsById(arr[j].id);
                    for (i = 0; arr[j].blockByLevel.length; i++) {
                        if (arr[j].blockByLevel[i] <= g.user.level) {
                            maxCount++;
                        } else break;
                    }
                     if (arLocked.length != maxCount) {
                        obj = {};
                        obj = g.dataBuilding.objectBuilding[arr[j].id];
                        obj.byLevel = arr[j].blockByLevel[0];
                        ar2.unshift(obj);
                        ar2.sortOn("byLevel", Array.NUMERIC);
                    } else {
                        ar2.push(arr[j]);
                    }
                }
                if (arr[j].buildType == BuildType.RIDGE) ar.push(arr[j]);//ar.unshift(arr[j]);
                if (arr[j].buildType == BuildType.CAT) ar.push(arr[j]);//ar.unshift(arr[j])
            } else if (arr[j].buildType == BuildType.TREE) {
                arLocked = g.townArea.getCityObjectsById(arr[j].id);
                b = false;
                for (i = 0; arr[j].blockByLevel.length; i++) {
                    if (arr[j].blockByLevel[i] <= g.user.level) {
                        maxCount++;
                    } else break;
                }
                maxCount = maxCount * arr[j].countUnblock;
                if (arLocked.length == maxCount) {
                    ar2.push(arr[j]);
                } else {
                    obj = {};
                    obj = g.dataBuilding.objectBuilding[arr[j].id];
                    obj.byLevel = arr[j].blockByLevel[0];
                    ar.push(obj);
                    ar.sortOn("byLevel", Array.NUMERIC);
                }

            } else if (arr[j].buildType == BuildType.DECOR || arr[j].buildType == BuildType.DECOR_FULL_FENСE ||
                    arr[j].buildType == BuildType.DECOR_POST_FENCE || arr[j].buildType == BuildType.DECOR_TAIL) {
                b = true;
                _decor = true;
                ar.push(arr[j]);
            } else if (arr[j].buildType == BuildType.ANIMAL) {
                b = false;
                var dataFarm:Object = g.dataBuilding.objectBuilding[arr[j].buildId];
                    var ar3:Array;
                    ar3=[];
                    if (g.user.level < dataFarm.blockByLevel[0]) {
                        ar2.push(arr[j]);
                    } else {
                        ar3 = g.townArea.getCityObjectsById(dataFarm.id);
                        maxCount = ar3.length * dataFarm.maxAnimalsCount;
                        curCount = 0;
                        for (i = 0; i < ar3.length; i++) {
                            curCount += (ar3[i] as Farm).arrAnimals.length;
                        }
                        if (maxCount == 0) {
                            ar.push(arr[j])
                        } else if (curCount >= maxCount) {
                            ar2.push(arr[j])
                        } else {
                            ar.unshift(arr[j]);
                        }
                    }
            }
        }
        if (b) {
            ar.sortOn("blockByLevel", Array.NUMERIC);
            ar = ar.concat(ar2);
        } else {
            ar = ar.concat(ar2);
        }
        for (var i:int = 0; i < ar.length; i++) {
            item = new ShopItem(ar[i]);
            item.source.x = 153*i;
            _itemsSprite.addChild(item.source);
            _arrItems.push(item);
        }

        checkArrows();
        _txtPageNumber.text = String(Math.ceil(_shift/4) + 1) + '/' + String(Math.ceil(_arrItems.length/4));
    }

    public function clearIt(b:Boolean = false):void {
        while (_itemsSprite.numChildren) {
            _itemsSprite.removeChildAt(0);
        }
//        _itemsSprite.x = 0;
//        if (g.woShop.getAnimalClick) {
//            _shift = 0;
//            animList();
//            g.woShop.activateTab(2);

        if (!b && !_decor) {
            _shift = 0;
            animList();
            g.woShop.activateTab(1);
        } else if (b && _decor){
            animList();
//            _decor = false;
        } else if (!b && _decor) {
            _shift = 0;
            animList();
            g.woShop.activateTab(1);
        }
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].clearIt();
        }
        _arrItems.length = 0;
    }

    private function checkArrows():void {
        _leftArrow.visible = true;
        _rightArrow.visible = true;

        if (_arrItems.length > 4) {
            if (_shift <= 0) {
                _leftArrow.setEnabled = false;
            } else {
                _leftArrow.setEnabled = true;
            }
            if (_shift >= _arrItems.length - 4){
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
        _shift -= 4;
        if (_shift < 0) _shift = 0;
        animList();
    }

    private function onRightClick():void {
        _shift += 4;
        if (_shift >= _arrItems.length - 4) _shift = _arrItems.length - 4;
        animList();
    }

    private function animList():void {
        var tween:Tween = new Tween(_itemsSprite, .5);
        tween.moveTo(-_shift*153, _itemsSprite.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);
        checkArrows();
        _txtPageNumber.text = String(Math.ceil(_shift/4) + 1) + '/' + String(Math.ceil(_arrItems.length/4));
    }
}
}
