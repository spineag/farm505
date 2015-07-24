package windows.cave {

import manager.Vars;
import starling.display.Image;
import utils.CSprite;
import utils.MCScaler;

public class CaveItem {
    public var source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _data:Object;
    private var _clickCallback:Function;

    private var g:Vars = Vars.getInstance();

    public function CaveItem() {
        source = new CSprite();
        _bg = new Image(g.interfaceAtlas.getTexture('tempItemBG'));
        MCScaler.scale(_bg, 100, 100);
        source.addChild(_bg);
        source.pivotX = source.width/2;
        source.pivotY = source.height/2;
        source.endClickCallback = onClick;
        source.alpha = .5;
    }

    public function fillData(ob:Object, f:Function):void {
        _data = ob;
        _clickCallback = f;
        source.alpha = 1;
        fillIcon(_data.imageShop);
    }

    private function fillIcon(s:String):void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _icon = new Image(g.instrumentAtlas.getTexture(s));
        MCScaler.scale(_icon, 80, 80);
        _icon.x = _bg.width/2 - _icon.width/2;
        _icon.y = _bg.height/2 - _icon.height/2;
        source.addChild(_icon);
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_data.id]);
        }
    }
}
}
