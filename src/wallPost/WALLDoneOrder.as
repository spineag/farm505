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

    public function WALLDoneOrder(callback:Function, params:Array) {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[467]), null, 'https://505.ninja/content/wall/ok/wall_OK_1.jpg');
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[467]), null, 'https://505.ninja/content/wall/fb/wall_1_eng.jpg');
        } else {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'wall/wall_done_order.jpg',onLoad);
        }
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_done_order.jpg'].create() as Bitmap;
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[467]), bitmap, 'interfaceAtlas');
        (g.pBitmaps[st + 'wall/wall_done_order.jpg'] as PBitmap).deleteIt();
        delete g.pBitmaps[st + 'wall/wall_done_order.jpg'];
    }
}
}
