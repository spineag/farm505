/**
 * Created by user on 10/6/15.
 */
package windows.noFreeCats {
import flash.events.TimerEvent;
import flash.utils.Timer;

import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;
import windows.shop.WOShop;

public class WONoFreeCats extends WindowMain {
    private var _btn:CButton;
    private var _woBG:WindowBackground;
    private var _txt1:CTextField;
    private var _txt2:CTextField;
    private var _txtBtn:CTextField;

    public function WONoFreeCats() {
        super();
        _windowType = WindowsManager.WO_NO_FREE_CATS;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _callbackClickBG = hideIt;
        createExitButton(hideIt);
        _txt1 = new CTextField(400,100,"НЕТ СВОБОДНЫХ ПОМОЩНИКОВ!");
        _txt1.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt1.x = -200;
        _txt1.y = -155;
        _txt1.touchable = false;
        _source.addChild(_txt1);
        _txt2 = new CTextField(400,100,'Подождите окончания производства или купите еще одного!');
        _txt2.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt2.x = -200;
        _txt2.y = -120;
        _txt2.touchable = false;
        _source.addChild(_txt2);
        _btn = new CButton();
        _btn.addButtonTexture(130,40,CButton.GREEN, true);
        _btn.clickCallback = onClick;
        _btn.y = 100;
        _source.addChild(_btn);
        _txtBtn = new CTextField(130, 40, "КУПИТЬ");
        _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtBtn.touchable = false;
        _btn.addChild(_txtBtn);
        var im:Image = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
        im.x = -40;
        im.y = -55;
        _source.addChild(im);
        _txtBtn.touchable = false;
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    private function onClick():void {
        super.hideIt();
        g.user.decorShop = false;
        g.user.decorShiftShop = 0;
        g.windowsManager.openWindow(WindowsManager.WO_SHOP, null, 1);
        createDelay(.7, atBuyCat);
    }

    private function atBuyCat():void {
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            (g.windowsManager.currentWindow as WOShop).addArrowAtPos(0, 3);
        }
    }


    private function createDelay(delay:Number, f:Function):void {
        var func:Function = function():void {
            timer.removeEventListener(TimerEvent.TIMER, func);
            timer = null;
            if (f != null) {
                f.apply();
            }
        };
        var timer:Timer = new Timer(delay*1000, 1);
        timer.addEventListener(TimerEvent.TIMER, func);
        timer.start();
    }


    override protected function deleteIt():void {
        if (_txt1) {
            _source.removeChild(_txt1);
            _txt1.deleteIt();
            _txt1 = null;
        }
        if (_txt2) {
            _source.removeChild(_txt2);
            _txt2.deleteIt();
            _txt2 = null;
        }
        if (_txtBtn) {
            _btn.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        _source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        super.deleteIt();
    }
}
}
