/**
 * Created by user on 10/6/15.
 */
package windows.noPlaces {
import data.DataMoney;
import manager.ManagerFilters;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.MCScaler;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WONoPlaces extends WindowMain {

    private var _btn:CButton;
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
        _windowType = WindowsManager.WO_NO_PLACES;
        _woWidth = 400;
        _woHeight = 380;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);

        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.GREEN, true);
        _btn.y = 120;
        _source.addChild(_btn);
        _btn.clickCallback = onClick;
        _txtName = new TextField(300,30,"НЕДОСТАТОЧНО МЕСТА!",g.allData.fonts['BloggerBold'],22,Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtName.x = -150;
        _txtName.y = -150;
        _source.addChild(_txtName);
        _txtText = new TextField(350,70,"",g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;

        _source.addChild(_txtText);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        MCScaler.scale(im,35,35);
        im.x = 80;
        im.y = 4;
        _btn.addChild(im);
        im.filter = ManagerFilters.SHADOW_TINY;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_k"));
        im.x = -50;
        im.y = -50;
        _txtCost = new TextField(50,50,"","g.allData.fonts['BloggerBold']",24,Color.WHITE);
        _txtCost.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _txtCost.x = 30;
        _txtCost.y = -3;
        _btn.addChild(_txtCost);
        _source.addChild(im);
        _txtAdd = new TextField(100,100,"",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtAdd.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _source.addChild(_txtAdd);
        _last = false;
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
            _last = true;
            _cost = params[0];
            _txtCost.text = String(_price);
            _txtAdd.text = 'Ускорить';
            _txtAdd.x = -47;
            _txtAdd.y = -15;
            _txtText.x = -175;
            _txtText.y = -130;
        } else {
            _txtText.text = 'У вас нет свободных ячеек. Вы можете купить их за рубины и продолжить производство.';
            _btn.visible = true;
            _txtCost.text = String(_price);
            _txtAdd.x = -47;
            _txtAdd.y = -50;
            _txtAdd.text = 'Добавить ячейку';
            _txtText.x = -170;
            _txtText.y = -115;
        }

        super.showIt();
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
