/**
 * Created by user on 5/31/16.
 */
package wallPost {
import flash.display.Bitmap;

import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import utils.DrawToBitmap;

public class WALLDoneTrain {
    protected var g:Vars = Vars.getInstance();
    private var _source:Sprite;

    public function WALLDoneTrain() {
        _source = new Sprite();
    }

    public function showItParams(callback:Function, params:Array):void {
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_done_train.jpg',onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_done_train.jpg'].create() as Bitmap;
        _source.addChild(Image.fromBitmap(bitmap));
        var bitMap:Bitmap = DrawToBitmap.drawToBitmap(_source);
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String('ТЫ КРАСАВА ВААААСССЯЯЯЯ, СУШАЙ ЗАПОЛНИЛ ЙОООООООООО ЛАВ ЮЮЮ '),bitMap,'interfaceAtlas');
    }
}
}
