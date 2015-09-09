/**
 * Created by user on 7/13/15.
 */
package windows.ambar {
import data.DataMoney;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class UpdateItem {
    public var source:Sprite;
    private var _resourceId:int;
    private var _im:Image;
    private var _btn:CSprite;
    private var _btnTxt:TextField;
    private var _imGalo4ka:Image;
    private var _txtCount:TextField;
    private var _isAmbarItem:Boolean;
    private var _buyCallback:Function;
    private var _countForBuy:int;

    private var g:Vars = Vars.getInstance();

    public function UpdateItem(id:int, isAmbar:Boolean = true) {
        _resourceId = id;
        _isAmbarItem = isAmbar;
        source = new Sprite();
        var quad:Quad = new Quad(100, 100, Color.GRAY);
        quad.alpha = .2;
        source.addChild(quad);
        _im = new Image(g.instrumentAtlas.getTexture(g.dataResource.objectResources[_resourceId].imageShop));
        MCScaler.scale(_im, 80, 80);
        _im.x = 50 - _im.width/2;
        _im.y = 50 - _im.height/2;
        source.addChild(_im);

        _txtCount = new TextField(50, 20, '', "Arial", 14, Color.BLACK);
        _txtCount.x = 60;
        _txtCount.y = 80;
        source.addChild(_txtCount);

        _btn = new CSprite();
        _btn.y = 120;
        source.addChild(_btn);
        _btn.endClickCallback = onBuy;
        var imBG:Image = new Image(g.interfaceAtlas.getTexture('btn4'));
        imBG.x = 50 - imBG.width/2;
        _btn.addChild(imBG);
        var _txt:TextField = new TextField(100, 20, 'Купить', "Arial", 16, Color.BLACK);
        _txt.y = 5;
        _btn.addChild(_txt);

        _btnTxt = new TextField(50, 20, '', "Arial", 16, Color.BLACK);
        _btnTxt.x = 20;
        _btnTxt.y = 28;
        _btn.addChild(_btnTxt);

        var dmnt:Image = new Image(g.interfaceAtlas.getTexture('diamont'));
        MCScaler.scale(dmnt, 25, 25);
        dmnt.x = 57;
        dmnt.y = 25;
        _btn.addChild(dmnt);

        _imGalo4ka = new Image(g.interfaceAtlas.getTexture('galo4ka'));
        _imGalo4ka.x = 50 - _imGalo4ka.width/2;
        _imGalo4ka.y = 120;
        source.addChild(_imGalo4ka);
    }

    public function updateIt():void {
        var needCountForUpdate:int;
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
            updateIt();
            if (_buyCallback != null) {
                _buyCallback.apply();
            }
        } else {
            if (_isAmbarItem) {
                g.woAmbar.hideIt();
            } else {
                g.woSklad.hideIt();
            }
            g.woBuyCurrency.showItMenu();
            g.woBuyCurrency._contSoft.visible = false;
            g.woBuyCurrency._contHard.visible = true;
        }
    }
}
}
