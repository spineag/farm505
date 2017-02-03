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
        im.x = - im.width/2 - 260;
        im.y = - im.height/2 - 100;
        _source.addChild(im);

        im = new Image(g.allData.atlas['partyAtlas'].getTexture('progress'));
        im.x = -230;
        im.y = 39;
        _source.addChild(im);
        _btn = new CButton();
        _btn.addButtonTexture(172, 45, CButton.GREEN, true);
        _txtBtn = new CTextField(172,45,"Начать");
        _txtBtn.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(_txtBtn);
        _btn.clickCallback = onClick;
        _btn.y = 200;
        source.addChild(_btn);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _data = params[0];
        _txtName = new CTextField(500, 70, String(_data.name));
        _txtName.setFormat(CTextField.BOLD30, 35, Color.RED, Color.WHITE);
        _txtName.alignH = Align.LEFT;
        _txtName.x = -160;
        _txtName.y = -230;
        _source.addChild(_txtName);
        _source.addChild(_sprItem);
        var item:WOPartyWindowItem;
        for (var i:int = 0; i < 5; i++) {
            item = new WOPartyWindowItem(_data.idGift[i], _data.typeGift[i], _data.countGift[i], _data.countToGift[i], i+1);
            item.source.x = (100 * i);
            item.source.y = -70;
            _sprItem.addChild(item.source);
            _arrItem.push(item);
        }
        _sprItem.x = -180;
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
