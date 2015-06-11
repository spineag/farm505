/**
 * Created by user on 6/11/15.
 */
package hint {
import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class WildHint {
    private var _source:CSprite;
    private var _isShowed:Boolean;
    private var _isOnHover:Boolean;
    private var _circle:Image;
    private var _bg:Image;
    private var _iconResource:Image;
    private var _countTxt:TextField;

    private var g:Vars = Vars.getInstance();

    public function WildHint() {
        _source = new CSprite();
        _isShowed = false;
        _isOnHover = false;
        _bg = new Image(g.interfaceAtlas.getTexture('hint_wild'));
        _source.addChild(_bg);
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height;
        _circle = new Image(g.interfaceAtlas.getTexture('hint_circle'));
        _circle.x = 70;
        _circle.y = 10;
        _source.addChild(_circle);
        var quad:Quad = new Quad(_source.width, _source.height, Color.WHITE ,false);
        quad.alpha = 0;
        _source.addChildAt(quad,0);

        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
    }

    public function showIt(x:int,y:int, idResourceForRemoving:int):void {
       if (_isShowed) return;
        _isShowed = true;
        _iconResource = new Image(g.instrumentAtlas.getTexture(g.dataResource.objectResources[idResourceForRemoving].imageShop));
        MCScaler.scale(_iconResource, 60, 60);
        _iconResource.x = _source.width/2 - _iconResource.width/2;
        _iconResource.y = 18;
        _source.addChild(_iconResource);
        _source.x = x;
        _source.y = y;
        g.cont.hintGameCont.addChild(_source);
    }

    public function hideIt():void {
        if (_isOnHover) return;
        _isShowed = false;
        if (g.cont.hintGameCont.contains(_source))
            g.cont.hintGameCont.removeChild(_source);
        _source.removeChild(_iconResource);
        _iconResource = null;
    }

    private function onHover():void {
        _isOnHover = true;
    }

    private function onOut():void {
        _isOnHover = false;
        hideIt();
    }

}
}
