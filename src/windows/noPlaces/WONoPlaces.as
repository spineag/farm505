/**
 * Created by user on 10/6/15.
 */
package windows.noPlaces {
import data.DataMoney;

import flash.filters.GlowFilter;

import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;
import windows.WOComponents.WindowBackground;

public class WONoPlaces extends Window{

    private var _contBtn:CButton;
    private var _txtText:TextField;
    private var _txtCost:TextField;
    private var _woBG:WindowBackground;
    private var _price:int;
    private var _buyCallback:Function;
    private var _exitCallback:Function;

    public function WONoPlaces() {
        super();
        _woWidth = 400;
        _woHeight = 380;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);

        _contBtn = new CButton();
        _contBtn.addButtonTexture(120, 40, CButton.GREEN, true);
        _contBtn.x =-5;
        _contBtn.y = 120;
        _source.addChild(_contBtn);
        _contBtn.clickCallback = onClick;
        _txtText = new TextField(200,100,"Недостаточно места",g.allData.fonts['BloggerBold'],24,Color.WHITE);
        _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtText.x = -100;
        _txtText.y = -150;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        MCScaler.scale(im,35,35);
        im.x = 80;
        im.y = 4;
        _contBtn.addDisplayObject(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_k"));
        im.x = -50;
        im.y = -50;
        _txtCost = new TextField(50,50,"","g.allData.fonts['BloggerBold']",24,Color.WHITE);
        _txtCost.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _txtCost.x = 30;
        _contBtn.addChild(_txtCost);
        _source.addChild(im);
        _source.addChild(_txtText);
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
        if (_exitCallback != null) {
            _exitCallback.apply();
            _exitCallback = null;
        }
        _buyCallback = null;
    }

    public function showItWithParams(price:int, callback:Function, callbackExit:Function):void {
        _price = price;
        _txtCost.text = String(price);
        _buyCallback = callback;
        _exitCallback = callbackExit;
        showIt();
    }

    private function onClick():void {
        hideIt();
        if (g.user.hardCurrency >= _price) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_price);
            if (_buyCallback != null) {
                _buyCallback.apply();
                _buyCallback = null;
            }
        } else {
            _buyCallback = null;
            g.woBuyCurrency.showItMenu(true);
        }
    }
}
}
