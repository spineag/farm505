/**
 * Created by user on 7/16/15.
 */
package preloader {
import flash.display.Bitmap;
import loaders.PBitmap;
import manager.ManagerFilters;
import manager.Vars;
import social.SocialNetworkSwitch;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CTextField;

public class StartPreloader {
//    [Embed(source="../../assets/embeds/uho1.jpg")]
//    private const Uho1:Class;
//    [Embed(source="../../assets/embeds/uho2.jpg")]
//    private const Uho2:Class;
    [Embed(source="../../assets/embeds/fb_back_new.jpg")]
    private const BigBackground:Class;

    private var _source:Sprite;
    private var _bg:Image;
    private var _quad:Quad;
    private var _txt:CTextField;
    private var _leftIm:Image;
    private var _rightIm:Image;
    private var _txtHelp:CTextField;
    private var _jpgUrl:String;
    private var _callbackInit:Function;
    private var _whiteQuad:Quad;
    private var _whiteShift:int = 2;
    private var _bigBG:Image;

    private var g:Vars = Vars.getInstance();

    public function StartPreloader(f:Function) {
        var arBGs:Array;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) arBGs = ['list_of_tips_decor_eng', 'list_of_tips_farm_stand_eng', 'list_of_tips_inventory_eng'];
            else arBGs = ['list_of_tips_decor_rus', 'list_of_tips_farm_stand_rus', 'list_of_tips_inventory_rus'];
        _jpgUrl = g.dataPath.getGraphicsPath() + 'preloader/' + arBGs[int(Math.random()*arBGs.length)] + '.jpg';
        _callbackInit = f;
        _source = new Sprite();
        g.load.loadImage(_jpgUrl, onLoad);
        _quad = new Quad(3, 3, 0x33a2f4);
        _quad.x = 410;
        _quad.y = 609;
        _quad.visible = false;
        _source.addChild(_quad);
        _txt = new CTextField(75,50,'0');
        _txt.setFormat(CTextField.BOLD24, 24, 0x0659b6);
        _source.addChild(_txt);
        _txt.x = 530;
        _txt.y = 536;
        _txt.visible = false;
//        createBitmap();
//        addIms();
        addBG();
        onResize();
    }

    private function addBG():void {
        var b:Bitmap = new BigBackground();
        _bigBG = new Image(Texture.fromBitmap(b));
        _bigBG.x = 500 - _bigBG.width/2;
        _bigBG.y = 320 - _bigBG.height/2;
        _source.addChildAt(_bigBG, 0);
        g.cont.popupCont.addChild(_source);
        g.pBitmaps['bigBG'] = new PBitmap(b);
    }

    private function onLoad(b:Bitmap):void {
        _whiteQuad = new Quad(1000 + 2*_whiteShift, 640 + 2*_whiteShift, Color.WHITE);
        _whiteQuad.x = -_whiteShift;
        _whiteQuad.y = -_whiteShift;
        _source.addChildAt(_whiteQuad, 1);
        _bg = new Image(Texture.fromBitmap(g.pBitmaps[_jpgUrl].create() as Bitmap));
        _source.addChildAt(_bg, 2);
        (g.pBitmaps[_jpgUrl] as PBitmap).deleteIt();
        delete g.pBitmaps[_jpgUrl];
        g.load.removeByUrl(_jpgUrl);
        _txt.visible = true;
        _quad.visible = true;
        onResize();
        if (_callbackInit != null) {
            _callbackInit.apply();
        }
    }

//    private function createBitmap():void {
//        var b:Bitmap;
//        b = new Uho1();
//        g.pBitmaps['uho1'] = new PBitmap(b);
//        b = new Uho2();
//        g.pBitmaps['uho2'] = new PBitmap(b);
//    }

    public function setProgress(a:int):void {
        _quad.scaleX = a;
        _txt.text = String(a + '%');
    }

    public function onResize():void {
        if (!_source) return;
        _source.x = g.managerResize.stageWidth/2 - 500;
        _source.y = g.managerResize.stageHeight/2 - 320;
    }

//    private function addIms():void {
//        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) return;
//        if (!_bottomGreen && g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
//            _bottomGreen = new Quad(g.managerResize.stageWidth + 80, 700, 0x68c401);
//            _bottomGreen.x = -_bottomGreen.width/2 + 500;
//            _bottomGreen.y = 640;
//            _source.addChild(_bottomGreen);
//        }
//        if (!_leftIm) {
//            _leftIm = new Image(Texture.fromBitmap(g.pBitmaps['uho1'].create() as Bitmap));
//            _leftIm.x = -_leftIm.width + 2;
//            _source.addChild(_leftIm);
//            _leftIm.touchable = false;
//        }
//        if (!_rightIm) {
//            _rightIm = new Image(Texture.fromBitmap(g.pBitmaps['uho2'].create() as Bitmap));
//            _rightIm.x = 1000;
//            _source.addChild(_rightIm);
//            _rightIm.touchable = false;
//        }
//    }

    public function textHelp(str:String):void {
        _txtHelp = new CTextField(1000, 640,str);
        _txtHelp.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtHelp.y = 275;
        _source.addChild(_txtHelp);
    }

    public function hideIt():void {
        if (!_source) return;
        if (_source) {
            g.cont.popupCont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
        }
        if (_txt) _txt.deleteIt();
        if (_txtHelp) _txtHelp.deleteIt();
        if (_bg)_bg.dispose();
        if (_bigBG) _bigBG.dispose();
        if (_whiteQuad) _whiteQuad.dispose();
        _leftIm = _rightIm = null;
        _source.dispose();
        _source = null;
    }
}
}
