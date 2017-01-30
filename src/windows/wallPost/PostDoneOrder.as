/**
 * Created by user on 5/31/16.
 */
package windows.wallPost {
import data.DataMoney;
import flash.display.Bitmap;
import flash.display.StageDisplayState;
import flash.geom.Rectangle;

import manager.ManagerFilters;
import manager.ManagerWallPost;

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
    
    public function PostDoneOrder() {
        super();
        _woHeight = 510;
        _woWidth = 510;
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_done_order.png',onLoad);
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_done_order.png'].create() as Bitmap;
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
        txt = new CTextField(120,30,'Рассказать');
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
        g.managerWallPost.openWindow(ManagerWallPost.DONE_ORDER,null,200,DataMoney.SOFT_CURRENCY);
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
    }
}
}
