/**
 * Created by user on 6/15/16.
 */
package tutorial {
import com.greensock.TweenMax;
import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;

public class TutorialCloud {
    private var _source:Sprite;
    private var _bg:Image;
    private var _txt:TextField;
    private var _txtSp:Sprite;
    private var _callback:Function;
    private var _btn:CButton;
    private var _isClickable:Boolean;
    private var g:Vars = Vars.getInstance();

    public function TutorialCloud(f:Function) {
        _callback = f;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'x1/cloud.jpg', onLoad);
    }

    private function onLoad(p:Bitmap):void {
        _isClickable = false;
        _bg = new Image(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'x1/cloud.jpg'].create() as Bitmap));
        delete g.pBitmaps[g.dataPath.getGraphicsPath() + 'x1/cloud.jpg'];
        _source = new Sprite();
        _source.addChild(_bg);
        _txtSp = new Sprite();
        _txt = new TextField(680, 340, '', g.allData.fonts['BloggerBold'], 30, ManagerFilters.TEXT_BLUE);
        _txtSp.addChild(_txt);
        _txtSp.x = 177;
        _txtSp.y = 128;
        _source.addChild(_txtSp);
        _txtSp.touchable = false;
        g.cont.popupCont.addChild(_source);
        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.BLUE, true);
        _btn.x = 500;
        _btn.y = 550;
        var btnTxt:TextField = new TextField(120, 40, 'Далее', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        btnTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(btnTxt);
        _btn.clickCallback = onClick;
        _source.addChild(_btn);
        applyCallback();
    }

    private function applyCallback():void {
        if (_callback != null) {
            _callback.apply();
        }
    }

    public function showText(t:String, f:Function):void {
        _callback = f;
        _txt.text = t;
        _txtSp.alpha = 0;
        TweenMax.to(_txtSp, .5, {alpha:1, onComplete: anim1});
    }

    private function anim1():void {
        _isClickable = true;
    }

    private function onClick():void {
        if (!_isClickable) return;
        TweenMax.to(_txtSp, .5, {alpha:0, onComplete: anim2});
    }

    private function anim2():void {
        _txt.text = '';
        _isClickable = false;
        applyCallback();
    }

    public function deleteIt():void {
        g.cont.popupCont.removeChild(_source);
        _btn.deleteIt();
        _source.dispose();
    }
}
}
