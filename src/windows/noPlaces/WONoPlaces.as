/**
 * Created by user on 10/6/15.
 */
package windows.noPlaces {
import data.DataMoney;

import flash.filters.GlowFilter;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;
import windows.WOComponents.WindowBackground;

public class WONoPlaces extends Window{

    private var _contBtn:CSprite;
    private var _txtText:TextField;
    private var _imageBtn:Image;
    private var _imageHard:Image;
    private var _imageBg:Image;
    private var _txtCost:TextField;
    private var _woBG:WindowBackground;
    private var _price:int;
    private var _buyCallback:Function;

    public function WONoPlaces() {
        super();
        _woBG = new WindowBackground(400, 380);
        _source.addChild(_woBG);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('bt_close'), '');
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 200;
        _btnExit.y -= 190;

        _contBtn = new CSprite();
        _contBtn.x =-65;
        _contBtn.y = 100;
        _source.addChild(_contBtn);
        _contBtn.endClickCallback = onClick;
        _txtText = new TextField(200,100,"Недостаточно места",g.allData.fonts['BloggerBold'],24,Color.WHITE);
        _txtText.nativeFilters = [new GlowFilter(0x2d610d, 1, 3, 3, 5.0)];
        _txtText.x = -100;
        _txtText.y = -150;
        _imageBtn = new Image(g.allData.atlas['interfaceAtlas'].getTexture("bt_green"));
        _imageHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        MCScaler.scale(_imageHard,35,35);
        _imageHard.x = 80;
        _imageHard.y = 4;
        _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_k"));
        _imageBg.x = -50;
        _imageBg.y = -50;
        _txtCost = new TextField(50,50,"","g.allData.fonts['BloggerBold']",24,Color.WHITE);
        _txtCost.nativeFilters = [new GlowFilter(0x2d610d, 1, 3, 3, 5.0)];
        _txtCost.x = 30;
        _contBtn.addChild(_imageBtn);
        _contBtn.addChild(_txtCost);
        _contBtn.addChild(_imageHard);
        _source.addChild(_imageBg);
        _source.addChild(_txtText);
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    public function showItWithParams(price:int, callback:Function):void {
        _price = price;
        _txtCost.text = String(price);
        _buyCallback = callback;
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
