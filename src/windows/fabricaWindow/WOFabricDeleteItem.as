/**
 * Created by user on 2/14/17.
 */
package windows.fabricaWindow {
import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;

import starling.utils.Color;

import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOFabricDeleteItem extends WindowMain{
    private var _woBG:WindowBackground;
    private var _b:CButton;
    private var _txt:CTextField;
    private var _txtInfo:CTextField;
    private var _txtBtn:CTextField;
    private var _callback:Function;

    public function WOFabricDeleteItem() {
        _windowType = WindowsManager.WO_FABRIC_DELETE_ITEM;
        _woWidth = 400;
        _woHeight = 200;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _txtInfo = new CTextField(300,30,String(g.managerLanguage.allTexts[436]));
        _txtInfo.setFormat(CTextField.MEDIUM24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtInfo.x = -150;
        _txtInfo.y = -20;
        _source.addChild(_txtInfo);
        _txt = new CTextField(300,30,String(g.managerLanguage.allTexts[435]));
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
        _callback = f;
        super.showIt();
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
        super.hideIt();
    }

}
}
