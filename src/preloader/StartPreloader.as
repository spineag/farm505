/**
 * Created by user on 7/16/15.
 */
package preloader {
import flash.geom.Rectangle;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

public class StartPreloader {
    private var _source:Sprite;
    private var _bg:Image;
    private var _preloaderSprite:Sprite;
    private var _preloaderBG:Image;
    private var _preloaderLine:Image;

    private var g:Vars = Vars.getInstance();

    public function StartPreloader() {
        _source = new Sprite();
        _bg = new Image(g.preloaderAtlas.getTexture('preloader'));
        _source.addChild(_bg);
        _preloaderSprite = new Sprite();
        _preloaderBG = new Image(g.preloaderAtlas.getTexture('preloader_bg'));
        _preloaderLine = new Image(g.preloaderAtlas.getTexture('preloader_line'));
        _preloaderSprite.addChild(_preloaderBG);
        _preloaderSprite.clipRect = new Rectangle(0, 0, _preloaderSprite.width, _preloaderSprite.height);
        _preloaderLine.x = -_preloaderLine.width;
        _preloaderSprite.addChild(_preloaderLine);
    }

    public function showIt():void {
        g.cont.popupCont.addChild(_source);
    }

    public function setProgress(a:int):void {
        _preloaderLine.x = -_preloaderLine.width*(100-a)/100;
    }

    public function hideIt():void {
        g.cont.popupCont.removeChild(_source);
        _bg.dispose();
        _preloaderBG.dispose();
        _preloaderLine.dispose();
    }
}
}
