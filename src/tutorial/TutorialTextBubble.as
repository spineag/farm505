/**
 * Created by andy on 3/3/16.
 */
package tutorial {
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import windows.WOComponents.HintBackground;

public class TutorialTextBubble {
    private var _source:Sprite;
    private var _bubble:HintBackground;
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _isFlip:Boolean;
    private var _st:String;
    private var _btn:CButton;

    public function TutorialTextBubble(p:Sprite) {
        _parent = p;
        _isFlip = false;
        _source = new Sprite();
        _parent.addChild(_source);
    }

    public function showBubble(st:String, isFlip:Boolean, stBtn:String, callback:Function):void {
        _isFlip = isFlip;
        createBubble();
        _source.addChild(_bubble);
        _bubble.addTextField(20);
        _bubble.setText(st);
        _st = st;
        if (callback != null && stBtn != '') addButton(stBtn, callback);
    }

    private function createBubble():void {
        hideBubble();
        if (_isFlip) {
            _bubble = new HintBackground(500 * g.scaleFactor, 300 * g.scaleFactor, HintBackground.SMALL_TRIANGLE, HintBackground.LEFT_BOTTOM);
            _bubble.x = 46 * g.scaleFactor;
            _bubble.y = -100 * g.scaleFactor;
        } else {
            _bubble = new HintBackground(500 * g.scaleFactor, 300 * g.scaleFactor, HintBackground.SMALL_TRIANGLE, HintBackground.RIGHT_BOTTOM);
            _bubble.x = -46 * g.scaleFactor;
            _bubble.y = -100 * g.scaleFactor;
        }
    }

    private function addButton(btnSt:String, callback:Function):void {
        _btn = new CButton();
        _btn.useFilters = false;
        _btn.addButtonTexture(100, 32, CButton.BLUE, true);
        if (_isFlip) {
            _btn.x = _bubble.x + 150;
        } else {
            _btn.x = _bubble.x - 150;
        }
        _btn.y = _bubble.y + 40;
        _source.addChild(_btn);
        _btn.clickCallback = callback;
        var btnTxt:TextField = new TextField(100, 32, btnSt, g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _btn.addChild(btnTxt);
    }

    public function hideBubble():void {
        if (_btn) {
            if (_source.contains(_btn)) _source.removeChild(_btn);
            _btn.dispose();
            _btn = null;
        }
        if (_bubble) {
            if (_source && _source.contains(_bubble)) _source.removeChild(_bubble);
            _bubble.clearIt();
            _bubble = null;
        }
    }

    public function deleteIt():void {
        hideBubble();
        if (_parent && _parent.contains(_source)) _parent.removeChild(_source);
        _source.dispose();
        _source = null;
        _parent = null;
    }

}
}
