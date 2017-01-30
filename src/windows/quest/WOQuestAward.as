/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;
import manager.Vars;

import quest.QuestStructure;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.CartonBackgroundIn;

public class WOQuestAward {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _txtAward:CTextField;
    private var _parent:Sprite;
    private var _arItems:Array;

    public function WOQuestAward(p:Sprite, ar:Array) {
        _parent = p;
        _source = new Sprite();
        _source.x = -80;
        _source.y = -106;
        _source.touchable = false;
        _parent.addChild(_source);
//        var q:Quad = new Quad(176, 70, Color.BLACK);
//        _source.addChild(q);

        _txtAward = new CTextField(176,48,'Награда:');
        _txtAward.setFormat(CTextField.MEDIUM18, 18, ManagerFilters.BLUE_COLOR);
        _txtAward.y = -3;
        _source.addChild(_txtAward);

        _arItems = [];
        var it:Item;
        var c:int = ar.length;
        for (var i:int=0; i<c; i++) {
            it = new Item(ar[i]);
            it.alignPivot();
            it.y = 53;
            _source.addChild(it);
            _arItems.push(it);
        }
        switch (c) {
            case 1: _arItems[0].x = 88; break;
            case 2: _arItems[0].x = 45; _arItems[1].x = 126; _arItems[0].scale = _arItems[1].scale = .85; break;
            case 3: _arItems[0].x = 27; _arItems[1].x = 84; _arItems[2].x = 141; _arItems[0].scale = _arItems[1].scale = _arItems[2].scale = .7; break;
        }
    }

    public function deleteIt():void {
        if (_txtAward) {
            _source.removeChild(_txtAward);
            _txtAward.deleteIt();
            _txtAward = null;
        }
        for (var i:int=0; i<_arItems.length; i++) {
            _arItems[i].deleteIt();
        }
        _arItems.length = 0;
        _parent.removeChild(_source);
        _parent = null;
        _source.dispose();
    }

}
}

import data.DataMoney;
import manager.ManagerFilters;
import manager.Vars;
import quest.QuestAwardStructure;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;
import utils.CTextField;
import utils.MCScaler;

internal class Item extends Sprite {
    private var g:Vars = Vars.getInstance();
    private var _aw:QuestAwardStructure;
    private var _txt:CTextField;

    public function Item(aw:QuestAwardStructure) {
        _aw = aw;
        _txt = new CTextField(45,30,String(aw.countResource));
        _txt.setFormat(CTextField.MEDIUM30, 30, ManagerFilters.BLUE_COLOR);
        _txt.alignH = Align.RIGHT;
        _txt.x = -47;
        addChild(_txt);
        touchable = false;

        var im:Image;
        if (aw.typeResource == 'money') {
            switch (aw.idResource) {
                case DataMoney.SOFT_CURRENCY: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small')); break;
                case DataMoney.HARD_CURRENCY: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small')); break;
                case DataMoney.BLUE_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone')); break;
                case DataMoney.RED_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone')); break;
                case DataMoney.GREEN_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone')); break;
                case DataMoney.YELLOW_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone')); break;
            }
        }

        if (im) {
            MCScaler.scale(im, 50, 50);
            im.y = 2;
            im.x = 3;
            addChild(im);
        }
    }

    public function deleteIt():void {
        if (_txt) {
            _txt.deleteIt();
            _txt = null;
        }
        dispose();
    }

}
