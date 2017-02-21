/**
 * Created by andy on 2/14/17.
 */
package particle.tuts {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import flash.geom.Point;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;

public class DustLikeParticle {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var TIME:int;
    private var _parent:Sprite;
    private var _LTpoint:Point;
    private var _RTpoint:Point;
    private var _LBpoint:Point;
    private var _RBpoint:Point;
    private var _startX:int;
    private var _startY:int;
    private var _numQuarter:int;

    public function DustLikeParticle(pLT:Point, pRT:Point, pRB:Point, pLB:Point, p:Sprite, t:int, imageName:String) {
        _LTpoint = pLT;
        _RTpoint = pRT;
        _RBpoint = pRB;
        _LBpoint = pLB;
        _parent = p;
        TIME = t;
        _source = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(imageName)); // width_x_height == 8_x_8
        im.scale = 1.5; // temp
        im.alignPivot();
        _source.addChild(im);
        _parent.addChild(_source);
    }
    
    public function setPosition(x:int, y:int, quarter:int):void {
        _startX = x;
        _startY = y;
        _source.x = _startX;
        _source.y = _startY;
        _numQuarter = quarter;
    }
    
    public function setPreStartPositions(pCenter:Point):void { // use gomotety principes
        var shift:int = 20;
        if (_numQuarter == 1) {
            _source.x = (pCenter.y + shift)*(_startX - pCenter.x)/pCenter.y + pCenter.x;
            _source.y = _startY - shift;
        } else if (_numQuarter == 2) {
            _source.x = _startX + shift;
            _source.y = (pCenter.x + shift)*(_startY - pCenter.y)/pCenter.x + pCenter.y;
        } else if (_numQuarter == 3) {
            _source.x = (pCenter.y + shift)*(_startX - pCenter.x)/pCenter.y + pCenter.x;
            _source.y = _startY + shift;
        } else {
            _source.x = _startX - shift;
            _source.y = (pCenter.x + shift)*(_startY - pCenter.y)/pCenter.x + pCenter.y;
        }
        _source.scale = 1.5;
    }

    public function preStartAnimations(t:Number):void {
        new TweenMax(_source, t, {x:_startX, y:_startY, scaleX: 1, scaleY:1, ease:Linear.easeNone});
    }

    public function simpleAnimate():void {
        var way:Array;
        if (_numQuarter == 1) {
            way = [{x:_RTpoint.x, y:_RTpoint.y}, {x:_RBpoint.x, y:_RBpoint.y}, {x:_LBpoint.x, y:_LBpoint.y}, {x:_LTpoint.x, y:_LTpoint.y}, {x:_startX, y:_startY}];
        } else if (_numQuarter == 2) {
            way = [{x:_RBpoint.x, y:_RBpoint.y}, {x:_LBpoint.x, y:_LBpoint.y}, {x:_LTpoint.x, y:_LTpoint.y}, {x:_RTpoint.x, y:_RTpoint.y}, {x:_startX, y:_startY}];
        } else if (_numQuarter == 3) {
            way = [{x:_LBpoint.x, y:_LBpoint.y}, {x:_LTpoint.x, y:_LTpoint.y}, {x:_RTpoint.x, y:_RTpoint.y}, {x:_RBpoint.x, y:_RBpoint.y}, {x:_startX, y:_startY}];
        } else {
            way = [{x:_LTpoint.x, y:_LTpoint.y}, {x:_RTpoint.x, y:_RTpoint.y}, {x:_RBpoint.x, y:_RBpoint.y}, {x:_LBpoint.x, y:_LBpoint.y}, {x:_startX, y:_startY}];
        }
        new TweenMax(_source, TIME, {bezier:{curviness:0, values:way}, ease:Linear.easeNone, onComplete: simpleAnimate});
    }
    
    public function deleteIt():void {
        if (!_source) return;
        TweenMax.killTweensOf(_source);
        if (_parent.contains(_source)) _parent.removeChild(_source);
        _parent = null;
        _LTpoint = _LBpoint = _RBpoint = _RTpoint = null;
        _source.dispose();
        _source = null;
    }
}
}
