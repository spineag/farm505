/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import manager.ManagerFilters;
import manager.Vars;
import quest.ManagerQuest;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import windows.WOComponents.CartonBackgroundIn;

public class WOQuestItem {
    private var _source:Sprite;
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _arItems:Array;

    public function WOQuestItem(p:Sprite, ar:Array) {
        _parent = p;
        _source = new Sprite();
        _source.x = -230;
        _source.y = 12;
        _parent.addChild(_source);
//        _bg = new CartonBackgroundIn(410, 75);
//        _source.addChild(_bg);
//        _txt = new CTextField(295,75,'');
//        _txt.setFormat(CTextField.MEDIUM18, 18, ManagerFilters.BROWN_COLOR);
//        _source.addChild(_txt);
//
//        _btn = new CButton();
//        _btn.addButtonTexture(120, 40, CButton.GREEN, true);
//        _txtBtn = new CTextField(120,40,'');
//        _txtBtn.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
//        _btn.addChild(_txtBtn);
//        _btn.x = 333;
//        _btn.y = 40;
//        _source.addChild(_btn);
//        _btn.visible = false;
//
//        _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
//        _galo4ka.x = 333 - int(_galo4ka.width/2);
//        _galo4ka.y = 40 - int(_galo4ka.height/2);
//        _source.addChild(_galo4ka);
//        _galo4ka.visible = false;

        _arItems = [];
        var c:int = ar.length;
        var it:Item;
        for (var i:int=0; i<c; i++) {
            it = new Item(c, ar[i]);
            _source.addChild(it);
            _arItems.push(it);
        }
    }


//    private function onClick():void {
//        if (_dataQuest.type == ManagerQuest.POST) _btn.clickCallback = null;
//        g.managerQuest.checkOnClickAtWoQuestItem(_dataQuest);
//    }

    public function deleteIt():void {
        _parent.removeChild(_source);
        _parent = null;
        _source.dispose();
    }
}
}

import manager.ManagerFilters;
import manager.Vars;
import quest.QuestTaskStructure;
import starling.display.Sprite;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;

import windows.WOComponents.CartonBackgroundIn;

internal class Item extends Sprite {
    private var g:Vars = Vars.getInstance();
    private var _task:QuestTaskStructure;
    private var _bg:CartonBackgroundIn;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txt:CTextField;
    private var _countTxt:CTextField;

    public function Item(c:int, t:QuestTaskStructure) {
        _task = t;
        var h:int;
        if (c == 1) {
            h = 160;
        } else if (c==2) {
            h = 100;
        } else if (c==3) {
            h = 70;
        }
        _bg = new CartonBackgroundIn(460, h);
        _bg.y = -h/2;
        addChild(_bg);

        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.GREEN, true);
        _txtBtn = new CTextField(120,40,'Показать');
        _txtBtn.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btn.addChild(_txtBtn);
        _btn.x = 390;
        addChild(_btn);

        _txt = new CTextField(200, int(h*2/3),'34546 7 45 er f vcv h fgh dfhs dhsh sdh gsh fgfgh df dfh');
        _txt.setFormat(CTextField.MEDIUM24, 24, ManagerFilters.BROWN_COLOR);
        _txt.y = -_txt.width/2;
        _txt.x = 110;
        addChild(_txt);

        
     }

}
