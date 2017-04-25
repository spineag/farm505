/**
 * Created by user on 9/23/15.
 */
package heroes {

import build.TownAreaBuildSprite;
import build.decor.DecorAnimation;
import build.farm.Farm;
import build.ridge.Ridge;
import com.greensock.TweenMax;

import data.BuildType;

import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.Slot;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;

import starling.display.Image;
import starling.display.Sprite;

import utils.CSprite;
import utils.Utils;

public class HeroCat extends BasicCat{
    private var _catImage:Sprite;
    private var _catWateringAndFeed:Sprite;
    private var _catBackImage:Sprite;
    private var _isFree:Boolean;
    private var _isFreeDecor:Boolean;
    private var _type:int;
    private var heroEyes:HeroEyesAnimation;
    private var _decorAnimation:DecorAnimation;
    private var freeIdleGo:Boolean;
    public var isLeftForFeedAndWatering:Boolean; // choose the side of ridge for watering
    public var curActiveRidge:Ridge; //  for watering ridge
    public var curActiveFarm:Farm;  // for feed animal at farm
    private var _animation:HeroCatsAnimation;

    public function HeroCat(type:int) {
        super();

        _type = type;
        _isFree = true;
        _isFreeDecor = true;
        _source = new TownAreaBuildSprite();
        _source.touchable = false;
        _catImage = new Sprite();
        _catWateringAndFeed = new Sprite();
        _catBackImage = new Sprite();
        freeIdleGo = true;

        _animation = new HeroCatsAnimation();
        _animation.catArmature = g.allData.factory['cat_main'].buildArmature("cat");
        _animation.catBackArmature = g.allData.factory['cat_main'].buildArmature("cat_back");
        _catImage.addChild(_animation.catArmature.display as StarlingArmatureDisplay);
        _catBackImage.addChild(_animation.catBackArmature.display as StarlingArmatureDisplay);

        if (_type == WOMAN) {
            releaseFrontWoman(_animation.catArmature);
            releaseBackWoman(_animation.catBackArmature);
        }
        var st2:String = '';
        if (_type == WOMAN) st2 = '_w';
        heroEyes = new HeroEyesAnimation(g.allData.factory['cat_main'], _animation.catArmature, 'head' + st2, st2, _type == WOMAN);
        _source.addChild(_catImage);
        _source.addChild(_catWateringAndFeed);
        _source.addChild(_catBackImage);
        _animation.catImage = _catImage;
        _animation.catBackImage = _catBackImage;
        _animation.catWorkerImage = _catWateringAndFeed;
        showFront(true);
        addShadow();
    }

    public function get typeMan():int {
        return _type;
    }

    private function addShadow():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_shadow'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -44*g.scaleFactor;
        im.y = -28*g.scaleFactor;
        im.alpha = .5;
        _source.addChildAt(im, 0);
    }

    override public function showFront(v:Boolean):void {
        _animation.showFront(v);
        if (heroEyes) {
            if (v) heroEyes.startAnimations();
            else heroEyes.stopAnimations();
        }
    }

    override public function set visible(value:Boolean):void {
        if (!value)  _animation.stopIt();
        super.visible = value;
    }

    public function pauseIt(v:Boolean):void {
        if (v) {
            if (_currentPath && _currentPath.length) {
                setPosition(_currentPath.pop());
                updatePosition();
            }
            killAllAnimations();
            _callbackOnWalking = null;
        } else {
            if (_isFree) makeFreeCatIdle();
        }
    }
    
    override public function flipIt(v:Boolean):void {
        _animation.flipIt(v);
    }

    public function get isFree():Boolean {
        return _isFree;
    }

    public function get isFreeDecor():Boolean {
        return _isFreeDecor;
    }

    public function get decorAnimation():DecorAnimation {
        return _decorAnimation;
    }

    public function set isFree(value:Boolean):void {
        _isFree = value;
        g.catPanel.checkCat();

        if (_isFree) makeFreeCatIdle();
        else {
            if (!_isFreeDecor) {
                _decorAnimation.forceStopDecorAnimation();
            } else stopFreeCatIdle();
             stopFreeCatIdle();
        }
    }

    public function set isFreeDecor(value:Boolean):void {
        _isFreeDecor = value;
//        g.catPanel.checkCat();
        if (_isFree) makeFreeCatIdle();
            else stopFreeCatIdle();
    }

    public function set decorAnimation(decorAnimation:DecorAnimation):void {
        _decorAnimation = decorAnimation;
    //       g.catPanel.checkCat();
//        if (_isFree) makeFreeCatIdle();
//            else stopFreeCatIdle();
    }

    override public function walkAnimation():void {
        if (heroEyes) heroEyes.startAnimations();
        _animation.playIt('walk');
        super.walkAnimation();
    }
    override public function walkIdleAnimation():void {
        if (heroEyes) heroEyes.startAnimations();
        _animation.playIt('walk');
        super.walkIdleAnimation();
    }
    override public function runAnimation():void {
        if (heroEyes) heroEyes.startAnimations();
        _animation.playIt('run');
        super.runAnimation();
    }
    override public function stopAnimation():void {
        if (heroEyes) heroEyes.stopAnimations();
        _animation.stopIt();
        super.stopAnimation();
    }
    override public function idleAnimation():void {
        if (Math.random() > .2) {
            showFront(true);
        } else {
            showFront(false);
        }
        if (heroEyes) heroEyes.startAnimations();
        _animation.playIt('idle');
        super.idleAnimation();
    }

//    public function get armatureCatFront():Armature {  return armature; }
//    public function get armatureCatBack():Armature {  return armatureBack; }

    private function releaseFrontWoman(arma:Armature):void {
        changeTexture("head", "head_w", arma);
        changeTexture("body", "body_w", arma);
        changeTexture("handLeft", "hand_w_l", arma);
        changeTexture("legLeft", "leg_w_l", arma);
        changeTexture("handRight", "hand_w_r", arma);
        changeTexture("legRight", "leg_w_r", arma);
        changeTexture("tail", "tail_w", arma);
        changeTexture("handRight copy", "hand_w_r", arma);
    }

    private function releaseBackWoman(arma:Armature):void {
        changeTexture("head", "head_w_b", arma);
        changeTexture("body", "body_w_b", arma);
        changeTexture("handLeft", "hand_w_l_b", arma);
        changeTexture("legLeft", "leg_w_l_b", arma);
        changeTexture("handRight", "hand_w_r_b", arma);
        changeTexture("legRight", "leg_w_r_b", arma);
        changeTexture("tail11", "tail_w", arma);
    }

    private function changeTexture(oldName:String, newName:String, arma:Armature):void {
//        var im:Image = g.allData.factory['cat_main'].getTextureDisplay('clothTextureTemp', newName) as Image;
        var im:Image = new Image(g.allData.atlas['customisationAtlas'].getTexture(newName));
        var b:Slot = arma.getSlot(oldName);
        if (b && im) {
            b.displayList = null;
            b.display = im;
        }
    }

// play Direct label
    public function playDirectLabel(label:String, playOnce:Boolean, callback:Function):void {
        showFront(true);
        if (heroEyes) heroEyes.startAnimations();
        _animation.playIt(label, playOnce, callback);
    }

// SIMPLE IDLE
    private var timer:int;
    public function makeFreeCatIdle():void {
        freeIdleGo = !freeIdleGo;
        if (freeIdleGo) {
            g.managerCats.goIdleCatToPoint(this, g.townArea.getRandomFreeCell(), makeFreeCatIdle);
        } else {
            var b:Boolean = false;
            var r:Number = Math.random();

            if (r <= .02) {
                if (g.townArea.getCityObjectsByType(BuildType.DECOR_ANIMATION)) {
                    var arr:Array = g.townArea.getCityObjectsByType((BuildType.DECOR_ANIMATION));
                    if (arr.length > 0) {
                        for (var i:int = 0; i < arr.length; i++) {
                            if (!arr[i].catNeed && !arr[i].decorWork && !arr[i].catRun) {
                                arr[i].forceStartDecorAnimation(this);
                                b = true;
                                break;
                            }
                        }
                    }
                }
            }
            if (!b) {
                idleAnimation();
                timer = 5 + int(Math.random() * 15);
                g.gameDispatcher.addToTimer(renderForIdleFreeCat);
                renderForIdleFreeCat();
            }
        }
    }
    
    public function get isIdleGoNow():Boolean {
        return !freeIdleGo;
    }

    private function renderForIdleFreeCat():void {
        timer--;
        if (timer <= 0) {
            stopAnimation();
            g.gameDispatcher.removeFromTimer(renderForIdleFreeCat);
            makeFreeCatIdle();
        }
    }

    public function stopFreeCatIdle():void {
        killAllAnimations();
    }

    public function killAllAnimations():void {
        stopAnimation();
        _currentPath = [];
        TweenMax.killTweensOf(_source);
        timer = 0;
        g.gameDispatcher.removeFromTimer(renderForIdleFreeCat);
    }

// WORK WITH PLANT
    public function  workWithPlant(callback:Function):void {
        _animation.deleteWorker();
        _animation.catWorkerArmature = g.allData.factory['cat_watering_can'].buildArmature("cat");
        var viyi:Slot = _animation.catWorkerArmature.getSlot('viyi');
        if (_type == WOMAN) {
            releaseFrontWoman(_animation.catWorkerArmature);
            if (viyi && viyi.display) viyi.display.visible = true;
        } else {
            if (viyi && viyi.display) viyi.display.visible = false;
        }
        flipIt(isLeftForFeedAndWatering);
        _animation.playIt('open', true, makeWatering, callback);
    }

    private function makeWatering(callback:Function):void {
        _animation.playIt('work', true, makeWateringIdle, callback);
    }

    private function makeWateringIdle(callback:Function):void {
        var fClose:Function = function():void {
            forceStopWork();
            if (callback != null) {
                callback.apply();
            }
        };
        var k:Number = Math.random();
        if (freeIdleGo) {
            _animation.playIt('close', true, fClose);
        } else {
            if (k < .4) {
                _animation.playIt('close', true, fClose);
            } else {
                if (k < .6) {
                    _animation.playIt("work", true, makeWateringIdle, callback);
                } else if (k < .8) {
                    _animation.playIt("idle", true, makeWateringIdle, callback);
                } else {
                    _animation.playIt("look", true, makeWateringIdle, callback);
                }
            }
        }
    }

    public function forceStopWork():void { /// !!!
        additionalRemoveWorker();
    }

    public function additionalRemoveWorker():void {  /// !!!
       _animation.deleteWorker();
        killAllAnimations();
        showFront(true);
        _catImage.visible = true;
        makeFreeCatIdle();
    }

// WORK WITH FARM
    public function workWithFarm(callback:Function):void {
        _animation.deleteWorker();
        _animation.catWorkerArmature = g.allData.factory['cat_feed'].buildArmature("cat");
        var viyi:Slot = _animation.catWorkerArmature.getSlot('viyi');
        if (_type == WOMAN) {
            releaseFrontWoman(_animation.catWorkerArmature);
            if (viyi && viyi.displayList.length) viyi.displayList[0].visible = true;
        } else {
            if (viyi && viyi.displayList.length) viyi.displayList[0].visible = false;
        }
        flipIt(isLeftForFeedAndWatering);

        makeFeeding(callback);
    }

    private function makeFeeding(callback:Function):void {
        _animation.playIt('work', true, makeFeedingPart1, callback);
    }

    private function makeFeedingPart1(callback:Function):void {
        makeFeedingParticles();
        _animation.playIt('work1', true, makeFeedingPart2, callback);
    }

    private function makeFeedingPart2(callback:Function):void {
        makeFeedingParticles();
        _animation.playIt('work2', true, makeFeedingPart3, callback);
    }

    private function makeFeedingPart3(callback:Function):void {
        makeFeedingParticles();
        _animation.playIt('work3', true, onFinishFeeding, callback);
    }

    private function onFinishFeeding(callback:Function):void {
        makeFeedIdle(callback);
    }

    private function makeFeedIdle(callback:Function):void {
        var k:Number = Math.random();
        if (k < .35) {
            forceStopWork();
            if (callback != null) {
                callback.apply();
            }
        } else if (k < .45) {
            makeFeeding(callback);
        } else if (k < .7) {
            _animation.playIt('hello', true, makeFeedIdle, callback);
        } else if (k < .85) {
            _animation.playIt('idle', true, makeFeedIdle, callback);
        } else {
            _animation.playIt('idle2', true, makeFeedIdle, callback);
        }
    }

    private function makeFeedingParticles():void {
        var p:Point = new Point();
        p.x = -11;
        p.y = -92;
        p = (_animation.catArmature.display as Sprite).localToGlobal(p);
        curActiveFarm.showParticles(p, isLeftForFeedAndWatering);
    }

// DELETE
    override public function deleteIt():void {
        killAllAnimations();
        removeFromMap();
        if (heroEyes) {
            heroEyes.stopAnimations();
            heroEyes = null;
        }
        _animation.deleteWorker();
        _catImage.removeChild(_animation.catArmature.display as Sprite);
        _catBackImage.removeChild(_animation.catBackArmature.display as Sprite);
        _animation.deleteArmature(_animation.catArmature);
        _animation.deleteArmature(_animation.catBackArmature);
        _animation.clearIt();
        super.deleteIt();
        _catImage = null;
        _catWateringAndFeed = null;
        _catBackImage = null;
    }


// SHOW FAIL CAT
    public function showFailCat(callback:Function):void {
        killAllAnimations();
        _animation.deleteWorker();
        _animation.playIt('fail', true, callback);
    }

// SIMPLE IDLE
    public function showSimpleIdle():void {
       _animation.playIt('idle');
    }

// JUMP CAT
    public function jumpCat(hello:Boolean = false):void {
        var f2:Function = function ():void {
            makeFreeCatIdle();
        };
        var f1:Function = function ():void {
            if (!hello) showFront(true);
            if (!hello) killAllAnimations();
            _animation.playIt('jump_funny',true,f2);
        };
        if (hello) f1();
        else Utils.createDelay(int(Math.random() * 2) + 2,f1);
    }

    // JUMP CAT
    public function helloCat():void {
        var f2:Function = function ():void {
            jumpCat(true);
        };
        var f1:Function = function ():void {
            showFront(true);
            killAllAnimations();
            _animation.playIt('hi_3',true,f2);
        };
        Utils.createDelay(int(Math.random() * 2) + 2,f1);
    }

}
}
