/**
 * Created by user on 6/2/15.
 */
package windows.buyPlant {
import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

public class WOItem {
    public var source:CSprite;
    private var _bg:Quad;
    private var _image:Image;
    private var _data:Object;
    private var _clickCallback:Function;

    private var g:Vars = Vars.getInstance();

    public function WOItem() {
        source = new CSprite();
        _bg = new Quad(100, 100, Color.WHITE);
        source.addChild(_bg);
        source.pivotX = source.width/2;
        source.pivotY = source.height/2;
        source.endClickCallback = onClick;
    }

    public function fillData(ob:Object, f:Function):void {
        _data = ob;
        _clickCallback = f;
        fillIcon(_data.imageShop);
    }

    private function fillIcon(s:String):void {
        _image = new Image(g.plantAtlas.getTexture(s));
        MCScaler.scale(_image, 100, 100);
//        _image.pivotX = _image.width/2;
//        _image.pivotY = _image.height/2;
//        _image.x = 50;
//        _image.y = 50;
        source.addChild(_image);
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_data]);
        }
    }
}
}
