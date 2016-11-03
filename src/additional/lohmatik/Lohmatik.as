/**
 * Created by user on 10/24/16.
 */
package additional.lohmatik {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import data.DataMoney;
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;
import flash.geom.Point;
import manager.Vars;
import manager.hitArea.ManagerHitArea;
import manager.hitArea.OwnHitArea;
import resourceItem.DropItem;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import ui.xpPanel.XPStar;
import utils.CSprite;
import utils.IsoUtils;
import utils.Point3D;

public class Lohmatik {
    private var g:Vars = Vars.getInstance();
    private var _source:CSprite;
    private var _build:Sprite;
    private var _armature:Armature;
    private var _armatureOpen:Armature;
    private var _depth:Number = 0;
    private var _posX:int = 0;
    private var _posY:int = 0;
    private var _isBack:Boolean;
    private var _clickCallback:Function;
    private var _callbackOnAnimation:Function;
    protected var _currentPath:Array;
    private var _hitArea:OwnHitArea;
    private var _scale:Number;

    public function Lohmatik(f:Function) {
        _isBack = false;
        _clickCallback = f;
        _source = new CSprite();
        _armature = g.allData.factory['lohmatik'].buildArmature("cat");
        _build = new Sprite();
        _build.addChild(_armature.display as StarlingArmatureDisplay);
        _scale = .5 + (int(Math.random()*5)/10);
        _build.scale = _scale;
        _source.addChild(_build);
        _source.releaseContDrag = true;
        _source.endClickCallback = onClick;
        changeSkin();
        WorldClock.clock.add(_armature);
        _hitArea = g.managerHitArea.getHitArea(_source, 'lohmatik', ManagerHitArea.TYPE_SIMPLE);
        _source.registerHitArea(_hitArea);

    }

    private function changeSkin():void {
        var skins:Array = ['lohmatik_blue', 'lohmatik_gray', 'lohmatik_green', 'lohmatik_violet', 'lohmatik_yellow'];
        var st:String = skins[int(Math.random()*5)];
        var im:Image = new Image(g.allData.atlas['customisationInterfaceAtlas'].getTexture(st));
        var b:Slot = _armature.getSlot('lohmatik');
        if (b && im) {
            b.displayList = null;
            b.display = im;
        }
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
        _source.endClickCallback = null;
        _source.isTouchable = false;
        _callbackOnAnimation = null;
        _build.scale = _scale;
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
        flyItAward();
        showBoom();
        new TweenMax(_source, .7, {alpha:0, ease: Linear.easeNone});
    }

    private function flyItAward():void {
        var obj:Object;
        obj = {};
        obj.count = 1;
        var p:Point = new Point(0, 0);
        p = _source.localToGlobal(p);
        obj.id =  DataMoney.SOFT_CURRENCY;
        new DropItem(p.x, p.y, obj);
        new XPStar(p.x, p.y, 1);
    }

    public function showBoom():void {
        _armatureOpen = g.allData.factory['explode'].buildArmature("expl");
        if (!_armatureOpen) {
            Cc.error('Lohmatik:: no boom :(');
            if (_clickCallback != null) {
                _clickCallback.apply(null, [this]);
            }
            return;
        }
        (_armatureOpen.display as StarlingArmatureDisplay).scale = .6;
        (_armatureOpen.display as StarlingArmatureDisplay).y = - 10;
        _source.addChild(_armatureOpen.display as StarlingArmatureDisplay);
        WorldClock.clock.add(_armatureOpen);
        _armatureOpen.addEventListener(EventObject.COMPLETE, onBoom);
        _armatureOpen.addEventListener(EventObject.LOOP_COMPLETE, onBoom);
        _armatureOpen.animation.gotoAndPlayByFrame("start");
    }

    private function onBoom(e:Event=null):void {
        if (_armatureOpen.hasEventListener(EventObject.COMPLETE)) _armatureOpen.removeEventListener(EventObject.COMPLETE, onBoom);
        if (_armatureOpen.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureOpen.removeEventListener(EventObject.LOOP_COMPLETE, onBoom);
        WorldClock.clock.remove(_armatureOpen);
        _source.removeChild(_armatureOpen.display as StarlingArmatureDisplay);
        _armatureOpen = null;
        if (_clickCallback != null) {
            _clickCallback.apply(null, [this]);
        }
    }

    public function deleteIt():void {
        if (_armature && _armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, onCompleteAnimation);
        if (_armature && _armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, onCompleteAnimation);
        TweenMax.killTweensOf(_source);
        g.townArea.removeLohmatik(this);
        if (_armature) {
            WorldClock.clock.remove(_armature);
            _build.removeChild(_armature.display as StarlingArmatureDisplay);
            _armature = null;
        }
        if (_armatureOpen) {
            if (_armatureOpen.hasEventListener(EventObject.COMPLETE)) _armatureOpen.removeEventListener(EventObject.COMPLETE, onBoom);
            if (_armatureOpen.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureOpen.removeEventListener(EventObject.LOOP_COMPLETE, onBoom);
            WorldClock.clock.remove(_armatureOpen);
            _source.removeChild(_armatureOpen.display as StarlingArmatureDisplay);
            _armatureOpen = null;
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
            _build.scaleX = _scale;
            Cc.error('Lohmatik gotoPoint:: wrong front-back logic');
        }
        new TweenMax(_source, koef/4, { x: pXY.x, y: pXY.y, ease: Linear.easeNone, onComplete: f1, onCompleteParams: [callback]});
    }

    private function flipIt(v:Boolean):void { if (v) _build.scaleX = -_scale; else _build.scaleX = _scale; }
    public function get posX():int { return _posX; }
    public function get posY():int { return _posY; }
    public function get source():CSprite { return _source; }
    public function get hitArea():OwnHitArea { return _hitArea; }
}
}
