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
import utils.CSprite;
import utils.MCScaler;

public class CountBlock {
    public var source:Sprite;
    public var _btnMinus:CSprite;
    public var _btnPlus:CSprite;
    private var _plawkaBg:Image;
    private var _txt:TextField;
    private var _curCount:int;
    private var _max:int;
    private var _min:int;
    private var _callback:Function;

    private var g:Vars = Vars.getInstance();

    public function CountBlock() {
        var im:Image;
        var btn:CButton;
        _curCount = 0;
        source = new Sprite();
        _btnMinus = new CSprite();

        btn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 27, 27);
        btn.addDisplayObject(im);
        btn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('minus'));
        MCScaler.scale(im, 16, 16);
        im.x = 6;
        im.y = 10;
        btn.addChild(im);
        _btnMinus.addChild(btn);

        _btnPlus = new CSprite();
        btn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 27, 27);
        btn.addDisplayObject(im);
        btn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 16, 16);
        im.x = 6;
        im.y = 6;
        btn.addChild(im);
        _btnPlus.addChild(btn);
        _txt = new TextField(50, 30, '0', "Arial", 16, Color.BLACK);
        _plawkaBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka7'));
        _btnPlus.startClickCallback = onStartPlus;
        _btnPlus.endClickCallback = onEndPlus;
        _btnMinus.startClickCallback = onStartMinus;
        _btnMinus.endClickCallback = onEndMinus;
        btnFilter();
    }

    public function btnNull():void {
        _btnMinus.filter = null;
        _btnPlus.filter = null;
    }

    public function btnFilter():void {
//        _btnMinus.filter = filter;
//        _btnPlus.filter = filter;
    }

    public function set setWidth(a:int):void {
        _plawkaBg.width = a;
        _plawkaBg.x = -_plawkaBg.width/2 - 60;
        _plawkaBg.y = -_plawkaBg.height/2 + 5;
        source.addChild(_plawkaBg);
        _txt.x = -_txt.width/2 - 60;
        _txt.y = -_txt.height/2 + 5;
        source.addChild(_txt);
        _btnMinus.x = _plawkaBg.x - _btnMinus.width + 5;
        _btnMinus.y = -_btnMinus.height/2 + 20;
        _btnPlus.x = _plawkaBg.x + _plawkaBg.width + 20;
        _btnPlus.y = -_btnPlus.height/2 + 20;
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
        _btnMinus.filter = null;
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
        _btnPlus.filter = null;
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
//            _btnPlus.filter = filter;
        } else {
            _btnPlus.filter = null;
        }
    }

    private function checkMinusBtn():void {
        if (_curCount <= _min) {
//            _btnMinus.filter = filter;
        } else {
            _btnMinus.filter = null;
        }
    }
}
}
