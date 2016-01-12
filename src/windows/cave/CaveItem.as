package windows.cave {

import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import manager.Vars;
import starling.display.Image;
import starling.text.TextField;

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
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_k'));
        source.addChild(_bg);
        source.pivotX = source.width/2;
        source.pivotY = source.height;
        source.endClickCallback = onClick;
//        source.hoverCallback = onHover;
//        source.outCallback = onOut;
        _txtCount = new TextField(40,30,'',g.allData.fonts['BloggerMedium'],16, ManagerFilters.TEXT_BROWN);
        _txtCount.x = 52;
        _txtCount.y = 68;
        source.addChild(_txtCount);
    }

    public function fillData(ob:Object, f:Function):void {
        _data = ob;
        if (!_data) {
            Cc.error('CaveItem fillData:: empty _data');
            g.woGameError.showIt();
            return;
        }
        _clickCallback = f;
        fillIcon();
    }

    private function fillIcon():void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _icon = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
        if (!_icon ) {
            Cc.error('CaveItem fillIcon:: no such image: ' + _data.imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(_icon, 80, 80);
        _icon.x = _bg.width/2 - _icon.width/2;
        _icon.y = _bg.height/2 - _icon.height/2;
        source.addChild(_icon);
        _countResource = g.userInventory.getCountResourceById(_data.id);
        _txtCount.text = String(_countResource);
//        if (_countResource <=0) {
//            source.alpha = .7;
//        }
    }

    private function onClick():void {
        if (_countResource <=0) return;

        if (_clickCallback != null) {
            _clickCallback.apply(null, [_data.id]);
        }
    }

    public function clearIt():void {
        _clickCallback = null;
        _data = null;
        source.removeChild(_icon);
        _icon.dispose();
        _icon = null;
        _txtCount.text = '';
    }
}
}
