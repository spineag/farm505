/**
 * Created by andy on 5/12/16.
 */
package preloader.miniPreloader {
import flash.geom.Point;

import starling.display.Sprite;

public class CatViewPreloader {
    private var _source:Sprite;
    private var _arrPoints:Array;
    private var _arrParticles:Array;

    public function CatViewPreloader() {
        _source = new Sprite();
        _source.touchable = false;
        _arrPoints = [new Point(20, -40), new Point(40, 0), new Point(40, 20), new Point(0, 60), new Point(-40, 20), new Point(-40, 0), new Point(-20,-40), new Point(0,0)];
        _arrParticles = [];
        var par:Particle;
        for (var i:int=0; i<3; i++) {
            par = new Particle(_arrPoints, _source, i*.2);
            _arrParticles.push(par);
        }
    }

    public function get source():Sprite {
        return _source;
    }

    public function deleteIt():void {
        for (var i:int=0; i<_arrParticles.length; i++) {
            _arrParticles[i].deleteIt();
        }
        _arrParticles = [];
        _source.dispose();
        _arrPoints = [];
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
    private var _arrPath:Array;
    private var _arrParticleImages:Array = ['p_1', 'p_2', 'p_3', 'p_4'];
    private var g:Vars = Vars.getInstance();

    public function Particle(ar:Array, p:Sprite, d:Number) {
        _parent = p;
        _arrPath = ar;
        _source = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(_arrParticleImages[int(4*Math.random())]));
        im.scaleX=im.scaleY = 3;
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source.addChild(im);
        _parent.addChild(_source);

         makeAnimation(d);
    }

    private function makeAnimation(d:Number=0):void {
        TweenMax.to(_source, 2, {bezier:{curviness:1, values:_arrPath}, ease:Linear.easeIn, onComplete:makeAnimation, delay: d});
    }

    public function deleteIt():void {
        TweenMax.killTweensOf(_source);
        _parent.removeChild(_source);
        _source.dispose();
        _parent = null;
        _arrParticleImages.length = 0;
    }
}
