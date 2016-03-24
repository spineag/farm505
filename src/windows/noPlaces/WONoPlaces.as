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
    private var _cost:int;
    private var _buyCallback:Function;
    private var _exitCallback:Function;
    private var _imageItem:Image;
    private var _last:Boolean;
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
        _txtName = new TextField(300,30,"НЕДОСТАТОЧНО МЕСТА!",g.allData.fonts['BloggerBold'],22,Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtName.x = -100;
        _txtName.y = -190;
        _source.addChild(_txtName);
        _txtText = new TextField(300,100,"У вас нет свободных ячеек. Вы можете купить их за рубины и продолжить производство.",g.allData.fonts['BloggerMedium'],18,Color.WHITE);
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
        _txtAdd = new TextField(100,100,"",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtAdd.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtAdd.x = -47;
        _txtAdd.y = -50;
        _source.addChild(_txtAdd);
        _last = false;
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
        if (_exitCallback != null) {
            _exitCallback.apply();
            _exitCallback = null;
        }
        _buyCallback = null;
        _source.removeChild(_imageItem);
    }

    public function showItWithParams(cost:int,price:int, callback:Function, callbackExit:Function, last:Boolean = false):void {
        _price = price;

        _buyCallback = callback;
        _exitCallback = callbackExit;
        if (last) {
            _txtText.text = 'Подождите пока освободится ячейка или ускорьте изготовление текущего продукта.';
            _imageItem = new Image(g.allData.atlas[g.dataResource.objectResources[price].url].getTexture(g.dataResource.objectResources[price].imageShop));
            MCScaler.scale(_imageItem,80,80);
            _imageItem.x = -40;
            _imageItem.y = -40;
            _source.addChild(_imageItem);
            _last = true;
            _cost = cost;
            _txtCost.text = String(cost);
            _txtAdd.x = -47;
            _txtAdd.y = -50;
            _txtAdd.text = 'ускорить';
            _txtAdd.x = -47;
            _txtAdd.y = -80;
        } else {
            _txtText.text = 'У вас нет свободных ячеек. Вы можете купить их за рубины и продолжить производство.';
            _contBtn.visible = true;
            _txtCost.text = String(price);
            _txtAdd.x = -47;
            _txtAdd.y = -50;
            _txtAdd.text = 'Добавить ячейку';
        }

        showIt();
    }

    private function onClick():void {
        hideIt();
        if (_last && g.user.hardCurrency >= _cost) {
            g.woFabrica.skipFirstCell();
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_cost);
            onClickExit();
            return;
        }
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
