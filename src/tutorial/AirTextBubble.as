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
    private var _bg:Image;
    private var _parent:Sprite;
    private var _txt:TextField;
    private var _btn:CButton;
    private var _btnTxt:TextField;
    private var _catHead:Sprite;
    private var _dust:DustRectangle;
    private var g:Vars = Vars.getInstance();

    public function AirTextBubble() {
        _source = new Sprite();
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_3'));
        _bg.scaleX = -1;
        _bg.x = _bg.width;
        _source.addChild(_bg);
        _txt = new TextField(260, 90, "", g.allData.fonts['BloggerBold'], 20, ManagerFilters.TEXT_BLUE);
        _txt.x = 36;
        _txt.y = 27;
        _source.addChild(_txt);
        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.BLUE, true);
        _btn.x = 180;
        _btn.y = 140;
        _btnTxt = new TextField(120, 38, 'Далее', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
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
            var f:Function = function():void {
                if (_dust) {
                    _dust.deleteIt();
                    _dust = null;
                }
                if (callback != null) {
                    callback.apply();
                }
            };
            _btn.clickCallback = f;
        } else {
            _btn.visible = false;
        }
    }

    private function createCatHead():void {
        _catHead = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_right'));
        im.scaleX = im.scaleY = .7;
        _catHead.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_icon'));
        im.scaleX = -1.3;
        im.scaleY = 1.3;
        im.x = 75;
        im.y = 16;
        _catHead.addChild(im);
        _catHead.x = 295;
        _catHead.y = 45;
        _source.addChild(_catHead);
    }

    public function showBtnParticles():void {
        _dust = new DustRectangle(_source, 120, 40, 120, 120);
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
        _bg = null;
        _source = null;
    }
}
}
