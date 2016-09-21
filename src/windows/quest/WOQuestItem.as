/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import manager.ManagerFilters;
import manager.Vars;

import quest.QuestData;

import starling.display.Image;

import starling.display.Sprite;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import windows.WOComponents.CartonBackgroundIn;

public class WOQuestItem {
    private var _source:Sprite;
    private var _bg:CartonBackgroundIn;
    private var _txt:CTextField;
    private var _txtBtn:CTextField;
    private var _btn:CButton;
    private var _parent:Sprite;
    private var _dataQuest:Object;
    private var g:Vars = Vars.getInstance();
    private var _galo4ka:Image;

    public function WOQuestItem(p:Sprite) {
        _parent = p;
        _source = new Sprite();
        _source.x = -207;
        _source.y = 0;
        _parent.addChild(_source);
        _bg = new CartonBackgroundIn(410, 75);
        _source.addChild(_bg);
        _txt = new CTextField(295,75,'');
        _txt.setFormat(CTextField.MEDIUM18, 18, ManagerFilters.BROWN_COLOR);
        _source.addChild(_txt);

        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.GREEN, true);
        _txtBtn = new CTextField(120,40,'');
        _txtBtn.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btn.addChild(_txtBtn);
        _btn.x = 333;
        _btn.y = 40;
        _source.addChild(_btn);
        _btn.visible = false;

        _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _galo4ka.x = 333 - int(_galo4ka.width/2);
        _galo4ka.y = 40 - int(_galo4ka.height/2);
        _source.addChild(_galo4ka);
        _galo4ka.visible = false;
    }

    public function fillIt(dQuest:Object):void {
        _dataQuest = dQuest;
        _txt.text = _dataQuest.text;
        if (_dataQuest.type == QuestData.TYPE_ADD_LEFT_MENU) {
            _txtBtn.text = 'Добавить';
        } else if (_dataQuest.type == QuestData.TYPE_ADD_TO_GROUP) {
            _txtBtn.text = 'Вступить';
            g.managerQuest.checkInGroup();
        } else if (_dataQuest.type == QuestData.TYPE_POST) {
            _txtBtn.text = 'Рассказать';
        }
        updateInfo();
    }

    private function onClick():void {
        g.managerQuest.checkOnClickAtWoQuestItem(_dataQuest);
    }

    public function updateTextField():void {
        _txt.updateIt();
        _txtBtn.updateIt();
    }
    
    public function updateInfo():void {
        if (_dataQuest.isDone) {
            _galo4ka.visible = true;
            _btn.visible = false;
            _btn.clickCallback = null;
        } else {
            _galo4ka.visible = false;
            _btn.visible = true;
            _btn.clickCallback = onClick;
        }
    }

    public function deleteIt():void {
        _parent.removeChild(_source);
        _parent = null;
        _source.removeChild(_btn);
        _btn.deleteIt();
        _source.removeChild(_bg);
        _bg.deleteIt();
        _source.dispose();
    }
}
}
