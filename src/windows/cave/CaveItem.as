package windows.cave {

import manager.Vars;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class CaveItem {
    public var source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _data:Object;
    private var _clickCallback:Function;
    private var _txtCount:TextField;
    private var _countResource:int;

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
        _txtCount = new TextField(30,30,"","Arial", 14, Color.BLACK);
        _txtCount.x = 65;
        _txtCount.y = 65;
        source.addChild(_txtCount);
        _countResource = g.userInventory.getCountResourceById(_data.id);
        _txtCount.text = String(_countResource);
        if (_countResource <=0) {
            source.alpha = .7;
        }
    }

    private function onClick():void {
        if (_countResource <=0) return;

        if (_clickCallback != null) {
            _clickCallback.apply(null, [_data.id]);
        }
    }

    public function clearIt():void {
        while (source.numChildren) source.removeChildAt(0);
        _clickCallback = null;
        _data = null;
        _bg.dispose();
        _icon.dispose();
        _txtCount.dispose();
        source = null;
    }
}
}
