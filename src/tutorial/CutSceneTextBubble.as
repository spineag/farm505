/**
 * Created by andy on 3/3/16.
 */
package tutorial {
import com.greensock.TweenMax;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.VAlign;

import utils.CButton;

public class CutSceneTextBubble {
    public static var SMALL:int = 1;
    public static var MIDDLE:int = 2;
    public static var BIG:int = 3;

    private var _source:Sprite;
    private var _parent:Sprite;
    private var _btn:CButton;
    private var _btnExit:CButton;
    private var _type:int;
    private var _innerImage:Image;
    private var _dustRectangle:DustRectangle;
    private var g:Vars = Vars.getInstance();

    public function CutSceneTextBubble(p:Sprite, type:int, stURL:String = '') {
        _type = type;
        _parent = p;
        _source = new Sprite();
        _source.y = -140;
        _source.x = 55;
        _parent.addChild(_source);
        if (stURL != '') {
            _innerImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture(stURL));
        }
    }

    public function showBubble(st:String, btnSt:String, callback:Function, callbackNo:Function=null):void {
        if (callback != null) addButton(btnSt, callback);
        if (callbackNo != null) addNoButton(callbackNo);
        createBubble(st);
        _source.scaleX = _source.scaleY = .3;
        TweenMax.to(_source, .2, {scaleX: 1, scaleY: 1, onComplete:addParticles});
    }

    public function set startClick(f:Function):void {
        if (_btn) {
            _btn.startClickCallback = f;
        }
    }

    private function addButton(btnSt:String, callback:Function):void {
        _btn = new CButton();
        _btn.addButtonTexture(200, 30, CButton.BLUE, true);
        _btn.clickCallback = callback;
        var _btnTxt:TextField = new TextField(200, 30, btnSt, g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _btnTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(_btnTxt);
    }

    private function addNoButton(callback:Function):void {
        _btnExit = new CButton();
        _btnExit.addDisplayObject(new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_close')));
        _btnExit.setPivots();
        _btnExit.createHitArea('bt_close');
        _btnExit.clickCallback = callback;
    }

    private function createBubble(st:String):void {
        var im:Image;
        var txt:TextField;
        switch (_type) {
            case BIG:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_1'));
                im.x = -12;
                im.y = -210;
                if (_innerImage) {
                    _innerImage.x = 201 - _innerImage.width/2;
                    _innerImage.y = -75 - _innerImage.height/2;
                    txt = new TextField(278, 60, st, g.allData.fonts['BloggerBold'], 24, ManagerFilters.TEXT_BLUE_COLOR);
                    txt.x = 62;
                    txt.y = -180;
                } else {
                    if (_btn) {
                        txt = new TextField(278, 132, st, g.allData.fonts['BloggerBold'], 24, ManagerFilters.TEXT_BLUE_COLOR);
                    } else {
                        txt = new TextField(278, 172, st, g.allData.fonts['BloggerBold'], 24, ManagerFilters.TEXT_BLUE_COLOR);
                    }
                    txt.x = 62;
                    txt.y = -180;
                }
                if (_btn) {
                    _btn.x = 203;
                    _btn.y = -10;
                }
                break;
            case MIDDLE:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_2'));
                im.x = -12;
                im.y = -169;
                if (_btn) {
                    _btn.x = 203;
                    _btn.y = -10;
                    txt = new TextField(270, 106, st, g.allData.fonts['BloggerBold'], 24, ManagerFilters.TEXT_BLUE_COLOR);
                } else {
                    txt = new TextField(270, 146, st, g.allData.fonts['BloggerBold'], 24, ManagerFilters.TEXT_BLUE_COLOR);
                }
                txt.x = 62;
                txt.y = -142;

                break;
            case SMALL:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_3'));
                im.x = -15;
                im.y = -116;
                txt = new TextField(268, 80, st, g.allData.fonts['BloggerBold'], 24, ManagerFilters.TEXT_BLUE_COLOR);
                txt.x = 62;
                txt.y = -94;
                if (_btn) {
                    _btn.x = 203;
                    _btn.y = 0;
                }
                break;
        }
        _source.addChild(im);
        if (_innerImage) _source.addChild(_innerImage);
        txt.autoScale = true;
        txt.vAlign = VAlign.CENTER;
        _source.addChild(txt);
        if (_btn) _source.addChild(_btn);
        if (_btnExit) {
            _btnExit.x = im.x + im.width - 20;
            _btnExit.y = im.y + 35;
            _source.addChild(_btnExit);
        }
    }

    public function hideBubble(f:Function, f2:Function):void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        TweenMax.to(_source, .2, {scaleX: .1, scaleY: .1, onComplete: directHide, onCompleteParams: [f, f2]});
    }

    private function directHide(f:Function = null, f2:Function = null):void {
        deleteIt();
        if (f != null) {
            f.apply();
        }
        if (f2 != null) {
            f2.apply();
        }
    }

    private function addParticles():void {
        if (_btn) {
            var p:Point = new Point();
            p.x = _btn.x - _btn.width/2 - 5;
            p.y = _btn.y - _btn.height/2 - 5;
            p = _source.localToGlobal(p);
            _dustRectangle = new DustRectangle(g.cont.popupCont, _btn.width + 10, _btn.height + 10, p.x, p.y);
        }
    }

    private function deleteIt():void {
        if (_parent.contains(_source)) _parent.removeChild(_source);
        if (_btn) {
            if (_source.contains(_btn)) _source.removeChild(_btn);
            _btn.dispose();
            _btn = null;
        }
        _source.dispose();
        _source = null;
        _parent = null;
        _innerImage = null;
    }
}
}
