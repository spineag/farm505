/**
 * Created by user on 5/30/16.
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

public class WALLOpenLand {
    protected var g:Vars = Vars.getInstance();
    private var _source:Sprite;

    public function WALLOpenLand() {
        _source = new Sprite();
    }

    public function showItParams(callback:Function, params:Array):void {
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_new_land.jpg',onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_new_land.jpg'].create() as Bitmap;
        _source.addChild(new Image(Texture.fromBitmap(bitmap)));
        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String('Новая территория открыта! Теперь моя Долина Рукоделия в игре Умелые Лапки стала еще больше!'),bitmap,'interfaceAtlas');
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String('Новая территория открыта! Теперь моя Долина Рукоделия в игре Умелые Лапки стала еще больше!'),
                    null, st + 'wall/wall_new_land.jpg');
        }
//        (g.pBitmaps[st + 'wall/wall_new_land.jpg'] as PBitmap).deleteIt();
//        delete g.pBitmaps[st + 'wall/wall_new_land.jpg'];
    }
}
}
