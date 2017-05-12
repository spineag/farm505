/**
 * Created by user on 5/31/16.
 */
package windows.wallPost {
import com.junkbyte.console.Cc;

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
import windows.WindowsManager;

public class PostOpenFabric  extends WindowMain {
    private var _btn:CButton;
    private var _image:Image;
    private var _data:Object;
    private var _txt1:CTextField;
    private var _txt2:CTextField;
    private var stUrl:String;
    
    public function PostOpenFabric() {
        super();
        _windowType = WindowsManager.POST_OPEN_FABRIC;
        _woHeight = 510;
        _woWidth = 510;
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
        _data = params[0];
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/fb/wall_5_eng.png';
        } else {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/wall_new_fabric.png';
        }
        g.load.loadImage(stUrl, onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        if (g.pBitmaps) {
            bitmap = g.pBitmaps[stUrl].create() as Bitmap;
            try {
                photoFromTexture(Texture.fromBitmap(bitmap));
            } catch (e:Error) {
                Cc.error('PostOpenFabrica:: ' + e.message);
                hideIt();
            }
        } else {
            Cc.error('PostDoneFabrica no stUrl: ' + stUrl);
            super.hideIt();
        }
    }

    private function photoFromTexture(tex:Texture):void {
        if (!_data) {
            Cc.error('PostOpenFabric:: empty data');
            super.hideIt();
            return;
        }
        _image = new Image(tex);
        _image.pivotX = _image.width/2;
        _image.pivotY = _image.height/2;
        _source.addChild(_image);
        _btn = new CButton();
        _btn.addButtonTexture(200, 45, CButton.BLUE, true);
        _btn.clickCallback = onClick;
        _txt1 = new CTextField(100,30,String(g.managerLanguage.allTexts[291]));
        _txt1.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt1.x = 5;
        _txt1.y = 7;
        _btn.addChild(_txt1);
        _txt2 = new CTextField(50,50,'200');
        _txt2.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt2.x = 119;
        _txt2.y = -2;
        _btn.addChild(_txt2);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins_small"));
        im.x = 165;
        im.y = 8;
        _btn.addChild(im);
        _btn.y = 240;
        _source.addChild(_btn);
        if (g.socialNetworkID != SocialNetworkSwitch.SN_FB_ID) {
            if (_data.image) {
                var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
                if (!texture) {
                    texture = g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon');
                }
            }
            if (texture) {
                im = new Image(texture);
                if (im) {
                    if (_data.id == 3) {
                        im.y = 10;
                        im.x = -115;
                    } else {
                        im.y = -40;
                        im.x = -115;
                    }
                }
                _source.addChild(im);
            }
        }
        createExitButton(hideIt);
    }

    private function onClick():void {
        if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
        }
        g.managerWallPost.postWallpost(ManagerWallPost.NEW_FABRIC,null,200,DataMoney.SOFT_CURRENCY,_data);
        _btn.clickCallback = null;
        hideIt();
    }

    override public function hideIt():void {
        g.managerCats.jumpCatsFunny();
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (_txt1) {
            _btn.removeChild(_txt1);
            _txt1.deleteIt();
            _txt1 = null;
        }
        if (_txt2) {
            _btn.removeChild(_txt2);
            _txt2.deleteIt();
            _txt2 = null;
        }
        _btn = null;
        _source = null;
        _data = null;
        if (g.pBitmaps[stUrl] as PBitmap) {
            (g.pBitmaps[stUrl] as PBitmap).deleteIt();
            delete g.pBitmaps[stUrl];
            g.load.removeByUrl(stUrl);
        }
    }
}

}
