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
    private var _txtName:TextField;
    private var _txtText:TextField;
    private var _txtCost:TextField;
    private var _txtAdd:TextField;
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
//        _contBtn.x =-5;
        _contBtn.y = 120;
        _source.addChild(_contBtn);
        _contBtn.clickCallback = onClick;
        _txtName = new TextField(200,100,"Недостаточно места",g.allData.fonts['BloggerBold'],20,Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtName.x = -100;
        _txtName.y = -190;
        _source.addChild(_txtName);
        _txtText = new TextField(300,100,"У вас нет свободных ячеек. Вы можете купить их за рубины и продолжить производство.",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtText.x = -150;
        _txtText.y = -150;
        _source.addChild(_txtText);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        MCScaler.scale(im,35,35);
        im.x = 80;
        im.y = 4;
        _contBtn.addChild(im);
        im.filter = ManagerFilters.SHADOW_TINY;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_k"));
        im.x = -50;
        im.y = -50;
        _txtCost = new TextField(50,50,"","g.allData.fonts['BloggerBold']",24,Color.WHITE);
        _txtCost.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _txtCost.x = 30;
        _txtCost.y = -3;
        _contBtn.addChild(_txtCost);
        _source.addChild(im);
        _txtAdd = new TextField(100,100,"Добавить ячейку",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtAdd.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtAdd.x = -47;
        _txtAdd.y = -50;
        _source.addChild(_txtAdd);
        _txtAdd.visible = false;
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
        if (_exitCallback != null) {
            _exitCallback.apply();
            _exitCallback = null;
        }
        _buyCallback = null;
    }

    public function showItWithParams(price:int, callback:Function, callbackExit:Function, last:Boolean = false):void {
        _price = price;
        _txtCost.text = String(price);
        _buyCallback = callback;
        _exitCallback = callbackExit;
        if (last) {
            _txtAdd.visible = false;
            _txtText.text = 'У вас нет свободных ячеек. Подождите пока освободится ячейка.';
            _contBtn.visible = false;
        } else {
            _txtAdd.visible = true;
            _txtText.text = 'У вас нет свободных ячеек. Вы можете купить их за рубины и продолжить производство.';
            _contBtn.visible = true;
        }

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
