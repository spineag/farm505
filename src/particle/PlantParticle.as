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
        _height = h - 20;
        _counter = int(4 + Math.random()*15);
        g.gameDispatcher.addToTimer(onEnterFrame);
    }

    private function onEnterFrame():void {
        _counter--;
        if (_counter <=0) {
            _counter = int(4 + Math.random()*10);
            new Particle(_height, source);
        }
    }

    public function clearIt():void {
        g.gameDispatcher.removeFromTimer(onEnterFrame);
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
    private var height:int;
    private var g:Vars = Vars.getInstance();

    public function Particle(h:int, p:Sprite){
        _parent = p;
        height = h;
        _source = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_particle'));
//        im.pivotX = im.width/2;
//        im.pivotY = im.height/2;
        _source.addChild(im);
        _source.y = -int(h/2*Math.random());
        _source.x = int((-60 + Math.random()*120) * g.scaleFactor);
        _parent.addChild(_source);
        var time:Number = 1 + Math.random();
//        var time:Number = 3*Math.random();
        TweenMax.to(_source, time, {y: _source.y - int(h/2), rotation:3*Math.PI, onComplete:onFinish, ease:Linear.easeNone});
        _source.scaleX = _source.scaleY = .2 * g.scaleFactor;
//        var scaleT:Number = (1 + Math.random()/2)*g.scaleFactor;
        var alphaT:Number = .5 + Math.random()*.3;
        _source.alpha = 1;

        var onFinishScaling:Function = function():void {
            TweenMax.to(_source, time/2, {scaleX:.3, scaleY:.3, alpha:.3, ease:Linear.easeNone});
        };
        TweenMax.to(_source, time/2, {scaleX:.5, scaleY:.5, alpha:alphaT, onComplete:onFinishScaling, ease:Linear.easeNone});
    }

    private function onFinish():void {
        TweenMax.killTweensOf(_source);
        _parent.removeChild(_source);
        _source.dispose();
        _source = null;
        _parent = null;
    }
}