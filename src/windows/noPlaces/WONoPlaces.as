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
//    private var _txtButton:TextField;
    private var _woBG:WindowBackground;
    private var _price:int;
    private var _cost:int;
    private var _buyCallback:Function;
    private var _exitCallback:Function;
    private var _imageItem:Image;
    private var _last:Boolean;
    private var _txtIcon:TextField;

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
        _txtName = new TextField(300,30,"НЕДОСТАТОЧНО МЕСТА!",g.allData.bFonts['BloggerBold24'],22,Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtName.x = -150;
        _txtName.y = -150;
        _source.addChild(_txtName);
        _txtText = new TextField(350,70,"",g.allData.bFonts['BloggerBold18'],18,Color.WHITE);
        _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;

        _source.addChild(_txtText);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins_medium"));
        MCScaler.scale(im,35,35);
        im.x = 178;
        im.y = 4;
        _btn.addChild(im);
        im.filter = ManagerFilters.SHADOW_TINY;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_k"));
        im.x = -50;
        im.y = -50;
        _txtCost = new TextField(200,50,"",g.allData.bFonts['BloggerBold18'],16,Color.WHITE);
        _txtCost.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _txtCost.x = -8;
        _txtCost.y = -3;
        _btn.addChild(_txtCost);
        _source.addChild(im);
        _txtAdd = new TextField(100,100,"",g.allData.bFonts['BloggerBold18'],16,Color.WHITE);
        _txtAdd.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _last = false;

        _txtIcon = new TextField(80,200,"добавить ячейку очереди",g.allData.bFonts['BloggerBold18'],18,ManagerFilters.TEXT_BLUE_COLOR);
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
            _txtCost.text = String('Ускорить за   ' + _price);
            _txtAdd.text = 'Ускорить';
            _txtAdd.x = -47;
            _txtAdd.y = -15;
            _txtText.x = -175;
            _txtText.y = -115;
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
            _txtText.y = -115;
//            _txtButton.text = 'Добавить ячейку за '
            _txtIcon.visible = true;
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
