/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;
import manager.Vars;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Sprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.CartonBackgroundIn;

public class WOQuestAward {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _bg:CartonBackgroundIn;
    private var _txtAward:CTextField;
    private var _txtCount:CTextField;
    private var _image:Image;
    private var _parent:Sprite;
    private var _count:int;

    public function WOQuestAward(p:Sprite) {
        _parent = p;
        _source = new Sprite();
        _source.touchable = false;
        _source.x = -125;
        _source.y = 98;
        _parent.addChild(_source);
        _bg = new CartonBackgroundIn(240, 50);
        _source.addChild(_bg);
        _txtAward = new CTextField(130,48,'Награда:');
        _txtAward.setFormat(CTextField.MEDIUM18, 18, ManagerFilters.BROWN_COLOR);
        _source.addChild(_txtAward);

        _txtCount = new CTextField(60,50,'');
        _txtCount.setFormat(CTextField.BOLD18, 18, ManagerFilters.BROWN_COLOR);
        _txtCount.x = 130;
        _source.addChild(_txtCount);
        _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        MCScaler.scale(_image, 32, 32);
        _image.x = 190;
        _image.y = 11;
        _source.addChild(_image);
    }

    public function fillIt(c:int):void {
        _count = c;
        _txtCount.text = String(_count);
    }

    public function updateTextField():void {
        _txtAward.updateIt();
        _txtCount.updateIt();
    }

    public function onGetAward():void {
        var obj:Object;
        obj = {};
        obj.count = _count;
        var p:Point = new Point(0, 0);
        p = _image.localToGlobal(p);
        obj.id =  DataMoney.SOFT_CURRENCY;
//        new DropItem(p.x + 30, p.y + 30, obj);
        new DropItem(p.x, p.y, obj);
    }

    public function deleteIt():void {
        _parent.removeChild(_source);
        _parent = null;
        _source.removeChild(_bg);
        _bg.deleteIt();
        _source.dispose();
    }

}
}
