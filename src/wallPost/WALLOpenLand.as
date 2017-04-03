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

    public function WALLOpenLand(callback:Function, params:Array):void {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[473]), null, 'https://505.ninja/content/wall/ok/wall_OK_6.jpg');
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[473]), null, 'https://505.ninja/content/wall/fb/wall_6_eng.jpg');
        } else {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'wall/wall_new_land.jpg', onLoad);
        }
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_new_land.jpg'].create() as Bitmap;
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String(g.managerLanguage.allTexts[473]),bitmap,'interfaceAtlas');
        (g.pBitmaps[st + 'wall/wall_new_land.jpg'] as PBitmap).deleteIt();
        delete g.pBitmaps[st + 'wall/wall_new_land.jpg'];
    }
}
}
