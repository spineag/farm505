/**
 * Created by user on 6/24/15.
 */
package resourceItem {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class DropItem {
    private var _source:Sprite;
    private var _image:Image;
    private var _resourceItem:ResourceItem;

    private var g:Vars = Vars.getInstance();

    public function DropItem(_x:int, _y:int,resourceItem:ResourceItem, _prise:Object) {
        _source = new Sprite();
        _image = new Image(g.interfaceAtlas.getTexture("star"));
        _resourceItem = resourceItem;
        g.cont.animationsResourceCont.addChild(_source);
        MCScaler.scale(_image, 50, 50);
        _source.addChild(_image);
        _source.pivotX = _source.width / 2;
        _source.pivotY = _source.height / 2;
        _source.x = _x;
        _source.y = _y;
        flyItStar();
    }

    public function flyItStar():void {
        var endX:int = g.stageWidth - 200;
        var endY:int = 50;

        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
            g.xpPanel.addXP(_resourceItem.craftXP);
        };
        var tempX:int;
        _source.x < endX ? tempX = _source.x + 70 : tempX = _source.x - 70;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - endX)*(_source.x - endX) + (_source.y - endY)*(_source.y - endY)));
        var v:Number = 250;
        new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endX, y:endY}], ease:Linear.easeOut ,onComplete: f1, delay:.2});
    }
}
}
