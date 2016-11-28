package social {
import com.adobe.crypto.MD5;
import social.blank.SN_Blank;
import social.ok.SN_OK;
import social.vk.SN_Vkontakte;
import manager.Vars;

public class SocialNetworkSwitch {
    public static var SN_VK_DEV:int = 1;
    public static var SN_VK_ID:int = 2;
    public static var SN_OK_ID:int = 3;

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

            case SN_VK_ID:
                SECRET_KEY = SECRET_KEY_VK;
                if (isDebug) {
                    flashVars["api_id"] = "5448769";
                    flashVars["viewer_id"] = "168207096";
                    flashVars["sid"] = "8efb8e8efc94a5f4d163d8a59cde7d767ac9598275043cf576a6e61d446ee39a9f45c144c27eb7f7826b7";
                    flashVars["secret"] = "3380722a54";
//
//                    flashVars["api_id"] = "5448769";
//                    flashVars["viewer_id"] = "8726902";
//                    flashVars["sid"] = "001770cb869652e0f160952d890b821ca4c04e3f0689318af4d13c543e7a3cce00c1268d031db612a2257";
//                    flashVars["secret"] = "0d07042c83";
                }

                flashVars["access_key"] = MD5.hash(flashVars["api_id"] + flashVars["viewer_id"] + SECRET_KEY);
                g.socialNetwork = new SN_Vkontakte(flashVars, g.dataPath.getMainPath());
                g.user.userSocialId =  flashVars["viewer_id"];
                break;
            case SN_OK_ID:
                    // Application ID: 1248696832.
//                     Публичный ключ приложения: CBALJOGLEBABABABA
//                     Секретный ключ приложения:  864364A475EBF25367549586
//                     Ссылка на приложение: http://www.odnoklassniki.ru/game/1248696832

                if (isDebug) {
                    flashVars["uid"] = "555480938615";
                    g.socialNetwork = new SN_Blank(flashVars, "ok", "https://505.ninja/", "https://505.ninja/");
                } else {
                    flashVars["uid"] = flashVars["logged_user_id"];
                    g.socialNetwork = new SN_OK(flashVars);
                }
                g.user.userSocialId =  flashVars["uid"];
                break;
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