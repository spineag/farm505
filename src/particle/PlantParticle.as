/**
 * Created by yusjanja on 03.01.2016.
 */
package particle {
import com.greensock.TweenMax;

import manager.Vars;

import starling.display.Sprite;

public class PlantParticle {
    public var source:Sprite;
    private var _counter:int;
    private var _height:int;
    private var g:Vars = Vars.getInstance();

    public function PlantParticle(h:int) {
        source = new Sprite();
        _height = h + 20;
        _counter = 0;
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function onEnterFrame():void {
        _counter++;
        if (_counter >= 15) {
            _counter = 0;
            new Particle(_height, source);
        }
    }

    public function clearIt():void {
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        _counter = 0;
        while (source.numChildren) {
            TweenMax.killTweensOf(source.getChildAt(0));
            source.removeChildAt(0);
        }
    }
}
}

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;

internal class Particle {
    private var _source:Sprite;
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();

    public function Particle(h:int, p:Sprite){
        _parent = p;
        _source = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_particle'));
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        _source.addChild(im);
        _source.y = -int(h/2*Math.random());
        _source.x = -60 + int(Math.random()*120);
        _parent.addChild(_source);
        var time:Number = 2 + 2*Math.random();
        TweenMax.to(_source, time, {y: _source.y - int(h/2), rotation:360, onComplete:onFinish, ease:Linear.easeNone});
        _source.scaleX = _source.scaleY = .5;
        var scaleT:Number = 1 + Math.random()/2;
        var alphaT:Number = .7 + Math.random()*.3;
        _source.alpha = .5;

        var onFinishScaling:Function = function():void {
            TweenMax.to(_source, time/2, {scaleX:.5, scaleY:.5, alpha:.3, ease:Linear.easeNone});
        };
        TweenMax.to(_source, time/2, {scaleX:scaleT, scaleY:scaleT, alpha:alphaT, onComplete:onFinishScaling, ease:Linear.easeNone});
    }

    private function onFinish():void {
        TweenMax.killTweensOf(_source);
        _parent.removeChild(_source);
        _source.dispose();
        _source = null;
        _parent = null;
    }
}