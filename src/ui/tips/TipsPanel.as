/**
 * Created by user on 8/8/16.
 */
package ui.tips {
import com.greensock.TweenMax;

import manager.Vars;

import starling.text.TextField;

import utils.CSprite;

public class TipsPanel {
    private var _source:CSprite;
    private var _isShowed:Boolean;
    private var _timer:int;
    private var _txt:TextField;
    private var g:Vars = Vars.getInstance();

    public function TipsPanel() {
        _isShowed = false;
    }

    public function showIt():void {
        if (_isShowed) return;
        _source = new CSprite();
        _source.x = 70;
        _source.y = 150;

        _source.scaleX = _source.scaleY = .9;
        if (!g.cont.interfaceCont.contains(_source)) g.cont.interfaceCont.addChild(_source);
        g.gameDispatcher.addToTimer(onTimer);
        _timer = 7;
        _source.endClickCallback = onClick;
    }

    public function hideIt():void {
        if (!_isShowed) return;
        if (g.cont.interfaceCont.contains(_source)) g.cont.interfaceCont.removeChild(_source);
        g.gameDispatcher.removeFromTimer(onTimer);
        _source.deleteIt();
        _source = null;
    }

    public function get isShowed():Boolean {
        return _isShowed;
    }

    public function updateAvailableActionCount(s:String):void {
        if (_txt) _txt.text = s;
    }

    private function onTimer():void {
        _timer--;
        if (_timer < 0) {
            animateIt();
            _timer = 10;
        }
    }

    private function onClick():void {

    }

    private function animateIt():void {
        TweenMax.to(_source, .2, {scaleX:1, scaleY:1, onComplete: animate2});
    }

    private function animate2():void {
        TweenMax.to(_source, .2, {scaleX:.9, scaleY:.9, onComplete: animate3});
    }

    private function animate3():void {
        TweenMax.to(_source, .2, {scaleX:1, scaleY:1, onComplete: animate4});
    }

    private function animate4():void {
        TweenMax.to(_source, .2, {scaleX:.9, scaleY:.9});
    }

}
}
