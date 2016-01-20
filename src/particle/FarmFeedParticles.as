/**
 * Created by user on 12/29/15.
 */
package particle {

import manager.Vars;

import starling.display.Sprite;

public class FarmFeedParticles {
    public var source:Sprite;
    private const MAX_COUNT:int = 8;
    private var _count:int;
    private var _callback:Function;
    private var g:Vars = Vars.getInstance()

    public function FarmFeedParticles(callback:Function) {
        source = new Sprite();
        _callback = callback;
        var part:Particle;
        _count = MAX_COUNT;
        var dX:int = (120 + 100*Math.random()) * g.scaleFactor;
        var dY:int = (120 + 100*Math.random()) * g.scaleFactor;
        for (var i:int=0; i< MAX_COUNT; i++) {
            part = new Particle(1 + Math.random(), dX, dY, onFinishParticle);
            source.addChild(part.source);
        }
    }

    private function onFinishParticle(p:Particle):void {
        source.removeChild(p.source);
        p.deleteIt();
        if (--_count <=0) {
            if (_callback != null) _callback.apply();
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
    public var source:Sprite;
    private var g:Vars = Vars.getInstance();

    public function Particle(lifeTime:int, DISTANCE_X:int, DISTANCE_Y:int, callback:Function):void {
        source = new Sprite();
        var s:Sprite = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('particle_yelow'));
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        im.scaleX = im.scaleY = .5 * g.scaleFactor;
        s.addChild(im);
        source.addChild(s);

        var deltaX:int = (-70 + 140*Math.random()) * g.scaleFactor;
        var deltaY:int = (-40 + 60*Math.random()) * g.scaleFactor;
        var arrValues:Array = new Array();
        var obj:Object = {};
        obj.x = (DISTANCE_X + deltaX)/3;
        obj.y = (-50 + Math.random()*20)*g.scaleFactor;
        arrValues.push(obj);
        obj = {};
        obj.x = DISTANCE_X + deltaX;
        obj.y = DISTANCE_Y + deltaY;
        arrValues.push(obj);
        new TweenMax(source, lifeTime + Math.random()/5, {bezier: {values: arrValues}, ease: Linear.easeIn, onComplete: onCompleteFunc, onCompleteParams:[callback]});

    }

    private function onCompleteFunc(callback:Function):void {
        new TweenMax(source, .3, {scaleX:.5, scaleY:.2, ease: Linear.easeIn, delay:.3, onComplete: onCompleteFunc2, onCompleteParams:[callback]});
    }

    private function onCompleteFunc2(callback:Function):void {
        if (callback != null) {
            callback.apply(null, [this]);
        }
    }

    public function deleteIt():void {
        TweenMax.killTweensOf(source);
        source.dispose();
        source = null;
    }
}
