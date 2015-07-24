package social {

import com.adobe.crypto.MD5;
import social.vk.SN_Vkontakte;

import manager.Vars;


public class SocialNetworkSwitch {
    public static var SN_VK_DEV:int = 1;
    public static var SN_VK:int = 2;

    protected static var _viewerID:String = "";
    private static var SECRET_KEY_VK_DEV:String = '';
    private static var SECRET_KEY_VK:String = '';
    private static var SECRET_KEY:String = '';

    protected static var g:Vars = Vars.getInstance();

    public static function init(channelID:int, flashVars:Object, isDebug:Boolean = true):void {
        switch (channelID) {
            case SN_VK_DEV:
                SECRET_KEY = SECRET_KEY_VK_DEV;
                if (isDebug) {
                    flashVars["api_id"] = "";
                    flashVars["viewer_id"] = "";
                    flashVars["sid"] = "";
                    flashVars["secret"] = "";
                }

                flashVars["access_key"] = MD5.hash(flashVars["api_id"] + flashVars["viewer_id"] + SECRET_KEY);
                g.socialNetwork = new SN_Vkontakte(flashVars, g.dataPath.getMainPath());
                g.user.userSocialId =  flashVars["viewer_id"];
                break;

            case SN_VK:
                SECRET_KEY = SECRET_KEY_VK;
                if (isDebug) {
                    flashVars["api_id"] = "4993465";
                    flashVars["viewer_id"] = "26373692";
                    flashVars["sid"] = "8fa1681d47756e5f7bbfed77e20857d01278e64c3730fb6e486196a707233403b303cff8e2a2a5b92ff5e";
                    flashVars["secret"] = "15a13237b3";
                }

                flashVars["access_key"] = MD5.hash(flashVars["api_id"] + flashVars["viewer_id"] + SECRET_KEY);
                g.socialNetwork = new SN_Vkontakte(flashVars, g.dataPath.getMainPath());
                g.user.userSocialId =  flashVars["viewer_id"];
                break;
//            case MainGame.SN_OK_ID:
//                if (isDebug) {
//                    flashVars["uid"] = "555480938615";
//                    //g.socialNetwork = new SN_Blank(flashVars, "ok", "http://bt.ok.joyrocks.com/", "http://i1.bt.ok.joyrocks.com/");
//                } else {
////                    g.socialNetwork = new SN_OK(flashVars);
//                }
//                break;
//            case MainGame.SN_MAILRU_ID:
//                if (isDebug) {
//                    flashVars["uid"] = "16517280194407900295";
//                   // g.socialNetwork = new SN_Blank(flashVars, "mm", "http://bt.mm.joyrocks.com/", "http://i1.bt.mm.joyrocks.com/");
//                } else {
////                    g.socialNetwork = new SN_MAIL_RU(flashVars);
//                }
//                break;
            default:
                break;
        }
//        if (isDebug && _viewerID) {
//            v.config.setViewer(_viewerID);
//        }
    }
}
}