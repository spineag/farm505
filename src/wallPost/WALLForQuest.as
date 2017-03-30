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

    public function WALLForQuest(callback:Function, params:Array):void {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID || g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[469]), null, g.dataPath.getGraphicsPath() + 'wall/quest_posting.jpg');
        } else {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'wall/quest_posting.jpg',onLoad);
        }
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/quest_posting.jpg'].create() as Bitmap;
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String(g.managerLanguage.allTexts[469]), bitmap, 'interfaceAtlas');
        (g.pBitmaps[st + 'wall/quest_posting.jpg'] as PBitmap).deleteIt();
        delete g.pBitmaps[st + 'wall/quest_posting.jpg'];
    }
}
}
