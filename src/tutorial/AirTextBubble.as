/**
 * Created by user on 3/18/16.
 */
package tutorial {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;

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
    private var _catHead:Sprite;
    private var g:Vars = Vars.getInstance();

    public function AirTextBubble() {
        _source = new Sprite();
        _bg = new HintBackground(250, 150, HintBackground.NONE_TRIANGLE);
        _source.addChild(_bg);
        _txt = new TextField(240, 100, "", g.allData.fonts['BloggerBold'], 18, ManagerFilters.TEXT_BROWN);
        _txt.x = 5;
        _txt.y = 5;
        _source.addChild(_txt);
        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.BLUE, true);
        _btn.x = 75;
        _btn.y = 110;
        _btnTxt = new TextField(120, 48, 'Далее', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _btnTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(_btnTxt);
        _source.addChild(_btn);
        createCatHead();
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

    private function createCatHead():void {
        _catHead = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_right'));
        im.scaleX = im.scaleY = .4;
        _catHead.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_icon'));
        im.scaleX = -1;
        im.x = 47;
        im.y = -4;
        _catHead.addChild(im);
        _catHead.x = 180;
        _catHead.y = 90;
        _source.addChild(_catHead);
    }

    public function hideIt():void {
        _parent.removeChild(_source);
        _parent = null;
    }

    public function deleteIt():void {
        while (_source.numChildren) _source.removeChildAt(0);
        _catHead.dispose();
        _catHead = null;
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
