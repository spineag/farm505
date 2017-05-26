/**
 * Created by user on 5/31/16.
 */
package wallPost {
import flash.display.Bitmap;
import loaders.PBitmap;
import manager.Vars;
import social.SocialNetworkSwitch;

public class WALLForQuest {
    protected var g:Vars = Vars.getInstance();
    private var stUrl:String;

    public function WALLForQuest(callback:Function, params:Array):void {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/quest_posting.jpg';
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[469]), null, stUrl);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/quest_posting_eng.jpg';
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[469]), null, stUrl);
        } else {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/quest_posting.jpg';
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'wall/quest_posting.jpg',onLoad);
        }
    }

    private function onLoad(bitmap:Bitmap):void {
        bitmap = g.pBitmaps[stUrl].create() as Bitmap;
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String(g.managerLanguage.allTexts[469]), bitmap, 'interfaceAtlas');
        (g.pBitmaps[stUrl] as PBitmap).deleteIt();
        delete g.pBitmaps[stUrl];
        g.load.removeByUrl(stUrl);
    }
}
}
