/**
 * Created by user on 7/16/15.
 */
package preloader {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;

import loaders.EmbedAssets;
import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import utils.FarmDispatcher;

public class StartPreloader {
    [Embed(source="../../assets/preloaderAtlas.png")]
    public static const PreloaderTexture:Class;
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
    private var _quad:Quad;
    private var _txt:TextField;


    private var g:Vars = Vars.getInstance();

    public function StartPreloader() {
        _source = new Sprite();
        var gameDispatcher:FarmDispatcher;
        gameDispatcher = new FarmDispatcher(g.mainStage);
        gameDispatcher.addEnterFrame(onEnterFrameGlobal);
        new EmbedAssets(null);
        _texture = Texture.fromBitmap(new PreloaderTexture());
        var xml:XML = XML(new PreloaderTextureXML());
        _preloaderAtlas = new TextureAtlas(_texture, xml);
        _bg = new Image(_preloaderAtlas.getTexture('preloader_window'));
        _source.addChild(_bg);
        _quad = new Quad(3.2, 3, 0xc0e8ff);
        _quad.x = 327;
        _quad.y = 599;
        _source.addChild(_quad);
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
        _txt = new TextField(75,50,'0');
        _txt.format.setTo(g.allData.bFonts['BloggerBold24'], 24, 0x0659b6);
        _source.addChild(_txt);
        _txt.x = _bg.width/2 - 42;
        _txt.y = _bg.height/2 + 185;
    }

    private function create():void {
        _armature = g.allData.factory['preloader'].buildArmature("splash_screen");
        (_armature.display as StarlingArmatureDisplay).x = _bg.width/2;
        (_armature.display as StarlingArmatureDisplay).y = _bg.height/2;
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        WorldClock.clock.add(_armature);
//        _armature.animation.gotoAndStop('default', 0);


        setProgress(0);
    }

    public function showIt():void {
        g.cont.popupCont.addChild(_source);
    }

    private function onEnterFrameGlobal():void {
        WorldClock.clock.advanceTime(-1);
    }

    public function setProgress(a:int):void {
//        _preloaderLine.x = -_preloaderLine.width*(100-a)/100;
        _quad.scaleX = a;
        _txt.text = String(a + '%');
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
}
}
