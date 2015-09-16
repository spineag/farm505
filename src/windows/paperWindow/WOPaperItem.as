/**
 * Created by user on 7/24/15.
 */
package windows.paperWindow {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.BuildType;
import data.DataMoney;

import flash.geom.Point;


import manager.Vars;

import resourceItem.ResourceItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class WOPaperItem {
    public var source:Sprite;
    public var s:Sprite;
    private var _imageCoin:Image;
    private var _imageItem:Image;
    private var _txtCountResource:TextField;
    private var _txtCost:TextField;
    private var _data:Object;
    private var _dataResource:Object;
    private var _btnBuy:CSprite;
    private var _btnVisit:CSprite;
    private var _bg:Image;
    private var _plawkaSold:Image;

    private var g:Vars = Vars.getInstance();
    public function WOPaperItem() {
        source = new Sprite();
        _bg = new Image(g.interfaceAtlas.getTexture('shop_item'));
        _bg.scaleY = .5;
        _txtCost = new TextField(50,50,"000","Arial",18,Color.BLACK);
        _txtCost.touchable = false;
        _txtCost.x = 32;
        _txtCost.y = -12;
        _btnBuy = new CSprite();
        var im:Image = new Image(g.interfaceAtlas.getTexture('btn1'));
        im.width = _bg.width;
        im.height = 30;
        _btnBuy.addChild(im);
        _imageCoin = new Image(g.interfaceAtlas.getTexture("coin"));
        _imageCoin.x = 115;
        _imageCoin.y = 3;
        MCScaler.scale(_imageCoin,25,25);
        _txtCountResource = new TextField(50,50,"11111","Arial",14,Color.BLACK);
        _txtCountResource.x = 85;
        _txtCountResource.y = 55;

        _btnBuy.addChild(_txtCost);
        _btnBuy.addChild(_imageCoin);
        _btnBuy.y = _bg.height - 30;
        _btnBuy.endClickCallback = onClickBuy;

        _btnVisit = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('btn3'));
        im.width = _bg.width;
        im.height = 20;
        _btnVisit.addChild(im);
        var t:TextField = new TextField(im.width,50,"Все предложения","Arial",14,Color.BLACK);
        t.y = -15;
        t.touchable = false;
        _btnVisit.addChild(t);
        _btnVisit.y = -10;
        _btnVisit.endClickCallback = onClickVisit;
    }

    public function fillIt(ob:Object):void {
        source.addChild(_bg);
        source.addChild(_txtCountResource);
        source.addChild(_btnBuy);
        source.addChild(_btnVisit);

        _data = ob;
        _txtCost.text = String(_data.cost);
        _txtCountResource.text = String(_data.resourceCount);
        _dataResource = g.dataResource.objectResources[_data.resourceId];
        if (_dataResource.buildType == BuildType.INSTRUMENT) {
            _imageItem = new Image(g.instrumentAtlas.getTexture(_dataResource.imageShop));
        } else if (_dataResource.buildType == BuildType.PLANT) {
            _imageItem = new Image(g.plantAtlas.getTexture(_dataResource.imageShop));
        } else {
            _imageItem = new Image(g.resourceAtlas.getTexture(_dataResource.imageShop));
        }
        MCScaler.scale(_imageItem,50,50);
        _imageItem.x = _bg.width/2 - _imageItem.width/2;
        _imageItem.y = _bg.height/2 - _imageItem.height/2 - 15;
        source.addChild(_imageItem);
        if (_data.isBuyed) {
            _plawkaSold = new Image(g.interfaceAtlas.getTexture('plawka_sold'));
            _plawkaSold.x = _bg.width/2 - _plawkaSold.width/2;
            source.addChild(_plawkaSold);

        }
    }

    private function onClickBuy():void {
        if (_data.isBuyed) return;

        if (g.user.softCurrencyCount < _data.cost) {
            g.flyMessage.showIt(source, "Недостаточно денег");
            return;
        }
        if (_dataResource.placeBuild == BuildType.PLACE_AMBAR) {
            if (g.userInventory.currentCountInAmbar + _data.resourceCount > g.user.ambarMaxCount) {
//                g.flyMessage.showIt(source, "Амбар заполнен");
                g.woAmbarFilled.showAmbarFilled(true);
                return;
            }
        } else if (_dataResource.placeBuild == BuildType.PLACE_SKLAD) {
            if (g.userInventory.currentCountInSklad + _data.resourceCount > g.user.skladMaxCount) {
//                g.flyMessage.showIt(source, "Склад заполнен");
                g.woAmbarFilled.showAmbarFilled(false);
                return;
            }
        }
        _data.isBuyed = true;
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_data.cost);
        showFlyResource(_dataResource, _data.resourceCount);
        g.directServer.buyFromMarket(_data.id, null);
        _txtCost.text= '';
        _plawkaSold = new Image(g.interfaceAtlas.getTexture('plawka_sold'));
        _plawkaSold.x = 10;
        _plawkaSold.y = 20;
        source.addChild(_plawkaSold);
    }

    private function onClickVisit():void {
        if (!_data) return;
        g.woPaper.hideIt();
        g.woMarket.addAdditionalUser(_data);
        g.woMarket.showIt();
    }

    private function showFlyResource(d:Object, count:int):void {
        var im:Image;
        if (d.url == 'plantAtlas') {
            im = new Image(g.plantAtlas.getTexture(d.imageShop));
        } else if (d.url == 'instrumentAtlas') {
            im = new Image(g.instrumentAtlas.getTexture(d.imageShop));
        } else {
            im = new Image(g.resourceAtlas.getTexture(d.imageShop));
        }

        MCScaler.scale(im, 50, 50);
        var p:Point = new Point(_bg.width/2, _bg.height/2);
        p = source.localToGlobal(p);
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        im.x = p.x;
        im.y = p.y;
        g.cont.animationsResourceCont.addChild(im);
        g.craftPanel.showIt(d.placeBuild);
        p = g.craftPanel.pointXY();
        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(im);
            im.dispose();
            g.userInventory.addResource(d.id, count);
            var item:ResourceItem = new ResourceItem();
            item.fillIt(d);
            g.craftPanel.afterFly(item);
        };
        new TweenMax(im, .5, {x:p.x, y:p.y, ease:Linear.easeOut ,onComplete: f1});
    }

    public function clearIt():void {
        if (_plawkaSold) {
            if (source.contains(_plawkaSold)) source.removeChild(_plawkaSold);
            _plawkaSold.dispose();
            _plawkaSold = null;
        }
        if (_imageItem) {
            if (source.contains(_imageItem)) source.removeChild(_imageItem);
            _imageItem.dispose();
            _imageItem = null;
        }
        _txtCost.text = '';
        _txtCountResource.text = '';
    }

    public function unFillIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
    }
}
}
