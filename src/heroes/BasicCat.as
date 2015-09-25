/**
 * Created by user on 9/23/15.
 */
package heroes {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import flash.geom.Point;

import manager.Vars;

import map.MatrixGrid;

import utils.CSprite;
import utils.IsoUtils;
import utils.Point3D;

public class BasicCat {
    public static const MAN:int = 1;
    public static const WOMAN:int = 2;

    protected var _posX:int;
    protected var _posY:int;
    protected var _depth:Number;
    protected var _source:CSprite;
    protected var _speedWalk:int = 4;
    protected var _speedRun:int = 7;
    protected var _curSpeed:int;
    protected var _currentPath:Array;
    protected var _callbackOnWalking:Function;
    protected var g:Vars = Vars.getInstance();

    public function BasicCat() {

    }

    public function setPosition(p:Point):void {
        _posX = p.x;
        _posY = p.y;
    }

    public function addToMap():void {
        g.townArea.addHero(this);
    }

    public function get depth():Number {
        return _depth;
    }

    public function updateDepth():void {
        var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));
        point3d.x += MatrixGrid.FACTOR/2;
        point3d.z += MatrixGrid.FACTOR/2;
        _depth = point3d.x + point3d.z;
    }

    public function get posX():int {
        return _posX;
    }

    public function get posY():int {
        return _posY;
    }

    public function get source():CSprite {
        return _source;
    }

    public function walkAnimation():void {
        _curSpeed = _speedWalk;
    }
    public function runAnimation():void {
        _curSpeed = _speedRun;
    }
    public function stopAnimation():void {
        _curSpeed = 0;
    }
    public function idleAnimation():void {}

    public function goWithPath(arr:Array):void {
        _currentPath = arr;
        if (_currentPath.length) {
            _currentPath.shift(); // first element is that point, where we are now
            gotoPoint(_currentPath.shift());
        }
    }

    protected function gotoPoint(p:Point):void {
        if (_curSpeed <= 0) return;
        var koef:Number = 1;
        var pXY:Point = g.matrixGrid.getXYFromIndex(p);
        var f1:Function = function():void {
            _posX = p.x;
            _posY = p.y;
            updateDepth();
            g.townArea.zSort();
            if (_currentPath.length) {
                gotoPoint(_currentPath.shift());
            } else {
                stopAnimation();
                if (_callbackOnWalking != null) {
                    _callbackOnWalking.apply();
                    _callbackOnWalking = null;
                }
            }
        };
        if (Math.abs(_posX - p.x) + Math.abs(_posY - p.y) == 2) {
            koef = 1.4;
        } else {
            koef = 1;
        }
        new TweenMax(_source, koef/_curSpeed, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1});
    }

}
}
