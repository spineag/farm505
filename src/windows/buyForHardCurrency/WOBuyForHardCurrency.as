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
    private var _id:int;
    private var _count:int;
    private var _woBG:WindowBackground;

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
        var txt:CTextField;
        txt = new CTextField(50,50,"Да");
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_GREEN_COLOR);
        txt.x = 15;
        txt.y = -5;
        _btnYes.addChild(txt);
        txt = new CTextField(50,50,"Нет");
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_YELLOW_COLOR);
        txt.x = 15;
        txt.y = -5;
        _btnNo.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("currency_buy_window"));
        _source.addChild(im);
        im.x = -50;
        im.y = -60;
        txt = new CTextField(300,50,"Подтвердить покупку за рубины?");
        txt.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.TEXT_BLUE_COLOR);
        txt.x = -150;
        txt.y = -100;
        _source.addChild(txt);
        txt = new CTextField(300,30,"ПОДТВЕРЖДЕНИЕ ПОКУПКИ!");
        txt.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.TEXT_BLUE_COLOR);
        txt.x = -150;
        txt.y = -115;
        _source.addChild(txt);
        _btnYes.clickCallback = onYes;
        _btnNo.clickCallback = onClickExit;
        _btnYes.x = 100;
        _btnYes.y = 80;
        _btnNo.x = -100;
        _btnNo.y = 80;

        _source.addChild(_btnYes);
        _source.addChild(_btnNo);
    }

    private function onYes():void {
        if (g.user.hardCurrency < _count * g.dataResource.objectResources[_id].priceHard) {
            g.windowsManager.uncasheWindow();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            hideIt();
            return;
        }
        g.userInventory.addMoney(1,-_count * g.dataResource.objectResources[_id].priceHard);
        g.userInventory.addResource(_id,_count);
        hideIt();
    }

    private function onClickExit():void {
        g.windowsManager.uncasheWindow();
        hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _id = params[0];
        _count = params[1] - g.userInventory.getCountResourceById(_id);
        showIt();
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
