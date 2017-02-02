/**
 * Created by user on 1/30/17.
 */
package windows.partWindow {
import manager.ManagerFilters;

import starling.display.Image;

import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;

import windows.WOComponents.Birka;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOPartyWindow extends WindowMain{
    private var _woBG:WindowBackground;
    private var _birka:Birka;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtName:CTextField;
    private var _data:Object;

    public function WOPartyWindow() {
        _windowType = WindowsManager.WO_PARTY;
        _woHeight = 500;
        _woWidth = 690;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _birka = new Birka('Задание', _source, _woWidth, _woHeight);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        var im:Image;
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('fon'));
        im.x = - im.width/2 - 20;
        im.y = - im.height/2 - 10;
        _source.addChild(im);
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('baloon'));
        im.x = - im.width/2 - 20;
        im.y = - im.height/2 - 50;
        _source.addChild(im);

        im = new Image(g.allData.atlas['partyAtlas'].getTexture('progress'));
        im.x = - im.width/2 - 20;
        im.y = - im.height/2 - 50;
        _source.addChild(im);
        _btn = new CButton();
        _btn.addButtonTexture(172, 45, CButton.GREEN, true);
        _txtBtn = new CTextField(110,100,"ВЗЯТЬ");
        _txtBtn.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(_txtBtn);
        _btn.clickCallback = onClick;
        source.addChild(_btn);

        _txtName = new CTextField(500, 70, 'Мой мяу Валентин');
        _txtName.setFormat(CTextField.BOLD30, 35, Color.RED, Color.WHITE);
        _txtName.alignH = Align.LEFT;
        _txtName.x = -180;
        _txtName.y = -230;
        _source.addChild(_txtName);

    }

    override public function showItParams(callback:Function, params:Array):void {
        _data = params[0];
        super.showIt();
    }

    override protected function deleteIt():void {
        super.deleteIt();
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    private function onClick():void {

    }
}
}
