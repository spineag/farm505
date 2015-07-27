/**
 * Created by user on 7/27/15.
 */
package ui.optionPanel {
import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.CSprite;

public class OptionPanel {
    private var _source:Sprite;
    private var _contFullScreen:CSprite;
    private var _contScalePlus:CSprite;
    private var _contScaleMinus:CSprite;
    private var _contScreenShot:CSprite;
    private var _contAnim:CSprite;
    private var _contMusic:CSprite;
    private var _contSound:CSprite;

    private var g:Vars = Vars.getInstance();
    public function OptionPanel() {
    }


    public function fillBtns():void {
        _source = new Sprite();
        _source.x = g.stageWidth;
        _source.y = 60;
        g.cont.interfaceCont.addChild(_source);
        var im:Image;

        _contFullScreen = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_fullscreen"));
        _contFullScreen.addChild(im);
        _source.addChild(_contFullScreen);
        _contFullScreen.hoverCallback = function():void { _contFullScreen.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _contFullScreen.outCallback = function():void { _contFullScreen.filter = null };
        _contFullScreen.endClickCallback = function():void {onClick('fullscreen')};

        _contScalePlus = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_scale_plus"));
        _contScalePlus.addChild(im);
        _contScalePlus.y = 50;
        _source.addChild(_contScalePlus);
        _contScalePlus.hoverCallback = function():void { _contScalePlus.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _contScalePlus.outCallback = function():void { _contScalePlus.filter = null };
        _contScalePlus.endClickCallback = function():void {onClick('scale_plus')};

        _contScaleMinus = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_scale_minus"));
        _contScaleMinus.addChild(im);
        _contScaleMinus.y = 100;
        _source.addChild(_contScaleMinus);
        _contScaleMinus.hoverCallback = function():void { _contScaleMinus.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _contScaleMinus.outCallback = function():void { _contScaleMinus.filter = null };
        _contScaleMinus.endClickCallback = function():void {onClick('scale_minus')};

        _contScreenShot = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_screenshot"));
        _contScreenShot.addChild(im);
        _contScreenShot.y = 150;
        _source.addChild(_contScreenShot);
        _contScreenShot.hoverCallback = function():void { _contScreenShot.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _contScreenShot.outCallback = function():void { _contScreenShot.filter = null };
        _contScreenShot.endClickCallback = function():void {onClick('screenshot')};

        _contAnim = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_anim"));
        _contAnim.addChild(im);
        _contAnim.y = 200;
        _source.addChild(_contAnim);
        _contAnim.hoverCallback = function():void { _contAnim.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _contAnim.outCallback = function():void { _contAnim.filter = null };
        _contAnim.endClickCallback = function():void {onClick('anim')};

        _contMusic = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_music"));
        _contMusic.addChild(im);
        _contMusic.y = 250;
        _source.addChild(_contMusic);
        _contMusic.hoverCallback = function():void { _contMusic.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _contMusic.outCallback = function():void { _contMusic.filter = null };
        _contMusic.endClickCallback = function():void {onClick('music')};

        _contSound = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_sound"));
        _contSound.addChild(im);
        _contSound.y = 300;
        _source.addChild(_contSound);
        _contSound.hoverCallback = function():void { _contSound.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _contSound.outCallback = function():void { _contSound.filter = null };
        _contSound.endClickCallback = function():void {onClick('sound')};


        var tween:Tween = new Tween(_source, 0.2);
        tween.moveTo(g.stageWidth - 50,_source.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);
    }

    public function onOut():void {
        var tween:Tween = new Tween(_source, 0.2);
        tween.moveTo(_source.x,_source.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);

        _source.visible = false;
    }

    private function onClick(reason:String):void {
        switch (reason) {
            case 'fullscreen':
                break;
            case 'scale_plus':
                break;
            case 'scale_minus':
                break;
            case 'screenshot':
                break;
            case 'anim':
                break;
            case 'music':
                break;
            case 'sound':
                break;
        }
    }
}
}
