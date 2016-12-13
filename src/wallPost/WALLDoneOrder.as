/**
 * Created by user on 5/31/16.
 */
package wallPost {
import flash.display.Bitmap;

import loaders.PBitmap;

import manager.Vars;

import social.SocialNetworkSwitch;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

import utils.DrawToBitmap;

public class WALLDoneOrder {
    protected var g:Vars = Vars.getInstance();
    private var _source:Sprite;

    public function WALLDoneOrder() {
        _source = new Sprite();
    }

    public function showItParams(callback:Function, params:Array):void {
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_done_order.jpg',onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_done_order.jpg'].create() as Bitmap;
        _source.addChild(new Image(Texture.fromBitmap(bitmap)));
        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String('Ура! Заказ Лавки в Умелых Лапках готов! За мою хорошую работу Жители Долины Рукоделия меня щедро отблагодарили!'), 
                    bitmap, 'interfaceAtlas');
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            st = 'https://505.ninja/content/wall/ok/wall_OK_1.jpg';
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String('Ура! Заказ Лавки в Умелых Лапках готов! За мою хорошую работу Жители Долины Рукоделия меня щедро отблагодарили!'),
                    null, st);
        }
        (g.pBitmaps[st + 'wall/wall_done_order.jpg'] as PBitmap).deleteIt();
        delete g.pBitmaps[st + 'wall/wall_done_order.jpg'];
    }
}
}
