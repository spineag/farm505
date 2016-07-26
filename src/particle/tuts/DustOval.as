/**
 * Created by user on 3/1/16.
 */
package particle.tuts {
import tutorial.*;

import starling.display.Sprite;

public class DustOval {
    private var _source:Sprite;
    private var _parent:Sprite;
    private var _radiusV:int;
    private var _radiusH:int;
    private var _arrDusts:Vector.<DustParticle>;
    private var _arrParticleImages:Array = ['p_1', 'p_2', 'p_3', 'p_4', 'p_5', 'p_6', 'p_7', 'p_8', 'p_9', 'p_10', 'p_11', 'p_12'];
    private var PADDING:int = 20;

    public function DustOval(p:Sprite, rVertical:int, rHorizontal:int, _x:int, _y:int):void {
        _source = new Sprite();
        _source.touchable = false;
        _source.x = _x;
        _source.y = _y;
        _parent = p;
        _parent.addChild(_source);
        _radiusV = rVertical;
        _radiusH = rHorizontal;

        createParticles();
        setToDefaults();
        startTweenIt();
    }

    private function createParticles():void {
        var i:int;
        var dust:DustParticle;
        _arrDusts = new Vector.<DustParticle>(2*_radiusH + 2*_radiusV);
        for (i = 0; i < 2*_radiusH + 2*_radiusV; i++) {
            dust = new DustParticle(_arrParticleImages[int(12*Math.random())]);
            _source.addChild(dust.source);
            _arrDusts[i] = dust;
        }
    }

    private function setToDefaults():void {
        var d:int;
        for (var i:int=0; i<_arrDusts.length; i++) {
            d = PADDING*(Math.random() - 1/2);
            _arrDusts[i].setDefaults(0, -_radiusV + d);
            _arrDusts[i].setRadiuses(_radiusV + d, _radiusH + d, 1 + 3*Math.random());
        }
    }

    private function startTweenIt():void {
        var time:Number;
        var delay:Number;
        for (var i:int=0; i<_arrDusts.length; i++) {
            time = 5 + Math.random()*5;
            delay = Math.random()*5;
            _arrDusts[i].moveItOval(time, onCallback, delay);
        }
    }

    private function onCallback(dust:DustParticle):void {
        var time:Number = 5 + Math.random()*5;
        dust.moveItOval(time, onCallback, 0);
    }
}
}
