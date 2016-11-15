/**
 * Created by user on 6/15/16.
 */
package tutorial.pretuts {
import com.greensock.TweenMax;
import flash.display.Bitmap;

import loaders.PBitmap;

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;

public class TutorialCloud {
    private var _source:Sprite;
    private var _bg:Image;
    private var _txt:CTextField;
    private var _txtPage:CTextField;
    private var _txtSp:Sprite;
    private var _callback:Function;
    private var _btn:CButton;
    private var _isClickable:Boolean;
    private var g:Vars = Vars.getInstance();
    private var _leftIm:Quad;
    private var _rightIm:Quad;

    public function TutorialCloud(f:Function) {
        _callback = f;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'x1/cloud.jpg', onLoad);
    }

    private function onLoad(p:Bitmap):void {
        _isClickable = false;
        _bg = new Image(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'x1/cloud.jpg'].create() as Bitmap));
        (g.pBitmaps[g.dataPath.getGraphicsPath() + 'x1/cloud.jpg'] as PBitmap).deleteIt();
        delete g.pBitmaps[g.dataPath.getGraphicsPath() + 'x1/cloud.jpg'];
        _source = new Sprite();
        _source.addChild(_bg);
        _txtSp = new Sprite();
        _txt = new CTextField(680, 340, '');
        _txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR);
        _txtSp.addChild(_txt);
        _txtSp.x = 177;
        _txtSp.y = 128;
        _source.addChild(_txtSp);
        _txtSp.touchable = false;
        g.cont.popupCont.addChild(_source);
        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.BLUE, true);
        _btn.x = 500;
        _btn.y = 520;
        var btnTxt:CTextField = new CTextField(120, 40, 'Далее');
        btnTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _btn.addChild(btnTxt);
        _btn.clickCallback = onClick;
        _source.addChild(_btn);
        _txtPage = new CTextField(100, 30, '');
        _txtPage.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR);
        _txtPage.x = 450;
        _txtPage.y = 460;
        _source.addChild(_txtPage);
        applyCallback();
        onResize();
    }

    public function onResize():void {
        _source.x = g.managerResize.stageWidth/2 - 500;
        addIms();
    }

    private function addIms():void {
        if (_leftIm) {
            if (_source.contains(_leftIm)) _source.removeChild(_leftIm);
            _leftIm.dispose();
        }
        if (_rightIm) {
            if (_source.contains(_rightIm)) _source.removeChild(_rightIm);
            _rightIm.dispose();
        }
        var w:int = g.managerResize.stageWidth;
        if (w < 1000 + 10) return;
        _leftIm = new Quad(int(w/2 - 500) + 1, 640);
        _leftIm.x = -_leftIm.width;
        _source.addChild(_leftIm);
        _rightIm = new Quad(int(w/2 - 500) + 1, 640);
        _rightIm.x = 1000;
        _source.addChild(_rightIm);
        _leftIm.touchable = false;
        _rightIm.touchable = false;
    }

    private function applyCallback():void {
        if (_callback != null) {
            _callback.apply();
        }
    }

    public function showText(t:String, f:Function, page:int):void {
        _callback = f;
        _txt.text = t;
        _txtSp.alpha = 0;
        _txtPage.text = String(page) + '/4';
        TweenMax.to(_txtSp, .3, {alpha:1, onComplete: anim1});
    }

    private function anim1():void {
        _isClickable = true;
    }

    private function onClick():void {
        if (!_isClickable) return;
        TweenMax.to(_txtSp, .3, {alpha:0, onComplete: anim2});
    }

    private function anim2():void {
        _txt.text = '';
        _txtPage.text = '';
        _isClickable = false;
        applyCallback();
    }

    public function deleteIt():void {
        g.cont.popupCont.removeChild(_source);
        _source.removeChild(_btn);
        _btn.deleteIt();
        _source.dispose();
    }
}
}
