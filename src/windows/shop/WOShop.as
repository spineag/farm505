/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import data.BuildType;

import flash.filters.GlowFilter;

import manager.ManagerFilters;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;

import utils.MCScaler;

import windows.WOComponents.Birka;

import windows.WOComponents.CartonBackground;
import windows.WOComponents.HorizontalPlawka;

import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOShop extends Window{
    private var _btnTab1:ShopTabBtn;
    private var _btnTab2:ShopTabBtn;
    private var _btnTab3:ShopTabBtn;
    private var _btnTab4:ShopTabBtn;
    private var _btnTab5:ShopTabBtn;
    private var _shopList:ShopList;
    private var curentTab:int;
    private var _shopSprite:Sprite;
    private var _contSprite:Sprite;
    private var _woBG:WindowBackground;
    private var _txtHardMoney:TextField;
    private var _txtSoftMoney:TextField;
    private var _txtBlueMoney:TextField;
    private var _txtGreenMoney:TextField;
    private var _txtYellowMoney:TextField;
    private var _txtRedMoney:TextField;

    public function WOShop() {
        super();
        _woWidth = 750;
        _woHeight = 590;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);

        _shopSprite = new Sprite();
        _shopSprite.x = -_woWidth/2 + 41;
        _shopSprite.y = -_woHeight/2 + 141;
        _shopSprite.filter = ManagerFilters.SHADOW;
        _source.addChild(_shopSprite);
        _contSprite = new Sprite();
        _contSprite.x = -_woWidth/2 + 41;
        _contSprite.y = -_woHeight/2 + 141;
        _source.addChild(_contSprite);
        _shopList = new ShopList(_contSprite);
        createShopTabBtns();
        curentTab = 1;

        createMoneyBlock();
        new Birka('МАГАЗИН', _source, _woWidth, _woHeight);
    }

    public function onClickExit(e:Event=null):void {
        _shopList.clearIt();
        hideIt();
    }

    override public function showIt():void{
        super.showIt();
        updateMoneyCounts();
        onTab(curentTab);
    }

    public function activateTab(a:int):void {
        curentTab = a;
    }

    public function createShopTabBtns():void {
        var c:CartonBackground = new CartonBackground(666, 320);
        _shopSprite.addChild(c);

        _btnTab1 = new ShopTabBtn(ShopTabBtn.VILLAGE, function():void {onTab(1)});
        _btnTab1.setPosition(7, - 81, _shopSprite.x, _shopSprite.y);
        _shopSprite.addChild(_btnTab1.source);
        _source.addChildAt(_btnTab1.cloneSource, 2);
        _btnTab2 = new ShopTabBtn(ShopTabBtn.ANIMAL, function():void {onTab(2)});
        _btnTab2.setPosition(7 + 133, - 81, _shopSprite.x, _shopSprite.y);
        _shopSprite.addChild(_btnTab2.source);
        _source.addChildAt(_btnTab2.cloneSource, 2);
        _btnTab3 = new ShopTabBtn(ShopTabBtn.FABRICA, function():void {onTab(3)});
        _btnTab3.setPosition(7 + 133*2, - 81, _shopSprite.x, _shopSprite.y);
        _shopSprite.addChild(_btnTab3.source);
        _source.addChildAt(_btnTab3.cloneSource, 2);
        _btnTab4 = new ShopTabBtn(ShopTabBtn.PLANT, function():void {onTab(4)});
        _btnTab4.setPosition(7 + 133*3, - 81, _shopSprite.x, _shopSprite.y);
        _shopSprite.addChild(_btnTab4.source);
        _source.addChildAt(_btnTab4.cloneSource, 2);
        _btnTab5 = new ShopTabBtn(ShopTabBtn.DECOR, function():void {onTab(5)});
        _btnTab5.setPosition(7 + 133*4, - 81, _shopSprite.x, _shopSprite.y);
        _shopSprite.addChild(_btnTab5.source);
        _source.addChildAt(_btnTab5.cloneSource, 2);
    }

    private function onTab(a:int):void {
        var arr:Array = [];
        var obj:Object;
        var id:String;

        curentTab = a;
        _btnTab1.activateIt(false);
        _btnTab2.activateIt(false);
        _btnTab3.activateIt(false);
        _btnTab4.activateIt(false);
        _btnTab5.activateIt(false);

        switch (a) {
            case 1: _btnTab1.activateIt(true);
                obj = g.dataBuilding.objectBuilding;
                arr.push(g.managerCats.catInfo);
                for (id in obj) {
                    if (obj[id].buildType == BuildType.RIDGE || obj[id].buildType == BuildType.FARM || obj[id].buildType == BuildType.PET_HOUSE) {
                        arr.push(obj[id]);
                    }
                }
                break;
            case 2: _btnTab2.activateIt(true);
                obj = g.dataAnimal.objectAnimal;
                for (id in obj) {
                        arr.push(obj[id]);
                }
                break;
            case 3: _btnTab3.activateIt(true);
                obj = g.dataBuilding.objectBuilding;
                for (id in obj) {
                    if (obj[id].buildType == BuildType.FABRICA) {
                        arr.push(obj[id]);
                    }
                }
                break;
            case 4: _btnTab4.activateIt(true);
                obj = g.dataBuilding.objectBuilding;
                for (id in obj) {
                    if (obj[id].buildType == BuildType.TREE) {
                        arr.push(obj[id]);
                    }
                }
                break;
            case 5: _btnTab5.activateIt(true);
                obj = g.dataBuilding.objectBuilding;
                for (id in obj) {
                    if (obj[id].buildType == BuildType.DECOR || obj[id].buildType == BuildType.DECOR_FULL_FENСE ||
                            obj[id].buildType == BuildType.DECOR_POST_FENCE || obj[id].buildType == BuildType.DECOR_TAIL) {
                        arr.push(obj[id]);
                    }
                }
                break;
        }
        _shopList.clearIt();
        _shopList.fillIt(arr);
    }

    private function createMoneyBlock():void {
        var txt:TextField = new TextField(250, 40, 'Ваши сбережения:', g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -_woWidth/2 + 238;
        txt.y = -_woHeight/2 + 461;
        _source.addChild(txt);

        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
            g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), 104);
        pl.x = -_woWidth/2 + 63;
        pl.y = -_woHeight/2 + 509;
        _source.addChild(pl);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 46, 46);
        im.x = -_woWidth/2 + 41;
        im.y = -_woHeight/2 + 505;
        _source.addChild(im);
        var btn:CButton = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 38, 38);
        btn.addDisplayObject(im);
        btn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 24, 24);
        im.x = im.y = 7;
        btn.addChild(im);
        btn.x = -_woWidth/2 + 163;
        btn.y = -_woHeight/2 + 528;
        _source.addChild(btn);
        var f1:Function = function ():void {
            onClickExit();
            g.woBuyCurrency.showItMenu(true);
        };
        btn.clickCallback = f1;

        pl = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), 104);
        pl.x = -_woWidth/2 + 218;
        pl.y = -_woHeight/2 + 509;
        _source.addChild(pl);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        MCScaler.scale(im, 48, 48);
        im.x = -_woWidth/2 + 196;
        im.y = -_woHeight/2 + 504;
        _source.addChild(im);
        btn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 38, 38);
        btn.addDisplayObject(im);
        btn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 24, 24);
        im.x = im.y = 7;
        btn.addChild(im);
        btn.x = -_woWidth/2 + 319;
        btn.y = -_woHeight/2 + 528;
        _source.addChild(btn);
        var f2:Function = function ():void {
            onClickExit();
            g.woBuyCurrency.showItMenu(false);
        };
        btn.clickCallback = f2;

        pl = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), 310);
        pl.x = -_woWidth/2 + 380;
        pl.y = -_woHeight/2 + 509;
        _source.addChild(pl);
        btn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 38, 38);
        btn.addDisplayObject(im);
        btn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 24, 24);
        im.x = im.y = 7;
        btn.addChild(im);
        btn.x = -_woWidth/2 + 687;
        btn.y = -_woHeight/2 + 528;
        _source.addChild(btn);
        var f3:Function = function ():void {
            onClickExit();
            g.woBuyCoupone.showItWO();
        };
        btn.clickCallback = f3;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone'));
        MCScaler.scale(im, 45, 45);
        im.x = -_woWidth/2 + 364;
        im.y = -_woHeight/2 + 505;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone'));
        MCScaler.scale(im, 45, 45);
        im.x = -_woWidth/2 + 439;
        im.y = -_woHeight/2 + 505;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone'));
        MCScaler.scale(im, 45, 45);
        im.x = -_woWidth/2 + 514;
        im.y = -_woHeight/2 + 505;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone'));
        MCScaler.scale(im, 45, 45);
        im.x = -_woWidth/2 + 589;
        im.y = -_woHeight/2 + 505;
        _source.addChild(im);

        _txtHardMoney = new TextField(63, 33, '88888', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtHardMoney.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtHardMoney.x = -_woWidth/2 + 81;
        _txtHardMoney.y = -_woHeight/2 + 512;
        _source.addChild(_txtHardMoney);
        _txtSoftMoney = new TextField(63, 33, '88888', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtSoftMoney.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtSoftMoney.x = -_woWidth/2 + 239;
        _txtSoftMoney.y = -_woHeight/2 + 512;
        _source.addChild(_txtSoftMoney);
        _txtRedMoney = new TextField(39, 33, '888', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtRedMoney.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtRedMoney.x = -_woWidth/2 + 400;
        _txtRedMoney.y = -_woHeight/2 + 512;
        _source.addChild(_txtRedMoney);
        _txtYellowMoney = new TextField(39, 33, '888', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtYellowMoney.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtYellowMoney.x = -_woWidth/2 + 475;
        _txtYellowMoney.y = -_woHeight/2 + 512;
        _source.addChild(_txtYellowMoney);
        _txtGreenMoney = new TextField(39, 33, '888', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtGreenMoney.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtGreenMoney.x = -_woWidth/2 + 550;
        _txtGreenMoney.y = -_woHeight/2 + 512;
        _source.addChild(_txtGreenMoney);
        _txtBlueMoney = new TextField(39, 33, '888', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtBlueMoney.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtBlueMoney.x = -_woWidth/2 + 625;
        _txtBlueMoney.y = -_woHeight/2 + 512;
        _source.addChild(_txtBlueMoney);
    }

    public function updateMoneyCounts():void {
        _txtHardMoney.text = String(g.user.hardCurrency);
        _txtSoftMoney.text = String(g.user.softCurrencyCount);
        _txtBlueMoney.text = String(g.user.blueCouponCount);
        _txtGreenMoney.text = String(g.user.greenCouponCount);
        _txtRedMoney.text = String(g.user.redCouponCount);
        _txtYellowMoney.text = String(g.user.yellowCouponCount);
    }
}
}
