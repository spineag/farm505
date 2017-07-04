/**
 * Created by andy on 6/23/17.
 */
package windows.announcement {
import flash.display.Bitmap;

import manager.ManagerFilters;

import starling.display.Image;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;

public class WOAnnouncement extends WindowMain {
    private var _url:String;
    private var _callback:Function;
    private var _btn:CButton;
    private var _txt1:CTextField;
    private var _txt2:CTextField;
    private var _txt3:CTextField;
    private var _woBG:WindowBackground;

    public function WOAnnouncement() {
        super ();
        _woWidth = 720;
        _woHeight = 534;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _url = g.dataPath.getGraphicsPath() + 'announcement/usa_post.png';
    }

    override public function showItParams(callback:Function, params:Array):void {
        _callback = callback;
        g.load.loadImage(_url, onLoad);
    }

    private function onLoad(b:Bitmap):void {
        b = g.pBitmaps[_url].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        b.bitmapData.dispose();
        b = null;
        var bg:Image = new Image(t);
        bg.x = -360;
        bg.y = -266;
        _source.addChild(bg);

        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        _btn = new CButton();
        _btn.addButtonTexture(130,40,CButton.GREEN, true);
        _btn.clickCallback = onClick;
        _btn.y = _woHeight/2;
        var txt:CTextField = new CTextField(130, 40, String(g.managerLanguage.allTexts[291]));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(txt);
        _source.addChild(_btn);

        _txt1 = new CTextField(150, 72, String(g.managerLanguage.allTexts[1089]));
        _txt1.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txt1.x = -_woWidth/2 + 139;
        _txt1.y = -_woHeight/2 + 256;
        _source.addChild(_txt1);
        _txt2 = new CTextField(150, 72, String(g.managerLanguage.allTexts[1090]));
        _txt2.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txt2.x = -_woWidth/2 + 292;
        _txt2.y = -_woHeight/2 + 256;
        _source.addChild(_txt2);
        _txt3 = new CTextField(150, 72, String(g.managerLanguage.allTexts[1091]));
        _txt3.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txt3.x = -_woWidth/2 + 446;
        _txt3.y = -_woHeight/2 + 256;
        _source.addChild(_txt3);

        super.showIt();
    }

    private function onClick():void {
        if (_callback != null) {
            _callback.apply(null, [true]);
        }
        super.hideIt();
    }

    private function onClickExit():void {
        if (_callback != null) {
            _callback.apply(null, [false]);
        }
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (!_source) return;
        delete  g.pBitmaps[_url];
        g.load.removeByUrl(_url);

        _source.removeChild(_woBG);
        _source.removeChild(_txt1);
        _source.removeChild(_txt2);
        _source.removeChild(_txt3);
        _source.removeChild(_btn);
        _woBG.deleteIt();
        _txt1.deleteIt();
        _txt2.deleteIt();
        _txt3.deleteIt();
        _btn.deleteIt();
        super.deleteIt();
    }
}
}
