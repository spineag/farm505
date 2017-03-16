/**
 * Created by andy on 7/24/16.
 */
package windows.shop {
import com.greensock.TweenMax;

import flash.geom.Point;
import flash.geom.Rectangle;
import manager.Vars;

import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import utils.CSprite;

public class DecorShopFilter {
    public static const FILTER_OTHER:int = 0;
    public static const FILTER_ALL:int = 1;
    public static const FILTER_TREES:int = 2;
    public static const FILTER_FENCE:int = 3;
    public static const FILTER_TAIL:int = 4;
    public static const FILTER_SPECIAL:int = 5;
    public static const FILTER_HOLIDAY:int = 6;

    private var _wo:WOShop;
    private var _source:Sprite;
    private var _itemsSprite:Sprite;
    private var _itemsSpriteMain:Sprite;
    private var _activeItem:DecorShopFilterItem;
    private var _arrItems:Array;
    private var g:Vars = Vars.getInstance();
    private var _isShow:Boolean;
    private var _black:CSprite;

    public function DecorShopFilter(wo:WOShop) {
        _wo = wo;
        _source = new Sprite();
        _source.x = 100;
        _source.y = 110;
        _wo.source.addChild(_source);
        _itemsSpriteMain = new Sprite();
        _itemsSprite = new Sprite();
        _itemsSprite.y = 5;
        _itemsSpriteMain.addChild(_itemsSprite);
        _source.addChild(_itemsSpriteMain);
        _itemsSpriteMain.mask = new Quad(200, 300);
        _itemsSpriteMain.mask.y = -300;
        _arrItems = [];
        _isShow = false;
        createItems();
    }

    public function set visible(v:Boolean):void {
        _source.visible = v;
    }

    private function deleteItems():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        _arrItems = [];
    }

    private function createItems():void {
        var arr:Array = [FILTER_ALL,FILTER_FENCE, FILTER_TAIL, FILTER_TREES,  FILTER_OTHER, FILTER_SPECIAL, FILTER_HOLIDAY];
        arr.splice(arr.indexOf(g.user.shopDecorFilter), 1);
        var item:DecorShopFilterItem;
        for (var i:int=0; i<6; i++) {
            item = new DecorShopFilterItem(arr[i], i, onItemClick, _itemsSprite);
            _arrItems.push(item);
        }
//        if (g.userTimer.partyToEndTimer > 0) _activeItem = new DecorShopFilterItem(6, 0, onActiveItemClick, _source);
//        else _activeItem = new DecorShopFilterItem(g.user.shopDecorFilter, 0, onActiveItemClick, _source);
        _activeItem = new DecorShopFilterItem(g.user.shopDecorFilter, 0, onActiveItemClick, _source);
        _activeItem.addButton();
        _arrItems.push(_activeItem);
    }

    private function onItemClick(type:int):void {
        g.user.shopDecorFilter = type;
        _itemsSprite.y = 5;
        _isShow = false;
        deleteBlack();
        deleteItems();
        createItems();
        _wo.onChangeDecorFilter();
    }

    private function onActiveItemClick(type:int):void {
        _isShow = !_isShow;
        if (_isShow) {
            // если Новый фильтр добовляешь ты, так добавь к {y: этому числу 31}
            TweenMax.to(_itemsSprite, .3, {y: -194});
            createBlack();
        } else {
            _itemsSprite.y = 5;
            deleteBlack();
        }
    }

    private function createBlack():void {
        _black = new CSprite();
        _black.addChild(new Quad(740, 530, Color.BLACK));
        _black.alpha = 0;
        _black.x = -465;
        _black.y = -350;
        _source.addChildAt(_black, 0);
        _black.endClickCallback = onBlackClick;
    }

    private function onBlackClick():void {
        _itemsSprite.y = 5;
        _isShow = false;
        deleteBlack();
    }

    private function deleteBlack():void {
        if (_black) {
            _source.removeChild(_black);
            _black.dispose();
            _black = null;
        }
    }

    public function deleteIt():void {
        _wo = null;
        deleteBlack();
        deleteItems();
        _activeItem = null;
        _source.dispose();
    }
}
}
