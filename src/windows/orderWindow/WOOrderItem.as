/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {

import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;

public class WOOrderItem {
    public var source:CSprite;
    private var _bgCarton:CartonBackground;
    private var _bgCartonIn:CartonBackgroundIn;
    private var _txtName:TextField;
    private var _txtXP:TextField;
    private var _txtCoins:TextField;
    private var _order:Object;

    private var g:Vars = Vars.getInstance();
    public function WOOrderItem() {
        source = new CSprite();
        _bgCarton = new CartonBackground(112, 90);
        _bgCarton.filter = ManagerFilters.SHADOW_LIGHT;
        source.addChild(_bgCarton);
        _bgCartonIn = new CartonBackgroundIn(102, 64);
        _bgCartonIn.x = 5;
        _bgCartonIn.y = 21;
        source.addChild(_bgCartonIn);
        _bgCarton.touchable = true;

        _txtName = new TextField(112, 20, "Васько", g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        source.addChild(_txtName);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        im.x = 17;
        im.y = 24;
        MCScaler.scale(im, 30, 30);
        im.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(im);
        _txtXP = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtXP.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtXP.x = 48;
        _txtXP.y = 26;
        source.addChild(_txtXP);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        im.x = 17;
        im.y = 55;
        MCScaler.scale(im, 30, 30);
        im.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(im);
        _txtCoins = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtCoins.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtCoins.x = 48;
        _txtCoins.y = 55;
        source.addChild(_txtCoins);

        source.visible = false;
    }

    public function activateIt(v:Boolean):void {
        if (v) {
            _bgCarton.filter = ManagerFilters.YELLOW_STROKE;
        } else {
            _bgCarton.filter = ManagerFilters.SHADOW_LIGHT;
        }
    }

    public function fillIt(order:Object, position:int, f:Function):void {
        _order = order;
        _txtName.text = _order.catName;
        _txtXP.text = String(_order.xp);
        _txtCoins.text = String(_order.coins);
        source.visible = true;
        var f1:Function = function():void {
            if (f != null) {
                f.apply(null, [position]);
            }
        };
        source.endClickCallback = f1;
    }

    public function clearIt():void {
        _order = null;
        source.endClickCallback = null;
        _txtCoins.text = '';
        _txtName.text = '';
        _txtCoins.text = '';
        source.visible = false;
    }

}
}
