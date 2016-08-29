/**
 * Created by user on 8/25/15.
 */
package windows.market {
import manager.ManagerFilters;
import manager.ManagerFilters;
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
    public var _btnMinus:CButton;
    public var _btnPlus:CButton;
    private var _plawkaBg:Image;
    private var _txt:TextField;
    private var _curCount:int;
    private var _max:int;
    private var _min:int;
    private var _callback:Function;

    private var g:Vars = Vars.getInstance();

    public function CountBlock() {
        var im:Image;
        _curCount = 0;
        source = new Sprite();
        _btnMinus = new CButton();

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 27, 27);
        _btnMinus.addDisplayObject(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('minus'));
        MCScaler.scale(im, 16, 16);
        im.x = 6;
        im.y = 10;
        _btnMinus.addDisplayObject(im);

        _btnPlus = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 27, 27);
        _btnPlus.addDisplayObject(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 16, 16);
        im.x = 6;
        im.y = 6;
        _btnPlus.addDisplayObject(im);
        _txt = new TextField(50, 30, '0');
        _txt.format.setTo(g.allData.bFonts['BloggerBold18'], 16, Color.WHITE);
        ManagerFilters.setStrokeStyle(_txt, ManagerFilters.TEXT_BROWN_COLOR);
        _plawkaBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka7'));
        _btnPlus.startClickCallback = onStartPlus;
        _btnPlus.clickCallback = onEndPlus;
        _btnMinus.startClickCallback = onStartMinus;
        _btnMinus.clickCallback = onEndMinus;
//        btnFilter();
    }

    public function btnNull():void {
        _btnMinus.filter = null;
        _btnPlus.filter = null;
    }

    public function btnFilter():void {
        _btnMinus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
        _btnPlus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
    }

    public function set setWidth(a:int):void {
        _plawkaBg.width = a;
        _plawkaBg.x = -_plawkaBg.width/2 - 60;
        _plawkaBg.y = -_plawkaBg.height/2 + 5;
        source.addChild(_plawkaBg);
        _txt.x = -_txt.width/2 - 60;
        _txt.y = -_txt.height/2 + 5;
        source.addChild(_txt);
        _btnMinus.x = _plawkaBg.x - _btnMinus.width - 10;
        _btnMinus.y = -_btnMinus.height/2 + 5;
        _btnPlus.x = _plawkaBg.x + _plawkaBg.width + 10;
        _btnPlus.y = -_btnPlus.height/2 + 5;
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
//        _btnMinus.filter = null;
        _btnMinus.setEnabled = true;
        g.gameDispatcher.removeEnterFrame(plusRender);
        if (timer <= 15 && _curCount < _max) {
            _curCount++;
            _txt.text = String(_curCount);
        }
        if (_callback != null) {
            _callback.apply(null, [true]);
        }
        checkPlusBtn();
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
        }
    }

    private function onStartMinus():void {
        timer = 0;
        delta = 0;
        g.gameDispatcher.addEnterFrame(minusRender);
    }

    private function onEndMinus():void {
//        _btnPlus.filter = null;
        _btnPlus.setEnabled = true;
        g.gameDispatcher.removeEnterFrame(minusRender);
        if (timer <= 15 && _curCount > _min) {
            _curCount--;
            _txt.text = String(_curCount);
        }
        if (_callback != null) {
            _callback.apply(null, [false]);
        }
        checkMinusBtn();
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
        }
    }

    private function checkPlusBtn():void {
        if (_curCount >= _max) {
//            _btnPlus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
            _btnPlus.setEnabled = false;
        } else {
//            _btnPlus.filter = null;
            _btnPlus.setEnabled = true;
        }
    }

    private function checkMinusBtn():void {
        if (_curCount <= _min) {
//            _btnMinus.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
            _btnMinus.setEnabled = false;
        } else {
//            _btnMinus.filter = null;
            _btnMinus.setEnabled = true;
        }
    }

    public function deleteIt():void {
//        btnNull();
        source.removeChild(_btnMinus);
        _btnMinus.deleteIt();
        _btnMinus = null;
        source.removeChild(_btnPlus);
        _btnPlus.deleteIt();
        _btnPlus = null;
        source.dispose();
        source = null;
    }

}
}
