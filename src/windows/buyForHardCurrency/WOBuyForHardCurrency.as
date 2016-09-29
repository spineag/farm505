/**
 * Created by user on 10/22/15.
 */
package windows.buyForHardCurrency {
import manager.ManagerFilters;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyForHardCurrency extends WindowMain {
    private var _btnYes:CButton;
    private var _btnNo:CButton;
    private var _txtYes:CTextField;
    private var _txtNo:CTextField;
    private var _txt:CTextField;
    private var _txt2:CTextField;
    private var _id:int;
    private var _count:int;
    private var _woBG:WindowBackground;
    private var _callback:Function;

    public function WOBuyForHardCurrency() {
        super();
        _windowType = WindowsManager.WO_BUY_FOR_HARD;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _btnNo = new CButton();
        _btnNo.addButtonTexture(80, 40, CButton.YELLOW, true);
        _btnYes = new CButton();
        _btnYes.addButtonTexture(80, 40, CButton.GREEN, true);
        _txtYes = new CTextField(50,50,"Да");
        _txtYes.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtYes.x = 15;
        _txtYes.y = -5;
        _btnYes.addChild(_txtYes);
        _txtNo = new CTextField(50,50,"Нет");
        _txtNo.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.YELLOW_COLOR);
        _txtNo.x = 15;
        _txtNo.y = -5;
        _btnNo.addChild(_txtNo);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("currency_buy_window"));
        _source.addChild(im);
        im.x = -50;
        im.y = -60;
        _txt = new CTextField(300,50,"Подтвердить покупку за рубины?");
        _txt.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -150;
        _txt.y = -100;
        _source.addChild(_txt);
        _txt2 = new CTextField(300,30,"ПОДТВЕРЖДЕНИЕ ПОКУПКИ!");
        _txt2.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt2.x = -150;
        _txt2.y = -115;
        _source.addChild(_txt2);
        _btnNo.clickCallback = onClickExit;
        _btnYes.x = 100;
        _btnYes.y = 80;
        _btnNo.x = -100;
        _btnNo.y = 80;

        _source.addChild(_btnYes);
        _source.addChild(_btnNo);
    }

    private function lockedLand():void {
        if (g.user.hardCurrency < _count * g.dataResource.objectResources[_id].priceHard) {
            g.windowsManager.uncasheWindow();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            super.hideIt();
            return;
        }
        _btnYes.clickCallback = null;
        g.userInventory.addMoney(1,-_count * g.dataResource.objectResources[_id].priceHard);
        g.userInventory.addResource(_id,_count);
        super.hideIt();
    }

    private function marketPapper():void {
        super.hideIt();
        if (_callback != null) {
            _callback.apply(null);
            _callback = null;
        }

    }

    private function onClickExit():void {
        g.windowsManager.uncasheWindow();
        super.hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        onWoShowCallback = onShow;
        switch (params[0]) {
            case 'lockedLand':
                _id = params[1];
                _count = params[2] - g.userInventory.getCountResourceById(_id);
                _btnYes.clickCallback = lockedLand;
                break;
            case 'market':
                _callback = callback;
                _btnYes.clickCallback =  marketPapper;
                break;
        }
        super.showIt();
    }

    private function onShow():void {
        _txt.updateIt();
        _txt2.updateIt();
        _txtNo.updateIt();
        _txtYes.updateIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_btnNo);
        _btnNo.deleteIt();
        _btnNo = null;
        _source.removeChild(_btnYes);
        _btnYes.deleteIt();
        _btnYes = null;
        super.deleteIt();
    }
}
}
