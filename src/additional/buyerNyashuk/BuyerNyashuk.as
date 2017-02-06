/**
 * Created by user on 12/2/16.
 */
package additional.buyerNyashuk {
import build.TownAreaBuildSprite;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import data.BuildType;

import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;

import flash.geom.Rectangle;

import manager.Vars;
import manager.hitArea.ManagerHitArea;
import manager.hitArea.OwnHitArea;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Color;

import utils.CSprite;
import utils.IsoUtils;
import utils.MCScaler;
import utils.Point3D;
import utils.SimpleArrow;

import windows.WindowsManager;

public class BuyerNyashuk {

    public static var LONG_OUTTILE_WALKING:int=1;
    public static var SHORT_OUTTILE_WALKING:int=2;
    public static var TILE_WALKING:int = 3;
    public static var STAY_IN_QUEUE:int = 4;

    private var g:Vars = Vars.getInstance();
    private var _armature:Armature;
    private var _buyerId:int;
    private var _hitArea:OwnHitArea;
    private var _data:Object;
    private var _build:Sprite;

    protected var _posX:int;
    protected var _posY:int;
    protected var _depth:Number;
    protected var _source:CSprite;
    protected var _speedWalk:int = 1;
    protected var _speedRun:int = 1;
    private var _queuePosition:int;
    private var _currentPath:Array;
    public var walkPosition:int;
    private var _arriveCallback:Function;
    private var _callbackHi:Function;
    private var _rect:Rectangle;
    private var _booleanFront:Boolean = true;
    private var _spriteTxt:Sprite;
    private var _isHover:Boolean;
    private var _arrow:SimpleArrow;

    public function BuyerNyashuk(id:int, ob:Object) {
        _buyerId = id;
        _data = ob;
        _source = new CSprite();
        _spriteTxt = new Sprite();
        _spriteTxt.touchable = true;
        _isHover = false;
        var dataResource:Object = g.dataResource.objectResources[_data.resourceId];
        var im:Image;
        if (dataResource.buildType == BuildType.PLANT)
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(dataResource.imageShop + '_icon'));
        else
            im = new Image(g.allData.atlas[dataResource.url].getTexture(dataResource.imageShop));
        MCScaler.scale(im, im.height - 60, im.width - 60);
        im.pivotX = im.pivotY = im.width/2;
        _spriteTxt.addChild(im);
        if (id == 1) {
            if (g.allData.factory['blue_n']) onLoad();
            else g.loadAnimation.load('animations_json/x1/blue_n', 'blue_n', onLoad);

        } else {
            if (g.allData.factory['red_n']) onLoad();
            else g.loadAnimation.load('animations_json/x1/red_n', 'red_n', onLoad);
        }
    }

    private function onLoad():void {
        if (_buyerId == 1)  _armature = g.allData.factory['blue_n'].buildArmature("blue_n");
        else _armature = g.allData.factory['red_n'].buildArmature("red_n");
        _build = new Sprite();
        _build.addChild(_armature.display as StarlingArmatureDisplay);
        _source.addChild(_build);
        _source.releaseContDrag = true;
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _source.hoverCallback = onHover;
            _source.outCallback = onOut;
        }
        WorldClock.clock.add(_armature);
        if (_buyerId == 1)   _hitArea = g.managerHitArea.getHitArea(_source, 'blue_n', ManagerHitArea.TYPE_SIMPLE);
        else  _hitArea = g.managerHitArea.getHitArea(_source, 'red_n', ManagerHitArea.TYPE_SIMPLE);
        _source.registerHitArea(_hitArea);

        var b:Slot = _armature.getSlot('item');
        if (b) {
            b.displayList = null;
            b.display = _spriteTxt;
        }
    }

    public function get depth():Number {
        var p:Point = new Point(_source.x, _source.y);
        p = g.matrixGrid.getIndexFromXY(p);
        _posX = p.x;
        _posY = p.y;
        if (_posX < 0 || _posY < 0) {
            _depth = _source.y - 150;
        } else {
            p.x = _source.x;
            p.y = _source.y;
            var point3d:Point3D = IsoUtils.screenToIso(p);
            point3d.x += g.matrixGrid.FACTOR/2;
            point3d.z += g.matrixGrid.FACTOR/2;
            _depth = point3d.x + point3d.z;
        }
        return _depth;
    }

    private function onClick():void {
        g.windowsManager.openWindow(WindowsManager.WO_BUYER_NYASHUK, null, _buyerId, _data,this);
    }

    public function noClick():void {
        _source.endClickCallback = null;
        _source.hoverCallback = null;
        _source.outCallback = null;
    }

    public function yesClick():void {
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _source.hoverCallback = onHover;
            _source.outCallback = onOut;
        }
    }

    private function onHover():void {
        if (_isHover) return;
        _isHover = true;
        var fEndOver:Function = function(e:Event=null):void {
            _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            idleFrontAnimation();
        };
        _armature.addEventListener(EventObject.COMPLETE, fEndOver);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
        _armature.animation.gotoAndPlayByFrame('run_quest');
    }

    private function onOut():void { _isHover = false; }
    public function get source():Sprite { return _source; }
    public function get posX():int { return _posX; }
    public function get posY():int { return _posY; }
    public function get rect():Rectangle { return _rect; }
    public function setPositionInQueue(i:int):void { _queuePosition = i; }
    public function get queuePosition():int { return _queuePosition; }
    public function flipIt(v:Boolean):void { v ? _source.scaleX = -1: _source.scaleX = 1; }

    public function showFront(v:Boolean):void {
        _booleanFront = v;
        walkAnimation();
    }

    public function addArrow(t:Number = 0):void {
        removeArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, source);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(0, -70);
        if (t>0) _arrow.activateTimer(t, removeArrow);
}

    public function removeArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function setTailPositions(posX:int, posY:int):void {
        _posX = posX;
        _posY = posY;
        var p:Point = new Point(_posX, _posY);
        p = g.matrixGrid.getXYFromIndex(p);
        _source.x = p.x;
        _source.y = p.y;
    }

    public function checkArriveCallback():void {
        if (_arriveCallback != null) {
            _arriveCallback.apply(null, [this]);
            _arriveCallback = null;
        }
    }

    public function set arriveCallback(f:Function):void {
        _arriveCallback = f;
    }

    public function deleteIt():void {
        g.townArea.removeBuyerNyashukFromCityObjects(this);
        g.townArea.removeBuyerNyashukFromCont(this);
        forceStopAnimation();

        WorldClock.clock.remove(_armature);
        TweenMax.killTweensOf(_source);
        while (_source.numChildren) _source.removeChildAt(0);
        if (_armature) {
            _armature.dispose();
            _armature = null;
        }
        _source.dispose();
        _currentPath = [];
    }

    public function showForOptimisation(needShow:Boolean):void {
        if (_source) _source.visible = needShow;
    }

    //  ------------------ ANIMATIONS -----------------------

    private var count:int;
    public function idleFrontAnimation():void {
        if (!_armature) return;
        var r:int = int(Math.random()*5);
        _armature.addEventListener(EventObject.COMPLETE, onFinishIdle);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
        switch (r) {
            case 0: _armature.animation.gotoAndPlayByFrame("idle_1"); break;
            case 1: _armature.animation.gotoAndPlayByFrame("idle_3"); break;
            case 2: _armature.animation.gotoAndPlayByFrame("idle_4"); break;
            case 3: _armature.animation.gotoAndPlayByFrame("idle_6"); break;
            case 4: _armature.animation.gotoAndPlayByFrame("idle_5"); break;
        }
    }

    private function onFinishIdle(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onFinishIdle);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
        idleFrontAnimation();
    }

    private function releaseBackIdle():void {
        showFront(false);
        count = 3;
        _armature.addEventListener(EventObject.COMPLETE, onFinishIdleBack);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
        _armature.animation.gotoAndPlayByFrame("idle");
    }

    private function onFinishIdleBack(e:Event=null):void {
        count--;
        _armature.removeEventListener(EventObject.COMPLETE, onFinishIdleBack);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
        if (count > 0) {
            _armature.addEventListener(EventObject.COMPLETE, onFinishIdleBack);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
            _armature.animation.gotoAndPlayByFrame("idle");
        } else {
            showFront(true);
            idleFrontAnimation();
        }
    }

    public function stopAnimation():void {
        showFront(true);
        if (_armature) _armature.animation.gotoAndStopByFrame('idle');
        if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, onFinishIdle);
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
    }

    public function forceStopAnimation():void {
        if (_callbackHi != null) _callbackHi = null;
        stopAnimation();
        TweenMax.killTweensOf(_source);
    }

    public function walkAnimation():void {
        if (_booleanFront) _armature.animation.gotoAndPlayByFrame("run");
        else _armature.animation.gotoAndPlayByFrame("run_b");
    }

    public function walkPackAnimation():void {
        if (_booleanFront) _armature.animation.gotoAndPlayByFrame("run");
        else _armature.animation.gotoAndPlayByFrame("run_b");
    }

    public function runAnimation():void {
        if (_booleanFront) _armature.animation.gotoAndPlayByFrame("run");
        else _armature.animation.gotoAndPlayByFrame("run_b");
    }

    // --------------- WALKING --------------

    public function goWithPath(arr:Array, callbackOnWalking:Function, catGoAway:Boolean = false):void {
        _currentPath = arr;
        if (_currentPath.length) {
            _currentPath.shift(); // first element is that point, where we are now
            gotoPoint(_currentPath.shift(), callbackOnWalking, catGoAway);
        }
    }

    private function gotoPoint(p:Point, callbackOnWalking:Function, catGoAway:Boolean = false):void {
        var koef:Number = 1;
        var pXY:Point = g.matrixGrid.getXYFromIndex(p);
        var f1:Function = function(callbackOnWalking:Function):void {
            _posX = p.x;
            _posY = p.y;
            g.townArea.zSort();
            if (_currentPath.length) {
                gotoPoint(_currentPath.shift(), callbackOnWalking,catGoAway);
            } else {
                if (callbackOnWalking != null) {
                    callbackOnWalking.apply();
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
                showFront(true);
                flipIt(true);
            } else if (p.y == _posY - 1) {
                showFront(true);
                flipIt(true);
            } else if (p.y == _posY + 1) {
                showFront(true);
                flipIt(false);
            }
        } else if (p.x == _posX) {
            if (p.y == _posY) {
                showFront(true);
                flipIt(false);
            } else if (p.y == _posY - 1) {
                showFront(false);
                flipIt(false);
            } else if (p.y == _posY + 1) {
                showFront(true);
                flipIt(false);
            }
        } else if (p.x == _posX - 1) {
            if (p.y == _posY) {
                showFront(false);
                flipIt(true);
            } else if (p.y == _posY - 1) {
                showFront(false);
                flipIt(false);
            } else if (p.y == _posY + 1) {
                showFront(true);
                flipIt(false);
            }
        } else {
            showFront(true);
            _source.scaleX = 1;
            Cc.error('OrderCat gotoPoint:: wrong front-back logic');
        }
        if (g.managerTutorial.isTutorial) {
            new TweenMax(_source, 6, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
        } else {
            if (catGoAway) new TweenMax(_source, 6, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
            else new TweenMax(_source, 6, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
        }
    }

    public function goNyaToXYPoint(p:Point, time:int, callbackOnWalking:Function):void {
        new TweenMax(_source, time, {x:p.x, y:p.y, ease:Linear.easeNone, onComplete: f2, onCompleteParams:[callbackOnWalking]});
    }

    private function f2(f:Function) :void {
        if (f != null) {
            f.apply(null, [this,_buyerId]);
        }
    }
}
}
