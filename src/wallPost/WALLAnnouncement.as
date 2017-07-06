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

public class WALLAnnouncement {
    protected var g:Vars = Vars.getInstance();
    private var stUrl:String;
    private var st:String;

    public function WALLAnnouncement(callback:Function, params:Array) {
        st='';
//        st = String(g.managerLanguage.allTexts[1089]) + ' - ' + String(g.managerLanguage.allTexts[1090] + ' - ' + String(g.managerLanguage.allTexts[1091]));
//        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
//            stUrl = g.dataPath.getGraphicsPath() + 'announcement/share_quests_info_ok.png';
//            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), st, null, stUrl);
//        } else
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            stUrl = g.dataPath.getGraphicsPath() + 'announcement/wall_fb_usa_post.png';
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), st, null, stUrl);
//        } else {
//            stUrl = g.dataPath.getGraphicsPath() + 'announcement/share_quests_info_vk.png';
//            g.load.loadImage(stUrl,onLoad);
        }
    }

    private function onLoad(bitmap:Bitmap):void { // only for VK
        bitmap = g.pBitmaps[stUrl].create() as Bitmap;
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), st, bitmap, 'interfaceAtlas');
        (g.pBitmaps[stUrl] as PBitmap).deleteIt();
        delete g.pBitmaps[stUrl];
        g.load.removeByUrl(stUrl);
    }
}
}
