/**
 * Created by user on 7/27/15.
 */
package ui.optionPanel {

import com.junkbyte.console.Cc;

import flash.display.StageDisplayState;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import manager.Vars;

import map.MatrixGrid;

import starling.animation.Tween;
import starling.core.Starling;
import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.KeyboardEvent;
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
    private var _arrCells:Array;

    private var g:Vars = Vars.getInstance();

    public function OptionPanel() {
        _arrCells = [];
        _arrCells = [.75, 1, 1.25, 1.5, 1.75];
        fillBtns();
    }

    private function fillBtns():void {
        _source = new Sprite();
        _source.x = g.stageWidth;
        _source.y = 100;
        g.cont.interfaceCont.addChild(_source);
        _source.visible = false;
        var im:Image;

        _contFullScreen = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_fullscreen"));
        _contFullScreen.addChild(im);
        _source.addChild(_contFullScreen);
        _contFullScreen.hoverCallback = function ():void {
            _contFullScreen.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1)
        };
        _contFullScreen.outCallback = function ():void {
            _contFullScreen.filter = null;
        };
        _contFullScreen.startClickCallback = function ():void {
            onClick('fullscreen');
        };

        _contScalePlus = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_scale_plus"));
        _contScalePlus.addChild(im);
        _contScalePlus.y = 50;
        _source.addChild(_contScalePlus);
        _contScalePlus.hoverCallback = function ():void {
            _contScalePlus.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1)
        };
        _contScalePlus.outCallback = function ():void {
            _contScalePlus.filter = null;
        };
        _contScalePlus.endClickCallback = function ():void {
            onClick('scale_plus');
        };

        _contScaleMinus = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_scale_minus"));
        _contScaleMinus.addChild(im);
        _contScaleMinus.y = 100;
        _source.addChild(_contScaleMinus);
        _contScaleMinus.hoverCallback = function ():void {
            _contScaleMinus.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1)
        };
        _contScaleMinus.outCallback = function ():void {
            _contScaleMinus.filter = null;
        };
        _contScaleMinus.endClickCallback = function ():void {
            onClick('scale_minus');
        };

        _contScreenShot = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_screenshot"));
        _contScreenShot.addChild(im);
        _contScreenShot.y = 150;
        _source.addChild(_contScreenShot);
        _contScreenShot.hoverCallback = function ():void {
            _contScreenShot.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1)
        };
        _contScreenShot.outCallback = function ():void {
            _contScreenShot.filter = null;
        };
        _contScreenShot.endClickCallback = function ():void {
            onClick('screenshot');
        };

        _contAnim = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_anim"));
        _contAnim.addChild(im);
        _contAnim.y = 200;
        _source.addChild(_contAnim);
        _contAnim.hoverCallback = function ():void {
            _contAnim.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1)
        };
        _contAnim.outCallback = function ():void {
            _contAnim.filter = null;
        };
        _contAnim.endClickCallback = function ():void {
            onClick('anim');
        };

        _contMusic = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_music"));
        _contMusic.addChild(im);
        _contMusic.y = 250;
        _source.addChild(_contMusic);
        _contMusic.hoverCallback = function ():void {
            _contMusic.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1)
        };
        _contMusic.outCallback = function ():void {
            _contMusic.filter = null;
        };
        _contMusic.endClickCallback = function ():void {
            onClick('music');
        };

        _contSound = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("option_sound"));
        _contSound.addChild(im);
        _contSound.y = 300;
        _source.addChild(_contSound);
        _contSound.hoverCallback = function ():void {
            _contSound.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1)
        };
        _contSound.outCallback = function ():void {
            _contSound.filter = null;
        };
        _contSound.endClickCallback = function ():void {
            onClick('sound');
        };
    }

    public function showIt():void {
        _source.visible = true;
        var tween:Tween = new Tween(_source, 0.2);
        _source.x = Starling.current.nativeStage.stageWidth;
        tween.moveTo(_source.x - 50, _source.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);
    }

    public function hideIt():void {
        var tween:Tween = new Tween(_source, 0.2);
        tween.moveTo(_source.x + 50, _source.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            _source.visible = false;
        };
        g.starling.juggler.add(tween);
    }

    private function onClick(reason:String):void {
        var i:int;
        switch (reason) {
            case 'fullscreen':
                    try {
                        var func:Function = function(e:flash.events.Event) {
                            Starling.current.nativeStage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, func);
                            if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) {
                                Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
                                Starling.current.viewPort = new Rectangle(0, 0, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
                                Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
                                Starling.current.nativeStage.addEventListener(flash.events.Event.RESIZE, onStageResize);
                                g.starling.stage.stageWidth = Starling.current.nativeStage.stageWidth;
                                g.starling.stage.stageHeight = Starling.current.nativeStage.stageHeight;
                            } else {
                                Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
                                Starling.current.viewPort = new Rectangle(0, 0, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
                                Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
                                g.starling.stage.stageWidth = Starling.current.nativeStage.stageWidth;
                                g.starling.stage.stageHeight = Starling.current.nativeStage.stageHeight;
                            }
                            _contFullScreen.filter = null;
                            makeResizeForGame();
                        };
                        Starling.current.nativeStage.addEventListener(flash.events.MouseEvent.MOUSE_UP, func);
                    } catch (e:Error) {
                        Cc.ch('screen', 'Error:: Trouble with fullscreen: ' + e.message);
                    }
                break;
            case 'scale_plus':
                i = _arrCells.indexOf(g.cont.gameCont.scaleX);
                if (i >= _arrCells.length-1) return;
                i++;
                makeScaling(_arrCells[i]);
                break;
            case 'scale_minus':
                i = _arrCells.indexOf(g.cont.gameCont.scaleX);
                if (i <= 0 ) return;
                i--;
                makeScaling(_arrCells[i]);
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

    private function reportKeyDown(event:KeyboardEvent):void  {
        if (event.keyCode == 27) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
            Starling.current.viewPort = new Rectangle(0, 0,Starling.current.nativeStage.stageWidth,Starling.current.nativeStage.stageHeight);
            Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
            g.starling.stage.stageWidth = Starling.current.nativeStage.stageWidth;
            g.starling.stage.stageHeight = Starling.current.nativeStage.stageHeight;
            makeResizeForGame();
        }
    }

    private function onStageResize(e:flash.events.Event):void {
        Starling.current.nativeStage.removeEventListener(flash.events.Event.RESIZE, onStageResize);
        Starling.current.viewPort = new Rectangle(0, 0, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
        Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
        g.starling.stage.stageWidth = Starling.current.nativeStage.stageWidth;
        g.starling.stage.stageHeight = Starling.current.nativeStage.stageHeight;
        makeResizeForGame();
    }

    private function makeResizeForGame():void {
        var cont:Sprite = g.cont.gameCont;
        var s:Number = cont.scaleX;
        var oY:Number = g.matrixGrid.offsetY*s;
        if (cont.y > -oY) cont.y = -oY;
        if (cont.y < -oY - g.realGameHeight*s + Starling.current.nativeStage.stageHeight)
            cont.y = -oY - g.realGameHeight*s + Starling.current.nativeStage.stageHeight;
        if (cont.x > s*g.realGameWidth/2 - s*MatrixGrid.DIAGONAL/2)
            cont.x =  s*g.realGameWidth/2 - s*MatrixGrid.DIAGONAL/2;
        if (cont.x < -s*g.realGameWidth/2 - s*MatrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth)
            cont.x =  -s*g.realGameWidth/2 - s*MatrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth;
        g.bottomPanel.onResize();
        g.craftPanel.onResize();
        g.friendPanel.onResize();
        g.toolsPanel.onResize();
        g.xpPanel.onResize();
        _source.x = Starling.current.nativeStage.stageWidth;
        _source.y = Starling.current.nativeStage.stageHeight - g.stageHeight + 100;
        if (_source.visible) _source.x -= 50;
    }

    private function makeScaling(s:Number):void {
        var p:Point;
        var cont:Sprite = g.cont.gameCont;
        p = new Point();
        p.x = g.stageWidth/2;
        p.y = g.stageHeight/2;
        p = cont.globalToLocal(p);
        cont.scaleX = cont.scaleY = s;
        p = cont.localToGlobal(p);
        cont.x -= p.x - g.stageWidth/2;
        cont.y -= p.y - g.stageHeight/2;
        var oY:Number = g.matrixGrid.offsetY*s;
        if (cont.y > -oY) cont.y = -oY;
        if (cont.y < -oY - g.realGameHeight*s + g.stageHeight)
            cont.y = -oY - g.realGameHeight*s + g.stageHeight;
        if (cont.x > s*g.realGameWidth/2 - s*MatrixGrid.DIAGONAL/2)
            cont.x =  s*g.realGameWidth/2 - s*MatrixGrid.DIAGONAL/2;
        if (cont.x < -s*g.realGameWidth/2 - s*MatrixGrid.DIAGONAL/2 + g.stageWidth)
            cont.x =  -s*g.realGameWidth/2 - s*MatrixGrid.DIAGONAL/2 + g.stageWidth;
    }
}
}
