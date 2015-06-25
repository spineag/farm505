/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import manager.Vars;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class ShopItem {
    public var source:CSprite;
    private var _bg:Image;
    private var _im:Image;
    private var _nameTxt:TextField;
    private var _countTxt:TextField;
    private var _data:Object;

    private var g:Vars = Vars.getInstance();

    public function ShopItem(data:Object) {
        _data = data;
        source = new CSprite();
        _bg = new Image(g.interfaceAtlas.getTexture('shop_item'));
        source.addChild(_bg);
        _im = new Image(g.tempBuildAtlas.getTexture(_data.image));
        MCScaler.scale(_im, 100, 100);
        _im.x = 35    + 50 - _im.width/2;
        _im.y = 30    + 50 - _im.height/2;
        source.addChild(_im);

        _nameTxt = new TextField(150, 70, String(_data.name), "Arial", 20, Color.BLACK);
        _nameTxt.x = 7;
        _nameTxt.y = 140;
        source.addChild(_nameTxt);

        _countTxt = new TextField(122, 30, String(_data.cost), "Arial", 16, Color.WHITE);
        _countTxt.x = 22;
        _countTxt.y = 220;
        source.addChild(_countTxt);
    }

    public function clearIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
    }
}
}
