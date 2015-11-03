/**
 * Created by user on 10/30/15.
 */
package heroes {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import flash.geom.Point;

import starling.display.Image;

import utils.CSprite;

public class FarmCat extends BasicCat{
    private var _catImage:Image;

    public function FarmCat() {
        super();

        _speedWalk = 20;
        _source = new CSprite();
        _source.isTouchable = false;
        _catImage = new Image(g.allData.atlas['catAtlas'].getTexture('cat_farm'));
        if (!_catImage) {
            Cc.error('FarmCat: no such image cat_farm');
            g.woGameError.showIt();
            return;
        }
        _catImage.pivotX = _catImage.width / 2;
        _catImage.pivotY = _catImage.height;
        _source.addChild(_catImage);
    }

    public function startFarmAnimation():void {
        chooseFarmAnimation();
    }

    private function chooseFarmAnimation():void {
        stopAnimation();
        var i:int = int(Math.random()*3);
        if (i > 0) {
            walkFarmAnimation();
        } else {
            countIdle = 3;
            idleFarmAnimation();
        }
    }

    private var countIdle:int;
    private function idleFarmAnimation():void {
        var f1:Function = function():void {
            new TweenMax(_catImage, .2, {y:0, ease:Linear.easeOut ,onComplete: f2});
        };
        var f2:Function = function():void {
            countIdle--;
            if (countIdle <= 0) {
                chooseFarmAnimation();
                return;
            }
            new TweenMax(_catImage, .2, {y:-20, ease:Linear.easeIn ,onComplete: f1});
        };
        f2();
    }

    private function walkFarmAnimation():void {
        var p:Point = g.farmGrid.getRandomPoint();
        var dist:int = Math.sqrt((_source.x - p.x)*(_source.x - p.x) + (_source.y - p.y)*(_source.y - p.y));
        new TweenMax(_source, dist/_speedWalk, {x:p.x, y:p.y, ease:Linear.easeIn ,onComplete: chooseFarmAnimation});
    }

    public function clearIt():void {
        TweenMax.killTweensOf(_source);
        _catImage.dispose();
        while (_source.numChildren) _source.removeChildAt(0);
    }
}
}
