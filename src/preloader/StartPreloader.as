/**
 * Created by user on 7/16/15.
 */
package preloader {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import dragonBones.factories.StarlingFactory;

import flash.events.Event;


import flash.geom.Rectangle;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.Color;

import utils.FarmDispatcher;

public class StartPreloader {
    [Embed(source="../../assets/preloaderAtlas1.png")]
    public static const PreloaderTexture:Class;
    [Embed(source = "../../assets/animations/preloader/splash_screen.png", mimeType = "application/octet-stream")]
    private const Preloader:Class;
    [Embed(source="../../assets/preloaderAtlas.xml", mimeType="application/octet-stream")]
    public static const PreloaderTextureXML:Class;

    private var _source:Sprite;
    private var _bg:Image;
    private var _preloaderSprite:Sprite;
    private var _preloaderBG:Image;
    private var _preloaderLine:Image;
    private var _texture:Texture;
    private var _preloaderAtlas:TextureAtlas;
    private var _armature:Armature;
    private var g:Vars = Vars.getInstance();
    private var _txt:TextField;
    public function StartPreloader() {
        _source = new Sprite();
        var gameDispatcher:FarmDispatcher;
        gameDispatcher = new FarmDispatcher(g.mainStage);
        gameDispatcher.addEnterFrame(onEnterFrameGlobal);

        _texture = Texture.fromBitmap(new PreloaderTexture());
        var xml:XML = XML(new PreloaderTextureXML());
        _preloaderAtlas = new TextureAtlas(_texture, xml);
        _bg = new Image(_preloaderAtlas.getTexture('preloader_window'));
        _source.addChild(_bg);
        loadFactory('preloader',Preloader,create);
//

//        _preloaderSprite = new Sprite();
//        _preloaderBG = new Image(_preloaderAtlas.getTexture('preloader_bg'));
//        _preloaderLine = new Image(_preloaderAtlas.getTexture('preloader_line'));
//        _preloaderSprite.addChild(_preloaderBG);
//        _preloaderSprite.clipRect = new Rectangle(0, 0, _preloaderSprite.width, _preloaderSprite.height);
//        _preloaderLine.x = -_preloaderLine.width;
//        _preloaderSprite.addChild(_preloaderLine);
//        _preloaderSprite.x = _source.width/2 - _preloaderBG.width/2;
//        _preloaderSprite.y = 600;
//        _source.addChild(_preloaderSprite);
        _txt = new TextField(60,50,'0','Arial', 24, Color.BLACK);
        _source.addChild(_txt);
    }
    private function create():void {
        _armature = g.allData.factory['preloader'].buildArmature("splash_screen");
        _armature.display.x = _bg.width/2;
        _armature.display.y = _bg.height/2;
        _source.addChild(_armature.display as Sprite);
        WorldClock.clock.add(_armature);
//        _armature.animation.gotoAndStop('default', 0);

        _txt.x = _bg.width/2 - 35;
        _txt.y = _bg.height/2 + 185;
        setProgress(0);
        animation();
    }

    public function showIt():void {
        g.cont.popupCont.addChild(_source);
    }

    private function onEnterFrameGlobal():void {
        WorldClock.clock.advanceTime(-1);
    }

    public function setProgress(a:int):void {
//        _preloaderLine.x = -_preloaderLine.width*(100-a)/100;
        _txt.text = String(a);
    }

    public function hideIt():void {
        g.cont.popupCont.removeChild(_source);
        while (_source.numChildren) {
            _source.removeChildAt(0);
        }
        if (_texture) _texture.dispose();
        if (_preloaderAtlas)_preloaderAtlas.dispose();
        if (_bg)_bg.dispose();
        if(_preloaderBG) _preloaderBG.dispose();
        if (_preloaderLine) _preloaderLine.dispose();
        if (_armature) _armature = null;
    }

    private function animation():void {
        if (!_armature) return;
        var fEndOver:Function = function():void {
            if (!_armature) return;
            _armature.removeEventListener(AnimationEvent.COMPLETE, fEndOver);
            _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
            animation();
        };
        _armature.addEventListener(AnimationEvent.COMPLETE, fEndOver);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
        _armature.animation.gotoAndPlay('load');
    }

    private function loadFactory(name:String, clas:Class, onLoad:Function):void {
        var factory:StarlingFactory = new StarlingFactory();
        var f:Function = function (e:Event):void {
            factory.removeEventListener(Event.COMPLETE, f);
            g.allData.factory[name] = factory;
            if (onLoad != null) onLoad.apply();
        };
        factory.addEventListener(Event.COMPLETE, f);
        factory.parseData(new clas());
    }
}
}
