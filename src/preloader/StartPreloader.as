/**
 * Created by user on 7/16/15.
 */
package preloader {
import flash.geom.Rectangle;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

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

    private var g:Vars = Vars.getInstance();

    public function StartPreloader() {
        _texture = Texture.fromBitmap(new PreloaderTexture());
        var xml:XML = XML(new PreloaderTextureXML());
        _preloaderAtlas = new TextureAtlas(_texture, xml);

        _source = new Sprite();
        _bg = new Image(_preloaderAtlas.getTexture('preloader_window'));
        _source.addChild(_bg);
        _preloaderSprite = new Sprite();
        _preloaderBG = new Image(_preloaderAtlas.getTexture('preloader_bg'));
        _preloaderLine = new Image(_preloaderAtlas.getTexture('preloader_line'));
        _preloaderSprite.addChild(_preloaderBG);
        _preloaderSprite.clipRect = new Rectangle(0, 0, _preloaderSprite.width, _preloaderSprite.height);
        _preloaderLine.x = -_preloaderLine.width;
        _preloaderSprite.addChild(_preloaderLine);
        _preloaderSprite.x = _source.width/2 - _preloaderBG.width/2;
        _preloaderSprite.y = 600;
        _source.addChild(_preloaderSprite);
        setProgress(0);
    }

    public function showIt():void {
        g.cont.popupCont.addChild(_source);
    }

    public function setProgress(a:int):void {
        _preloaderLine.x = -_preloaderLine.width*(100-a)/100;
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
    }
}
}
