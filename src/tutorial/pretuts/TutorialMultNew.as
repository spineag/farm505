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
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import utils.DrawToBitmap;

public class TutorialMultNew {
    private var _source:Sprite;
    private var _leftIm:Quad;
    private var _rightIm:Quad;
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
        g.loadAnimation.load('animations_json/tuts/box_mult_3/', 'tutorial_mult', onLoad);
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
        g.cont.popupCont.addChild(_source);
        if (_startCallback != null) {
            _startCallback.apply();
        }

        _contF1 = new Sprite();
        _contF2 = new Sprite();
        _contF2.visible = false;
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
        var bd:BitmapData = DrawToBitmap.copyToBitmapDataWithRectangle(Starling.current, _source, rect); // should use more bigger field!!!!
        var im:Image = new Image(Texture.fromBitmapData(bd));
        im.width = 1100;
        im.height = 700;
        im.x = -50;
        im.y = -30;
        _tempBlured = new Sprite();
        _tempBlured.addChild(im);
        im = new Image(Texture.fromBitmapData(bd));
        _tempBlured.addChild(im);
        _tempBlured.filter = ManagerFilters.HARD_BLUR;
        _tempBlured.x = -500;
        _tempBlured.y = -320;
        _contF1.addChild(_tempBlured);

        _armature.addEventListener(EventObject.COMPLETE, onIdle1);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle1);
        _armature.animation.gotoAndPlayByFrame('idle');

        onResize();
    }

    public function onResize():void {
        _source.x = g.managerResize.stageWidth/2 - 500;
        addIms();
    }

    private function addIms():void {
        if (_leftIm) {
            if (_source.contains(_leftIm)) _source.removeChild(_leftIm);
            _leftIm.dispose();
        }
        if (_rightIm) {
            if (_source.contains(_rightIm)) _source.removeChild(_rightIm);
            _rightIm.dispose();
        }
        var w:int = g.managerResize.stageWidth;
        if (w < 1000 + 10) return;
        _leftIm = new Quad(int(w/2 - 500) + 1, 640);
        _leftIm.x = -_leftIm.width;
        _source.addChild(_leftIm);
        _rightIm = new Quad(int(w/2 - 500) + 1, 640);
        _rightIm.x = 1000;
        _source.addChild(_rightIm);
        _leftIm.touchable = false;
        _rightIm.touchable = false;
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
        TweenMax.to(_tempBlured, 25, {alpha:0, ease:Linear.easeNone, useFrames:true});
    }

    private function onIdle3(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle3);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle3);
        _contF1.visible = false;
        _tempBlured.filter.dispose();
        _tempBlured.filter = null;
        _contF1.removeChild(_tempBlured);
        while (_tempBlured.numChildren) _tempBlured.removeChildAt(0);
        showCats();
        _armature.addEventListener(EventObject.COMPLETE, onIdle4);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onIdle4);
        _armature.animation.gotoAndPlayByFrame('idle_4');
    }

    private function onIdle4(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, onIdle4);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onIdle4);
        _armature.animation.gotoAndStopByFrame('idle_5');

        var bm:Bitmap = DrawToBitmap.drawToBitmap(Starling.current, _source);
        var im:Image = new Image(Texture.fromBitmap(bm));
        im.width = 1100;
        im.height = 700;
        im.x = -550;
        im.y = -350;
        _tempBlured.addChild(im);
        im = new Image(Texture.fromBitmap(bm));
        _tempBlured.addChild(im);
        im.x = -500;
        im.y = -320;
        _tempBlured.filter = ManagerFilters.HARD_BLUR;
        _contF2.addChild(_tempBlured);
        _contF2.alpha = 0;
        _contF2.visible = true;
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
        if (_endCallback != null) {
//            _endCallback.apply();
        }
    }

    private function showCats():void {
        _arrCats = [];
        var cat:MultCat = new MultCat(-577, 213, _contCats);
        cat.flipIt();
        cat.moveTo(-322, 146, 0);
        _arrCats.push(cat);
        cat = new MultCat(1, 79, _contCats);
        cat.moveTo(-164, 68, .1);
        _arrCats.push(cat);
        cat = new MultCat(472, 248, _contCats);
        cat.moveTo(274, 120, .3);
        _arrCats.push(cat);
        cat = new MultCat(171, 275, _contCats);
        cat.moveTo(-23, 283, .3);
        _arrCats.push(cat);
        cat = new MultCat(446, 30, _contCats);
        cat.moveTo(284, 46, .3);
        _arrCats.push(cat);
        cat = new MultCat(-360, -30, _contCats);
        cat.flipIt();
        cat.moveTo(-298, 73, .4);
        _arrCats.push(cat);
        cat = new MultCat(191, -113, _contCats);
        cat.moveTo(105, -57, .5);
        _arrCats.push(cat);
        cat = new MultCat(-390, 185, _contCats);
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
        g.cont.popupCont.removeChild(_source);
        _source.removeChild(_armature.display as Sprite);
        (g.allData.factory['tutorial_mult'] as StarlingFactory).clear();
        delete g.allData.factory['tutorial_mult'];
        (g.pBitmaps['tutorial_mult_map'] as PBitmap).deleteIt();
        delete g.pBitmaps['tutorial_mult_map'];
        _armature.dispose();
        _source.dispose();
    }
}
}
