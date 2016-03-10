/**
 * Created by andy on 3/3/16.
 */
package tutorial {
import com.greensock.TweenMax;

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import windows.WOComponents.HintBackground;

public class CutSceneTextBubble {
    private var _source:Sprite;
    private var _bubble:HintBackground;
    private var _parent:Sprite;
    private var _btn:CButton;
    private var _btnTxt:TextField;
    private var g:Vars = Vars.getInstance();

    public function CutSceneTextBubble(p:Sprite) {
        _parent = p;
        _source = new Sprite();
        _source.y = -130;
        _source.x = 65;
        _parent.addChild(_source);
    }

    public function showBubble(st:String, btnSt:String, callback:Function):void {
        createBubble();
        _source.addChild(_bubble);
        _source.scaleX = _source.scaleY = .3;
        _bubble.addTextField(18);
        _bubble.setText(st);
        if (callback != null) addButton(btnSt, callback);
        TweenMax.to(_source, .3, {scaleX: 1, scaleY: 1});
    }

    private function addButton(btnSt:String, callback:Function):void {
        _btn = new CButton();
        _btn.addButtonTexture(200, 30, CButton.BLUE, true);
        _btn.x = 170;
        _btn.y = 40;
        _source.addChild(_btn);
        _btn.clickCallback = callback;
        _btnTxt = new TextField(200, 30, btnSt, g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _btnTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(_btnTxt);
    }

    private function createBubble():void {
        directHide();
        _bubble = new HintBackground(300, 150, HintBackground.SMALL_TRIANGLE, HintBackground.LEFT_BOTTOM);
    }

    public function hideBubble(f:Function):void {
        if (_bubble) {
            TweenMax.to(_source, .3, {scaleX: .3, scaleY: .3, onComplete: directHide, onCompleteParams: [f]});
        }
    }

    private function directHide(f:Function = null):void {
        if (_bubble) {
            if (_source.contains(_bubble)) _source.removeChild(_bubble);
            _bubble.clearIt();
            _bubble = null;
        }
        if (f != null) {
            f.apply();
        }
    }

    public function reChangeBubble(st:String, btnSt:String, callback:Function):void {
        if (_bubble) {
            TweenMax.to(_source, .3, {scaleX: .3, scaleY: .3, onComplete: onReChange, onCompleteParams: [st, btnSt, callback]});
        } else {
            showBubble(st, btnSt, callback);
        }
    }

    private function onReChange(st:String, btnSt:String, callback:Function):void {
        if (!_btn) {
            addButton(btnSt, callback);
        } else {
            _btnTxt.text = btnSt;
            _btn.clickCallback = callback;
        }
        _bubble.setText(st);
        TweenMax.to(_source, .3, {scaleX: 1, scaleY: 1});
    }

    public function deleteIt():void {
        directHide();
        if (_parent.contains(_source)) _parent.removeChild(_source);
        if (_btn) {
            if (_source.contains(_btn)) _source.removeChild(_btn);
            _btn.dispose();
            _btn = null;
        }
        _source.dispose();
        _source = null;
        _parent = null;
    }
}
}
