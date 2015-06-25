/**
 * Created by user on 6/24/15.
 */
package ui.xpPanel {
import flash.geom.Point;

import manager.Vars;

import resourceItem.ResourceItem;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;

import utils.CSprite;
import utils.MCScaler;

public class XPStar {

    private var _source:CSprite;
    private var _image:Image;

    private var g:Vars = Vars.getInstance();

    public function XPStar(_x:int, _y:int) {
        _source = new CSprite();
        _image = new Image(g.interfaceAtlas.getTexture("star"));
        g.cont.mainCont.addChild(_source);
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
        var tween:Tween = new Tween(_source, 1);
        tween.moveTo(endX, endY);

        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
        };
        g.starling.juggler.add(tween);
    }
}
}
