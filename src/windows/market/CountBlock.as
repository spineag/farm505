/**
 * Created by user on 8/25/15.
 */
package windows.market {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

public class CountBlock {
    public var source:Sprite;
    private var _btnMinus:CButton;
    private var _btnPlus:CButton;
    private var _plawkaBg:Image;
    private var _txt:TextField;
    private var _curCount:int;
    private var _max:int;
    private var _min:int;
    private var _callback:Function;
    private var filter:ColorMatrixFilter;

    private var g:Vars = Vars.getInstance();

    public function CountBlock() {
        _curCount = 0;
        source = new Sprite();
        _btnMinus = new CButton(g.interfaceAtlas.getTexture('minus'), '', g.interfaceAtlas.getTexture('minus'));
        _btnPlus = new CButton(g.interfaceAtlas.getTexture('plus'), '', g.interfaceAtlas.getTexture('plus'));
        _txt = new TextField(50, 30, '0', "Arial", 16, Color.BLACK);
        _plawkaBg = new Image(g.interfaceAtlas.getTexture('plawka7'));
        _btnPlus.startClickCallback = onStartPlus;
        _btnPlus.endClickCallback = onEndPlus;
        _btnMinus.startClickCallback = onStartMinus;
        _btnMinus.endClickCallback = onEndMinus;
        filter = new ColorMatrixFilter();
        filter.adjustSaturation(-1);
    }

    public function set setWidth(a:int):void {
        _plawkaBg.width = a;
        _plawkaBg.x = -_plawkaBg.width/2;
        _plawkaBg.y = -_plawkaBg.height/2;
        source.addChild(_plawkaBg);
        _txt.x = -_txt.width/2;
        _txt.y = -_txt.height/2;
        source.addChild(_txt);
        _btnMinus.x = _plawkaBg.x - _btnMinus.width - 10;
        _btnMinus.y = -_btnMinus.height/2;
        _btnPlus.x = _plawkaBg.x + _plawkaBg.width + 10;
        _btnPlus.y = -_btnPlus.height/2;
        source.addChild(_btnMinus);
        source.addChild(_btnPlus);
    }

    public function set maxValue(a:int):void {
        _max = a;
        if (_max < _curCount) {
            count = _max;
        }
    }

    public function set minValue(a:int):void {
        _min = a;
    }

    public function set count(a:int):void {
        _curCount = a;
        _txt.text = String(_curCount);
    }

    public function get count():int {
        return _curCount;
    }

    public function set onChangeCallback(f:Function):void {
        _callback = f;
    }

    private var delta:int;
    private var timer:int;
    private function onStartPlus():void {
        timer = 0;
        delta = 0;
        g.gameDispatcher.addEnterFrame(plusRender);
    }

    private function onEndPlus():void {
        g.gameDispatcher.removeEnterFrame(plusRender);
        if (timer <= 15 && _curCount < _max) {
            _curCount++;
            _txt.text = String(_curCount);
        }
        if (_callback != null) {
            _callback.apply(null, [true]);
        }
    }

    private function plusRender():void {
        timer++;
        if (timer > 15 && _curCount < _max) {
            delta++;
            _curCount += delta;
            if (_curCount > _max) {
                _curCount = _max;
            }
            _txt.text = String(_curCount);
            checkPlusBtn();
        }
    }

    private function onStartMinus():void {
        timer = 0;
        delta = 0;
        g.gameDispatcher.addEnterFrame(minusRender);
    }

    private function onEndMinus():void {
        g.gameDispatcher.removeEnterFrame(minusRender);
        if (timer <= 15 && _curCount > _min) {
            _curCount--;
            _txt.text = String(_curCount);
        }
        if (_callback != null) {
            _callback.apply(null, [false]);
        }
    }

    private function minusRender():void {
        timer++;
        if (timer > 15 && _curCount > _min) {
            delta++;
            _curCount -= delta;
            if (_curCount < _min) {
                _curCount = _min;
            }
            _txt.text = String(_curCount);
            checkMinusBtn();
        }
    }

    private function checkPlusBtn():void {
        if (_curCount >= _max) {
            _btnPlus.filter = filter;
        } else {
            _btnPlus.filter = null;
        }
    }

    private function checkMinusBtn():void {
        if (_curCount <= _min) {
            _btnMinus.filter = filter;
        } else {
            _btnMinus.filter = null;
        }
    }
}
}
