/**
 * Created by user on 5/30/16.
 */
package wallPost {
import flash.display.Bitmap;

import manager.Vars;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

import utils.DrawToBitmap;

public class WALLOpenCave {
    protected var g:Vars = Vars.getInstance();
    private var _source:Sprite;

    public function WALLOpenCave() {
        _source = new Sprite();
    }

    public function showItParams(callback:Function, params:Array):void {
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_open_cave.jpg',onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_open_cave.jpg'].create() as Bitmap;
        _source.addChild(new Image(Texture.fromBitmap(bitmap)));
        var bitMap:Bitmap = DrawToBitmap.drawToBitmap(Starling.current, _source);
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String('Проход в шахту расчищен! Теперь мы можем самостоятельно добывать руду в Долине Рукоделия!'),bitMap,'interfaceAtlas');
    }
}
}
