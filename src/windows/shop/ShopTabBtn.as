/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import manager.Vars;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

public class ShopTabBtn {
    public var source:CSprite;
    private var _txt:TextField;

    private var g:Vars = Vars.getInstance();

    public function ShopTabBtn(st:String, f:Function) {
        source = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_tab'));
        source.addChild(im);
        _txt = new TextField(source.width, source.height, st, "Arial", 20, Color.BLACK);
        source.addChild(_txt);
        source.endClickCallback = f;
    }

    public function activateIt(value:Boolean):void {
        value ? source.alpha = 1 : source.alpha = .5;
    }
}
}
