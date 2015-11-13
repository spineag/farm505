/**
 * Created by andy on 11/13/15.
 */
package windows.orderWindow {
import flash.filters.GlowFilter;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;

import windows.CartonBackgroundIn;

public class WOOrderResourceItem {
    public var source:Sprite;
    private var _check:Image;
    private var _countTxt:TextField;
    private var g:Vars = Vars.getInstance();

    public function WOOrderResourceItem() {
        source = new Sprite();
        var bg:CartonBackgroundIn = new CartonBackgroundIn(93, 93);
        source.addChild(bg);
        source.touchable = false;

        _check = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _check.x = 69;
        _check.y = -5;
        source.addChild(_check);

        _countTxt = new TextField(80, 40, "10/10", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _countTxt.hAlign = HAlign.RIGHT;
        _countTxt.nativeFilters = [new GlowFilter(0x674b0e, 1, 3, 3, 5.0)];
        _countTxt.x = 12;
        _countTxt.y = 60;
        source.addChild(_countTxt);
    }
}
}
