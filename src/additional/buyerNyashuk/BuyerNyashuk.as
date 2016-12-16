/**
 * Created by user on 12/2/16.
 */
package additional.buyerNyashuk {
import build.TownAreaBuildSprite;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;

import flash.geom.Rectangle;

import manager.Vars;
import manager.hitArea.ManagerHitArea;
import manager.hitArea.OwnHitArea;

import starling.display.Sprite;
import starling.events.Event;

import utils.CSprite;

import windows.WindowsManager;

public class BuyerNyashuk {

    public static var LONG_OUTTILE_WALKING:int=1;
    public static var SHORT_OUTTILE_WALKING:int=2;
    public static var TILE_WALKING:int = 3;
    public static var STAY_IN_QUEUE:int = 4;

    private var g:Vars = Vars.getInstance();
    private var _armature:Armature;
    private var buyerId:int;
    private var _hitArea:OwnHitArea;
    private var _data:Object;
    private var _build:Sprite;

    protected var _posX:int;
    protected var _posY:int;
    protected var _depth:Number;
    protected var _source:TownAreaBuildSprite;
//    protected var _typeCat:int;
    protected var _speedWalk:int = 2;
    protected var _speedRun:int = 8;
    private var _catImage:Sprite;
    private var _catBackImage:Sprite;
    private var armature:Armature;
    private var armatureBack:Armature;
    private var _queuePosition:int;
    private var _currentPath:Array;
    public var walkPosition:int;
    public var bant:int;
    private var _arriveCallback:Function;
    private var _callbackHi:Function;
    private var _catData:Object;
    private var _rect:Rectangle;


    public function BuyerNyashuk(id:int, ob:Object) {
        buyerId = id;
        _data = ob;
        if (id == 1) {
            if (g.allData.factory['blue_n']) onLoad();
            else g.loadAnimation.load('animations_json/x1/blue_n', 'blue_n', onLoad);

        } else {
            if (g.allData.factory['red_n']) onLoad();
            else g.loadAnimation.load('animations_json/x1/red_n', 'red_n', onLoad);
        }
    }

    private function onLoad():void {
        if (buyerId == 1)  _armature = g.allData.factory['blue_n'].buildArmature("blue_n");
        else _armature = g.allData.factory['red_n'].buildArmature("red_n");
        _source = new TownAreaBuildSprite();
        _build = new Sprite();
        _build.addChild(_armature.display as StarlingArmatureDisplay);
        _source.addChild(_build);
        _source.releaseContDrag = true;
        _source.endClickCallback = onClick;
        WorldClock.clock.add(_armature);
        if (buyerId == 1)   _hitArea = g.managerHitArea.getHitArea(_source, 'blue_n', ManagerHitArea.TYPE_SIMPLE);
        else  _hitArea = g.managerHitArea.getHitArea(_source, 'red_n', ManagerHitArea.TYPE_SIMPLE);
        _source.registerHitArea(_hitArea);

    }

    private function onClick():void {
        g.windowsManager.openWindow(WindowsManager.WO_AMBAR, null, buyerId, _data);
    }

    public function get source():Sprite {
        return _source;
    }

    public function get posX():int {
        return _posX;
    }

    public function get posY():int {
        return _posY;
    }

    public function get rect():Rectangle {
        return _rect;
    }

    public function setPositionInQueue(i:int):void {
        _queuePosition = i;
    }

    public function get queuePosition():int {
        return _queuePosition;
    }

    public function flipIt(v:Boolean):void {
        v ? _source.scaleX = -1: _source.scaleX = 1;
    }

    public function showFront(v:Boolean):void {
        _catImage.visible = v;
        _catBackImage.visible = !v;
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

    public function deleteIt():void {
        g.townArea.removeBuyerNyashukFromCityObjects(this);
        g.townArea.removeBuyerNyashukFromCont(this);
        forceStopAnimation();

        WorldClock.clock.remove(armature);
        WorldClock.clock.remove(armatureBack);
        TweenMax.killTweensOf(_source);
        while (_source.numChildren) _source.removeChildAt(0);
        if (armature) {
            armature.dispose();
            armature = null;
        }
        if (armatureBack) {
            armatureBack.dispose();
            armatureBack = null;
        }
        _catImage = null;
        _catBackImage = null;
        _source.dispose();
        _currentPath = [];
    }

//    public function get typeCat():int {
//        return _catData.color;
//    }
//
//    public function get sexCat():Boolean {
//        return _catData.isWoman;
//    }

    public function get catData():Object {
        return _catData;
    }

    public function showForOptimisation(needShow:Boolean):void {
        if (_source) _source.visible = needShow;
    }


    //  ------------------ ANIMATIONS -----------------------

    private var count:int;
    public function idleFrontAnimation():void {
        var r:int = int(Math.random()*50);
        if (r != 10) {
            armature.addEventListener(EventObject.COMPLETE, onFinishIdle);
            armature.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
        }
        if (r > 10) {
            armature.animation.gotoAndPlayByFrame("breath");
        } else {
            switch (r) {
                case 0: armature.animation.gotoAndPlayByFrame("idle1"); break;
                case 1: armature.animation.gotoAndPlayByFrame("idle2"); break;
                case 2: armature.animation.gotoAndPlayByFrame("idle3"); break;
                case 3: armature.animation.gotoAndPlayByFrame("idle4"); break;
                case 4: armature.animation.gotoAndPlayByFrame("idle5"); break;
                case 5: armature.animation.gotoAndPlayByFrame("idle6"); break;
                case 6: armature.animation.gotoAndPlayByFrame("idle7"); break;
                case 7: armature.animation.gotoAndPlayByFrame("idle8"); break;
                case 8: armature.animation.gotoAndPlayByFrame("idle9"); break;
                case 9: releaseBackIdle(); break;
                case 10:
                    armature.addEventListener(EventObject.COMPLETE, onFinishIdle);
                    armature.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
                    switch (_catData.type) {
//                        case DataCat.AKRIL:
//                            armature.animation.gotoAndPlayByFrame("akril");
//                            break;
//                        case DataCat.ASHUR:
//                            armature.animation.gotoAndPlayByFrame("agur");
//                            break;
//                        case DataCat.BULAVKA:
//                            armature.animation.gotoAndPlayByFrame("bulavka");
//                            break;
//                        case DataCat.BUSINKA:
//                            armature.animation.gotoAndPlayByFrame("businka");
//                            break;
//                        case DataCat.IGOLOCHKA:
//                            armature.animation.gotoAndPlayByFrame("igolochka");
//                            break;
//                        case DataCat.IRIS:
//                            armature.animation.gotoAndPlayByFrame("iris");
//                            break;
//                        case DataCat.KRUCHOK:
//                            armature.animation.gotoAndPlayByFrame("kruchek");
//                            break;
//                        case DataCat.LENTOCHKA:
//                            armature.animation.gotoAndPlayByFrame("lentochka");
//                            break;
//                        case DataCat.NAPERSTOK:
//                            armature.animation.gotoAndPlayByFrame("naperdstok");
//                            break;
//                        case DataCat.PETELKA:
//                            armature.animation.gotoAndPlayByFrame("petelka");
//                            break;
//                        case DataCat.PRYAGA:
//                            armature.animation.gotoAndPlayByFrame("pryaga");
//                            break;
//                        case DataCat.SINTETIKA:
//                            armature.animation.gotoAndPlayByFrame("sintetika");
//                            break;
//                        case DataCat.STESHOK:
//                            armature.animation.gotoAndPlayByFrame("stegok");
//                            break;
//                        case DataCat.YZELOK:
//                            armature.animation.gotoAndPlayByFrame("uzelok");
//                            break;
                    }
                    break;
            }
        }
    }

    private function onFinishIdle(e:Event=null):void {
        armature.removeEventListener(EventObject.COMPLETE, onFinishIdle);
        armature.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
        idleFrontAnimation();
    }

    private function releaseBackIdle():void {
        showFront(false);
        count = 3;
        armatureBack.addEventListener(EventObject.COMPLETE, onFinishIdleBack);
        armatureBack.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
        armatureBack.animation.gotoAndPlayByFrame("idle");
    }

    private function onFinishIdleBack(e:Event=null):void {
        count--;
        armatureBack.removeEventListener(EventObject.COMPLETE, onFinishIdleBack);
        armatureBack.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
        if (count > 0) {
            armatureBack.addEventListener(EventObject.COMPLETE, onFinishIdleBack);
            armatureBack.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
            armatureBack.animation.gotoAndPlayByFrame("idle");
        } else {
            showFront(true);
            idleFrontAnimation();
        }
    }

    public function stopAnimation():void {
        showFront(true);
        if (armature) armature.animation.gotoAndStopByFrame('idle1');
        if (armatureBack) armatureBack.animation.gotoAndStopByFrame('idle');
        if (armature.hasEventListener(EventObject.COMPLETE)) armature.removeEventListener(EventObject.COMPLETE, onFinishIdle);
        if (armature.hasEventListener(EventObject.LOOP_COMPLETE)) armature.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
        if (armatureBack.hasEventListener(EventObject.COMPLETE)) armatureBack.removeEventListener(EventObject.COMPLETE, onFinishIdleBack);
        if (armatureBack.hasEventListener(EventObject.LOOP_COMPLETE)) armatureBack.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
    }

    public function forceStopAnimation():void {
        if (_callbackHi != null) _callbackHi = null;
        stopAnimation();
        TweenMax.killTweensOf(_source);
    }

    public function walkAnimation():void {
        armature.animation.gotoAndPlayByFrame("walk");
        armatureBack.animation.gotoAndPlayByFrame("walk");
    }

    public function walkPackAnimation():void {
        armature.animation.gotoAndPlayByFrame("walk_pack");
        armatureBack.animation.gotoAndPlayByFrame("walk_pack");
    }

    public function runAnimation():void {
        armature.animation.gotoAndPlayByFrame("run");
        armatureBack.animation.gotoAndPlayByFrame("run");
    }

    public function sayHIAnimation(callback:Function):void {
        _callbackHi= callback;
        var onSayHI:Function = function(e:Event=null):void {
            if (armature.hasEventListener(EventObject.COMPLETE)) armature.removeEventListener(EventObject.COMPLETE, onSayHI);
            if (armature.hasEventListener(EventObject.LOOP_COMPLETE)) armature.removeEventListener(EventObject.LOOP_COMPLETE, onSayHI);
            if (_callbackHi != null) {
                _callbackHi.apply();
            }
        };
        armature.addEventListener(EventObject.COMPLETE, onSayHI);
        armature.addEventListener(EventObject.LOOP_COMPLETE, onSayHI);
        armature.animation.gotoAndPlayByFrame('idle2');
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
            new TweenMax(_source, koef/_speedRun, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
        } else {
            if (catGoAway) new TweenMax(_source, koef/_speedWalk, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
            else new TweenMax(_source, koef/_speedRun, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
        }
    }

    public function goCatToXYPoint(p:Point, time:int, callbackOnWalking:Function):void {
        new TweenMax(_source, time, {x:p.x, y:p.y, ease:Linear.easeNone, onComplete: f2, onCompleteParams:[callbackOnWalking]});
    }

    private function f2(f:Function) :void {
        if (f != null) {
            f.apply(null, [this]);
        }
    }
}
}
