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
import windows.WindowsManager;

public class WOBuyCouponeItem {
    public var source:Sprite;
    private var _carton:CartonBackground;
    private var _cost:int;
    private var _count:int;
    private var _imageCoupone:Image;
    private var _btn:CButton;
    private var _txtCount:TextField;
    private var _type:int;
    private var g:Vars = Vars.getInstance();

    public function WOBuyCouponeItem(imageCopone:String, txtItemCoupone:int, txtCostCoupone:int,type:int) {
        try {
            _type = type;
            _carton = new CartonBackground(100, 150);
            _cost = txtCostCoupone;
            _count = txtItemCoupone;
            _carton.filter = ManagerFilters.SHADOW_LIGHT;
            source = new Sprite();
            source.addChild(_carton);
            _btn = new CButton();
            _btn.addButtonTexture(80, 50, CButton.GREEN, true);
            var txt:TextField = new TextField(50,50,'+' + String(_cost),g.allData.fonts['BloggerBold'],16,Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
//            txt.x = 5;
            _btn.addChild(txt);
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
//            MCScaler.scale(im,30,30);
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
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'buyCoupone');
        }
    }

    private function onClick():void {
        if (g.user.hardCurrency < _cost) {
//            g.windowsManager.hideWindow(WindowsManager.WO_BUY_COUPONE);
            g.windowsManager.closeAllWindows();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(1, -_cost);
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

    public function deleteIt():void {
        source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        source.removeChild(_imageCoupone);
        _imageCoupone.dispose();
        _imageCoupone = null;
        source.removeChild(_txtCount);
        _txtCount.dispose();
        _txtCount = null;
        source.removeChild(_carton);
        _carton.deleteIt();
        _carton = null;
    }
}
}
