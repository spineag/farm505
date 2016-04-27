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
    protected var _windowType:String;
    protected var _isShowed:Boolean = false;
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
        g.cont.windowsCont.addChild(_source);
        _source.scaleX = _source.scaleY = .8;
        TweenMax.to(_source, .2, {scaleX:1, scaleY:1, alpha: 1, onComplete:onShowingWindow});
        _isShowed = true;
    }

    private function onShowingWindow():void {
        if (g.managerTutorial.isTutorial) g.managerTutorial.checkTutorialCallbackOnShowWindow();
    }

    public function hideIt():void {
        if (g.cont.windowsCont.contains(_source))
            TweenMax.to(_source, .1, {scaleX:.8, scaleY:.8, alpha:0, onComplete:onHideAnimation});
        else onHideAnimation();
    }

    public function hideItQuick():void {
        onHideAnimation();
    }

    private function onHideAnimation():void {
        _isShowed = false;
        if (g.cont.windowsCont.contains(_source)) g.cont.windowsCont.removeChild(_source);
        g.cont.addGameContListener(true);
        removeBlackBG();
        if (!isCashed) deleteIt();
        g.windowsManager.onHideWindow(this);
    }

    protected function deleteIt():void {
        if (_btnExit) {
            _source.removeChild(_btnExit);
            _btnExit.deleteIt();
            _btnExit = null;
        }
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
        _btnExit.createHitArea('bt_close');
        _source.addChild(_btnExit);
        _btnExit.clickCallback = callback;
    }

    protected function grayExitButton(b:Boolean):void {
        if (b) _btnExit.alpha = .5;
        else _btnExit.alpha = 1;
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
        if (_black) return;
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
                if (_black) _black.dispose();
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

    public function releaseFromCash():void {
        showIt();
    }

    public function get isShowed():Boolean {
        return _isShowed;
    }
}
}
