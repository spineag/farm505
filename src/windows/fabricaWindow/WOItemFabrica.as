/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import manager.Vars;

import starling.display.Image;

import utils.CSprite;
import utils.MCScaler;

public class WOItemFabrica {
    public var source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _dataRecipe:Object;
    private var _clickCallback:Function;

    private var g:Vars = Vars.getInstance();

    public function WOItemFabrica() {
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
        _dataRecipe = ob;
        _clickCallback = f;
        source.alpha = 1;
        fillIcon(g.dataResource.objectResources[_dataRecipe.idResource].imageShop);
    }

    private function fillIcon(s:String):void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _icon = new Image(g.resourceAtlas.getTexture(s));
        MCScaler.scale(_icon, 80, 80);
        _icon.x = _bg.width/2 - _icon.width/2;
        _icon.y = _bg.height/2 - _icon.height/2;
        source.addChild(_icon);
    }

    public function unfillIt():void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _dataRecipe = null;
        _clickCallback = null;
        source.alpha = .5;
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_dataRecipe]);
        }
    }
}
}
