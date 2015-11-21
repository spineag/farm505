/**
 * Created by user on 9/23/15.
 */
package heroes {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import dragonBones.Armature;
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
    private var _catBackImage:Image;
    private var _isFree:Boolean;
    private var _isActive:Boolean;
    private var _type:int;

    private var factory:StarlingFactory;
    private var armature:Armature;
    private var armatureClip:Sprite;

    public function HeroCat(type:int) {
        super();

        _type = type;
        _isFree = true;
        _isActive = false;
        _source = new CSprite();
        _catImage = new Sprite();
        switch (type) {
            case MAN:
                factory = new StarlingFactory();
                var f1:Function = function ():void {
                    armature = factory.buildArmature("cat");
                    armatureClip = armature.display as Sprite;
                    _catImage.addChild(armatureClip);
                    WorldClock.clock.add(armature);
                    g.gameDispatcher.addEnterFrame(onEnterFrame);
                };
                factory.addEventListener(Event.COMPLETE, f1);
                factory.parseData(new EmbedAssets.CatData());
//                var im:Image = new Image(g.allData.atlas['catAtlas'].getTexture('cat_man'));
//                _catImage.addChild(im);
                _catBackImage = new Image(g.allData.atlas['catAtlas'].getTexture('cat_man_back'));
                break;
            case WOMAN:
                var im:Image = new Image(g.allData.atlas['catAtlas'].getTexture('cat_woman'));
                _catImage.addChild(im);
                _catBackImage = new Image(g.allData.atlas['catAtlas'].getTexture('cat_woman_back'));
                break;
        }
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
        showFront(true);

        _source.endClickCallback = onClick;
    }

    private function onEnterFrame():void {
        WorldClock.clock.advanceTime(-1);
    }

    override public function showFront(v:Boolean):void {
        _catImage.visible = v;
        _catBackImage.visible = !v;
    }

    override public function flipIt(v:Boolean):void {
        v ? _source.scaleX = -1*_scaleDefault : _source.scaleX = 1*_scaleDefault;
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType != ToolsModifier.NONE) return;
        activateIt();
    }

    public function activateIt():void {
        if (!_isFree) return;
        _isActive = !_isActive;
        if (_isActive) {
            if (g.activeCat) g.activeCat.activateIt();
            _source.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1);
            g.activeCat = this;
        } else {
            _source.filter = null;
            g.activeCat = null;
        }
    }

    public function get isFree():Boolean {
        return _isFree;
    }

    public function set isFree(value:Boolean):void {
        _isFree = value;
        g.catPanel.checkCat();
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
        if (_type == MAN) armature.animation.gotoAndPlay("walk");
        super.walkAnimation();
    }
    override public function runAnimation():void {
        if (_type == MAN) armature.animation.gotoAndPlay("run");
        super.runAnimation();
    }
    override public function stopAnimation():void {
        if (_type == MAN) armature.animation.gotoAndStop("idle", 0);
        super.stopAnimation()
    }
    override public function idleAnimation():void {
        if (_type == MAN) armature.animation.gotoAndPlay("idle");
        super.idleAnimation();
    }

}
}
