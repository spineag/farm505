/**
 * Created by andy on 6/23/17.
 */
package announcement {
import manager.ManagerWallPost;
import manager.Vars;

import social.SocialNetworkSwitch;

import utils.Utils;
import windows.WindowsManager;

public class ManagerAnnouncement {
    private var g:Vars = Vars.getInstance();
    
    public function ManagerAnnouncement() {
//        if (!g.user.announcement && g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) Utils.createDelay(10, openWO);
    }

    private function openWO():void { g.windowsManager.openWindow(WindowsManager.WO_ANNOUNCEMENT, onClose); }

    private function onClose(isPost:Boolean):void {
        if (isPost) g.managerWallPost.postWallpost(ManagerWallPost.POST_ANNOUNCEMENT,null, 0, 0);
        g.user.announcement = true;
        g.directServer.onShowAnnouncement();
//        if (g.managerCutScenes.isCutScene) return;
//        if (g.managerMiniScenes.isMiniScene) return;
//        if (g.managerQuest) g.managerQuest.showArrowsForAllVisibleIconQuests(3);
    }
}
}
