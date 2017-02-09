/**
 * Created by user on 10/6/15.
 */
package windows.noFreeCats {
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

public class WOWaitFreeCats extends WindowMain{

    private var _btn:CButton;
    private var _woBG:WindowBackground;
    private var txt1:CTextField;
    private var txt2:CTextField;
    private var txt3:CTextField;

    public function WOWaitFreeCats() {
        super();
        _windowType = WindowsManager.WO_WAIT_FREE_CATS;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _callbackClickBG = hideIt;
        createExitButton(hideIt);
        txt1 = new CTextField(400,100,"НЕТ СВОБОДНЫХ ПОМОЩНИКОВ!");
        txt1.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt1.touchable = false;
        txt1.x = -200;
        txt1.y = -155;
        _source.addChild(txt1);
        txt2 = new CTextField(400,100,'Все помощники сейчас заняты! Подождите окончания другого производства!');
        txt2.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt2.x = -200;
        txt2.y = -120;
        txt2.touchable = false;
        _source.addChild(txt2);
        _btn = new CButton();
        _btn.addButtonTexture(130,40,CButton.GREEN, true);
        _btn.clickCallback = hideIt;
        _btn.y = 100;
        _source.addChild(_btn);
        txt3 = new CTextField(130, 40, "ОК");
        txt3.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(txt3);
        var im:Image = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
        im.x = -40;
        im.y = -55;
        _source.addChild(im);
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    override protected function deleteIt():void {
        if (txt1) {
            _source.removeChild(txt1);
            txt1.deleteIt();
            txt1 = null;
        }
        if (txt2) {
            _source.removeChild(txt2);
            txt2.deleteIt();
            txt2 = null;
        }
        if (txt3) {
            _btn.removeChild(txt1);
            txt3.deleteIt();
            txt3 = null;
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
