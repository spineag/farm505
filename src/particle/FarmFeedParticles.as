/**
 * Created by user on 12/29/15.
 */
package particle {

import starling.display.Sprite;

public class FarmFeedParticles {
    public var source:Sprite;
    private const MAX_COUNT:int = 10;
    private var _count:int;
    private var _callback:Function;

    public function FarmFeedParticles(callback:Function) {
        source = new Sprite();
        _callback = callback;
        var part:Particle;
        _count = MAX_COUNT;
        for (var i:int=0; i< MAX_COUNT; i++) {
            part = new Particle(1 + Math.random(), onFinishParticle);
            source.addChild(part.source);
        }
    }

    private function onFinishParticle(p:Particle):void {
        p.deleteIt();
        if (--_count <=0) {
            if (_callback != null) _callback.apply();
        }
    }

}
}

import com.greensock.TweenMax;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;

internal class Particle {
    public var source:Sprite;
    private var g:Vars = Vars.getInstance();
    private const DISTANCE_X:int = 300;
    private const DISTANCE_Y:int = 50;

    public function Particle(lifeTime:int, callback:Function):void {
        source = new Sprite();
        var s:Sprite = new Sprite();
        var im:Image = g.allData.atlas['interfaceAtlas'].getTexture('star_particle');
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        s.addChild(im);
        source.addChild(s);

        var time:Number = 1 + Math.random();
        var deltaX:int = -50 + 100*Math.random();
        var deltaY:int = -20 + 40*Math.random();
        new TweenMax(source, lifeTime + time, {x:DISTANCE_X + deltaX, y:DISTANCE_Y + deltaY, rotation: 3600, onComplete: onCompleteFunc, onCompleteParams:callback});

    }

    private function onCompleteFunc(callback:Function):void {
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
