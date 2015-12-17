/**
 * Created by user on 9/23/15.
 */
package heroes {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.factories.StarlingFactory;

import flash.events.Event;
import manager.EmbedAssets;
import mouse.ToolsModifier;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.CSprite;

public class HeroCat extends BasicCat{
    private var _catImage:Sprite;
    private var _catBackImage:Sprite;
    private var _isFree:Boolean;
    private var _type:int;
    private var factory:StarlingFactory;
    private var armature:Armature;
    private var armatureBack:Armature;
    private var armatureClip:Sprite;
    private var armatureClipBack:Sprite;
    private var heroEyes:HeroEyesAnimation;

    public function HeroCat(type:int) {
        super();

        _type = type;
        _isFree = true;
        _source = new CSprite();
        _catImage = new Sprite();
        _catBackImage = new Sprite();
        factory = new StarlingFactory();
        _isLoaded = false;
        var f1:Function = function (e:Event):void {
            armature = factory.buildArmature("cat");
            armatureBack = factory.buildArmature("cat_back");
            armatureClip = armature.display as Sprite;
            armatureClipBack = armatureBack.display as Sprite;
            _catImage.addChild(armatureClip);
            _catBackImage.addChild(armatureClipBack);
            WorldClock.clock.add(armature);
            WorldClock.clock.add(armatureBack);
            if (_type == WOMAN) {
                releaseWoman();
            }
            heroEyes = new HeroEyesAnimation(factory, armature, _type == WOMAN);
            showFront(true);
            _isLoaded = true;
            makeFreeCatIdle();
            if (_loadedCallback != null) {
                _loadedCallback.apply();
                _loadedCallback = null;
            }
        };
        factory.addEventListener(Event.COMPLETE, f1);
        factory.parseData(new EmbedAssets.CatData());

        if (!_catImage || !_catBackImage) {
            Cc.error('HeroCat no such image: for type: ' + type);
            g.woGameError.showIt();
            return;
        }
        _catImage.x = -_catImage.width/2;
        _catImage.y = -_catImage.height + 2;
        _source.addChild(_catImage);
        _catBackImage.x = -_catBackImage.width/2;
        _catBackImage.y = -_catBackImage.height + 2;
        _source.addChild(_catBackImage);
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
        v ? _source.scaleX = -1*_scaleDefault : _source.scaleX = 1*_scaleDefault;
    }

    public function get isFree():Boolean {
        return _isFree;
    }

    public function set isFree(value:Boolean):void {
        _isFree = value;
        g.catPanel.checkCat();
        if (_isFree) {
            makeFreeCatIdle();
        }
    }

    private var countWorkPlant:int;
    public function workWithPlant(f:Function):void {
        var s:Number = _source.scaleX;
        countWorkPlant = 10;
        var f1:Function = function():void {
            new TweenMax(_catImage, .5, {scaleX:0.97*s, scaleY:1.03*s, ease:Linear.easeOut ,onComplete: f2});
        };
        var f2:Function = function():void {
            countWorkPlant--;
            if (countWorkPlant <= 0) {
                _catImage.scaleX = _catImage.scaleY = s;
                if (f != null) {
                    f.apply(null, [this]);
                }
                return;
            }
            new TweenMax(_catImage, .5, {scaleX:1.03*s, scaleY:0.97*s, ease:Linear.easeIn ,onComplete: f1});
        };
        f2();
    }

    override public function walkAnimation():void {
        if (isLoaded) {
            heroEyes.startAnimations();
            armature.animation.gotoAndPlay("walk");
            armatureBack.animation.gotoAndPlay("walk");
            super.walkAnimation();
        }
    }
    override public function runAnimation():void {
        if (isLoaded) {
            heroEyes.startAnimations();
            armature.animation.gotoAndPlay("run");
            armatureBack.animation.gotoAndPlay("run");
            super.runAnimation();
        }
    }
    override public function stopAnimation():void {
        if (isLoaded) {
            heroEyes.stopAnimations();
            armature.animation.gotoAndStop("idle", 0);
            armatureBack.animation.gotoAndStop("idle", 0);
            super.stopAnimation();
        }
    }
    override public function idleAnimation():void {
        if (isLoaded) {
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
    }

    private function releaseWoman():void {
        changeTexture("head", "heads/head_w");
        changeTexture("head", "heads_b/head_w_b", false);
        changeTexture("body", "bodys/body_w");
        changeTexture("body", "bodys_b/body_w_b", false);
        changeTexture("handLeft", "left_hand/handLeft_w");
        changeTexture("handLeft", "left_hand_b/handLeft_w_b", false);
        changeTexture("legLeft", "left_leg/legLeft_w");
        changeTexture("legLeft", "left_leg_b/legLeft_w_b", false);
        changeTexture("handRight", "right_hand/handRight_w");
        changeTexture("handRight", "right_hand_n/handRight_w_b", false);
        changeTexture("legRight", "right_leg/legRight_w");
        changeTexture("legRight", "right_leg_b/legRight_w_b", false);
        changeTexture("tail", "tails/tail_w");
        changeTexture("tail11", "tails/tail_w", false);
    }

    private function changeTexture(oldName:String, newName:String, isFront:Boolean = true):void {
        var im:Image = factory.getTextureDisplay(newName) as Image;
        var b:Bone;
        if (isFront) {
            b = armature.getBone(oldName);
        } else {
            b = armatureBack.getBone(oldName);
        }
        b.display.dispose();
        b.display = im;
    }

    private var timer:int;
    private function makeFreeCatIdle():void {
        if (isLoaded) {
            if (Math.random() > .5) {
                g.managerCats.goIdleCatToPoint(this, g.managerCats.getRandomFreeCell(), makeFreeCatIdle);
            } else {
                idleAnimation();
                timer = 3 + int(Math.random()) * 7;
                g.gameDispatcher.addToTimer(renderForIdleFreeCat);
                renderForIdleFreeCat();
            }
        }
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
        timer = 0;
        g.gameDispatcher.removeFromTimer(renderForIdleFreeCat);
    }

    public function killAllAnimations():void {
        stopAnimation();
        _currentPath = [];
        TweenMax.killTweensOf(_source);
    }

}
}
