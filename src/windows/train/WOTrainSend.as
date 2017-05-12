/**
 * Created by user on 1/26/16.
 */
package windows.train {
import build.train.Train;

import manager.ManagerFilters;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTrainSend extends WindowMain {
    private var _woBG:WindowBackground;
    private var _btnYes:CButton;
    private var _btnNo:CButton;
    private var _callback:Function;
    private var _build:Train;
    private var _txtA:CTextField;
    private var _txtB:CTextField;
    private var _txtYes:CTextField;
    private var _txtNo:CTextField;

    public function WOTrainSend() {
        super();
        _windowType = WindowsManager.WO_TRAIN_SEND;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _txtA = new CTextField(300,200,String(g.managerLanguage.allTexts[306]));
        _txtA.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtA.x = -150;
        _txtA.y = -210;
        _source.addChild(_txtA);
        _txtB = new CTextField(350,50,String(g.managerLanguage.allTexts[307]));
        _txtB.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtB.x = -180;
        _txtB.y = -105;
        _source.addChild(_txtB);
        _btnNo = new CButton();
        _btnNo.addButtonTexture(80, 40, CButton.GREEN, true);
        _btnYes = new CButton();
        _btnYes.addButtonTexture(80, 40, CButton.PINK, true);
        _txtYes = new CTextField(50,50,String(g.managerLanguage.allTexts[308]));
        _txtYes.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.RED_COLOR);
        _txtYes.x = 15;
        _txtYes.y = -5;
        _btnYes.addChild(_txtYes);
        _txtNo = new CTextField(50,50,String(g.managerLanguage.allTexts[309]));
        _txtNo.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _txtNo.x = 15;
        _txtNo.y = -5;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('basket_big'));
        im.y = -70;
        im.x = -60;
        _source.addChild(im);
        _btnYes.x = -100;
        _btnYes.y = 85;
        _btnNo.x = 100;
        _btnNo.y = 85;
        _btnNo.addChild(_txtNo);
        _source.addChild(_btnYes);
        _source.addChild(_btnNo);
        _btnNo.clickCallback = onNo;
        _btnYes.clickCallback = onYes;
        _callbackClickBG = onNo;
    }

    override public function showItParams(f:Function, params:Array):void {
        _callback = f;
        _build = params[0];
        super.showIt();
    }

    private function onYes():void {
//        if (_callback != null) {
//            _callback.apply(null,[true]);
//            _callback = null;
//        }
        (_build as Train).fullTrain(true);
//        g.windowsManager.uncasheWindow();
        super.hideIt();
    }

    private function onNo():void {
//        g.windowsManager.uncasheWindow();
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (_txtA) {
            _source.removeChild(_txtA);
            _txtA.deleteIt();
            _txtA = null;
        }
        if (_txtB) {
            _source.removeChild(_txtB);
            _txtB.deleteIt();
            _txtB = null;
        }
        if (_txtYes) {
            _btnYes.removeChild(_txtYes);
            _txtYes.deleteIt();
            _txtYes = null;
        }
        if (_txtNo) {
            _btnNo.removeChild(_txtNo);
            _txtNo.deleteIt();
            _txtNo = null;
        }
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _callback = null;
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
