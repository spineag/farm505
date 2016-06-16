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

public class StartPreloader {
    [Embed(source="../../assets/preloaderAtlas.png")]
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
        _texture = Texture.fromBitmap(new PreloaderTexture());
        var xml:XML = XML(new PreloaderTextureXML());
        _preloaderAtlas = new TextureAtlas(_texture, xml);
        loadFactory('preloader',Preloader,create);
//
//        _bg = new Image(_preloaderAtlas.getTexture('preloader_window'));
//        _source.addChild(_bg);
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
        _armature.display.x = _armature.display.width/2-106;
        _armature.display.y = _armature.display.height/2;
        _source.addChildAt(_armature.display as Sprite,0);
        WorldClock.clock.add(_armature);
//        _armature.animation.gotoAndStop('default', 0);
        animation();
        _txt.x = _armature.display.width/2 - 142;
        _txt.y = _armature.display.height/2 + 185;
        setProgress(0);
    }

    public function showIt():void {
        g.cont.popupCont.addChild(_source);
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
        _texture.dispose();
        _preloaderAtlas.dispose();
        _bg.dispose();
        _preloaderBG.dispose();
        _preloaderLine.dispose();
        _armature = null;
    }

    private function animation():void {
        var fEndOver:Function = function():void {
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
