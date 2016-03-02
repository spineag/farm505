/**
 * Created by user on 3/1/16.
 */
package tutorial {
import com.greensock.TweenMax;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

public class SimpleArrow {
    public static const POSITION_TOP:int=1;
    public static const POSITION_BOTTOM:int=2;
    public static const POSITION_LEFT:int=3;
    public static const POSITION_RIGHT:int=4;

    private var _source:Sprite;
    private var _arrow:Sprite;
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();

    public function SimpleArrow(pos:int, parent:Sprite, scale:Number = 1) {
        _parent = parent;
        _source = new Sprite();
        _arrow = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tutorial_arrow_stroke'));
        im.scaleX = im.scaleY = .5;
        im.x = -im.width/2;
        im.y = -im.height;
        _arrow.addChild(im);
        _source.addChild(_arrow);
        _source.scaleX = _source.scaleY = scale;
        switch (pos) {
            case POSITION_TOP: _source.rotation = 0; break;
            case POSITION_BOTTOM: _source.rotation = Math.PI/2; break;
            case POSITION_RIGHT: _source.rotation = Math.PI/4; break;
            case POSITION_LEFT: _source.rotation = -Math.PI/4; break;
        }

        animateIt();
    }

    private var time:Number = 1;
    private function animateIt():void {
        TweenMax.to(_arrow, time, {scaleX:.97, scaleY:1.03, y: - _source.width/2, onComplete:func1});
    }

    private function func1():void {

    }
}
}
