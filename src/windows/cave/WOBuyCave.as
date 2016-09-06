/**
 * Created by user on 7/23/15.
 */
package windows.cave {
import com.junkbyte.console.Cc;
import manager.ManagerFilters;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.WindowMine;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyCave extends WindowMain {
    private var _btn:CButton;
    private var _txt:CTextField;
    private var _priceTxt:CTextField;
    private var _callback:Function;
    private var _dataObject:Object;
    private var _woBG:WindowMine;

    public function WOBuyCave() {
        super();
        _windowType = WindowsManager.WO_BUY_CAVE;
        _woWidth = 600;
        _woHeight = 350;
        _woBG = new WindowMine(_woWidth,_woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        _btn = new CButton();
        _btn.addButtonTexture(250, 35, CButton.BLUE, true);
        _btn.y = 165;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        MCScaler.scale(im,25,25);
        im.x = 215;
        im.y = 7;
        _btn.addChild(im);
        _priceTxt = new CTextField(217, 30, '');
        _priceTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _priceTxt.y = 5;
        _btn.addChild(_priceTxt);
        _source.addChild(_btn);
        _btn.clickCallback = onClickBuy;

        _txt = new CTextField(300, 30, '');
        _txt.setFormat(CTextField.BOLD18, 18, Color.WHITE);
        _txt.x = -150;
        _txt.y = -20;
        _source.addChild(_txt);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _dataObject = params[0];
        _priceTxt.text = 'Отремонтировать ' + String(_dataObject.cost);
        _callback = callback;
        var im:Image;
        if (params[2]) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('mine_picture'));
        } else {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('aerial_tram_all'));
        }
        im.x = - 298;
        im.y = - 175;
        _source.addChildAt(im,0);
        super.showIt();
    }

    private function onClickBuy(callob:Object = null, cost:int = 0):void {
        if (g.user.softCurrencyCount < _dataObject.cost) {
            var ob:Object = {};
            ob.currency = 2;
            ob.count = _dataObject.cost - g.user.softCurrencyCount;
            g.windowsManager.cashWindow = this;
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClickBuy, 'money', ob);
            return;
        }
        if (_callback != null) {
            _callback.apply();
        }
        if (isCashed) {
            g.windowsManager.uncasheWindow();
        } else {
            hideIt();
        }
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        _dataObject = null;
        super.deleteIt();
    }

    override public function releaseFromCash():void {
        isCashed = false;
        deleteIt();
    }
}
}
