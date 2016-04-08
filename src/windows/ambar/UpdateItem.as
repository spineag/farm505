/**
 * Created by user on 7/13/15.
 */
package windows.ambar {
import data.DataMoney;

import flash.filters.GlowFilter;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;
import windows.WOComponents.WOButtonTexture;
import windows.WindowsManager;

public class UpdateItem {
    public var source:CSprite;
    private var _contImage:CSprite;
    private var _resourceId:int;
    private var _bg:Sprite;
    private var _btn:CButton;
    private var _btnTxt:TextField;
    private var _imGalo4ka:Image;
    private var _txtCount:TextField;
    private var _isAmbarItem:Boolean;
    private var _buyCallback:Function;
    private var _countForBuy:int;
    private var _resourceImage:Image;
    private var _wo:WOAmbars;

    private var g:Vars = Vars.getInstance();

    public function UpdateItem(wo:WOAmbars) {
        _wo = wo;
        source = new CSprite();
        _contImage = new CSprite();
        _bg = new CartonBackgroundIn(100, 100);
        source.addChild(_bg);
        source.addChild(_contImage);
        _contImage.hoverCallback = onHover;
        _contImage.outCallback = onOut;

        _txtCount = new TextField(80,40,'',g.allData.fonts['BloggerBold'],18, Color.WHITE);
        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtCount.x = 60;
        _txtCount.y = 80;
        source.addChild(_txtCount);

        _btn = new CButton();
        _btn.addButtonTexture(100, 40, CButton.GREEN, true);
        _btn.x = 50;
        _btn.y = 140;
        source.addChild(_btn);
        _btn.clickCallback = onBuy;

        _btnTxt = new TextField(50,20,'50',g.allData.fonts['BloggerMedium'],18, Color.WHITE);
        _btnTxt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btnTxt.x = 16;
        _btnTxt.y = 10;
//        _contTxt.addChild(_btnTxt);
        _btn.addChild(_btnTxt);

        var dmnt:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(dmnt, 30, 30);
        dmnt.x = 57;
        dmnt.y = 4;
        _btn.addChild(dmnt);
        dmnt.filter = ManagerFilters.SHADOW_TINY;

        _imGalo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _imGalo4ka.x = 53 - _imGalo4ka.width/2;
        _imGalo4ka.y = 123;
        source.addChild(_imGalo4ka);
        _imGalo4ka.filter = ManagerFilters.SHADOW_TINY;
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
        if (_resourceImage) {
            _contImage.removeChild(_resourceImage);
            _resourceImage.dispose();
            _resourceImage = null;
        }
        _resourceImage = new Image(g.allData.atlas[g.dataResource.objectResources[_resourceId].url].getTexture(g.dataResource.objectResources[_resourceId].imageShop));
        MCScaler.scale(_resourceImage, 90, 90);
        _resourceImage.x = 50 - _resourceImage.width/2;
        _resourceImage.y = 50 - _resourceImage.height/2;
        _contImage.addChild(_resourceImage);
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
            _wo.smallUpdate();
            if (_buyCallback != null) {
                _buyCallback.apply();
            }
        } else {
            _wo.isCashed = false;
            _wo.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
        }
    }

    private function onHover():void {
        if (!g.resourceHint.isShowed)
            g.resourceHint.showIt(_resourceId,source.x,source.y,source,true);
    }

    private function onOut():void {
        g.resourceHint.hideIt();
    }

    public function deleteIt():void {
        _wo = null;
        source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        source.dispose();
        source = null;
    }
}
}
