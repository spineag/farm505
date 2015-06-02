/**
 * Created by user on 6/2/15.
 */
package windows {
import manager.Vars;

import starling.display.Image;
import starling.display.Quad;

import starling.display.Sprite;
import starling.textures.Texture;

import utils.CButton;

public class Window {
    protected var _source:Sprite;
    protected var _btnExit:CButton;
    protected var _bg:Image;
    protected var _woWidth:int;
    protected var _woHeight:int;
    protected var g:Vars = Vars.getInstance();

    public function Window() {
        _source = new Sprite();
        _source.x = g.stageWidth/2;
        _source.y = g.stageHeight/2;
        _woHeight = 0;
        _woWidth = 0;
    }

    public function showIt():void {
        while (g.cont.windowsCont.numChildren) {
            g.cont.windowsCont.removeChildAt(0);
        }
        g.cont.windowsCont.addChild(_source);
    }

    public function hideIt():void {
        while (g.cont.windowsCont.numChildren) {
            g.cont.windowsCont.removeChildAt(0);
        }
    }

    public function destroyedIt():void {

    }

    protected function createExitButton(up:Texture, txt:String ='', click:Texture = null, hover:Texture = null):void {
        _btnExit = new CButton(up, txt, click, hover);
        _btnExit.pivotX = _btnExit.width/2;
        _btnExit.pivotY = _btnExit.height/2;
        _btnExit.x = _woWidth/2;
        _btnExit.y = -_woHeight/2;
        _source.addChild(_btnExit);
    }

    protected function createTempBG(w:int, h:int, color:uint):void {
        var q:Quad = new Quad(w, h, color);
        q.pivotX = w/2;
        q.pivotY = h/2;
        _source.addChild(q);
    }
}
}
