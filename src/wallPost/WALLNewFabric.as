/**
 * Created by user on 5/31/16.
 */
package wallPost {
import flash.display.Bitmap;

import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

import utils.DrawToBitmap;

public class WALLNewFabric {
    protected var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _data:Object;

    public function WALLNewFabric() {
        _source = new Sprite();
    }

    public function showItParams(callback:Function, params:Object):void {
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_new_fabric.jpg',onLoad);
        _data = params;
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_new_fabric.jpg'].create() as Bitmap;
        _source.addChild(Image.fromBitmap(bitmap));
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture) {
                texture = g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon');
            }
        }
        var im:Image = new Image(texture);
        im.x = 200;
        im.y = 160;
        _source.addChild(im);
        var bitMap:Bitmap = DrawToBitmap.drawToBitmap(_source);
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String('ТЫ КРАСАВА ВААААСССЯЯЯЯ, ФАБРИКА ПРОСТО ЧУМААААА'),bitMap,'interfaceAtlas');
    }
}
}
