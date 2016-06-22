/**
 * Created by user on 6/15/16.
 */
package tutorial.pretuts {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import manager.Vars;
import starling.display.Quad;
import starling.display.Sprite;

public class TutorialMult {
    private var _isLoad:Boolean;
    private var _needStart:Boolean;
    private var _startCallback:Function;
    private var _endCallback:Function;
    private var _armature:Armature;
    private var _tempBG:Quad;
    private var _tempSprite:Sprite;
    private var _tempBlack:Sprite;
    private var _arrCats:Array;
    private var _catsSprite:Sprite;
    private var _bone:Bone;
    private var _boneCats:Bone;
    private var _boneBlack:Bone;
    private var g:Vars = Vars.getInstance();

    public function TutorialMult() {
        _isLoad = false;
        _needStart = false;
        g.loadAnimation.load('animations/tuts/box_mult_m/', 'tutorial_mult', onLoad);
    }

    private function onLoad():void {
        _isLoad = true;
        if (_needStart) startMult();
    }

    public function showMult(fStart:Function, fEnd:Function):void {
        _needStart = true;
        _startCallback = fStart;
        _endCallback = fEnd;
        if (_isLoad) startMult();
    }

    private function startMult():void {
        _armature = g.allData.factory['tutorial_mult'].buildArmature('mult');
        (_armature.display as Sprite).x = g.stageWidth/2;
        (_armature.display as Sprite).y = g.stageHeight/2;
        g.cont.popupCont.addChild(_armature.display as Sprite);
        if (_startCallback != null) {
            _startCallback.apply();
        }
        WorldClock.clock.add(_armature);
        _armature.addEventListener(AnimationEvent.COMPLETE, onIdle1);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onIdle1);
        _bone = _armature.getBone('blue');
        _tempSprite = new Sprite();
        _tempBG = new Quad(g.stageWidth, g.stageHeight);
        _tempBG.setVertexColor(0, 0x7FAFB3);
        _tempBG.setVertexColor(1, 0x7FAFB3);
        _tempBG.setVertexColor(2, 0xA4C6C8);
        _tempBG.setVertexColor(3, 0xA4C6C8);
        _tempBG.x = -g.stageWidth/2;
        _tempBG.y = -g.stageHeight/2;
        _tempSprite.addChild(_tempBG);
        _bone.display = _tempSprite;
        _armature.animation.gotoAndPlay('idle');
        createCatSprite();
        _boneBlack = _armature.getBone('black');
        _tempBlack = new Sprite();
        _boneBlack.display = _tempBlack;
    }

    private function onIdle1(e:AnimationEvent):void {
        _armature.removeEventListener(AnimationEvent.COMPLETE, onIdle1);
        _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onIdle1);
        _armature.addEventListener(AnimationEvent.COMPLETE, onIdle2);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onIdle2);
        _armature.animation.gotoAndPlay('idle2');
    }

    private function onIdle2(e:AnimationEvent):void {
        _armature.removeEventListener(AnimationEvent.COMPLETE, onIdle2);
        _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onIdle2);
        _armature.addEventListener(AnimationEvent.COMPLETE, onIdle3);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onIdle3);
        _armature.animation.gotoAndPlay('idle3');
    }

    private function onIdle3(e:AnimationEvent):void {
        _armature.removeEventListener(AnimationEvent.COMPLETE, onIdle3);
        _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onIdle3);
        _bone.display = null;
        _bone = null;
        _tempSprite.removeChild(_tempBG);
        _tempBG.dispose();
        _tempBG = null;
        showCats();
        _armature.addEventListener(AnimationEvent.COMPLETE, onIdle4);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onIdle4);
        _armature.animation.gotoAndPlay('idle4');
    }

    private function onIdle4(e:AnimationEvent):void {
        _armature.removeEventListener(AnimationEvent.COMPLETE, onIdle4);
        _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onIdle4);
        _armature.addEventListener(AnimationEvent.COMPLETE, onIdle5);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onIdle5);
        _armature.animation.gotoAndPlay('idle5');
        _tempBG = new Quad(g.stageWidth, g.stageHeight, 0xF5F3E4);
        _tempBG.x = -g.stageWidth/2;
        _tempBG.y = -g.stageHeight/2;
        _tempBlack.addChild(_tempBG);
        _tempBlack.alpha = 0;
        TweenMax.to(_tempBlack, 10, {alpha:1, ease:Linear.easeNone, useFrames:true, delay: 21});
    }

    private function onIdle5(e:AnimationEvent):void {
        _armature.removeEventListener(AnimationEvent.COMPLETE, onIdle5);
        _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onIdle5);
        _armature.addEventListener(AnimationEvent.COMPLETE, onIdle6);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onIdle6);
        _armature.animation.gotoAndPlay('idle6');
    }

    private function onIdle6(e:AnimationEvent):void {
        deleteCats();
        _armature.removeEventListener(AnimationEvent.COMPLETE, onIdle6);
        _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onIdle6);
        if (_endCallback != null) {
            _endCallback.apply();
        }
    }

    private function createCatSprite():void {
        _boneCats = _armature.getBone('cats');
        _catsSprite = new Sprite();
        _boneCats.display = _catsSprite;
    }

    private function showCats():void {
        _arrCats = [];
        var cat:MultCat = new MultCat(-577, 213, _catsSprite);
        cat.flipIt();
        cat.moveTo(-322, 146, 0);
        _arrCats.push(cat);
        cat = new MultCat(1, 79, _catsSprite);
        cat.moveTo(-164, 68, .1);
        _arrCats.push(cat);
        cat = new MultCat(472, 248, _catsSprite);
        cat.moveTo(274, 20, .3);
        _arrCats.push(cat);
        cat = new MultCat(171, 275, _catsSprite);
        cat.moveTo(-23, 283, .3);
        _arrCats.push(cat);
        cat = new MultCat(446, 30, _catsSprite);
        cat.moveTo(284, 46, .3);
        _arrCats.push(cat);
        cat = new MultCat(-360, -30, _catsSprite);
        cat.flipIt();
        cat.moveTo(-298, 73, .4);
        _arrCats.push(cat);
        cat = new MultCat(191, -113, _catsSprite);
        cat.moveTo(105, -57, .5);
        _arrCats.push(cat);
        cat = new MultCat(-390, 185, _catsSprite);
        cat.flipIt();
        cat.moveTo(-181, 297, .7);
        _arrCats.push(cat);
    }

    private function deleteCats():void {
        for (var i:int=0; i<_arrCats.length; i++) {
            _arrCats[i].deleteIt();
        }
        _arrCats.length = 0;
    }

    public function deleteIt():void {
        g.cont.popupCont.removeChild(_armature.display as Sprite);
        delete g.allData.factory['tutorial_mult'];
        _catsSprite.dispose();
        _tempBG.dispose();
        _tempSprite.dispose();
        _armature.dispose();
    }
}
}
