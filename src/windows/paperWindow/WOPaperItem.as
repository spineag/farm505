/**
 * Created by user on 7/24/15.
 */
package windows.paperWindow {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.display.Bitmap;

import flash.geom.Rectangle;

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import starling.utils.HAlign;

import user.Someone;

import utils.CSprite;
import utils.MCScaler;

public class WOPaperItem {
    public var source:CSprite;
    private var _imageItem:Image;
    private var _txtCountResource:TextField;
    private var _txtCost:TextField;
    private var _data:Object;
    private var _dataResource:Object;
    private var _bg:Sprite = new Sprite();
    private var _plawkaSold:Image;
    private var _ava:Sprite;
    private var _userAvatar:Image;
    private var _txtUserName:TextField;
    private var _txtResourceName:TextField;
    private var _p:Someone;

    private var g:Vars = Vars.getInstance();
    public function WOPaperItem(i:int) {
        source = new CSprite();

        _bg = new Sprite();
        source.addChild(_bg);
        var q:Quad = new Quad(172, 134, Color.WHITE);
        _bg.addChild(q);
        q = new Quad(172, 1, 0xffeac1);
        _bg.addChild(q);
        q = new Quad(172, 1, 0xffeac1);
        q.y = 134;
        _bg.addChild(q);
        q = new Quad(1, 134, 0xffeac1);
        _bg.addChild(q);
        q = new Quad(1, 134, 0xffeac1);
        q.x = 172;
        _bg.addChild(q);

        if (i%2) {
            q = new Quad(160, 50, 0x8eb8b9);
        } else {
            q = new Quad(160, 50, 0x36bf1c);
        }
        q.x = 7;
        q.y = 5;
        _bg.addChild(q);

        _ava = new Sprite();
        _ava.x = 9;
        _ava.y = 7;
        _ava.clipRect = new Rectangle(0, 0, 46, 46);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("birka_c"));
        im.x = -5;
        _ava.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("birka_c"));
        im.scaleY = -1;
        im.x = -5;
        im.y = 50;
        _ava.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("birka_cat"));
        MCScaler.scale(im, 38, 38);
        im.rotation = Math.PI/2;
        im.x = 40;
        im.y = 6;
        _ava.addChild(im);
        source.addChild(_ava);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins"));
        MCScaler.scale(im, 25, 25);
        im.x = 143;
        im.y = 60;
        source.addChild(im);

        _txtCost = new TextField(84, 62, "1500", g.allData.fonts['BloggerBold'], 20, ManagerFilters.TEXT_BLUE);
        _txtCost.hAlign = HAlign.RIGHT;
        _txtCost.touchable = false;
        _txtCost.x = 53;
        _txtCost.y = 42;
        source.addChild(_txtCost);

        _txtCountResource = new TextField(84, 62, "10 шт.", g.allData.fonts['BloggerMedium'], 14, ManagerFilters.TEXT_BLUE);
        _txtCountResource.hAlign = HAlign.RIGHT;
        _txtCountResource.touchable = false;
        _txtCountResource.x = 80;
        _txtCountResource.y = 70;
        source.addChild(_txtCountResource);

        _txtResourceName = new TextField(200, 30, "Смаженый кабаньчик", g.allData.fonts['BloggerMedium'], 14, ManagerFilters.TEXT_BLUE);
        _txtResourceName.hAlign = HAlign.RIGHT;
        _txtResourceName.touchable = false;
        _txtResourceName.x = -38;
        _txtResourceName.y = 103;
        source.addChild(_txtResourceName);

        _txtUserName = new TextField(120, 50, "Станислав Йованович", g.allData.fonts['BloggerBold'], 16, ManagerFilters.TEXT_BLUE);
        _txtUserName.hAlign = HAlign.LEFT;
        _txtUserName.touchable = false;
        _txtUserName.x = 56;
        _txtUserName.y = 12;
        source.addChild(_txtUserName);

        source.visible = false;
//        source.endClickCallback = onClickVisit;
    }

    public function updateAvatar():void {
        if (!_data) return;
        _txtUserName.text = _p.name + ' ' + _p.lastName;
        g.load.loadImage(_p.photo, onLoadPhoto);
    }

    public function fillIt(ob:Object):void {
        _data = ob;
        if (!_data) {
            Cc.error('WOPaperItem fillIt:: empty _data');
            g.woGameError.showIt();
            return;
        }
        source.visible = true;
        _txtCost.text = String(_data.cost);
        _txtCountResource.text = String(_data.resourceCount) + ' шт.';
        _dataResource = g.dataResource.objectResources[_data.resourceId];
        _txtResourceName.text = _dataResource.name;
        if (_dataResource.buildType == BuildType.PLANT)
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(_dataResource.imageShop + '_icon'));
        else
            _imageItem = new Image(g.allData.atlas[_dataResource.url].getTexture(_dataResource.imageShop));
        if (!_imageItem) {
            Cc.error('WOPaperItem fillIt:: no such image: ' + _dataResource.imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(_imageItem,50,50);
        _imageItem.x = 39 - _imageItem.width/2;
        _imageItem.y = 83 - +_imageItem.height/2;
        source.addChild(_imageItem);
        if (_data.isBuyed) {
            _plawkaSold = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka_sold'));
            _plawkaSold.x = _bg.width/2 - _plawkaSold.width/2;
            source.addChild(_plawkaSold);
        }
        _p = g.user.getSomeoneBySocialId(ob.userSocialId);
        if (_p.photo) {
            _txtUserName.text = _p.name + ' ' + _p.lastName;
            g.load.loadImage(_p.photo, onLoadPhoto);
        } else {
            _txtUserName.text = ob.userSocialId;
        }
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!_ava) return;
        if (!bitmap) {
            bitmap = g.pBitmaps[_p.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('WOPaperItem:: no photo for userId: ' + _p.userSocialId);
            return;
        }
        _userAvatar = new Image(Texture.fromBitmap(bitmap));
        MCScaler.scaleMin(_userAvatar, 46, 46);
        _ava.addChild(_userAvatar);
    }

    private function onClickVisit():void {
        if (!_data) return;
        g.woPaper.hideIt();
//        g.woMarket.addAdditionalUser(_data);
//        g.woMarket.showIt();
        g.woMarket.showItPapper(_p);
    }

    public function deleteIt():void {
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
        _txtResourceName.text = '';
        _txtUserName.text = '';
        source.visible = false;
        while (source.numChildren) source.removeChildAt(0);
        _txtCost = null;
        _txtCountResource = null;
        _txtResourceName = null;
        _txtUserName = null;
        while (_ava.numChildren) _ava.removeChildAt(0);
        _ava = null;
        while (_bg.numChildren) _bg.removeChildAt(0);
        _bg = null;
    }


//    private function onClickBuy():void {
//        if (_data.isBuyed) return;
//
//        if (g.user.softCurrencyCount < _data.cost) {
//            var p:Point = new Point(source.x, source.y);
//            p = source.parent.localToGlobal(p);
//            new FlyMessage(p, "Недостаточно денег");
//            return;
//        }
//        if (_dataResource.placeBuild == BuildType.PLACE_AMBAR) {
//            if (g.userInventory.currentCountInAmbar + _data.resourceCount > g.user.ambarMaxCount) {
////                g.flyMessage.showIt(source, "Амбар заполнен");
//                g.woAmbarFilled.showAmbarFilled(true);
//                return;
//            }
//        } else if (_dataResource.placeBuild == BuildType.PLACE_SKLAD) {
//            if (g.userInventory.currentCountInSklad + _data.resourceCount > g.user.skladMaxCount) {
////                g.flyMessage.showIt(source, "Склад заполнен");
//                g.woAmbarFilled.showAmbarFilled(false);
//                return;
//            }
//        }
//        _data.isBuyed = true;
//        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_data.cost);
//        showFlyResource(_dataResource, _data.resourceCount);
//        g.directServer.buyFromMarket(_data.id, null);
//        _txtCost.text= '';
//        _plawkaSold = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka_sold'));
//        _plawkaSold.x = 10;
//        _plawkaSold.y = 20;
//        source.addChild(_plawkaSold);
//    }


//    private function showFlyResource(d:Object, count:int):void {
//        var im:Image;
//        if (!d) {
//            Cc.error('WOPaperItem fillIt:: empty _data');
//            g.woGameError.showIt();
//            return;
//        }
//        im = new Image(g.allData.atlas[d.url].getTexture(d.imageShop));
//        if (!im) {
//            Cc.error('WOPaperItem fillIt:: no such image: ' + d.imageShop);
//            g.woGameError.showIt();
//            return;
//        }
//        MCScaler.scale(im, 50, 50);
//        var p:Point = new Point(_bg.width/2, _bg.height/2);
//        p = source.localToGlobal(p);
//        im.pivotX = im.width/2;
//        im.pivotY = im.height/2;
//        im.x = p.x;
//        im.y = p.y;
//        g.cont.animationsResourceCont.addChild(im);
//        g.craftPanel.showIt(d.placeBuild);
//        p = g.craftPanel.pointXY();
//        var f1:Function = function():void {
//            g.cont.animationsResourceCont.removeChild(im);
//            im.dispose();
//            g.userInventory.addResource(d.id, count);
//            var item:ResourceItem = new ResourceItem();
//            item.fillIt(d);
//            g.craftPanel.afterFly(item);
//        };
//        new TweenMax(im, .5, {x:p.x, y:p.y, ease:Linear.easeOut ,onComplete: f1});
//    }

}
}
