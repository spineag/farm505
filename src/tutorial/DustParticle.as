/**
 * Created by user on 2/29/16.
 */
package tutorial {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;

public class DustParticle {
    private var _q:Sprite;
    public var source:Sprite;
    private var _side:int;
    private var _rV:int;
    private var _rH:int;
    private var g:Vars = Vars.getInstance();

    public function DustParticle(imageName:String) {
        source = new Sprite();
        _q = getRandomParticle(imageName);
        source.addChild(_q);
    }

    private function getRandomParticle(imageName):Sprite {
        var sp:Sprite = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(imageName));
        im.x = -im.width/2;
        im.y = -im.height/2;
        sp.addChild(im);
        sp.touchable = false;
        sp.flatten();
        return sp;
    }

    public function set side(s:int):void {
        _side = s;
    }

    public function setDefaults(_x:int, _y:int):void {
        source.x = _x;
        source.y = _y;
        _q.scaleX = _q.scaleY = .2;
    }

    public function moveIt(_newX:int, _newY:int, time:Number, f:Function):void {
        if (f != null) {
            TweenMax.to(source, time, {x:_newX, y:_newY, ease:Linear.easeNone, onComplete:f, onCompleteParams: [this, _side]});
        } else {
            TweenMax.to(source, time, {x:_newX, y:_newY, ease:Linear.easeNone});
        }
    }

    public function scaleIt(time:Number, f:Function):void {
        var scale:Number = .5 + .8*Math.random();
        TweenMax.to(_q, time, {scaleX:scale, scaleY:scale, ease:Linear.easeNone, onComplete:scaleIt2, onCompleteParams: [time, f]});
    }

    private function scaleIt2(time:Number, f:Function):void {
        TweenMax.to(_q, time, {scaleX:.2, scaleY:.2, ease:Linear.easeNone, onComplete:scaleIt3, onCompleteParams: [f]});
    }

    private function scaleIt3(f:Function):void {
        if (f!=null) {
            f.apply(null, [this, _side]);
        }
    }

    public function setRadiuses(rVertical:int, rHorizontal:int, scale:Number = 1):void {
        _rV = rVertical;
        _rH = rHorizontal;
        _q.scaleX = _q.scaleY = scale;
    }

    public function moveItOval(time:Number, f:Function, delay:Number):void {
        TweenMax.to(source, time, {bezier:[{x:_rH, y:0}, {x:0, y:_rV}, {x:-_rH, y:0}, {x:0, y:-_rV}], ease:Linear.easeNone, onComplete:f, onCompleteParams:[this], delay:delay});
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
