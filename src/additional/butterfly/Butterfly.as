/**
 * Created by andy on 5/9/16.
 */
package additional.butterfly {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import flash.geom.Point;
import manager.Vars;
import starling.display.Sprite;

public class Butterfly {
    public static const TYPE_PINK:int = 1;
    public static const TYPE_YELLOW:int = 2;
    public static const TYPE_BLUE:int = 3;

    private var _source:Sprite;
    private var _curType:int;
    private var _animation:ButterflyAnimation;
    private var _cont:Sprite;
    private var _manager:ManagerButterfly;
    private var _isFlying:Boolean;
    private var _endPoint:Point;
    private var _curPoint:Point;
    private var Y_UNDER_EARTH:int; // высота полета над землей
    private var g:Vars = Vars.getInstance();

    public function Butterfly(type:int, mngr:ManagerButterfly) {
        _source = new Sprite();
        _curType = type;
        _animation = new ButterflyAnimation(_curType);
        _source.addChild(_animation.source);
        _cont = g.cont.cloudsCont;
        _manager = mngr;
    }

    public function flipIt(v:Boolean):void {
        if (v) _source.scaleX = -1;
            else _source.scaleX = 1;
    }

    public function startFly():void {
        _curPoint = _manager.randomPoint;
        var p:Point = g.matrixGrid.getXYFromIndex(_curPoint);
        _source.x = p.x;
        _source.y = p.y;
        _cont.addChild(_source);
        playDirectLabel('idle_2', false, null);
        _animation.source.rotation = Math.PI/2;
        flyToRandomPoint();
    }

    private function playDirectLabel(label:String, playOnce:Boolean, callback:Function):void {
        _animation.playIt(label, playOnce, callback);
    }

    private function flyToRandomPoint():void {
        _endPoint = _manager.getRandomClosestPoint(_curPoint);  // get end point
        var arrPoints:Array = [];                               // use for points between current position and end position, make 2 points + last one
        var p:Point = g.matrixGrid.getXYFromIndex(_endPoint);
        arrPoints.push(p);

        p = new Point();
        p.x = int(2*_curPoint.x/3 + _endPoint.x/3);
        p.y = int(2*_curPoint.y/3 + _endPoint.y/3);
        p = _manager.getRandomClosestPoint(p, 5);
        p = g.matrixGrid.getXYFromIndex(p);
        arrPoints.unshift(p);
        p = new Point();
        p.x = int(_curPoint.x/3 + 2*_endPoint.x/3);
        p.y = int(_curPoint.y/3 + 2*_endPoint.y/3);
        p = _manager.getRandomClosestPoint(p, 5);
        p = g.matrixGrid.getXYFromIndex(p);
        arrPoints.unshift(p);

        var distance:int = calculateDistance(arrPoints);
        var time:int = int(distance/50 + Math.random()*5);
        TweenMax.to(_source, time, {bezier:{curviness:1.5, autoRotate:["x","y","rotation",0,true], values:arrPoints}, ease:Linear.easeNone, onComplete:flyToRandomPoint, delay: 1});
        _curPoint = _endPoint;
    }

    private function calculateDistance(arr:Array):int {
        var d:int = Math.sqrt((_source.x-arr[0].x)*(_source.x-arr[0].x) + (_source.y-arr[0].y)*(_source.y-arr[0].y));
        d += Math.sqrt((arr[0].x-arr[1].x)*(arr[0].x-arr[1].x) + (arr[0].y-arr[1].y)*(arr[0].y-arr[1].y));
        d += Math.sqrt((arr[2].x-arr[1].x)*(arr[2].x-arr[1].x) + (arr[2].y-arr[1].y)*(arr[2].y-arr[1].y));
        return d;
    }
}
}
