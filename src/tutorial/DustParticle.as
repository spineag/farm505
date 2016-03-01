/**
 * Created by user on 2/29/16.
 */
package tutorial {
import com.greensock.TweenMax;
import com.greensock.easing.Ease;
import com.greensock.easing.Linear;

import starling.display.Quad;
import starling.display.Sprite;

public class DustParticle {
    private var _q:Quad;
    public var source:Sprite;
    private var _side:int;

    public function DustParticle(color:int, side:int) {
        source = new Sprite();
        _q = new Quad(1, 1, color);
        source.addChild(_q);
        _side = side;
    }

    public function setDefaults(_x:int, _y:int):void {
        source.x = _x;
        source.y = _y;
        source.scaleX = source.scaleY = 1;
    }

    public function moveIt(_newX:int, _newY:int, time:Number, f:Function):void {
        if (f != null) {
            TweenMax.to(source, time, {x:_newX, y:_newY, ease:Linear.easeNone, onComplete:f, onCompleteParams: [this, _side]});
        } else {
            TweenMax.to(source, time, {x:_newX, y:_newY, ease:Linear.easeNone});
        }
    }

    public function scaleIt(time:Number, f:Function):void {
        var scale:Number = 1 + 1.5*Math.random();
        TweenMax.to(_q, time, {scaleX:scale, scaleY:scale, ease:Linear.easeNone, onComplete:scaleIt2, onCompleteParams: [time, f]});
    }

    private function scaleIt2(time:Number, f:Function):void {
        TweenMax.to(_q, time, {scaleX:1, scaleY:1, ease:Linear.easeNone, onComplete:scaleIt3, onCompleteParams: [f]});
    }

    private function scaleIt3(f:Function):void {
        if (f!=null) {
            f.apply(null, [this, _side]);
        }
    }

    public function deleteIt():void {
        TweenMax.killTweensOf(_q);
        TweenMax.killTweensOf(source);
        _q.dispose();
        source.dispose();
        _q = null;
        source = null;
    }

}
}
