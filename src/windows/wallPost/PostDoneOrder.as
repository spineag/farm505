/**
 * Created by user on 5/31/16.
 */
package windows.wallPost {
import data.DataMoney;
import flash.display.Bitmap;
import flash.display.StageDisplayState;
import flash.geom.Rectangle;

import loaders.PBitmap;

import manager.ManagerFilters;
import manager.ManagerWallPost;

import social.SocialNetworkSwitch;

import starling.core.Starling;
import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WindowMain;

public class PostDoneOrder extends WindowMain {
    private var _btn:CButton;
    private var _image:Image;
    private var txt:CTextField;
    private var stUrl:String;
    
    public function PostDoneOrder() {
        super();
        _woHeight = 510;
        _woWidth = 510;
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/fb/wall_1_eng.png';
        } else {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/wall_done_order.png';
        }
        g.load.loadImage(stUrl, onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        bitmap = g.pBitmaps[stUrl].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        _image = new Image(tex);
        _image.pivotX = _image.width/2;
        _image.pivotY = _image.height/2;
        _source.addChild(_image);
        _btn = new CButton();
        _btn.addButtonTexture(200, 45, CButton.BLUE, true);
        _btn.clickCallback = onClick;
        txt = new CTextField(120,30,String(g.managerLanguage.allTexts[291]));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = 5;
        txt.y = 7;
        _btn.addChild(txt);
        txt = new CTextField(50,50,'200');
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = 119;
        txt.y = -2;
        _btn.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins_small"));
        im.x = 165;
        im.y = 8;
        _btn.addChild(im);
        _btn.y = 240;
        _source.addChild(_btn);
        createExitButton(hideIt);
    }

    private function onClick():void {
        if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
        }
        g.managerWallPost.postWallpost(ManagerWallPost.DONE_ORDER,null,200,DataMoney.SOFT_CURRENCY);
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (txt) {
            _btn.removeChild(txt);
            txt.deleteIt();
            txt = null;
        }
        _btn = null;
        _source = null;
        (g.pBitmaps[stUrl] as PBitmap).deleteIt();
        delete g.pBitmaps[stUrl];
    }
}
}
