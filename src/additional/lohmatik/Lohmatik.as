/**
 * Created by user on 10/24/16.
 */
package additional.lohmatik {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;
import flash.geom.Point;
import manager.Vars;
import manager.hitArea.ManagerHitArea;
import manager.hitArea.OwnHitArea;
import starling.display.Sprite;
import starling.events.Event;
import utils.CSprite;
import utils.IsoUtils;
import utils.Point3D;

public class Lohmatik {
    private var g:Vars = Vars.getInstance();
    private var _source:CSprite;
    private var _build:Sprite;
    private var _armature:Armature;
    private var _depth:Number = 0;
    private var _posX:int = 0;
    private var _posY:int = 0;
    private var _isBack:Boolean;
    private var _clickCallback:Function;
    private var _callbackOnAnimation:Function;
    protected var _currentPath:Array;
    private var _hitArea:OwnHitArea;

    public function Lohmatik(f:Function) {
        _isBack = false;
        _clickCallback = f;
        _source = new CSprite();
        _armature = g.allData.factory['lohmatik'].buildArmature("cat");
        _build = new Sprite();
        _build.addChild(_armature.display as StarlingArmatureDisplay);
        _source.addChild(_build);
        _source.releaseContDrag = true;
        _source.endClickCallback = onClick;
        WorldClock.clock.add(_armature);
        _hitArea = g.managerHitArea.getHitArea(_source, 'lohmatik', ManagerHitArea.TYPE_SIMPLE);
        _source.registerHitArea(_hitArea);
    }

    public function setPosition(p:Point):void {
        _posX = p.x;
        _posY = p.y;
        g.townArea.addLohmatik(this);
    }

    public function get depth():Number {
        var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));
        point3d.x += g.matrixGrid.FACTOR/2;
        point3d.z += g.matrixGrid.FACTOR/2;
        _depth = point3d.x + point3d.z;
        return _depth;
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial || g.managerCutScenes.isCutScene) return;
        _callbackOnAnimation = null;
        _build.scale = 1;
        TweenMax.killTweensOf(_source);
        if (_armature && _armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, onCompleteAnimation);
        if (_armature && _armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
        _armature.animation.gotoAndPlayByFrame('idle_5');
        if (_armature && !_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, onCompleteAnimation5);
        if (_armature && !_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation5);
    }

    private function onCompleteAnimation5(e:Event=null):void {
        if (_armature && _armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, onCompleteAnimation5);
        if (_armature && _armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation5);
        if (_clickCallback != null) {
            _clickCallback.apply(null, [this]);
        }
    }

    public function deleteIt():void {
        g.townArea.removeLohmatik(this);
        if (_armature) {
            WorldClock.clock.remove(_armature);
            _build.removeChild(_armature.display as StarlingArmatureDisplay);
            _armature = null;
        }
        _source.deleteIt();
        _source = null;
        _callbackOnAnimation = null;
        _clickCallback = null;
    }

    public function idleAnimation(s:String, callbackOnAnimation:Function):void {
        _callbackOnAnimation = callbackOnAnimation;
        _armature.animation.gotoAndPlayByFrame(s);
        if (_armature && !_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, onCompleteAnimation);
        if (_armature && !_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
    }

    private function onCompleteAnimation(e:Event=null):void {
        if (_armature && _armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, onCompleteAnimation);
        if (_armature && _armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
        if (_callbackOnAnimation != null) {
            _callbackOnAnimation.apply(null, [this]);
        }
    }

    private function walkAnimation():void {
        _armature.animation.gotoAndPlayByFrame('idle_3');
    }

    public function walkBackAnimation():void {
        _armature.animation.gotoAndPlayByFrame('idle_4');
    }

    public function stopAnimation():void {
        _armature.animation.gotoAndStopByFrame('idle');
    }

    public function goWithPath(arr:Array, callbackOnWalking:Function):void {
        _currentPath = arr;
        _callbackOnAnimation = callbackOnWalking;
        if (_currentPath.length > 1) {
            _currentPath.shift(); // first element is that point, where we are now
            gotoPoint(_currentPath.shift(), _callbackOnAnimation);
        } else {
            if (_currentPath.length) {
                gotoPoint(_currentPath.shift(), _callbackOnAnimation);
            } else {
                if (_callbackOnAnimation != null) {
                    _callbackOnAnimation.apply();
                    _callbackOnAnimation = null;
                }
            }
        }
    }

    protected function gotoPoint(p:Point, callback:Function):void {
        var koef:Number = 1;
        var pXY:Point = g.matrixGrid.getXYFromIndex(p);
        var f1:Function = function (callback:Function):void {
            _posX = p.x;
            _posY = p.y;
            g.townArea.zSort();

            if (_currentPath.length) {
                gotoPoint(_currentPath.shift(), callback);
            } else {
                stopAnimation();
                if (callback != null) {
                    callback.apply();
                    callback = null;
                }
            }
        };

        if (Math.abs(_posX - p.x) + Math.abs(_posY - p.y) == 2) {
            koef = 1.4;
        } else {
            koef = 1;
        }
        if (p.x == _posX + 1) {
            if (p.y == _posY) {
                walkAnimation();
                flipIt(true);
            } else if (p.y == _posY - 1) {
                walkAnimation();
                flipIt(true);
            } else if (p.y == _posY + 1) {
                walkAnimation();
                flipIt(false);
            }
        } else if (p.x == _posX) {
            if (p.y == _posY) {
                walkAnimation();
                flipIt(false);
            } else if (p.y == _posY - 1) {
                walkBackAnimation();
                flipIt(false);
            } else if (p.y == _posY + 1) {
                walkAnimation();
                flipIt(false);
            }
        } else if (p.x == _posX - 1) {
            if (p.y == _posY) {
                walkBackAnimation();
                flipIt(true);
            } else if (p.y == _posY - 1) {
                walkBackAnimation();
                flipIt(false);
            } else if (p.y == _posY + 1) {
                walkAnimation();
                flipIt(false);
            }
        } else {
            _source.scaleX = 1;
            Cc.error('Lohmatik gotoPoint:: wrong front-back logic');
        }
        new TweenMax(_source, koef/4, { x: pXY.x, y: pXY.y, ease: Linear.easeNone, onComplete: f1, onCompleteParams: [callback]});
    }

    private function flipIt(v:Boolean):void { if (v) _build.scaleX = -1; else _build.scaleX = 1; }
    public function get posX():int { return _posX; }
    public function get posY():int { return _posY; }
    public function get source():CSprite { return _source; }
    public function get hitArea():OwnHitArea { return _hitArea; }
}
}
