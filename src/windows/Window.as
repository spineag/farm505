/**
 * Created by user on 6/2/15.
 */
package windows {
import manager.Vars;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Quad;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CButton;

public class Window {
    protected var _source:Sprite;
    protected var _btnExit:CButton;
    protected var _bg:Image;
    protected var _woWidth:int;
    protected var _woHeight:int;
    protected var _black:Quad;
    protected var g:Vars = Vars.getInstance();
    protected var callbackClickBG:Function;
    public var needAddToPool:Boolean = false;

    public function Window() {
        _source = new Sprite();
        _source.x = g.stageWidth/2;
        _source.y = g.stageHeight/2;
        _woHeight = 0;
        _woWidth = 0;
    }

    public function showIt():void {
        g.hideAllHints();
        createBlackBG();
        _source.x = Starling.current.nativeStage.stageWidth/2;
        _source.y = Starling.current.nativeStage.stageHeight/2;
        g.cont.addGameContListener(false);
        if (g.currentOpenedWindow) {
//            while (g.cont.windowsCont.numChildren) {
//                g.cont.windowsCont.removeChildAt(0);
//            }
            if (needAddToPool) {
                g.windowsPool.push(this);
                return;
            } else {
                if (g.currentOpenedWindow) g.currentOpenedWindow.hideIt();
            }
        }

        g.cont.windowsCont.addChild(_source);
        g.currentOpenedWindow = this;
    }

    public function hideIt():void {
        removeBlackBG();
        while (g.cont.windowsCont.numChildren) {
            g.cont.windowsCont.removeChildAt(0);
        }
        g.currentOpenedWindow = null;
        g.cont.addGameContListener(true);

        if (g.windowsPool.length) {
            g.windowsPool.shift().showIt();
        }
    }

    public function destroyedIt():void {

    }

    protected function createExitButton(up:Texture, txt:String ='', click:Texture = null, hover:Texture = null):void {
        _btnExit = new CButton(up, txt, click, hover);
        _btnExit.pivotX = _btnExit.width*3/4;
        _btnExit.pivotY = _btnExit.height*1/4;
        _source.addChild(_btnExit);
    }

    protected function createTempBG(w:int, h:int, color:uint):void {
        var q:Quad = new Quad(w, h, color);
        q.pivotX = w/2;
        q.pivotY = h/2;
        _source.addChild(q);
    }

    public function get source():Sprite {
        return _source;
    }

    public function onResize():void {
        _source.x = Starling.current.nativeStage.stageWidth/2;
        _source.y = Starling.current.nativeStage.stageHeight/2;
        removeBlackBG();
        createBlackBG();
    }

    private function createBlackBG():void {
        _black = new Quad(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, Color.BLACK);
        _black.x = -Starling.current.nativeStage.stageWidth/2;
        _black.y = -Starling.current.nativeStage.stageHeight/2;
        _source.addChildAt(_black, 0);
        _black.alpha = .3;
        _black.addEventListener(TouchEvent.TOUCH, onBGTouch);
    }

    private function removeBlackBG():void {
        if (_black) {
            _black.removeEventListener(TouchEvent.TOUCH, onBGTouch);
            if (_source.contains(_black))_source.removeChild(_black);
            _black.dispose();
            _black = null;
        }
    }

    private function onBGTouch(te:TouchEvent):void {
        if ( te.getTouch(_black, TouchPhase.ENDED)) {
            if (callbackClickBG != null) {
                callbackClickBG.apply();
            } else {
                hideIt();
            }
        }
    }
}
}
