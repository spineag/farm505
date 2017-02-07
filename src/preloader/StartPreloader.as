/**
 * Created by user on 7/16/15.
 */
package preloader {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;
import dragonBones.starling.StarlingFactory;

import flash.display.Bitmap;

import loaders.EmbedAssets;
import loaders.PBitmap;

import manager.ManagerFilters;
import manager.Vars;

import server.DirectServer;

import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.Color;

import utils.CTextField;
import utils.FarmDispatcher;

public class StartPreloader {
    [Embed(source="../../assets/preloaderAtlas.png")]
    private const PreloaderTexture:Class;
    [Embed(source="../../assets/preloaderAtlas.xml", mimeType="application/octet-stream")]
    private const PreloaderTextureXML:Class;
    [Embed(source="../../assets/embeds/uho1.jpg")]
    private const Uho1:Class;
    [Embed(source="../../assets/embeds/uho2.jpg")]
    private const Uho2:Class;

    private var _source:Sprite;
    private var _bg:Image;
    private var _preloaderBG:Image;
    private var _preloaderLine:Image;
    private var _texture:Texture;
    private var _preloaderAtlas:TextureAtlas;
    private var _armature:Armature;
    private var _quad:Quad;
    private var _txt:CTextField;
    private var _leftIm:Image;
    private var _rightIm:Image;
    private var _txtHelp:CTextField;

    private var g:Vars = Vars.getInstance();

    public function StartPreloader() {
        _source = new Sprite();
        _texture = Texture.fromBitmap(new PreloaderTexture());
        var xml:XML = XML(new PreloaderTextureXML());
        _preloaderAtlas = new TextureAtlas(_texture, xml);
        _bg = new Image(_preloaderAtlas.getTexture('preloader_bg'));
        _source.addChild(_bg);
        _quad = new Quad(3.2, 3, 0xfbaaa7);
        _quad.x = 327;
        _quad.y = 569;
        _source.addChild(_quad);
        _txt = new CTextField(75,50,'0');
        _txt.setFormat(CTextField.BOLD24, 24, 0x0659b6);
        _source.addChild(_txt);
        _txt.x = _bg.width/2 - 46;
        _txt.y = _bg.height/2 + 182;
        createBitmap();
        addIms();

    }

    private function createBitmap():void {
        var b:Bitmap;
        b = new Uho1();
        g.pBitmaps['uho1'] = new PBitmap(b);
        b = new Uho2();
        g.pBitmaps['uho2'] = new PBitmap(b);
    }

    private function create():void {
        _armature = g.allData.factory['preloader'].buildArmature("splash_screen");
        (_armature.display as StarlingArmatureDisplay).x = _bg.width/2;
        (_armature.display as StarlingArmatureDisplay).y = _bg.height/2;
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        WorldClock.clock.add(_armature);
        setProgress(0);
    }

    public function showIt():void {
        onResize();
        g.cont.popupCont.addChild(_source);
    }

    public function setProgress(a:int):void {
        _quad.scaleX = a;
        _txt.text = String(a + '%');
    }

    public function onResize():void {
        if (!_source) return;
        _source.x = g.managerResize.stageWidth/2 - 500;
        if (g.managerResize.stageWidth > 1000 && !_leftIm) addIms();
    }

    private function addIms():void {
        if (g.managerResize.stageWidth < 1004) {
//            if (g.pBitmaps['uho1']) {
//                (g.pBitmaps['uho1'] as PBitmap).deleteIt();
//                delete g.pBitmaps['uho1'];
//            }
//            if (g.pBitmaps['uho2']) {
//                (g.pBitmaps['uho2'] as PBitmap).deleteIt();
//                delete g.pBitmaps['uho2'];
//            }
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

    public function textHelp(str:String):void {
        _txtHelp = new CTextField(1000, 640,str);
        _txtHelp.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtHelp.y = 275;
        _source.addChild(_txtHelp);
    }


    public function hideIt():void {
        if (_armature) WorldClock.clock.remove(_armature);
        if (_source) {
            g.cont.popupCont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
        }
        if (_texture) _texture.dispose();
        if (_txt) _txt.deleteIt();
        if (_txtHelp) _txtHelp.deleteIt();
        if (_preloaderAtlas)_preloaderAtlas.dispose();
        if (_bg)_bg.dispose();
        if(_preloaderBG) _preloaderBG.dispose();
        if (_preloaderLine) _preloaderLine.dispose();
        if (_armature) _armature.dispose();
        _armature = null;
        _source.dispose();
        _source = null;
        if (g.allData.factory['preloader']) {
            (g.allData.factory['preloader'] as StarlingFactory).clear();
            delete g.allData.factory['preloader'];
        }
    }
}
}
