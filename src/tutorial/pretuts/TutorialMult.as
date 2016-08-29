/**
 * Created by user on 6/15/16.
 */
package tutorial.pretuts {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.display.Bitmap;

import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

import utils.DrawToBitmap;

public class TutorialMult {
    private var _isLoad:Boolean;
    private var _needStart:Boolean;
    private var _startCallback:Function;
    private var _endCallback:Function;
    private var _armature:Armature;
    private var _tempBG:Quad;
    private var _boneBlueSprite:Sprite;
    private var _tempBlack:Sprite;
    private var _arrCats:Array;
    private var _catsSprite:Sprite;
    private var _boneBlue:Slot;
    private var _boneCats:Slot;
    private var _boneBlack:Slot;
    private var walls:Array;
    private var wallImage:Image;
    private var g:Vars = Vars.getInstance();

    public function TutorialMult() {
        _isLoad = false;
        _needStart = false;
        g.loadAnimation.load('animations_json/tuts/box_mult_m/', 'tutorial_mult', onLoad);

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
        (_armature.display as StarlingArmatureDisplay).x = g.stageWidth/2;
        (_armature.display as StarlingArmatureDisplay).y = g.stageHeight/2;
        g.cont.popupCont.addChild(_armature.display as StarlingArmatureDisplay);
        if (_startCallback != null) {
            _startCallback.apply();
        }
        var bWall:Slot = _armature.getSlot('wall_temp');
        if (bWall && bWall.displayList.length) {
            wallImage = bWall.displayList[0] as Image;
//            bWall.display.visible = false;
        } else {
            //..
        }
        _boneBlue = _armature.getSlot('blue');
        _boneBlueSprite = new Sprite();
        _tempBG = new Quad(g.stageWidth + 500, g.stageHeight + 500);
        _tempBG.setVertexColor(0, 0x7FAFB3);
        _tempBG.setVertexColor(1, 0x7FAFB3);
        _tempBG.setVertexColor(2, 0xA4C6C8);
        _tempBG.setVertexColor(3, 0xA4C6C8);
        _tempBG.x = -_tempBG.width/2;
        _tempBG.y = -_tempBG.height/2;
        _boneBlueSprite.addChild(_tempBG);
        _boneBlue.display = _boneBlueSprite;
        createCatSprite();
        _boneBlack = _armature.getSlot('black');
        _tempBlack = new Sprite();
        _boneBlack.display = _tempBlack;

        walls = [];
        var sp:Sprite = new Sprite();
        var b:Slot = _armature.getSlot('wall');
//        var im:Image = g.allData.factory['tutorial_mult'].getTextureDisplay('wall_back') as Image;
//        var im:Image = new Image(DrawToBitmap.getTextureFromImage(wallImage));
        var im:Image = new Image(Texture.fromBitmap(g.pBitmaps['tutorial_mult_map'].create() as Bitmap));
        sp.addChild(im);
        b.display = sp;
        walls.push(sp);
        b = _armature.getSlot('wall1');
        im = new Image(Texture.fromBitmap(g.pBitmaps['tutorial_mult_map'].create() as Bitmap));
        sp = new Sprite();
        sp.addChild(im);
        b.display = sp;
        walls.push(sp);

        WorldClock.clock.add(_armature);
        _armature.addEventListener(EventObject.COMPLETE, onIdle1);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle1);
        _armature.animation.gotoAndPlayByFrame('idle');
    }

    private function onIdle1(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle1);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle1);
        _armature.addEventListener(EventObject.COMPLETE, onIdle2);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle2);
        _armature.animation.gotoAndPlayByFrame('idle2');
    }

    private function onIdle2(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle2);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle2);
        _armature.addEventListener(EventObject.COMPLETE, onIdle3);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle3);
        _armature.animation.gotoAndPlayByFrame('idle3');
        TweenMax.to(_boneBlueSprite, 20, {alpha:0, ease:Linear.easeNone, useFrames:true, delay: 15});

        var sp:Sprite = new Sprite();
        var b:Slot = _armature.getSlot('wall2');
//        var im:Image = g.allData.factory['tutorial_mult'].getTextureDisplay('wall_back') as Image;
        var im:Image = new Image(Texture.fromBitmap(g.pBitmaps['tutorial_mult_map'].create() as Bitmap));
        sp.addChild(im);
        b.display = sp;
        walls.push(sp);
        sp.alpha = 0;
        var b1:Slot = _armature.getSlot('wall3');
//        im = g.allData.factory['tutorial_mult'].getTextureDisplay('wall_back') as Image;
        im = new Image(Texture.fromBitmap(g.pBitmaps['tutorial_mult_map'].create() as Bitmap));
        sp = new Sprite();
        sp.addChild(im);
        b1.display = sp;
        sp.alpha = 0;
        walls.push(sp);

        var f:Function = function():void {
          for (var i:int=0; i<walls.length; i++) {
              walls[i].alpha = 1;
              TweenMax.to(walls[i], 6, {alpha:0, ease:Linear.easeNone, useFrames:true});
          }
        };
        TweenMax.to(walls[0], 16, {alpha:1, ease:Linear.easeNone, useFrames:true, onComplete:f});
    }

    private function onIdle3(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle3);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle3);
        _boneBlue.display = null;
        _boneBlue = null;
        _boneBlueSprite.removeChild(_tempBG);
        _tempBG.dispose();
        _tempBG = null;
        showCats();
        _armature.addEventListener(EventObject.COMPLETE, onIdle4);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle4);
        _armature.animation.gotoAndPlayByFrame('idle4');
    }

    private function onIdle4(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle4);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle4);
        _armature.addEventListener(EventObject.COMPLETE, onIdle5);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle5);
        _armature.animation.gotoAndPlayByFrame('idle5');
        _tempBG = new Quad(g.stageWidth + 500, g.stageHeight + 500, 0xF5F3E4);
        _tempBG.x = -_tempBG.width/2;
        _tempBG.y = -_tempBG.height/2;
        _tempBlack.addChild(_tempBG);
        _tempBlack.alpha = 0;
        TweenMax.to(_tempBlack, 10, {alpha:1, ease:Linear.easeNone, useFrames:true, delay: 21});
    }

    private function onIdle5(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle5);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle5);
        _armature.addEventListener(EventObject.COMPLETE, onIdle6);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle6);
        _armature.animation.gotoAndPlayByFrame('idle6');
    }

    private function onIdle6(e:Event=null):void {
        deleteCats();
        _armature.removeEventListener(EventObject.COMPLETE, onIdle6);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle6);
        if (_endCallback != null) {
            _endCallback.apply();
        }
    }

    private function createCatSprite():void {
        _boneCats = _armature.getSlot('cats');
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
        cat.moveTo(274, 120, .3);
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
        WorldClock.clock.remove(_armature);
        g.cont.popupCont.removeChild(_armature.display as Sprite);
        delete g.allData.factory['tutorial_mult'];
        delete g.pBitmaps['tutorial_mult_map'];
        _catsSprite.dispose();
        _tempBG.dispose();
        _boneBlueSprite.dispose();
        _armature.dispose();
    }
}
}
