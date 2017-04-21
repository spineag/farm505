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
//    [Embed(source="../../assets/preloaderAtlas.png")]
//    private const PreloaderTexture:Class;
//    [Embed(source="../../assets/preloaderAtlas.xml", mimeType="application/octet-stream")]
//    private const PreloaderTextureXML:Class;
    [Embed(source="../../assets/embeds/uho1.jpg")]
    private const Uho1:Class;
    [Embed(source="../../assets/embeds/uho2.jpg")]
    private const Uho2:Class;

    private var _source:Sprite;
    private var _bg:Image;
    private var _quad:Quad;
    private var _txt:CTextField;
    private var _leftIm:Image;
    private var _rightIm:Image;
    private var _txtHelp:CTextField;
    private var _jpgUrl:String;
    private var _callbackInit:Function;

    private var g:Vars = Vars.getInstance();

    public function StartPreloader(f:Function) {
        _callbackInit = f;
        _source = new Sprite();
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) _jpgUrl = g.dataPath.getGraphicsPath() + 'preloader/eng_splash_screen_main.jpg';
            else _jpgUrl = g.dataPath.getGraphicsPath() + 'preloader/preloader_bg.jpg';
        g.load.loadImage(_jpgUrl, onLoad);
        _quad = new Quad(3, 3, 0x33a2f4);
        _quad.x = 327;
        _quad.y = 569;
        _source.addChild(_quad);
        _txt = new CTextField(75,50,'0');
        _txt.setFormat(CTextField.BOLD24, 24, 0x0659b6);
        _source.addChild(_txt);
        _txt.x = 453;
        _txt.y = 502;
        createBitmap();
        addIms();
    }

    private function onLoad(b:Bitmap):void {
        _bg = new Image(Texture.fromBitmap(g.pBitmaps[_jpgUrl].create() as Bitmap));
        _source.addChildAt(_bg, 0);
        (g.pBitmaps[_jpgUrl] as PBitmap).deleteIt();
        delete g.pBitmaps[_jpgUrl];
        g.load.removeByUrl(_jpgUrl);

        onResize();
        g.cont.popupCont.addChild(_source);
        if (_callbackInit != null) {
            _callbackInit.apply();
        }
    }

    private function createBitmap():void {
        var b:Bitmap;
        b = new Uho1();
        g.pBitmaps['uho1'] = new PBitmap(b);
        b = new Uho2();
        g.pBitmaps['uho2'] = new PBitmap(b);
    }

    public function setProgress(a:int):void {
        _quad.scaleX = a;
        _txt.text = String(a + '%');
    }

    public function onResize():void {
        if (!_source) return;
        _source.x = g.managerResize.stageWidth/2 - 500;
    }

    private function addIms():void {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) return;
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
        if (_source) {
            g.cont.popupCont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
        }
        if (_txt) _txt.deleteIt();
        if (_txtHelp) _txtHelp.deleteIt();
        if (_bg)_bg.dispose();
        _source.dispose();
        _source = null;
    }
}
}
