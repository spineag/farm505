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
import utils.MCScaler;

import windows.WindowMain;

public class PostDoneTrain extends WindowMain {
    private var _btn:CButton;
    private var _image:Image;
    public function PostDoneTrain() {
        super();
        _woHeight = 430;
        _woWidth = 620;
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_done_train.png',onLoad);

    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_done_train.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        _image = new Image(tex);
        _image.pivotX = _image.width/2;
        _image.pivotY = _image.height/2;
        _source.addChild(_image);
        _btn = new CButton();
        _btn.addButtonTexture(176, 45, CButton.BLUE, true);
        _btn.clickCallback = onClick;
        var txt:TextField = new TextField(100,30,'Рассказать');
        txt.format.setTo(g.allData.bFonts['BloggerBold18'],18,Color.WHITE);
        txt.x = 5;
        txt.y = 7;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_BLUE_COLOR);
        _btn.addChild(txt);
        txt = new TextField(50,50,'100');
        txt.format.setTo(g.allData.bFonts['BloggerBold18'],18,Color.WHITE);
        txt.x = 95;
        txt.y = -2;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_BLUE_COLOR);
        _btn.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("star_small"));
        im.x = 140;
        im.y = 6;
        _btn.addChild(im);
        _btn.y = 180;
        _source.addChild(_btn);
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
        g.managerWallPost.openWindow(ManagerWallPost.DONE_TRAIN,null,100,9);
        super.hideIt();
    }

    override protected function deleteIt():void {
        _btn = null;
        _source = null;
    }
}
}
