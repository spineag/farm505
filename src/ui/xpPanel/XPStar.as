/**
 * Created by user on 6/24/15.
 */
package ui.xpPanel {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import manager.ManagerFilters;

import manager.Vars;

import resourceItem.ResourceItem;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class XPStar {

    private var _source:Sprite;
    private var _image:Image;
    private var _xp:int;
    private var _txtStar:TextField;

    private var g:Vars = Vars.getInstance();

    public function XPStar(_x:int, _y:int,xp:int) {
        _source = new Sprite();
        _txtStar = new TextField(80,50,'',g.allData.fonts['BloggerBold'],18, Color.WHITE);
        _txtStar.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtStar.x = -15;
        _txtStar.y = 25;
        _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("star"));
        _xp = xp;
        g.cont.animationsResourceCont.addChild(_source);
        MCScaler.scale(_image, 50, 50);
        _source.addChild(_image);
        _source.pivotX = _source.width / 2;
        _source.pivotY = _source.height / 2;
        _source.x = _x;
        _source.y = _y;
        _source.addChild(_txtStar);
        flyItStar();

    }

    private function flyItStar():void {
        var endX:int = Starling.current.nativeStage.stageWidth - 200;
        var endY:int = 50;
        _txtStar.text = '+' + String(_xp);

        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
            g.xpPanel.addXP(_xp);
        };
        var tempX:int;
        _source.x < endX ? tempX = _source.x + 70 : tempX = _source.x - 70;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - endX)*(_source.x - endX) + (_source.y - endY)*(_source.y - endY)));
        var v:Number = 300;
        new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endX, y:endY}], ease:Linear.easeOut ,onComplete: f1, delay:.5});
    }
}
}
