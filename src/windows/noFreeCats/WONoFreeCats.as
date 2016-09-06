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

    public function WONoFreeCats() {
        super();
        _windowType = WindowsManager.WO_NO_FREE_CATS;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _callbackClickBG = hideIt;
        createExitButton(hideIt);
        var txt:CTextField = new CTextField(400,100,"НЕТ СВОБОДНЫХ ПОМОЩНИКОВ!");
        txt.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -200;
        txt.y = -155;
        txt.touchable = false;
        _source.addChild(txt);
        txt = new CTextField(400,100,'Подождите окончания производства или купите еще одного!');
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -200;
        txt.y = -120;
        txt.touchable = false;
        _source.addChild(txt);
        _btn = new CButton();
        _btn.addButtonTexture(130,40,CButton.GREEN, true);
        _btn.clickCallback = onClick;
        _btn.y = 100;
        _source.addChild(_btn);
        txt = new CTextField(130, 40, "КУПИТЬ");
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.touchable = false;
        _btn.addChild(txt);
        var im:Image = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
        im.x = -40;
        im.y = -55;
        _source.addChild(im);
        txt.touchable = false;
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
        showIt();
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
