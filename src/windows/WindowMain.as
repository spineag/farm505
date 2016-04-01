/**
 * Created by user on 6/2/15.
 */
package windows {
import com.greensock.TweenMax;

import manager.Vars;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CButton;
import utils.CSprite;

public class WindowMain {
    protected var _source:Sprite;
    protected var _btnExit:CButton;
    protected var _bg:Image;
    protected var _woWidth:int;
    protected var _woHeight:int;
    protected var _black:CSprite;
    protected var g:Vars = Vars.getInstance();
    protected var _callbackClickBG:Function;
    public var needAddToPool:Boolean = false;
    protected var _windowType:String;
    public var isCashed:Boolean = false;

    public function WindowMain() {
        _source = new Sprite();
        _source.x = g.stageWidth/2;
        _source.y = g.stageHeight/2;
        _woHeight = 0;
        _woWidth = 0;
    }

    public function get windowType():String {
        return _windowType;
    }

    public function showItParams(callback:Function, params:Array):void { }

    public function showIt():void {
        g.hideAllHints();//?
        createBlackBG();
        _source.x = Starling.current.nativeStage.stageWidth/2;
        _source.y = Starling.current.nativeStage.stageHeight/2;
        g.cont.addGameContListener(false);
//        if (g.currentOpenedWindow) {
//            if (needAddToPool) {
//                g.windowsPool.push(this);
//                return;
//            } else {
//                if (g.currentOpenedWindow) g.currentOpenedWindow.hideIt();
//            }
//        }

        g.cont.windowsCont.addChild(_source);
        _source.scaleX = _source.scaleY = .8;
        TweenMax.to(_source, .2, {scaleX:1, scaleY:1});
        trace('window showIt:: ' + _windowType);
    }

    public function hideIt():void {
        trace('window hideIt:: ' + _windowType);
        if (g.cont.windowsCont.contains(_source))
            TweenMax.to(_source, .1, {scaleX:.8, scaleY:.8, alpha:0, onComplete:onHideAnimation});
        else onHideAnimation();
    }

    private function onHideAnimation():void {
        if (g.cont.windowsCont.contains(_source)) g.cont.windowsCont.removeChild(_source);
        g.cont.addGameContListener(true);
        deleteIt();
        g.windowsManager.onHideWindow();
    }

    protected function deleteIt():void {
        trace('window deleteIt:: ' + _windowType);
        if (_btnExit) {
            _source.removeChild(_btnExit);
            _btnExit.deleteIt();
            _btnExit = null;
        }
        removeBlackBG();
        _callbackClickBG = null;
        _source.dispose();
        _source = null;
    }

    protected function createExitButton(callback:Function):void {
        _btnExit = new CButton();
        _btnExit.addDisplayObject(new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_close')));
        _btnExit.setPivots();
        _btnExit.x = _woWidth/2 - 36;
        _btnExit.y = -_woHeight/2 + 36;
        _source.addChild(_btnExit);
        _btnExit.clickCallback = callback;
    }

//    protected function createTempBG():void {
//        var q:Quad = new Quad(_woWidth, _woHeight, Color.GRAY);
//        q.pivotX = _woWidth/2;
//        q.pivotY = _woHeight/2;
//        _source.addChild(q);
//    }

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
        _black = new CSprite();
        _black.addChild(new Quad(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, Color.BLACK));
        g.cont.windowsCont.addChildAt(_black, 0);
        _black.alpha = .0;
        _black.endClickCallback = onBGClick;
        TweenMax.to(_black, .2, {alpha:.3});
    }

    private function removeBlackBG():void {
        if (_black) {
            _black.endClickCallback = null;
            var blackEnd:Function = function():void {
                if (g.cont.windowsCont.contains(_black)) g.cont.windowsCont.removeChild(_black);
                _black.dispose();
                _black = null;
            };
            TweenMax.to(_black, .2, {alpha:0, onComplete:blackEnd});
        }
    }

    private function onBGClick():void {
        if (_callbackClickBG != null) {
            _callbackClickBG.apply();
        }
    }

    public function releaseFromCash():void {}
}
}
