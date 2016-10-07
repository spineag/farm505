/**
 * Created by user on 7/27/15.
 */
package ui.optionPanel {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import flash.display.StageDisplayState;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import map.Containers;

import manager.Vars;

import map.MatrixGrid;

import mouse.ToolsModifier;

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
        _arrCells = [/*.5,*/ .62, .8, 1, 1.25, 1.55];
        fillBtns();
        Starling.current.nativeStage.addEventListener(flash.events.Event.RESIZE, onStageResize);
    }

    private function fillBtns():void {
        _source = new Sprite();
        _source.x = g.stageWidth;
        _source.y = 147;
        g.cont.interfaceCont.addChild(_source);
        _source.visible = false;
        var im:Image;

        _contFullScreen = new CSprite();
        _contFullScreen.nameIt = 'contFullScreen';
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_fs_off"));
        _contFullScreen.addChild(im);
        _contFullScreen.y = 115;
        _source.addChild(_contFullScreen);
        _contFullScreen.hoverCallback = function ():void {
            g.hint.showIt("На весь экран");
        };
        _contFullScreen.outCallback = function ():void {
            g.hint.hideIt();
        };
        _contFullScreen.startClickCallback = function ():void {
            if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) {
                _contFullScreen.removeChild(im);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_fs"));
                _contFullScreen.addChild(im);
            } else {
                _contFullScreen.removeChild(im);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_fs_off"));
                _contFullScreen.addChild(im);
            }
            onClick('fullscreen');
            g.hint.hideIt();
        };

        _contScalePlus = new CSprite();
        _contScalePlus.nameIt = 'contScalePlus';
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_z_in_off"));
        _contScalePlus.addChild(im);
        _contScalePlus.y = 160;
        _source.addChild(_contScalePlus);
        _contScalePlus.hoverCallback = function ():void {
            _contScalePlus.removeChild(im);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_z_in"));
            _contScalePlus.addChild(im);
            g.hint.showIt("Приблизить");
        };
        _contScalePlus.outCallback = function ():void {
            _contScalePlus.removeChild(im);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_z_in_off"));
            _contScalePlus.addChild(im);
            g.hint.hideIt();
        };
        _contScalePlus.endClickCallback = function ():void {
            onClick('scale_plus');
        };

        _contScaleMinus = new CSprite();
        _contScaleMinus.nameIt = 'contScaleMinus';
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_z_out_off"));
        _contScaleMinus.addChild(im);
        _contScaleMinus.y = 205;
        _source.addChild(_contScaleMinus);
        _contScaleMinus.hoverCallback = function ():void {
            _contScaleMinus.removeChild(im);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_z_out"));
            _contScaleMinus.addChild(im);
            g.hint.showIt("Отдалить");
        };
        _contScaleMinus.outCallback = function ():void {
            _contScaleMinus.removeChild(im);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_z_out_off"));
            _contScaleMinus.addChild(im);
            g.hint.hideIt();
        };
        _contScaleMinus.endClickCallback = function ():void {
            onClick('scale_minus');
        };

        _contScreenShot = new CSprite();
        _contScreenShot.nameIt = 'contScreenShot';
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_screen"));
        _contScreenShot.addChild(im);
        _contScreenShot.y = 149;
//        _source.addChild(_contScreenShot);
        _contScreenShot.hoverCallback = function ():void {
            g.hint.showIt("Сделать снимок");
        };
        _contScreenShot.outCallback = function ():void {
            g.hint.hideIt();
        };
        _contScreenShot.endClickCallback = function ():void {
            onClick('screenshot');
        };

        _contAnim = new CSprite();
        _contAnim.nameIt = 'contAnim';
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_a_off"));
        _contAnim.addChild(im);
        _contAnim.y = 205;
//        _source.addChild(_contAnim);
        _contAnim.hoverCallback = function ():void {
            g.hint.showIt("Включить эфекты");
        };
        _contAnim.outCallback = function ():void {
            g.hint.hideIt();
        };
        _contAnim.endClickCallback = function ():void {
            onClick('anim');
        };

        _contMusic = new CSprite();
        _contMusic.nameIt = '_contMusic';
        if (g.soundManager.isPlayingMusic) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_m_on"));
        } else {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_m_off"));
        }
        _contMusic.addChild(im);
        _contMusic.y = 250;
        _source.addChild(_contMusic);
        _contMusic.hoverCallback = function ():void {
            if (g.soundManager.isPlayingMusic) {
                g.hint.showIt("Выключить музыку");
            } else {
                g.hint.showIt("Включить музыку");
            }
        };
        _contMusic.outCallback = function ():void {
            g.hint.hideIt();
        };
        _contMusic.endClickCallback = function ():void {
            onClick('music');
        };

        _contSound = new CSprite();
        _contSound.nameIt = 'contSound';
        if (g.soundManager.isPlayingSound) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_s_on"));
        } else {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_s_off"));
        }
        _contSound.addChild(im);
        _contSound.y = 295;
        _source.addChild(_contSound);
        _contSound.hoverCallback = function ():void {
            if (g.soundManager.isPlayingSound) {
                g.hint.showIt("Выключить звук");
            } else {
                g.hint.showIt("Включить звук");
            }
        };
        _contSound.outCallback = function ():void {
            g.hint.hideIt();
        };
        _contSound.endClickCallback = function ():void {
            onClick('sound');
        };
    }

    public function showIt():void {
        _source.visible = true;
        var tween:Tween = new Tween(_source, 0.2);
        _source.x = Starling.current.nativeStage.stageWidth;
        tween.moveTo(_source.x - 58, _source.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);
    }

    public function hideIt():void {
        var tween:Tween = new Tween(_source, 0.2);
        tween.moveTo(_source.x + 58, _source.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            _source.visible = false;
        };
        g.starling.juggler.add(tween);
    }

    public function get isShowed():Boolean {
        return _source.visible;
    }

    private function onClick(reason:String):void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        var i:int;
        var im:Image;
        switch (reason) {
            case 'fullscreen':
                g.bottomPanel.cancelBoolean(false);
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.toolsModifier.cancelMove();
                    try {
                        var func:Function = function(e:flash.events.Event):void {
                            Starling.current.nativeStage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, func);
                            makeFullScreen();
                            _contFullScreen.filter = null;
//                            makeResizeForGame();
                        };
                        Starling.current.nativeStage.addEventListener(flash.events.MouseEvent.MOUSE_UP, func);
                    } catch (e:Error) {
                        Cc.ch('screen', 'Error:: Trouble with fullscreen: ' + e.message);
                    }
                break;
            case 'scale_plus':
                g.bottomPanel.cancelBoolean(false);
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.toolsModifier.cancelMove();
                if (isAnimScaling) return;
                i = _arrCells.indexOf(g.cont.gameCont.scaleX);
                if (i >= _arrCells.length-1) return;
                i++;
                makeScaling(_arrCells[i]);
                break;
            case 'scale_minus':
                g.bottomPanel.cancelBoolean(false);
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.toolsModifier.cancelMove();
                if (isAnimScaling) return;
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
                while (_contMusic.numChildren) _contMusic.removeChildAt(0);
                g.soundManager.enabledMusic(!g.soundManager.isPlayingMusic);
                g.directServer.updateUserMusic(null);
                if (g.soundManager.isPlayingMusic) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_m_on"));
                    g.soundManager.playMusic();
                } else {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_m_off"));
                }
                _contMusic.addChild(im);
                break;
            case 'sound':
                while (_contSound.numChildren) _contSound.removeChildAt(0);
                g.soundManager.enabledSound(!g.soundManager.isPlayingSound);
                g.directServer.updateUserSound(null);
                if (g.soundManager.isPlayingSound) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_s_on"));
                } else {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("op_bt_s_off"));
                }
                _contSound.addChild(im);
                break;
        }
    }

//    private function reportKeyDown(event:KeyboardEvent):void  {
//        if (event.keyCode == 27) {
//            Cc.info('reportKeyDown: ESC');
//            makeFullScreen();
//            makeResizeForGame();
//        }
//    }

    private function onStageResize(e:flash.events.Event):void {
        Cc.info('event onStageResize');
//        makeFullScreen();
        makeResizeForGame();
    }

    public function makeFullScreen():void {
        Cc.info('makeFullScreen');
        if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) {
//            Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN;
            Starling.current.viewPort = new Rectangle(0, 0, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
//            Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
//            Starling.current.nativeStage.addEventListener(flash.events.Event.RESIZE, onStageResize);
            g.starling.stage.stageWidth = Starling.current.nativeStage.stageWidth;
            g.starling.stage.stageHeight = Starling.current.nativeStage.stageHeight;
        } else {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
            Starling.current.viewPort = new Rectangle(0, 0, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
//            Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
            g.starling.stage.stageWidth = Starling.current.nativeStage.stageWidth;
            g.starling.stage.stageHeight = Starling.current.nativeStage.stageHeight;
        }
    }

    public function makeResizeForGame():void {
        Cc.info('makeResizeForGame');
        var cont:Sprite = g.cont.gameCont;
        var s:Number = cont.scaleX;
        var oY:Number = g.matrixGrid.offsetY*s;
        if (cont.y > oY + g.cont.SHIFT_MAP_Y*s) cont.y = oY + g.cont.SHIFT_MAP_Y*s;
        if (cont.y < -oY - g.realGameTilesHeight*s + Starling.current.nativeStage.stageHeight + g.cont.SHIFT_MAP_Y*s)
            cont.y = -oY - g.realGameTilesHeight*s + Starling.current.nativeStage.stageHeight + g.cont.SHIFT_MAP_Y*s;
        if (cont.x > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s)
            cont.x =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s;
        if (cont.x < -s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth + g.cont.SHIFT_MAP_X*s)
            cont.x =  -s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth + g.cont.SHIFT_MAP_Y*s;
        try {
            g.bottomPanel.onResize();
            g.bottomPanel.onResizePanelFriend();
            g.craftPanel.onResize();
            g.friendPanel.onResize();
            g.toolsPanel.onResize();
            g.xpPanel.onResize();
            g.catPanel.onResize();
            g.windowsManager.onResize();
            if (g.managerVisibleObjects) g.managerVisibleObjects.onResize();
            if (g.managerTips) g.managerTips.onResize();
            _source.x = Starling.current.nativeStage.stageWidth;
            _source.y = Starling.current.nativeStage.stageHeight - g.stageHeight + 147;
            if (_source.visible) _source.x -= 58;
        } catch (e:Error) {
            Cc.stackch('error', 'error at makeResizeForGame::', 10);
        }
        Cc.info('before check tuts for resize');
        if (g.managerTutorial.isTutorial) g.managerTutorial.onResize();
        if (g.managerCutScenes.isCutScene) g.managerCutScenes.onResize();
        if (g.managerHelpers) g.managerHelpers.onResize();
    }

    private var isAnimScaling:Boolean = false;
    public function makeScaling(s:Number, sendToServer:Boolean = true, needQuick:Boolean = false):void {
        var p:Point;
        var pNew:Point;
        var oldScale:Number;
        var cont:Sprite = g.cont.gameCont;
        oldScale = cont.scaleX;
        if (oldScale > s-.05 && oldScale < s+.05) return;
        p = new Point();
        p.x = g.stageWidth/2;
        p.y = g.stageHeight/2;
        p = cont.globalToLocal(p);
        cont.scaleX = cont.scaleY = s;
        p = cont.localToGlobal(p);
        pNew = new Point();
        pNew.x = cont.x - p.x + g.stageWidth/2;
        pNew.y = cont.y - p.y + g.stageHeight/2;
        var oY:Number = g.matrixGrid.offsetY*s;

        if (pNew.y > oY + g.cont.SHIFT_MAP_Y*s) pNew.y = oY + g.cont.SHIFT_MAP_Y*s;
        if (pNew.y < oY - g.realGameHeight*s + Starling.current.nativeStage.stageHeight + g.cont.SHIFT_MAP_Y*s)
            pNew.y = oY - g.realGameHeight*s + Starling.current.nativeStage.stageHeight + g.cont.SHIFT_MAP_Y*s;
        if (pNew.x > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s)
            pNew.x =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s;
        if (pNew.x < -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth - g.cont.SHIFT_MAP_X*s)
            pNew.x =  -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth - g.cont.SHIFT_MAP_X*s;
        cont.scaleX = cont.scaleY = oldScale;
        g.currentGameScale = s;
        if (needQuick) {
            TweenMax.killTweensOf(cont);
            cont.scaleX = cont.scaleY = s;
            cont.x = pNew.x;
            cont.y = pNew.y;
            isAnimScaling = false;
        } else {
            isAnimScaling = true;
            new TweenMax(cont, .5, {x: pNew.x, y: pNew.y, scaleX: s, scaleY: s, ease: Linear.easeOut, onComplete: function ():void {isAnimScaling = false;}});
        }
        if (sendToServer) {
            g.directServer.saveUserGameScale(null);
        }
        Cc.info('Game scale:: ' + s*100 + '%');
    }
}
}
