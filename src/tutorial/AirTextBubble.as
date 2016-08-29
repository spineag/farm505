/**
 * Created by user on 3/18/16.
 */
package tutorial {
import manager.ManagerFilters;
import manager.Vars;

import particle.tuts.DustRectangle;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;
import utils.CSprite;
import utils.SimpleArrow;

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
    private var _arrow:SimpleArrow;
    private var _fonClickable:CSprite;
    private var _callback:Function;
    private var g:Vars = Vars.getInstance();

    public function AirTextBubble() {
        _source = new Sprite();
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_3'));
        _bg.scaleX = -1;
        _bg.x = _bg.width;
        _source.addChild(_bg);
        _txt = new TextField(260, 90, "");
        _txt.format.setTo(g.allData.bFonts['BloggerBold24'], 20, ManagerFilters.TEXT_BLUE_COLOR);
        _txt.x = 36;
        _txt.y = 32;
        _txt.autoScale = true;
        ManagerFilters.setEmptyStyle(_txt);
        _source.addChild(_txt);
        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.BLUE, true);
        _btn.x = 180;
        _btn.y = 140;
        _btnTxt = new TextField(120, 38, 'Далее');
        _btnTxt.format.setTo(g.allData.bFonts['BloggerBold18'], 18, Color.WHITE);
        _btn.addChild(_btnTxt);
        ManagerFilters.setStrokeStyle(_btnTxt, ManagerFilters.TEXT_BLUE_COLOR);
        _source.addChild(_btn);
        createCatHead();
    }

    public function showIt(st:String, p:Sprite, _x:int, _y:int, callback:Function = null):void {
        _parent = p;
        _txt.text = st;
        _source.x = _x;
        _source.y = _y;
        _callback = callback;
        if (_callback != null) {
            _btn.visible = true;
            _btn.clickCallback = onCallback;
            createClickableFon();
        } else {
            _btn.visible = false;
        }
        _parent.addChild(_source);
    }

    private function onCallback():void {
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
    }

    private function createClickableFon():void {
        if (_fonClickable) return;
        _fonClickable = new CSprite();
        _fonClickable.nameIt = 'airText_fonClickable';
        _fonClickable.addChild(new Quad(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, Color.BLACK));
        _parent.addChild(_fonClickable);
        _fonClickable.alpha = 0;
        _fonClickable.endClickCallback = null;
    }

    private function deleteFonClickable():void {
        if (_fonClickable) {
            _parent.addChildAt(_fonClickable, 0);
            _fonClickable.deleteIt();
            _fonClickable = null;
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

    public function showBtnArrow():void {
        deleteArrow();
        if (_btn && _btn.visible) {
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, _source);
            _arrow.scaleIt(.5);
            _arrow.animateAtPosition(_btn.x, _btn.y + 20);
        }
    }

    private function deleteArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function hideIt():void {
        deleteArrow();
        deleteFonClickable();
        if (_dust) {
            _dust.deleteIt();
            _dust = null;
        }
        _parent.removeChild(_source);
        _parent = null;
    }

    public function deleteIt():void {
        while (_source.numChildren) _source.removeChildAt(0);
        _callback = null;
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
