/**
 * Created by user on 5/31/16.
 */
package wallPost {
import flash.display.Bitmap;

import loaders.PBitmap;

import manager.ManagerLanguage;

import manager.Vars;

import social.SocialNetworkSwitch;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

import utils.DrawToBitmap;

public class WALLDoneTrain {
    protected var g:Vars = Vars.getInstance();
    private var stUrl:String;

    public function WALLDoneTrain(callback:Function, params:Array):void {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/ok/wall_OK_2.jpg';
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[468]), null, stUrl);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            if (g.user.language == ManagerLanguage.RUSSIAN) {
                stUrl = g.dataPath.getGraphicsPath() + 'wall/fb/new/fb_2.jpg';
            } else {
                stUrl = g.dataPath.getGraphicsPath() + 'wall/fb/new/fb_2_eng.jpg';
            }
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[468]), null, stUrl);
        } else {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/wall_done_train.jpg';
            g.load.loadImage(stUrl, onLoad);
        }
    }

    private function onLoad(bitmap:Bitmap):void { // only for VK
        bitmap = g.pBitmaps[stUrl].create() as Bitmap;
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String(g.managerLanguage.allTexts[468]),bitmap,'interfaceAtlas');
        (g.pBitmaps[stUrl] as PBitmap).deleteIt();
        delete g.pBitmaps[stUrl];
        g.load.removeByUrl(stUrl);
    }
}
}
