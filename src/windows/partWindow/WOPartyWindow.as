/**
 * Created by user on 1/30/17.
 */
package windows.partWindow {
import manager.ManagerFilters;

import starling.display.Image;
import starling.display.Sprite;

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
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtName:CTextField;
    private var _data:Object;
    private var _arrItem:Array;
    private var _sprItem:Sprite;
    private var _imTime:Image;
    private var _txtBabl:CTextField;
    private var _txtTime:CTextField;
    private var _txtTimeLost:CTextField;
    private var _time:int;

    public function WOPartyWindow() {
        _windowType = WindowsManager.WO_PARTY;
        _arrItem= [];
        _woHeight = 500;
        _woWidth = 690;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _sprItem = new Sprite();
        var im:Image;
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('fon'));
        im.x = - im.width/2 - 20;
        im.y = - im.height/2 - 10;
        _source.addChild(im);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('baloon'));
        im.x = - im.width/2 - 275;
        im.y = - im.height/2 - 100;
        _source.addChild(im);

        _btn = new CButton();
        _btn.addButtonTexture(172, 45, CButton.GREEN, true);
        _txtBtn = new CTextField(172,45,"ОК");
        _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(_txtBtn);
        _btn.clickCallback = onClick;
        _btn.y = 220;
        _source.addChild(_btn);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _data = g.managerParty.dataParty;
        _txtName = new CTextField(500, 70, String(_data.name));
        _txtName.setFormat(CTextField.BOLD30, 35, Color.RED, Color.WHITE);
        _txtName.alignH = Align.LEFT;
        _txtName.x = -160;
        _txtName.y = -230;
        _source.addChild(_txtName);
        _source.addChild(_sprItem);
        var item:WOPartyWindowItem;
        for (var i:int = 0; i < 5; i++) {
            item = new WOPartyWindowItem(_data.idGift[i], _data.typeGift[i], _data.countGift[i],  _data.countToGift[i], i+1);
            item.source.x = (98 * i);
//            item.source.y = -70;
            _sprItem.addChild(item.source);
            _arrItem.push(item);
        }

        _imTime = new Image(g.allData.atlas['partyAtlas'].getTexture('valik_timer'));
        _imTime.x = 275;
        _imTime.y = -185;
        _source.addChild(_imTime);
        _sprItem.x = -195;
        _sprItem.y = -100;

        _txtBabl = new CTextField(172,200,String(_data.description));
        _txtBabl.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _source.addChild(_txtBabl);
        _txtBabl.x = -365;
        _txtBabl.y = -240;

        _txtTimeLost = new CTextField(120,60,'Осталось времени');
        _txtTimeLost.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _source.addChild(_txtTimeLost);
        _txtTimeLost.x = 288;
        _txtTimeLost.y = -165;

        var im:Image = new Image(g.allData.atlas['partyAtlas'].getTexture('progress'));
        im.x = -230;
        im.y = 40;
//        _source.addChild(im);
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
