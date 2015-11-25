/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import data.BuildType;
import data.BuildType;

import flash.geom.Rectangle;

import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;

import starling.display.Sprite;

import utils.CSprite;

public class ShopList {
    private var _arrItems:Array;
    private var _leftArrow:CSprite;
    private var _rightArrow:CSprite;
    private var _shift:int;
    private var _source:Sprite;
    private var _itemsSprite:Sprite;

    private var g:Vars = Vars.getInstance();

    public function ShopList(parent:Sprite) {
        _arrItems = [];
        _source = new Sprite();
        _source.x = -353;
        _source.y = -22;
        _source.clipRect = new Rectangle(0, 0, 708, 253);
        parent.addChild(_source);
        _itemsSprite = new Sprite();
        _source.addChild(_itemsSprite);
        addArrows(parent);
    }

    private function addArrows(parent:Sprite):void {
        var im:Image;

        _leftArrow = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_arrow'));
        im.scaleX = -1;
        im.x = im.width;
        _leftArrow.addChild(im);
        _leftArrow.x = -393;
        _leftArrow.y = 39;
        parent.addChild(_leftArrow);
        _leftArrow.endClickCallback = onLeftClick;

        _rightArrow = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_arrow'));
        _rightArrow.addChild(im);
        _rightArrow.x = 360;
        _rightArrow.y = 39;
        parent.addChild(_rightArrow);
        _rightArrow.endClickCallback = onRightClick;
    }

    public function fillIt(arr:Array):void {
        var n:int;
        var item:ShopItem;
        var arLocked:Array;
        arLocked=[];
        var ar:Array;
        var ar2:Array;
        var obj:Object;
        ar2 = [];
        ar =[];
        for (var j:int = 0; j < arr.length; j++) {
                arLocked = g.townArea.getCityObjectsById(arr[j].id);
                if (arr[j].buildType == BuildType.FABRICA){
                    if (arLocked.length == 1) {
                        ar2.push(arr[j]);
                    } else {
                        ar.push(arr[j]);
                    }
                } else if (arr[j].buildType == BuildType.RIDGE || arr[j].buildType == BuildType.FARM || arr[j].buildType == BuildType.PET_HOUSE) {
                    ar.push(arr[j]);
                } else if (arr[j].buildType == BuildType.TREE){
                    obj = {};
                    obj = g.dataBuilding.objectBuilding[arr[j].id];
                    obj.byLevel = arr[j].blockByLevel[0];
                    ar2.push(obj);
                    ar2.sortOn("byLevel", Array.NUMERIC);
                } else if (arr[j].buildType == BuildType.DECOR || arr[j].buildType == BuildType.DECOR_FULL_FENСE ||
                    arr[j].buildType == BuildType.DECOR_POST_FENCE || arr[j].buildType == BuildType.DECOR_TAIL) {
                    ar.push(arr[j]);
                } else if (arr[j].buildType == BuildType.ANIMAL || arr[j].buildType == BuildType.CAT) {
                    ar.push(arr[j]);
                }
        }

            ar.sortOn("blockByLevel", Array.NUMERIC);
            ar = ar.concat(ar2);

        for (var i:int = 0; i < ar.length; i++) {
            item = new ShopItem(ar[i]);
            item.source.x = 180*i;
            _itemsSprite.addChild(item.source);
            _arrItems.push(item);
        }

        checkArrows();
    }

    public function clearIt():void {
        while (_itemsSprite.numChildren) {
            _itemsSprite.removeChildAt(0);
        }
        _itemsSprite.x = 0;
        _shift = 0;
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
                _leftArrow.visible = false;
            }
            if (_shift >= _arrItems.length - 4){
                _rightArrow.visible = false;
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
        tween.moveTo(-_shift*180, _itemsSprite.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);
        checkArrows();
    }
}
}
