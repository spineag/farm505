/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
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
import utils.MCScaler;

public class WOBuyCurrencyItem {
    public var source:Sprite;
    private var _bg:Sprite;
    private var _btn:CButton;
    private var g:Vars = Vars.getInstance();

    public function WOBuyCurrencyItem(currency:int, count:int, profit:String, cost:int) {
        source = new Sprite();
        _bg = new Sprite();
        _bg.touchable = false;
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
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        } else {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        }
        MCScaler.scale(im, 38, 38);
        im.x = 15;
        im.y = 9;
        im.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(im);

        var txt:TextField = new TextField(135, 52, String(count), g.allData.fonts['BloggerBold'], 24, ManagerFilters.TEXT_BLUE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
        txt.x = 70;
        txt.y = 4;
        source.addChild(txt);

        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.GREEN, true);
        txt = new TextField(120, 38, String(cost) + ' голосов', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN_BIG;
        _btn.addChild(txt);
        _btn.x = 493;
        _btn.y = 31;
        source.addChild(_btn);
        var onClick:Function = function():void {
            var obj:Object;
            obj = {};
            obj.count = count;
            var p:Point = new Point(im.x, im.y);
            p = im.localToGlobal(p);

            if (currency == DataMoney.HARD_CURRENCY) {
                obj.id =  int(DataMoney.HARD_CURRENCY);
                new DropItem(p.x + 30, p.y + 30, obj);
            } else {
                obj.id = int(DataMoney.SOFT_CURRENCY);
                new DropItem(p.x + 30, p.y + 30, obj);
            }
        };
        _btn.clickCallback = onClick;
    }

    public function deleteIt():void {
        source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        source.dispose();
        source = null;
        g = null;
    }
}
}
