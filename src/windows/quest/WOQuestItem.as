/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import manager.Vars;
import starling.display.Sprite;

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

        _arItems = [];
        var c:int = ar.length;
        var it:Item;
        for (var i:int=0; i<c; i++) {
            it = new Item(c, ar[i]);
            _source.addChild(it);
            _arItems.push(it);
        }
        switch (c) {
            case 1: _arItems[0].y = 120; break;
            case 2: _arItems[0].y = 60; _arItems[1].y = 180; break;
            case 3: _arItems[0].y = 40; _arItems[1].y = 120; _arItems[2].y = 200; break;
        }
    }

    public function deleteIt():void {
        for (var i:int=0; i<_arItems.length; i++) {
            _source.removeChild(_arItems[i]);
            _arItems[i].deleteIt();
        }
        _arItems = [];
        _parent.removeChild(_source);
        _parent = null;
        _source.dispose();
    }
}
}

import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;
import quest.ManagerQuest;
import quest.QuestTaskStructure;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;

internal class Item extends Sprite {
    private var g:Vars = Vars.getInstance();
    private var _task:QuestTaskStructure;
    private var _bg:CartonBackgroundIn;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txt:CTextField;
    private var _countTxt:CTextField;
    private var _c:int;
    private var _galo4ka:Image;

    public function Item(c:int, t:QuestTaskStructure) {
        _task = t;
        _c = c;
        if (_task.isDone) {
            _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            MCScaler.scale(_galo4ka, 50, 50);
            _galo4ka.alignPivot();
            _galo4ka.x = 390;
        } else {
            if (c == 1) {
                _btn = new CButton();
                _btn.addButtonTexture(120, 40, CButton.GREEN, true);
                _txtBtn = new CTextField(120, 40, 'Показать');
                _txtBtn.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
                _btn.x = 390;
                _btn.y = 25;
                _countTxt = new CTextField(80, 30, '');
                _countTxt.setFormat(CTextField.MEDIUM24, 24, ManagerFilters.BROWN_COLOR);
                _countTxt.y = -40;
                _countTxt.x = 350;
            } else if (c == 2) {
                _btn = new CButton();
                _btn.addButtonTexture(100, 40, CButton.GREEN, true);
                _txtBtn = new CTextField(96, 40, 'Показать');
                _txtBtn.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
                _txtBtn.x = 2;
                _btn.x = 397;
                _countTxt = new CTextField(60, 30, '');
                _countTxt.setFormat(CTextField.MEDIUM24, 24, ManagerFilters.BROWN_COLOR);
                _countTxt.y = -15;
                _countTxt.x = 285;
            } else if (c == 3) {
                _btn = new CButton();
                _btn.addButtonTexture(80, 30, CButton.GREEN, true);
                _txtBtn = new CTextField(76, 30, 'Показать');
                _txtBtn.setFormat(CTextField.MEDIUM18, 16, Color.WHITE, ManagerFilters.GREEN_COLOR);
                _txtBtn.x = 2;
                _btn.x = 410;
                _countTxt = new CTextField(60, 30, '');
                _countTxt.setFormat(CTextField.MEDIUM18, 18, ManagerFilters.BROWN_COLOR);
                _countTxt.y = -15;
                _countTxt.x = 305;
            }
        }
        if (c == 1) {
            _bg = new CartonBackgroundIn(460, 160);
            _txt = new CTextField(220, 120, _task.description);
            _txt.setFormat(CTextField.MEDIUM24, 24, ManagerFilters.BROWN_COLOR);
            _txt.y = -62;
            _txt.x = 100;
        } else if (c == 2) {
            _bg = new CartonBackgroundIn(460, 100);
            _txt = new CTextField(210, 80, _task.description);
            _txt.setFormat(CTextField.MEDIUM24, 20, ManagerFilters.BROWN_COLOR);
            _txt.y = -40;
            _txt.x = 75;
        } else if (c == 3) {
            _bg = new CartonBackgroundIn(460, 70);
            _txt = new CTextField(240, 60, _task.description);
            _txt.setFormat(CTextField.MEDIUM18, 18, ManagerFilters.BROWN_COLOR);
            _txt.y = -30;
            _txt.x = 60;
        }
 
        _bg.touchable = false;
        _txt.touchable = false;
        _bg.y = -_bg.height/2;
        addChild(_bg);
        if (_btn) {
            _btn.addChild(_txtBtn);
            addChild(_btn);
            _btn.clickCallback = onClick;
            if (_task.typeAction == ManagerQuest.POST) {
                _txtBtn.text = 'Рассказать';
            } else if (_task.typeAction == ManagerQuest.ADD_LEFT_MENU) {
                _txtBtn.text = 'Добавить';
            } else if (_task.typeAction == ManagerQuest.INVITE_FRIENDS) {
                _txtBtn.text = 'Пригласить';
            } else if (_task.typeAction == ManagerQuest.ADD_TO_GROUP) {
                _txtBtn.text = 'Вступить';
            }
        }
        addChild(_txt);
        if (_countTxt) {
            _countTxt.text = String(_task.countDone) + '/' + String(_task.countNeed);
            _countTxt.touchable = false;
            addChild(_countTxt);
        }
        if (_galo4ka) addChild(_galo4ka);

        var st:String = _task.icon;
        if (st == '0') {
            addIm(_task.iconImageFromAtlas);
        } else {
            g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
        }
    }

    private function onLoadIcon(bitmap:Bitmap):void {
        addIm(new Image(Texture.fromBitmap(bitmap)));
    }

    private function addIm(im:Image):void {
        if (_c == 1) {
            MCScaler.scale(im, 90, 90);
            im.alignPivot();
            im.x = 55;
        } else if (_c == 2) {
            MCScaler.scale(im, 70, 70);
            im.alignPivot();
            im.x = 45;
        } else {
            MCScaler.scale(im, 50, 50);
            im.alignPivot();
            im.x = 30;
        }
        im.touchable = false;
        addChild(im);
    }

    private function onClick():void {
        if (_task.typeAction == ManagerQuest.POST) _btn.clickCallback = null;
        g.managerQuest.checkOnClickAtWoQuestItem(_task);
    }

    public function deleteIt():void {
        if (_btn) {
            removeChild(_btn);
            _btn.deleteIt();
        }
        removeChild(_bg);
        _bg.deleteIt();
        dispose();
    }

}
