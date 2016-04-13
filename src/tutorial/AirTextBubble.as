/**
 * Created by user on 3/18/16.
 */
package tutorial {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import windows.WOComponents.HintBackground;

public class AirTextBubble {
    private var _source:Sprite;
    private var _bg:HintBackground;
    private var _parent:Sprite;
    private var _txt:TextField;
    private var _btn:CButton;
    private var _btnTxt:TextField;
    private var g:Vars = Vars.getInstance();

    public function AirTextBubble() {
        _source = new Sprite();
        _bg = new HintBackground(250, 150, HintBackground.NONE_TRIANGLE);
        _source.addChild(_bg);
        _txt = new TextField(240, 145, "", g.allData.fonts['BloggerBold'], 18, ManagerFilters.TEXT_BROWN);
        _txt.x = 5;
        _txt.y = 5;
        _source.addChild(_txt);
        _btn = new CButton();
        _btn.addButtonTexture(60, 30, CButton.BLUE, true);
        _btn.x = 125;
        _btn.y = 150;
        _btnTxt = new TextField(60, 28, 'Далее', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _btnTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(_btnTxt);
        _source.addChild(_btn);
    }

    public function showIt(st:String, p:Sprite, _x:int, _y:int, callback:Function = null):void {
        _parent = p;
        _txt.text = st;
        _source.x = _x;
        _source.y = _y;
        _parent.addChild(_source);
        if (callback != null) {
            _btn.visible = true;
            _btn.clickCallback = callback;
        } else {
            _btn.visible = false;
        }
    }

    public function hideIt():void {
        _parent.removeChild(_source);
        _parent = null;
    }

    public function deleteIt():void {
        while (_source.numChildren) _source.removeChildAt(0);
        _btn.deleteIt();
        _txt.dispose();
        _btn = null;
        _btnTxt = null;
        _bg.deleteIt();
        _bg = null;
        _source = null;
    }
}
}
