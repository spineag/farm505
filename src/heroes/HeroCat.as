/**
 * Created by user on 9/23/15.
 */
package heroes {

import build.farm.Farm;
import build.ridge.Ridge;

import com.greensock.TweenMax;
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;

import starling.display.Image;
import starling.display.Sprite;

import utils.CSprite;

public class HeroCat extends BasicCat{
    private var _catImage:Sprite;
    private var _catWateringAndFeed:Sprite;
    private var _catBackImage:Sprite;
    private var _isFree:Boolean;
    private var _type:int;
    private var armature:Armature;
    private var armatureBack:Armature;
    private var armatureWorker:Armature; // for watering and feeding
    private var heroEyes:HeroEyesAnimation;
    private var freeIdleGo:Boolean;
    public var isLeftForFeedAndWatering:Boolean; // choose the side of ridge for watering
    public var curActiveRidge:Ridge; //  for watering ridge
    public var curActiveFarm:Farm;  // for feed animal at farm

    public function HeroCat(type:int) {
        super();

        _type = type;
        _isFree = true;
        _source = new CSprite();
        _catImage = new Sprite();
        _catWateringAndFeed = new Sprite();
        _catBackImage = new Sprite();
        freeIdleGo = true;
        armature = g.allData.factory['cat'].buildArmature("cat");
        armatureBack = g.allData.factory['cat'].buildArmature("cat_back");
        _catImage.addChild(armature.display as Sprite);
        _catBackImage.addChild(armatureBack.display as Sprite);
        WorldClock.clock.add(armature);
        WorldClock.clock.add(armatureBack);

        if (_type == WOMAN) {
            releaseFrontWoman('cat', armature);
            releaseBackWoman('cat', armatureBack);
        }
        heroEyes = new HeroEyesAnimation(g.allData.factory['cat'], armature, _type == WOMAN);
        _source.addChild(_catImage);
        _source.addChild(_catWateringAndFeed);
        _source.addChild(_catBackImage);
        showFront(true);
    }

    override public function showFront(v:Boolean):void {
        _catImage.visible = v;
        _catBackImage.visible = !v;
        if (v) {
            heroEyes.startAnimations();
        } else {
            heroEyes.stopAnimations();
        }
    }

    override public function set visible(value:Boolean):void {
        if (!value) {
            stopAnimation();
        } else {
//            idleAnimation();  - already has this after going away from fabrica via run or walk
        }
        super.visible = value;
    }

    override public function flipIt(v:Boolean):void {
        v ? _source.scaleX = -1: _source.scaleX = 1;
    }

    public function get isFree():Boolean {
        return _isFree;
    }

    public function set isFree(value:Boolean):void {
        _isFree = value;
        g.catPanel.checkCat();
        if (_isFree) {
            makeFreeCatIdle();
        } else {
            stopFreeCatIdle();
        }
    }

    override public function walkAnimation():void {
            heroEyes.startAnimations();
            armature.animation.gotoAndPlay("walk");
            armatureBack.animation.gotoAndPlay("walk");
            super.walkAnimation();
    }
    override public function runAnimation():void {
            heroEyes.startAnimations();
            armature.animation.gotoAndPlay("run");
            armatureBack.animation.gotoAndPlay("run");
            super.runAnimation();
    }
    override public function stopAnimation():void {
            heroEyes.stopAnimations();
            armature.animation.gotoAndStop("idle", 0);
            armatureBack.animation.gotoAndStop("idle", 0);
            super.stopAnimation();
    }
    override public function idleAnimation():void {
        if (armatureWorker) return;
        if (Math.random() > .2) {
            showFront(true);
        } else {
            showFront(false);
        }
        heroEyes.startAnimations();
        armature.animation.gotoAndPlay("idle");
        armatureBack.animation.gotoAndPlay("idle");
        super.idleAnimation();
    }

    private function releaseFrontWoman(factory:String, arma:Armature):void {
        changeTexture(factory, "head", "heads/head_w", arma);
        changeTexture(factory, "body", "bodys/body_w", arma);
        changeTexture(factory, "handLeft", "left_hand/handLeft_w", arma);
        changeTexture(factory, "legLeft", "left_leg/legLeft_w", arma);
        changeTexture(factory, "handRight", "right_hand/handRight_w", arma);
        changeTexture(factory, "legRight", "right_leg/legRight_w", arma);
        changeTexture(factory, "tail", "tails/tail_w", arma);
    }

    private function releaseBackWoman(factory:String, arma:Armature):void {
        changeTexture(factory, "head", "heads_b/head_w_b", arma);
        changeTexture(factory, "body", "bodys_b/body_w_b", arma);
        changeTexture(factory, "handLeft", "left_hand_b/handLeft_w_b", arma);
        changeTexture(factory, "legLeft", "left_leg_b/legLeft_w_b", arma);
        changeTexture(factory, "handRight", "right_hand_b/handRight_w_b", arma);
        changeTexture(factory, "legRight", "right_leg_b/legRight_w_b", arma);
        changeTexture(factory, "tail11", "tails/tail_w", arma);
    }

    private function changeTexture(factory:String, oldName:String, newName:String, arma:Armature):void {
        var im:Image = g.allData.factory[factory].getTextureDisplay(newName) as Image;
        var b:Bone = arma.getBone(oldName);
        b.display.dispose();
        b.display = im;
    }

// SIMPLE IDLE
    private var timer:int;
    public function makeFreeCatIdle():void {
            if (freeIdleGo) {
                g.managerCats.goIdleCatToPoint(this, g.managerCats.getRandomFreeCell(), makeFreeCatIdle);
            } else {
                idleAnimation();
                timer = 5 + int(Math.random()*15);
                g.gameDispatcher.addToTimer(renderForIdleFreeCat);
                renderForIdleFreeCat();
            }
            freeIdleGo = !freeIdleGo;
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
    public function workWithPlant(callback:Function):void {
        if (!armatureWorker) {
            armatureWorker = g.allData.factory['cat_watering'].buildArmature("cat");
            WorldClock.clock.add(armatureWorker);
            if (_type == WOMAN) {
                releaseFrontWoman('cat', armatureWorker);
            }
        }
        _catWateringAndFeed.addChild(armatureWorker.display as Sprite);
        _catImage.visible = false;
        _catBackImage.visible = false;
        if (isLeftForFeedAndWatering) flipIt(true);

        var f:Function = function(e:AnimationEvent):void {
            armatureWorker.removeEventListener(AnimationEvent.COMPLETE, f);
            armatureWorker.removeEventListener(AnimationEvent.LOOP_COMPLETE, f);
            makeWatering(callback);
        };
        armatureWorker.addEventListener(AnimationEvent.COMPLETE, f);
        armatureWorker.addEventListener(AnimationEvent.LOOP_COMPLETE, f);
        armatureWorker.animation.gotoAndPlay("open");
    }

    private function makeWatering(callback:Function):void {
        var f:Function = function(e:AnimationEvent):void {
            armatureWorker.removeEventListener(AnimationEvent.COMPLETE, f);
            armatureWorker.removeEventListener(AnimationEvent.LOOP_COMPLETE, f);
            makeWateringIdle(callback);
        };
        armatureWorker.addEventListener(AnimationEvent.COMPLETE, f);
        armatureWorker.addEventListener(AnimationEvent.LOOP_COMPLETE, f);
        armatureWorker.animation.gotoAndPlay("work");
    }

    private function makeWateringIdle(callback:Function):void {
        var f:Function = function(e:AnimationEvent):void {
            armatureWorker.removeEventListener(AnimationEvent.COMPLETE, f);
            armatureWorker.removeEventListener(AnimationEvent.LOOP_COMPLETE, f);
            makeWateringIdle(callback);
        };
        var fClose:Function = function(e:AnimationEvent):void {
            armatureWorker.removeEventListener(AnimationEvent.COMPLETE, fClose);
            armatureWorker.removeEventListener(AnimationEvent.LOOP_COMPLETE, fClose);
            forceStopWork();
            if (callback != null) {
                callback.apply();
            }
        };
        var k:Number = Math.random();
        if (k < .4) {
            armatureWorker.addEventListener(AnimationEvent.COMPLETE, fClose);
            armatureWorker.addEventListener(AnimationEvent.LOOP_COMPLETE, fClose);
            armatureWorker.animation.gotoAndPlay("close");
        } else {
            armatureWorker.addEventListener(AnimationEvent.COMPLETE, f);
            armatureWorker.addEventListener(AnimationEvent.LOOP_COMPLETE, f);
            if (k < .6) {
                armatureWorker.animation.gotoAndPlay("work");
            } else if (k < .8) {
                armatureWorker.animation.gotoAndPlay("idle");
            } else {
                armatureWorker.animation.gotoAndPlay("look");
            }
        }
    }

    public function forceStopWork():void {
        WorldClock.clock.remove(armatureWorker);
        while (_catWateringAndFeed.numChildren) _catWateringAndFeed.removeChildAt(0);
        armatureWorker.dispose();
        armatureWorker = null;
        showFront(true);
    }

// WORK WITH FARM
    public function workWithFarm(callback:Function):void {
        if (!armatureWorker) {
            armatureWorker = g.allData.factory['cat_feed'].buildArmature("cat");
            WorldClock.clock.add(armatureWorker);
            if (_type == WOMAN) {
                releaseFrontWoman('cat', armatureWorker);
            }
        }
        _catWateringAndFeed.addChild(armatureWorker.display as Sprite);
        _catImage.visible = false;
        _catBackImage.visible = false;
        if (isLeftForFeedAndWatering) flipIt(true);

        makeFeeding(callback);
    }

    private function makeFeeding(callback:Function):void {
        var f:Function = function():void {
            armatureWorker.removeEventListener(AnimationEvent.COMPLETE, f);
            armatureWorker.removeEventListener(AnimationEvent.LOOP_COMPLETE, f);
            armatureWorker.addEventListener(AnimationEvent.COMPLETE, f1);
            armatureWorker.addEventListener(AnimationEvent.LOOP_COMPLETE, f1);
            makeFeedingParticles();
            armatureWorker.animation.gotoAndPlay("work1");
        };
        var f1:Function = function():void {
            armatureWorker.removeEventListener(AnimationEvent.COMPLETE, f1);
            armatureWorker.removeEventListener(AnimationEvent.LOOP_COMPLETE, f1);
            armatureWorker.addEventListener(AnimationEvent.COMPLETE, f2);
            armatureWorker.addEventListener(AnimationEvent.LOOP_COMPLETE, f2);
            makeFeedingParticles();
            armatureWorker.animation.gotoAndPlay("work2");
        };
        var f2:Function = function():void {
            armatureWorker.removeEventListener(AnimationEvent.COMPLETE, f2);
            armatureWorker.removeEventListener(AnimationEvent.LOOP_COMPLETE, f2);
            armatureWorker.addEventListener(AnimationEvent.COMPLETE, onFinishFeeding);
            armatureWorker.addEventListener(AnimationEvent.LOOP_COMPLETE, onFinishFeeding);
            makeFeedingParticles();
            armatureWorker.animation.gotoAndPlay("work3");
        };
        var onFinishFeeding:Function = function():void {
            armatureWorker.removeEventListener(AnimationEvent.COMPLETE, onFinishFeeding);
            armatureWorker.removeEventListener(AnimationEvent.LOOP_COMPLETE, onFinishFeeding);
            makeFeedIdle(callback);
        };
        armatureWorker.addEventListener(AnimationEvent.COMPLETE, f);
        armatureWorker.addEventListener(AnimationEvent.LOOP_COMPLETE, f);
        armatureWorker.animation.gotoAndPlay("work");
    }

    private function makeFeedIdle(callback:Function):void {
        var k:Number = Math.random();
        if (k < .4) {
            forceStopWork();
            if (callback != null) {
                callback.apply();
            }
        } else if (k < .5) {
            makeFeeding(callback);
        } else if (k < .75) {
            var fHello:Function = function():void {
                armatureWorker.removeEventListener(AnimationEvent.COMPLETE, fHello);
                armatureWorker.removeEventListener(AnimationEvent.LOOP_COMPLETE, fHello);
                makeFeedIdle(callback);
            };
            armatureWorker.addEventListener(AnimationEvent.COMPLETE, fHello);
            armatureWorker.addEventListener(AnimationEvent.LOOP_COMPLETE, fHello);
            armatureWorker.animation.gotoAndPlay("hello");
        } else {
            var fIdle:Function = function():void {
                armatureWorker.removeEventListener(AnimationEvent.COMPLETE, fIdle);
                armatureWorker.removeEventListener(AnimationEvent.LOOP_COMPLETE, fIdle);
                makeFeedIdle(callback);
            };
            armatureWorker.addEventListener(AnimationEvent.COMPLETE, fIdle);
            armatureWorker.addEventListener(AnimationEvent.LOOP_COMPLETE, fIdle);
            armatureWorker.animation.gotoAndPlay("idle");
        }
    }

    private function makeFeedingParticles():void {

    }

}
}
