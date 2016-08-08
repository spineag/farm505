/**
 * Created by user on 5/31/16.
 */
package windows.wallPost {
import com.junkbyte.console.Cc;

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
import utils.MCScaler;

import windows.WindowMain;

public class PostOpenFabric  extends WindowMain {
    private var _btn:CButton;
    private var _image:Image;
    private var _data:Object;
    public function PostOpenFabric() {
        super();
//        if (g.windowsManager.currentWindow) {
//            g.windowsManager.cashWindow = this;
//            return;
//        }
//        g.windowsManager.cashWindow = this;
        _woHeight = 430;
        _woWidth = 620;


    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
        _data = params[0];
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_new_fabric.png',onLoad);
//        g.windowsManager.cashWindow = this;
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_new_fabric.png'].create() as Bitmap;
        try {
            photoFromTexture(Texture.fromBitmap(bitmap));
        } catch (e:Error) {
            Cc.error('PostOpenFabrica:: ' + e.message);
            hideIt();
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
        _btn.addButtonTexture(176, 45, CButton.BLUE, true);
        _btn.clickCallback = onClick;
        var txt:TextField = new TextField(100,30,'Рассказать',g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.x = 5;
        txt.y = 7;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(txt);
        txt = new TextField(50,50,'200',g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.x = 95;
        txt.y = -2;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins_small"));
        im.x = 140;
        im.y = 6;
        _btn.addChild(im);
        _btn.y = 180;
        _source.addChild(_btn);
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture) {
                texture = g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon');
            }
        }
        im = new Image(texture);
        if (_data.id == 3) {
            im.y = -5;
            im.x = -95;
        } else {
            im.y = -75;
            im.x = -95;
        }


        _source.addChild(im);
        createExitButton(hideIt);
    }

    private function onClick():void {
        if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
            Starling.current.viewPort = new Rectangle(0, 0, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
//            Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
            g.starling.stage.stageWidth = Starling.current.nativeStage.stageWidth;
            g.starling.stage.stageHeight = Starling.current.nativeStage.stageHeight;
        }
        g.managerWallPost.openWindow(ManagerWallPost.NEW_FABRIC,null,200,DataMoney.SOFT_CURRENCY,_data);
        hideIt();
    }

    override public function hideIt():void {
//        g.windowsManager.uncasheWindow();
        super.hideIt();
    }

    override protected function deleteIt():void {
        _btn = null;
        _source = null;
        _data = null;
    }
}

}
