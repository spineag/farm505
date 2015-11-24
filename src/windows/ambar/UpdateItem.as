/**
 * Created by user on 7/13/15.
 */
package windows.ambar {
import data.DataMoney;

import flash.filters.GlowFilter;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;
import windows.WOComponents.WOButtonTexture;

public class UpdateItem {
    public var source:CSprite;
    private var _resourceId:int;
    private var _bg:Sprite;
    private var _btn:CSprite;
    private var _btnTxt:TextField;
    private var _imGalo4ka:Image;
    private var _txtCount:TextField;
    private var _isAmbarItem:Boolean;
    private var _buyCallback:Function;
    private var _countForBuy:int;

    private var g:Vars = Vars.getInstance();

    public function UpdateItem() {
        source = new CSprite();
        _bg = new CartonBackgroundIn(100, 100);
        source.addChild(_bg);
        source.hoverCallback = onHover;
        source.outCallback = onOut;

        _txtCount = new TextField(50,20,'',g.allData.fonts['BloggerMedium'],14,0xf46809);
        _txtCount.nativeFilters = [new GlowFilter(Color.WHITE, 1, 6, 6, 9.0)];
        _txtCount.x = 60;
        _txtCount.y = 80;
        source.addChild(_txtCount);

        _btn = new CSprite();
        _btn.y = 120;
        source.addChild(_btn);
        _btn.endClickCallback = onBuy;
        var imBG:Sprite = new WOButtonTexture(100, 60, WOButtonTexture.BLUE);
        _btn.addChild(imBG);
        var _txt:TextField = new TextField(100,20,'Купить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
        _txt.nativeFilters = [new GlowFilter(0x3a8013, 1, 6, 6, 9.0)];
        _txt.y = 5;
        _btn.addChild(_txt);

        _btnTxt = new TextField(50,20,'Увеличить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
        _btnTxt.nativeFilters = [new GlowFilter(0x0356e2, 1, 6, 6, 9.0)];
        _btnTxt.x = 20;
        _btnTxt.y = 28;
        _btn.addChild(_btnTxt);

        var dmnt:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(dmnt, 25, 25);
        dmnt.x = 57;
        dmnt.y = 25;
        _btn.addChild(dmnt);

        _imGalo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _imGalo4ka.x = 50 - _imGalo4ka.width/2;
        _imGalo4ka.y = 120;
        source.addChild(_imGalo4ka);
    }

    public function updateIt(id:int, isAmbar:Boolean = true):void {
        var needCountForUpdate:int;
        _resourceId = id;
        _isAmbarItem = isAmbar;
        var curCount:int = g.userInventory.getCountResourceById(_resourceId);
        if (_isAmbarItem) {
            needCountForUpdate = g.dataBuilding.objectBuilding[12].startCountInstrumets + g.dataBuilding.objectBuilding[12].deltaCountAfterUpgrade * (g.user.ambarLevel-1);
            _txtCount.text = String(curCount) + '/' + String(needCountForUpdate);
            if (curCount >= needCountForUpdate) {
                _imGalo4ka.visible = true;
                _btn.visible = false;
            } else {
                _imGalo4ka.visible = false;
                _btn.visible = true;
                _countForBuy = needCountForUpdate - curCount;
                _btnTxt.text = String(_countForBuy * g.dataResource.objectResources[_resourceId].priceHard);
            }
        } else {
            needCountForUpdate = g.dataBuilding.objectBuilding[13].startCountInstrumets + g.dataBuilding.objectBuilding[13].deltaCountAfterUpgrade * (g.user.skladLevel-1);
            _txtCount.text = String(curCount) + '/' + String(needCountForUpdate);
            if (curCount >= needCountForUpdate) {
                _imGalo4ka.visible = true;
                _btn.visible = false;
            } else {
                _imGalo4ka.visible = false;
                _btn.visible = true;
                _countForBuy = needCountForUpdate - curCount;
                _btnTxt.text = String(_countForBuy * g.dataResource.objectResources[_resourceId].priceHard);
            }
        }
    }

    public function get isFull():Boolean {
        return _imGalo4ka.visible;
    }

    public function set onBuyCallback(f:Function):void {
        _buyCallback = f;
    }

    private function onBuy():void {
        if (g.user.hardCurrency >= _countForBuy * g.dataResource.objectResources[_resourceId].priceHard) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countForBuy * g.dataResource.objectResources[_resourceId].priceHard);
            g.userInventory.addResource(_resourceId, _countForBuy);
            updateIt(_resourceId, _isAmbarItem);
            if (!_isAmbarItem) {
                g.woSklad.smallUpdate();
            }
            if (_buyCallback != null) {
                _buyCallback.apply();
            }
        } else {
            if (_isAmbarItem) {
                g.woAmbar.hideIt();
            } else {
                g.woSklad.hideIt();
            }
            g.woBuyCurrency.showItMenu(true);
        }
    }

    private function onHover():void {
        g.resourceHint.showIt(_resourceId,"",source.x,source.y,source);
    }

    private function onOut():void {
        g.resourceHint.hideIt();
    }
}
}
