/**
 * Created by user on 10/6/15.
 */
package windows.noPlaces {
import data.DataMoney;
import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WONoPlaces extends WindowMain {

    private var _btn:CButton;
    private var _txtName:CTextField;
    private var _txtText:CTextField;
    private var _txtCost:CTextField;
    private var _txtAdd:CTextField;
//    private var _txtButton:TextField;
    private var _woBG:WindowBackground;
    private var _price:int;
    private var _cost:int;
    private var _buyCallback:Function;
    private var _exitCallback:Function;
    private var _imageItem:Image;
    private var _last:Boolean;
    private var _txtIcon:CTextField;

    public function WONoPlaces() {
        super();
        _windowType = WindowsManager.WO_NO_PLACES;
        _woWidth = 400;
        _woHeight = 380;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        SOUND_OPEN = SoundConst.WO_AHTUNG;

        _btn = new CButton();
        _btn.addButtonTexture(220, 40, CButton.GREEN, true);
        _btn.y = 120;
        _source.addChild(_btn);
        _btn.clickCallback = onClick;
        _txtName = new CTextField(300,30,"Недостаточно места!");
        _txtName.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtName.x = -150;
        _txtName.y = -150;
        _source.addChild(_txtName);
        _txtText = new CTextField(350,70,"");
        _txtText.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _source.addChild(_txtText);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins_medium"));
        MCScaler.scale(im,32,32);
        im.x = 178;
        im.y = 6;
        _btn.addChild(im);
        im.filter = ManagerFilters.SHADOW_TINY;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_k"));
        im.x = -50;
        im.y = -50;
        _txtCost = new CTextField(200,50,"");
        _txtCost.setFormat(CTextField.BOLD18, 15, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtCost.x = -8;
        _txtCost.y = -5;
        _btn.addChild(_txtCost);
        _source.addChild(im);
        _txtAdd = new CTextField(100,100,"");
        _txtAdd.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _last = false;
        _txtIcon = new CTextField(80,200,"добавить ячейку очереди");
        _txtIcon.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR);
        _txtIcon.x = -37;
        _txtIcon.y = -102;
        _source.addChild(_txtIcon);
        _txtIcon.visible = false;
    }

    private function onClickExit(e:Event=null):void {
        if (_exitCallback != null) {
            _exitCallback.apply();
            _exitCallback = null;
        }
        super.hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _price = params[0];
        _buyCallback = callback;
        _exitCallback = params[2];
        _last = params[3];
        if (_last) {
            _txtText.text = 'Подождите пока освободится ячейка или ускорьте изготовление текущего продукта.';
            _imageItem = new Image(g.allData.atlas[g.dataResource.objectResources[params[1]].url].getTexture(g.dataResource.objectResources[params[1]].imageShop));
            MCScaler.scale(_imageItem,80,80);
            _imageItem.x = -40;
            _imageItem.y = -40;
            _source.addChild(_imageItem);
            _source.addChild(_txtAdd);
            _last = true;
            _cost = params[0];
            _txtCost.text = String('Ускорить за  ' + _price);
            _txtAdd.text = 'Ускорить';
            _txtAdd.x = -47;
            _txtAdd.y = -15;
            _txtText.x = -175;
            _txtText.y = -118;
            _txtIcon.visible = false;
//            _txtButton.text = 'Ускорить за '
        } else {
            _txtText.text = 'У вас нет свободных ячеек. Вы можете купить их за рубины и продолжить производство.';
            _btn.visible = true;
            _txtCost.text = String('Добавить ячейку за ' + _price);
            _txtAdd.x = -47;
            _txtAdd.y = -50;
            _txtAdd.text = 'Добавить ячейку';
            _txtText.x = -170;
            _txtText.y = -118;
//            _txtButton.text = 'Добавить ячейку за '
            _txtIcon.visible = true;
        }
        onWoShowCallback = onShow;
        super.showIt();
    }

    private function onShow():void {
        _txtAdd.updateIt();
        _txtCost.updateIt();
        _txtIcon.updateIt();
        _txtName.updateIt();
        _txtText.updateIt();
    }

    private function onClick():void {
        if (_last && g.user.hardCurrency >= _price) {
            if (_buyCallback != null) {
                _buyCallback.apply();
                _buyCallback = null;
            }
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_price);
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
            g.windowsManager.uncasheWindow();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
        }
        super.hideIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _buyCallback = null;
        _exitCallback = null;
        super.deleteIt();
    }
}
}
