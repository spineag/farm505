/**
 * Created by user on 6/2/15.
 */
package windows.buyPlant {
import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

public class WOBuyPlantItem {
    public var source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _data:Object;
    private var _clickCallback:Function;
    private var _txtNumber:TextField;

    private var g:Vars = Vars.getInstance();

    public function WOBuyPlantItem() {
        source = new CSprite();
        _bg = new Image(g.interfaceAtlas.getTexture('tempItemBG'));
        MCScaler.scale(_bg, 100, 100);
        source.addChild(_bg);
        source.pivotX = source.width/2;
        source.pivotY = source.height/2;
        source.endClickCallback = onClick;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        source.alpha = .5;
        _txtNumber = new TextField(40,30,"","Arial", 18,Color.BLACK);
        _txtNumber.x = 50;
        _txtNumber.y = 60;
        source.addChild(_txtNumber);
    }

    public function fillData(ob:Object, f:Function):void {
        _data = ob;
        _clickCallback = f;
        _txtNumber.text = String(g.userInventory.getCountResourceById(_data.id));
        fillIcon(_data.imageShop);
        source.alpha = 1;
    }

    private function fillIcon(s:String):void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _icon = new Image(g.plantAtlas.getTexture(s));
        MCScaler.scale(_icon, 100, 100);
        source.addChildAt(_icon, 1);
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_data]);
        }
    }
    private function onHover():void {
        if(_data) g.resourceHint.showIt(_data.id,"",source.x -50, source.y -40,source);

    }

    private function onOut():void {
       if (_data) g.resourceHint.hideIt();
    }

    public function unfillIt():void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _data = null;
        _clickCallback = null;
        _txtNumber.text = '';
        source.alpha = .5;
    }


}
}
