package social {
import com.adobe.crypto.MD5;
import social.blank.SN_Blank;
import social.fb.SN_FB;
import social.ok.SN_OK;
import social.vk.SN_Vkontakte;
import manager.Vars;

public class SocialNetworkSwitch {
    public static var SN_VK_DEV:int = 1;
    public static var SN_VK_ID:int = 2;
    public static var SN_OK_ID:int = 3;
    public static var SN_FB_ID:int = 4;

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
                    flashVars["viewer_id"] = "191561520";
                    flashVars["sid"] = "a6b2d9d7d7644458e3bc6be92e6e0f467d0a0a4d66deeb23c789cb8ad055709449be53466eed12a9bfa23";
                    flashVars["secret"] = "2193ce906d";

//                    flashVars["api_id"] = "5448769";
//                    flashVars["viewer_id"] = "8726902";
//                    flashVars["sid"] = "4c5f68095369c92a12f5a7fe1c808a53e8584e6c82dc1b8787139bf11efd7a059e2ed9cdf5968ecf9c774";
//                    flashVars["secret"] = "e790b2b01a";
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
            case SN_FB_ID:
                if (isDebug) {
                    flashVars["uid"] = "1302214063192215";
                    g.socialNetwork = new SN_Blank(flashVars, "fb", "https://505.ninja/", "https://505.ninja/");
                } else {
                    g.socialNetwork = new SN_FB(flashVars);
                }
                break;
            default:
                break;
        }
        
//        if (isDebug && _viewerID) {
//            v.config.setViewer(_viewerID);
//        }
    }
}
}