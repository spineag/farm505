/**
 * Created by user on 2/5/16.
 */
package heroes {
import build.TownAreaBuildSprite;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

import temp.catCharacters.DataCat;
import utils.IsoUtils;
import utils.Point3D;

public class OrderCat {
    public static var BLACK:int = 1;
    public static var BLUE:int = 2;
    public static var GREEN:int = 3;
    public static var ORANGE:int = 4;
    public static var PINK:int = 5;
    public static var WHITE:int = 6;
    public static var BROWN:int = 7;

    public static var ALL_CAT_COLORS:int = 7;

    public static var LONG_OUTTILE_WALKING:int=1;
    public static var SHORT_OUTTILE_WALKING:int=2;
    public static var TILE_WALKING:int = 3;
    public static var STAY_IN_QUEUE:int = 4;

    protected var _posX:int;
    protected var _posY:int;
    protected var _depth:Number;
    protected var _source:TownAreaBuildSprite;
//    protected var _typeCat:int;
    protected var _speedWalk:int = 2;
    protected var _speedRun:int = 8;
    private var _catImage:Sprite;
    private var _catBackImage:Sprite;
    private var heroEyes:HeroEyesAnimation;
    private var armature:Armature;
    private var armatureBack:Armature;
    private var _queuePosition:int;
    private var _currentPath:Array;
    public var walkPosition:int;
    public var bant:int;
    private var _arriveCallback:Function;
    private var _catData:Object;

    private var _isWoman:Boolean;
    protected var g:Vars = Vars.getInstance();

    public function OrderCat(ob:Object) {
        _posX = _posY = -1;
//        _typeCat = type;
        _catData = ob;
        _source = new TownAreaBuildSprite();
        _source.isTouchable = false;
        _catImage = new Sprite();
        _catBackImage = new Sprite();
        armature = g.allData.factory['cat_queue'].buildArmature("cat");
        armatureBack = g.allData.factory['cat_queue'].buildArmature("cat_back");
        _catImage.addChild(armature.display as StarlingArmatureDisplay);
        _catBackImage.addChild(armatureBack.display as StarlingArmatureDisplay);
        WorldClock.clock.add(armature);
        WorldClock.clock.add(armatureBack);
        bant = 0;
//        if (_typeCat != BLACK) {
            changeCatTexture();
//        } else {
//            heroEyes = new HeroEyesAnimation(g.allData.factory['cat_queue'], armature, 'heads/head', '_black', false);
//            var b:Bone = armature.getBone('bant');
//            b.visible = false;
//        }
        _source.addChild(_catImage);
        _source.addChild(_catBackImage);
        showFront(true);

        addShadow();
    }

    public function setPositionInQueue(i:int):void {
        _queuePosition = i;
    }

    public function get queuePosition():int {
        return _queuePosition;
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

    public function flipIt(v:Boolean):void {
        v ? _source.scaleX = -1: _source.scaleX = 1;
    }

    public function set arriveCallback(f:Function):void {
        _arriveCallback = f;
    }

    public function checkArriveCallback():void {
        if (_arriveCallback != null) {
            _arriveCallback.apply(null, [this]);
            _arriveCallback = null;
        }
    }

    private function addShadow():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_shadow'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -44*g.scaleFactor;
        im.y = -28*g.scaleFactor;
        im.alpha = .5;
        _source.addChildAt(im, 0);
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

    public function showFront(v:Boolean):void {
        _catImage.visible = v;
        _catBackImage.visible = !v;
        if (heroEyes) {
            if (v) {
                heroEyes.startAnimations();
            } else {
                heroEyes.stopAnimations();
            }
        }
    }

    private function changeCatTexture():void {
        var st:String;
        var st2:String;
        switch (_catData.color) {
            case BLACK:   st = '';   st2 = '_black'; break;
            case BLUE:   st = '_bl'; st2 = '_blue'; break;
            case GREEN:  st = '_gr'; st2 = '_green'; break;
            case BROWN:  st = '_br'; st2 = '_brown'; break;
            case ORANGE: st = '_or'; st2 = '_orange'; break;
            case PINK:   st = '_pk'; st2 = '_pink'; break;
            case WHITE:  st = '_wh'; st2 = '_white';break;
        }

        releaseFrontTexture(st);
        releaseBackTexture(st);
//        heroEyes = new HeroEyesAnimation(g.allData.factory['cat_queue'], armature, 'heads/head' + st, st2, _catData.isWoman);


        if (!_catData.isWoman) {
            var b:Slot = armature.getSlot('bant');
            if (b && b.display) b.display.visible = false;

        } else  changeBant(int(Math.random() * 8 + 1));
        var okuli:Slot = armature.getSlot('okuli');
        var sharf:Slot = armature.getSlot('sharf');
        switch (_catData.type) {
            case DataCat.AKRIL:
                if (okuli && okuli.display) okuli.display.visible = false;
                break;
            case DataCat.ASHUR:
                if (okuli && okuli.display) okuli.display.visible = false;
                if (sharf && sharf.display) sharf.display.visible = false;
                break;
            case DataCat.BULAVKA:
                if (okuli && okuli.display)  okuli.display.visible = false;
                if (sharf && sharf.display) sharf.display.visible = false;
                break;
            case DataCat.BUSINKA:
                if (okuli && okuli.display) okuli.display.visible = false;
                break;
            case DataCat.IGOLOCHKA:
                if (okuli && okuli.display) okuli.display.visible = false;
                if (sharf && sharf.display) sharf.display.visible = false;
                break;
            case DataCat.IRIS:
                if (okuli && okuli.display) okuli.display.visible = false;
                if (sharf && sharf.display) sharf.display.visible = false;
                break;
            case DataCat.KRUCHOK:
                if (okuli && okuli.display) okuli.display.visible = false;
                break;
            case DataCat.LENTOCHKA:
                if (okuli && okuli.display) okuli.display.visible = false;
                if (sharf && sharf.display) sharf.display.visible = false;
                break;
            case DataCat.NAPERSTOK:
                if (okuli && okuli.display) okuli.display.visible = false;
                if (sharf && sharf.display) sharf.display.visible = false;
                break;
            case DataCat.PETELKA:
                if (okuli && okuli.display) okuli.display.visible = false;
                if (sharf && sharf.display) sharf.display.visible = false;
                break;
            case DataCat.PRYAGA:
                if (okuli && okuli.display) okuli.display.visible = false;
                if (sharf && sharf.display) sharf.display.visible = false;
                break;
            case DataCat.SINTETIKA:
                if (okuli && okuli.display) sharf.display.visible = false;
                break;
            case DataCat.STESHOK:
                if (okuli && okuli.display) okuli.display.visible = false;
                if (sharf && sharf.display) sharf.display.visible = false;
                break;
            case DataCat.YZELOK:
                if (okuli && okuli.display) okuli.display.visible = false;
                break;
        }
        var im:Image = g.allData.factory['cat_queue'].getTextureDisplay(_catData.png) as Image;
        if (!im)return;
        var cast:Slot = armature.getSlot('sharf');
        if (cast.display) cast.display.dispose();
        cast.display = im;
    }

    private function changeBant(n:int):void {
        var str:String = 'bant_'+ n;
        bant = n;
        var im:Image = g.allData.factory['cat_queue'].getTextureDisplay(str) as Image;
        var b:Slot = armature.getSlot('bant');
        if (b.display) b.display.dispose();
        b.display = im;
    }

    private function releaseFrontTexture(st:String):void {
        changeTexture("head", "heads/head" + st, armature);
        changeTexture("body", "bodys/body" + st, armature);
        changeTexture("handLeft", "left_hand/handLeft" + st, armature);
        changeTexture("handLeft 2copy", "left_hand/handLeft" + st, armature);
        changeTexture("legLeft", "left_leg/legLeft" + st, armature);
        changeTexture("handRight", "right_hand/handRight" + st, armature);
        changeTexture("legRight", "right_leg/legRight" + st, armature);
        changeTexture("tail", "tails/tail" + st, armature);
    }

    private function releaseBackTexture(st:String):void {
        changeTexture("head", "heads_b/head_b" + st, armatureBack);
        changeTexture("body", "bodys_b/body_b" + st, armatureBack);
        changeTexture("handLeft", "left_hand_b/handLeft_b" + st, armatureBack);
        changeTexture("legLeft", "left_leg_b/legLeft_b" + st, armatureBack);
        changeTexture("handRight", "right_hand_b/handRight_b" + st, armatureBack);
        changeTexture("legRight", "right_leg_b/legRight_b" + st, armatureBack);
        changeTexture("tail", "tails/tail" + st, armatureBack);
    }

    private function changeTexture(oldName:String, newName:String, arma:Armature):void {
        var im:Image = g.allData.factory['cat_queue'].getTextureDisplay(newName) as Image;
        var b:Slot = arma.getSlot(oldName);
        if (b.display) b.display.dispose();
        b.display = im;
    }

    public function setTailPositions(posX:int, posY:int):void {
        _posX = posX;
        _posY = posY;
        var p:Point = new Point(_posX, _posY);
        p = g.matrixGrid.getXYFromIndex(p);
        _source.x = p.x;
        _source.y = p.y;
    }

    public function deleteIt():void {
        g.townArea.removeOrderCatFromCityObjects(this);
        g.townArea.removeOrderCatFromCont(this);
        forceStopAnimation();
        if (heroEyes) {
            heroEyes.stopAnimations();
            heroEyes = null;
        }
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
                    case DataCat.AKRIL:
                        armature.animation.gotoAndPlayByFrame("akril");
                        break;
                    case DataCat.ASHUR:
                        armature.animation.gotoAndPlayByFrame("agur");
                        break;
                    case DataCat.BULAVKA:
                        armature.animation.gotoAndPlayByFrame("bulavka");
                        break;
                    case DataCat.BUSINKA:
                        armature.animation.gotoAndPlayByFrame("businka");
                        break;
                    case DataCat.IGOLOCHKA:
                        armature.animation.gotoAndPlayByFrame("igolochka");
                        break;
                    case DataCat.IRIS:
                        armature.animation.gotoAndPlayByFrame("iris");
                        break;
                    case DataCat.KRUCHOK:
                        armature.animation.gotoAndPlayByFrame("kruchek");
                        break;
                    case DataCat.LENTOCHKA:
                        armature.animation.gotoAndPlayByFrame("lentochka");
                        break;
                    case DataCat.NAPERSTOK:
                        armature.animation.gotoAndPlayByFrame("naperdstok");
                        break;
                    case DataCat.PETELKA:
                        armature.animation.gotoAndPlayByFrame("petelka");
                        break;
                    case DataCat.PRYAGA:
                        armature.animation.gotoAndPlayByFrame("pryaga");
                        break;
                    case DataCat.SINTETIKA:
                        armature.animation.gotoAndPlayByFrame("sintetika");
                        break;
                    case DataCat.STESHOK:
                        armature.animation.gotoAndPlayByFrame("stegok");
                        break;
                    case DataCat.YZELOK:
                        armature.animation.gotoAndPlayByFrame("uzelok");
                        break;
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
        if (armature) armature.animation.stop('idle1');
        if (armatureBack) armatureBack.animation.stop('idle');
        if (armature.hasEventListener(EventObject.COMPLETE)) armature.removeEventListener(EventObject.COMPLETE, onFinishIdle);
        if (armature.hasEventListener(EventObject.LOOP_COMPLETE)) armature.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
        if (armatureBack.hasEventListener(EventObject.COMPLETE)) armatureBack.removeEventListener(EventObject.COMPLETE, onFinishIdleBack);
        if (armatureBack.hasEventListener(EventObject.LOOP_COMPLETE)) armatureBack.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
    }

    public function forceStopAnimation():void {
        stopAnimation();
        TweenMax.killTweensOf(_source);
    }

    public function walkAnimation():void {
        if (heroEyes) heroEyes.startAnimations();
        armature.animation.gotoAndPlayByFrame("walk");
        armatureBack.animation.gotoAndPlayByFrame("walk");
    }

    public function walkPackAnimation():void {
        if (heroEyes) heroEyes.startAnimations();
        armature.animation.gotoAndPlayByFrame("walk_pack");
        armatureBack.animation.gotoAndPlayByFrame("walk_pack");
    }

    public function runAnimation():void {
        if (heroEyes) heroEyes.startAnimations();
        armature.animation.gotoAndPlayByFrame("run");
        armatureBack.animation.gotoAndPlayByFrame("run");
    }

    public function sayHIAnimation(callback:Function):void {
        var onSayHI:Function = function(e:Event=null):void {
            if (armature.hasEventListener(EventObject.COMPLETE)) armature.removeEventListener(EventObject.COMPLETE, onSayHI);
            if (armature.hasEventListener(EventObject.LOOP_COMPLETE)) armature.removeEventListener(EventObject.LOOP_COMPLETE, onSayHI);
            if (callback != null) {
                callback.apply();
            }
        };
        armature.addEventListener(EventObject.COMPLETE, onSayHI);
        armature.addEventListener(EventObject.LOOP_COMPLETE, onSayHI);
        armature.animation.gotoAndPlayByFrame('idle2');
    }




    // --------------- WALKING --------------

    public function goWithPath(arr:Array, callbackOnWalking:Function):void {
        _currentPath = arr;
        if (_currentPath.length) {
            _currentPath.shift(); // first element is that point, where we are now
            gotoPoint(_currentPath.shift(), callbackOnWalking);
        }
    }

    private function gotoPoint(p:Point, callbackOnWalking:Function):void {
        var koef:Number = 1;
        var pXY:Point = g.matrixGrid.getXYFromIndex(p);
        var f1:Function = function(callbackOnWalking:Function):void {
            _posX = p.x;
            _posY = p.y;
            g.townArea.zSort();
            if (_currentPath.length) {
                gotoPoint(_currentPath.shift(), callbackOnWalking);
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
            new TweenMax(_source, koef/_speedWalk, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
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
