/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.greensock.loading.core.DisplayObjectLoader;

import data.DataMoney;

import flash.filters.GlowFilter;
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


public class WOBuyCurrencyItem {
    public var source:Sprite;
    private var _image:Image;
    private var g:Vars = Vars.getInstance();

    public function WOBuyCurrencyItem(currency:int, count:int, profit:String, cost:int) {
        source = new Sprite();
        var _bg:Sprite = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_l'));
        _bg.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_r'));
        im.x = 593 - im.width;
        _bg.addChild(im);
        for (var i:int=0; i<8; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_c'));
            im.x = 58*(i+1);
            _bg.addChild(im);
        }
        im.width = 71;
        _bg.flatten();
        source.addChild(_bg);

        if (currency == DataMoney.HARD_CURRENCY) {
            _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        } else {
            _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        }
        MCScaler.scale(_image, 38, 38);
        _image.x = 15;
        _image.y = 9;
        _image.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_image);

        var txt:TextField = new TextField(135, 52, String(count), g.allData.fonts['BloggerBold'], 24, ManagerFilters.TEXT_BLUE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
        txt.x = 70;
        txt.y = 4;
        source.addChild(txt);

        var btn:CButton = new CButton();
        btn.addButtonTexture(120, 40, CButton.GREEN, true);
        txt = new TextField(120, 38, String(cost) + ' голосов', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN_BIG;
        btn.addChild(txt);
        btn.x = 493;
        btn.y = 31;
        source.addChild(btn);
        var onClick:Function = function():void {
            var endPoint:Point;
            var f1:Function = function():void {
                g.userInventory.addMoney(currency, count);
            };
            var obj:Object;
            obj = {};
            obj.count = count;
            var p:Point = new Point(_image.x, _image.y);
            p = _image.localToGlobal(p);

            if (currency == DataMoney.HARD_CURRENCY) {
                obj.id =  int(DataMoney.HARD_CURRENCY);
                new DropItem(p.x + 30, p.y + 30, obj);
            } else {
                obj.id = int(DataMoney.SOFT_CURRENCY);
                new DropItem(p.x + 30, p.y + 30, obj);
            }
        };
        btn.clickCallback = onClick;
    }
}
}
