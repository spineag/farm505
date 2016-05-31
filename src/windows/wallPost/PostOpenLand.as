/**
 * Created by user on 5/31/16.
 */
package windows.wallPost {
import data.DataMoney;
import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.ManagerWallPost;
import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import windows.WindowMain;

public class PostOpenLand  extends WindowMain {
    private var _btn:CButton;
    private var _image:Image;
    public function PostOpenLand() {
        super();
        _woHeight = 430;
        _woWidth = 620;
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_new_land.png',onLoad);

    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_new_land.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        _image = new Image(tex);
        _image.pivotX = _image.width/2;
        _image.pivotY = _image.height/2;
        _source.addChild(_image);
        _btn = new CButton();
        _btn.addButtonTexture(172, 45, CButton.BLUE, true);
        _btn.clickCallback = onClick;
        var txt:TextField = new TextField(100,30,'Рассказать',g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.x = 35;
        txt.y = 7;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(txt);
        _btn.y = 180;
        _source.addChild(_btn);
        createExitButton(hideIt);
    }

    private function onClick():void {
        g.managerWallPost.openWindow(ManagerWallPost.NEW_LAND,null,3,DataMoney.HARD_CURRENCY);
    }

    override protected function deleteIt():void {
        _btn = null;
        _source = null;
    }
}
}
