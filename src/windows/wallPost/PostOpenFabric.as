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
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import windows.WindowMain;

public class PostOpenFabric  extends WindowMain {
    private var _btn:CButton;
    private var _image:Image;
    private var _data:Object;
    public function PostOpenFabric() {
        super();
        _woHeight = 430;
        _woWidth = 620;
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_new_fabric.png',onLoad);
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
        _data = params[0];
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_new_fabric.png'].create() as Bitmap;
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
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture) {
                texture = g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon');
            }
        }
        var im:Image = new Image(texture);
        im.x = -75;
        im.y = -50;
        _source.addChild(im);
        createExitButton(hideIt);
    }

    private function onClick():void {
        g.managerWallPost.openWindow(ManagerWallPost.NEW_FABRIC,null,200,9,_data);
    }

    override protected function deleteIt():void {
        _btn = null;
        _source = null;
    }
}

}
