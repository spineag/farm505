/**
 * Created by user on 6/2/15.
 */
package windows {
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
    protected var closeOnBgClick:Boolean = true;
    protected var _windowType:String;

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
        g.hideAllHints();
        createBlackBG();
        _source.x = Starling.current.nativeStage.stageWidth/2;
        _source.y = Starling.current.nativeStage.stageHeight/2;
        g.cont.addGameContListener(false);
        if (g.currentOpenedWindow) {
            if (needAddToPool) {
                g.windowsPool.push(this);
                return;
            } else {
                if (g.currentOpenedWindow) g.currentOpenedWindow.hideIt();
            }
        }

        g.cont.windowsCont.addChild(_source);
    }

    public function hideIt():void {
        while (g.cont.windowsCont.numChildren) {
            g.cont.windowsCont.removeChildAt(0);
        }
        removeBlackBG();
        g.cont.addGameContListener(true);
        g.windowsManager.onHideWindow();
    }

    protected function deleteIt():void {
        if (_btnExit) {
            _source.removeChild(_btnExit);
            _btnExit.deleteIt();
            _btnExit = null;
        }
        if (_black) {
            _source.removeChild(_black);
            _black.dispose();
            _black = null;
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
        _source.addChild(_btnExit);
        _btnExit.clickCallback = callback;
    }

    protected function createTempBG():void {
        var q:Quad = new Quad(_woWidth, _woHeight, Color.GRAY);
        q.pivotX = _woWidth/2;
        q.pivotY = _woHeight/2;
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
        _black = new CSprite();
        _black.addChild(new Quad(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, Color.BLACK));
        _black.x = -Starling.current.nativeStage.stageWidth/2;
        _black.y = -Starling.current.nativeStage.stageHeight/2;
        _source.addChildAt(_black, 0);
        _black.alpha = .3;
        _black.endClickCallback = onBGClick;
    }

    private function removeBlackBG():void {
        if (_black) {
            _black.endClickCallback = null;
            while (_black.numChildren) _black.removeChildAt(0);
            if (_source.contains(_black))_source.removeChild(_black);
            _black.dispose();
            _black = null;
        }
    }

    private function onBGClick():void {
        if (_callbackClickBG != null) {
            _callbackClickBG.apply();
        } else {
            if (closeOnBgClick) hideIt();
        }
    }
}
}
