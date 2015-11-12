/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import data.DataMoney;

import flash.filters.GlowFilter;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;


public class WOBuyCurrencyItem {
    public var source:Sprite;

    private var g:Vars = Vars.getInstance();

    public function WOBuyCurrencyItem(currency:int, count:int, profit:String, cost:int) {
        source = new Sprite();

        //create bg
        var _bg:Sprite = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_l'));
        _bg.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_r'));
        im.x = 593 - im.width;
        _bg.addChild(im);
//        var l:int = Math.ceil((_bg.width - 2*im.width)/im.width ===== 9;
        for (var i:int=0; i<9; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_c'));
            im.x = 58*(i+1);
            _bg.addChild(im);
        }
        _bg.flatten();
        source.addChild(_bg);

        if (currency == DataMoney.HARD_CURRENCY) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        } else {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        }
        MCScaler.scale(im, 38, 38);
        im.x = 15;
        im.y = 9;
        source.addChild(im);

        var txt:TextField = new TextField(135, 52, String(count), g.allData.fonts['BloggerBold'], 24, 0x0064b4);
        txt.nativeFilters = [new GlowFilter(Color.WHITE, 1, 6, 6, 5.0)];
        txt.x = 70;
        txt.y = 4;
        source.addChild(txt);

        var btn:CSprite = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_green'));
        btn.addChild(im);
        txt = new TextField(btn.width, btn.height-5, String(cost) + ' голосов', g.allData.fonts['BloggerRegular'], 18, Color.WHITE);
        txt.nativeFilters = [new GlowFilter(Color.BLACK, 1, 2, 2, 5.0)];
        btn.addChild(txt);
        btn.x = 453;
        btn.y = 7;
        source.addChild(btn);
        var onClick:Function = function():void {
            g.userInventory.addMoney(currency, count);
        };
        btn.endClickCallback = onClick;
    }
}
}
