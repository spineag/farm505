/**
 * Created by user on 7/16/15.
 */
package preloader {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;
import dragonBones.starling.StarlingFactory;

import loaders.EmbedAssets;

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

import utils.CTextField;
import utils.FarmDispatcher;

public class StartPreloader {
    [Embed(source="../../assets/preloaderAtlas.png")]
    private const PreloaderTexture:Class;
    [Embed(source="../../assets/preloaderAtlas.xml", mimeType="application/octet-stream")]
    private const PreloaderTextureXML:Class;

    private var _source:Sprite;
    private var _bg:Image;
    private var _preloaderBG:Image;
    private var _preloaderLine:Image;
    private var _texture:Texture;
    private var _preloaderAtlas:TextureAtlas;
    private var _armature:Armature;
    private var _quad:Quad;
    private var _txt:CTextField;

    private var g:Vars = Vars.getInstance();

    public function StartPreloader() {
        _source = new Sprite();
        _texture = Texture.fromBitmap(new PreloaderTexture());
        var xml:XML = XML(new PreloaderTextureXML());
        _preloaderAtlas = new TextureAtlas(_texture, xml);
        _bg = new Image(_preloaderAtlas.getTexture('preloader_window'));
        _source.addChild(_bg);
        _quad = new Quad(3.2, 3, 0xc0e8ff);
        _quad.x = 327;
        _quad.y = 599;
        _source.addChild(_quad);
        _txt = new CTextField(75,50,'0');
        _txt.setFormat(CTextField.BOLD24, 24, 0x0659b6);
        _source.addChild(_txt);
        _txt.x = _bg.width/2 - 46;
        _txt.y = _bg.height/2 + 182;
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
        g.cont.popupCont.addChild(_source);
    }

    public function setProgress(a:int):void {
        _quad.scaleX = a;
        _txt.text = String(a + '%');
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
