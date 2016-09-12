/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import manager.ManagerFilters;
import manager.Vars;

import quest.QuestData;

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
    }

    public function fillIt(dQuest:Object):void {
        _dataQuest = dQuest;
        _txt.text = _dataQuest.text;
        if (_dataQuest.type == QuestData.TYPE_ADD_LEFT_MENU) {
            _txtBtn.text = 'Добавить';
        } else if (_dataQuest.type == QuestData.TYPE_ADD_TO_GROUP) {
            _txtBtn.text = 'Вступить';
        } else if (_dataQuest.type == QuestData.TYPE_POST) {
            _txtBtn.text = 'Рассказать';
        }
        _btn.clickCallback = onClick;
    }

    private function onClick():void {
        g.managerQuest.checkOnClick(_dataQuest);
    }

    public function updateTextField():void {
        _txt.updateIt();
        _txtBtn.updateIt();
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
