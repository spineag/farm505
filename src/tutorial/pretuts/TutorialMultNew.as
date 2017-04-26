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
import dragonBones.starling.StarlingFactory;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import loaders.PBitmap;
import manager.ManagerFilters;
import manager.Vars;

import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import utils.DrawToBitmap;
import utils.Utils;

public class TutorialMultNew {
    private var _source:Sprite;
    private var _leftIm:Image;
    private var _rightIm:Image;
    private var _isLoad:Boolean;
    private var _needStart:Boolean;
    private var _startCallback:Function;
    private var _endCallback:Function;
    private var _armature:Armature;
    private var _arrCats:Array;
    private var _tempBlured:Sprite;
    private var _contF1:Sprite;
    private var _contCats:Sprite;
    private var _contF2:Sprite;
    private var g:Vars = Vars.getInstance();

    public function TutorialMultNew() {
        _isLoad = false;
        _needStart = false;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            g.loadAnimation.load('animations_json/tuts/box_mult_fb/', 'tutorial_mult', onLoad);
        } else g.loadAnimation.load('animations_json/tuts/box_mult_3/', 'tutorial_mult', onLoad);
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
        _source = new Sprite();
        _armature = g.allData.factory['tutorial_mult'].buildArmature('mult');
        (_armature.display as StarlingArmatureDisplay).x = 500;
        (_armature.display as StarlingArmatureDisplay).y = 320;
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        g.managerResize.recheckProperties();
        onResize();
        addIms();
        g.cont.popupCont.addChild(_source);
        if (_startCallback != null) {
            _startCallback.apply();
        }

        _contF1 = new Sprite();
        _contF2 = new Sprite();
        _contCats = new Sprite();
        var b:Slot = _armature.getSlot('f1');
        b.displayList = null;
        b.display = _contF1;
        b = _armature.getSlot('cats');
        b.displayList = null;
        b.display = _contCats;
        b = _armature.getSlot('f2');
        b.displayList = null;
        b.display = _contF2;

        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndStopByFrame('idle');
        var rect:Rectangle = new Rectangle();
        rect.width = 1000;
        rect.height = 640;
        rect.x = g.managerResize.stageWidth/2 - 500;
        var bd:BitmapData = DrawToBitmap.stageScreenShotByRect(rect);
        var im:Image = new Image(Texture.fromBitmapData(bd));
        _tempBlured = new Sprite();
        _tempBlured.addChild(im);
        _tempBlured.filter = ManagerFilters.HARD_BLUR;
        _tempBlured.x = -500 + 16;
        _tempBlured.y = -320 + 16;
        _contF1.addChild(_tempBlured);

        _armature.addEventListener(EventObject.COMPLETE, onIdle1);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle1);
        _armature.animation.gotoAndPlayByFrame('idle');
    }

    public function onResize():void {
        _source.x = g.managerResize.stageWidth/2 - 500;
    }

    private function addIms():void {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            if (g.pBitmaps['uho1']) {
                (g.pBitmaps['uho1'] as PBitmap).deleteIt();
                delete g.pBitmaps['uho1'];
                g.load.removeByUrl('uho1');
            }
            if (g.pBitmaps['uho2']) {
                (g.pBitmaps['uho2'] as PBitmap).deleteIt();
                delete g.pBitmaps['uho2'];
                g.load.removeByUrl('uho2');
            }
            return;
        }
        if (!_leftIm) {
            _leftIm = new Image(Texture.fromBitmap(g.pBitmaps['uho1'].create() as Bitmap));
            _leftIm.x = -_leftIm.width + 2;
            _source.addChild(_leftIm);
            _leftIm.touchable = false;
        }
        if (!_rightIm) {
            _rightIm = new Image(Texture.fromBitmap(g.pBitmaps['uho2'].create() as Bitmap));
            _rightIm.x = 1000;
            _source.addChild(_rightIm);
            _rightIm.touchable = false;
        }
    }

    private function onIdle1(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle1);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle1);
        _armature.addEventListener(EventObject.COMPLETE, onIdle2);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle2);
        _armature.animation.gotoAndPlayByFrame('idle_2');
    }

    private function onIdle2(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle2);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle2);
        _armature.addEventListener(EventObject.COMPLETE, onIdle3);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle3);
        _armature.animation.gotoAndPlayByFrame('idle_3');
        TweenMax.to(_tempBlured, 30, {alpha:0, ease:Linear.easeNone, useFrames:true});
    }

    private function onIdle3(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle3);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle3);
        _contF1.visible = false;
        _contF1.removeChild(_tempBlured);
        _tempBlured.dispose();
        _tempBlured = null;
        showCats();
        _armature.addEventListener(EventObject.COMPLETE, onIdle4);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle4);
        _armature.animation.gotoAndPlayByFrame('idle_4');
    }

    private function onIdle4(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle4);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle4);
        _armature.animation.gotoAndStopByFrame('idle_5');

        var rect:Rectangle = new Rectangle();
        rect.width = 1000;
        rect.height = 640;
        rect.x = g.managerResize.stageWidth/2 - 1000/2;
        var bd:BitmapData = DrawToBitmap.stageScreenShotByRect(rect);
        var im:Image = new Image(Texture.fromBitmapData(bd));
        _tempBlured = new Sprite();
        _tempBlured.addChild(im);
        _tempBlured.filter = ManagerFilters.HARD_BLUR;
        _tempBlured.x = -500 + 16;
        _tempBlured.y = -320 + 16;
        _contF2.addChild(_tempBlured);
        _tempBlured.alpha = 0;
        TweenMax.to(_tempBlured, 20, {alpha:1, ease:Linear.easeNone, useFrames:true});

        _armature.addEventListener(EventObject.COMPLETE, onIdle5);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle5);
        _armature.animation.gotoAndPlayByFrame('idle_5');
    }

    private function onIdle5(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle5);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle5);
        _armature.addEventListener(EventObject.COMPLETE, onIdle6);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle6);
        _armature.animation.gotoAndPlayByFrame('idle_6');
    }

    private function onIdle6(e:Event=null):void {
        deleteCats();
        _armature.removeEventListener(EventObject.COMPLETE, onIdle6);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle6);
        Utils.createDelay(2, onEndMult);
    }

    private function onEndMult():void {
        if (_endCallback != null) {
            _endCallback.apply();
        }
    }

    private function showCats():void {
        _arrCats = [];
        var cat:MultCat = new MultCat(-577, 213, _contCats, 1);
        cat.flipIt();
        cat.moveTo(-320, 156, 0);
        _arrCats.push(cat);
        cat = new MultCat(1, 79, _contCats, 2);
        cat.moveTo(-159, 58, .1);
        _arrCats.push(cat);
        cat = new MultCat(472, 270, _contCats, 3);
        cat.moveTo(274, 165, .3);
        _arrCats.push(cat);
        cat = new MultCat(171, 275, _contCats, 4);
        cat.moveTo(-23, 273, .3);
        _arrCats.push(cat);
        cat = new MultCat(470, 65, _contCats, 5);
        cat.moveTo(300, 65, .3);
        _arrCats.push(cat);
        cat = new MultCat(-360, -30, _contCats, 6);
        cat.flipIt();
        cat.moveTo(-300, 70, .4);
        _arrCats.push(cat);
        cat = new MultCat(191, -113, _contCats, 7);
        cat.moveTo(110, -60, .5);
        _arrCats.push(cat);
        cat = new MultCat(-390, 185, _contCats, 8);
        cat.flipIt();
        cat.moveTo(-181, 270, .7);
        _arrCats.push(cat);
    }

    private function deleteCats():void {
        for (var i:int=0; i<_arrCats.length; i++) {
            _arrCats[i].deleteIt();
        }
        _arrCats.length = 0;
    }

    public function deleteIt():void {
        _contF2.removeChild(_tempBlured);
        _tempBlured.dispose();
        WorldClock.clock.remove(_armature);
        g.cont.popupCont.removeChild(_source);
        _source.removeChild(_armature.display as Sprite);
        (g.allData.factory['tutorial_mult'] as StarlingFactory).clear();
        delete g.allData.factory['tutorial_mult'];
        (g.pBitmaps['tutorial_mult_map'] as PBitmap).deleteIt();
        delete g.pBitmaps['tutorial_mult_map'];
        g.load.removeByUrl('tutorial_mult_map');
        _armature.dispose();
        _source.dispose();
    }
}
}
