/**
 * Created by user on 6/25/15.
 */
package resourceItem {
import flash.geom.Point;

import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;

import utils.MCScaler;

public class RawItem {
    private var _source:Sprite;
    private var _countTxt:TextField;

    private var g:Vars = Vars.getInstance();

    public function RawItem(endPoint:Point, texture:Texture, count:int, delay:Number):void {
        _source = new Sprite();
        _source.touchable = false;
        var im:Image = new Image(texture);
        MCScaler.scale(im, 50, 50);
        _source.addChild(im);
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height/2;
        _source.x = endPoint.x;
        _source.y = endPoint.y - 100;
        g.cont.animationsResourceCont.addChild(_source);

        var tween:Tween = new Tween(_source, .3);
        tween.moveTo(endPoint.x, endPoint.y);
        tween.delay = delay;
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            g.cont.animationsResourceCont.removeChild(_source);
        };
        g.starling.juggler.add(tween);
    }
}
}
