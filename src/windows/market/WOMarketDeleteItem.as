/**
 * Created by user on 5/5/16.
 */
package windows.market {
import manager.ManagerFabricaRecipe;
import manager.ManagerFilters;

import starling.display.Image;

import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import starling.events.Event;

import windows.WindowsManager;

public class WOMarketDeleteItem extends WindowMain{
    private var _woBG:WindowBackground;
    private var _b:CButton;
    private var _callback:Function;
    private var _data:Object;
    private var _count:int;
    private var _txt:CTextField;
    private var _txtInfo:CTextField;
    private var _txtBtn:CTextField;

    public function WOMarketDeleteItem() {
        _windowType = WindowsManager.WO_MARKET_DELETE_ITEM;
        _woWidth = 400;
        _woHeight = 200;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _txtInfo = new CTextField(300,30,String(g.managerLanguage.allTexts[408]));
        _txtInfo.setFormat(CTextField.MEDIUM24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtInfo.x = -150;
        _txtInfo.y = -20;
        _source.addChild(_txtInfo);
        _txt = new CTextField(300,30,String(g.managerLanguage.allTexts[400]));
        _txt.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -157;
        _txt.y = -60;
        _source.addChild(_txt);
        _callbackClickBG = onClickExit;
        _b = new CButton();
        _b.addButtonTexture(210, 34, CButton.GREEN, true);
        _b.y = 120;
        _source.addChild(_b);
        _txtBtn = new CTextField(200, 34, String(g.managerLanguage.allTexts[410]));
        _txtBtn.setFormat(CTextField.MEDIUM18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _b.addChild(_txtBtn);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        im.x = 150;
        im.y = 1;
//        MCScaler.scale(im,30,30);
        _b.addChild(im);
        _b.y = 70;
        _b.clickCallback = onClick;
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        super.hideIt();
    }

    override public function showItParams(f:Function, params:Array):void {
        super.showIt();
        _callback = f;
        _data = params[0];
        _count = params[1];
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.user.hardCurrency < 1) {
            g.windowsManager.closeAllWindows();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        if (_callback != null) {
            _callback.apply(null,[]);
        }
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (_txtInfo) {
            _source.removeChild(_txtInfo);
            _txtInfo.deleteIt();
            _txtInfo = null;
        }
        if (_txt) {
            _source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        if (_txtBtn) {
            _b.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_b);
        _b.deleteIt();
        _b = null;
        _callback = null;
        super.deleteIt();
    }
}
}
