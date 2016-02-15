/**
 * Created by user on 7/15/15.
 */
package windows.buyCoupone {
import com.junkbyte.console.Cc;

import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;

import utils.MCScaler;

import windows.WOComponents.CartonBackground;

public class WOBuyCouponeItem {
    public var source:Sprite;
    private var _cost:int;
    private var _count:int;
    private var _imageCoupone:Image;
    private var _btn:CButton;
    private var _txtCount:TextField;
    private var _type:int;
    private var g:Vars = Vars.getInstance();

    public function WOBuyCouponeItem(imageCopone:String, txtItemCoupone:int, txtCostCoupone:int,type:int) {
        try {
            var im:Image;
            var txt:TextField;
            _type = type;
            var carton:CartonBackground = new CartonBackground(100, 150);
            _cost = txtCostCoupone;
            _count = txtItemCoupone;
            carton.filter = ManagerFilters.SHADOW_LIGHT;
            source = new Sprite();
            source.addChild(carton);
            _btn = new CButton();
            _btn.addButtonTexture(80, 50, CButton.GREEN, true);
            txt = new TextField(50,50,'+' + String(_cost),g.allData.fonts['BloggerBold'],16,Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
            txt.x = 5;
//            txt.y = 20;
            _btn.addChild(txt);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            MCScaler.scale(im,30,30);
            im.x = 45;
            im.y = 10;
            _btn.addDisplayObject(im);
            source.addChild(_btn);
            _btn.clickCallback = onClick;
            _btn.x = 50;
            _btn.y = 115;
            _imageCoupone = new Image(g.allData.atlas['interfaceAtlas'].getTexture(imageCopone));
            _imageCoupone.x = 30;
            _imageCoupone.y = 20;
            source.addChild(_imageCoupone);
            _txtCount = new TextField(50,50,String(_count),g.allData.fonts['BloggerBold'],16,Color.WHITE);
            _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtCount.x = 23;
            _txtCount.y = 50;
            source.addChild(_txtCount);
        } catch (e:Error) {
            Cc.error('WOBuyCouponeItem error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    private function onClick():void {
        if (g.user.hardCurrency < _cost) {
            g.woBuyCurrency.showItMenu(true);
            return;
        }
        g.userInventory.addMoney(1, -_cost);

//        g.userInventory.addMoney(_type,1);
        _count++;
        _txtCount.text = String(_count);
        var obj:Object;
        obj = {};
        obj.count = 1;
        var p:Point = new Point(_imageCoupone.x, _imageCoupone.y);
        p = _imageCoupone.localToGlobal(p);
        obj.id = _type;
        new DropItem(p.x, p.y, obj);
        }

    public function hideIt():void {
        while (source.numChildren) source.removeChildAt(0);
    }
}
}
