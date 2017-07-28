package social {
import com.adobe.crypto.MD5;
import social.blank.SN_Blank;
import social.blank_FB.SN_Blank_FB;
import social.fb.SN_FB;
import social.ok.SN_OK;
import social.vk.SN_Vkontakte;
import manager.Vars;

public class SocialNetworkSwitch {
    public static var SN_VK_ID:int = 2;
    public static var SN_OK_ID:int = 3;
    public static var SN_FB_ID:int = 4;

    private static var SECRET_KEY_VK:String = '';
    private static var SECRET_KEY:String = '';

    protected static var g:Vars = Vars.getInstance();

    public static function init(channelID:int, flashVars:Object, isDebug:Boolean = true):void {
        switch (channelID) {
            case SN_VK_ID:
                SECRET_KEY = SECRET_KEY_VK;
                if (isDebug) {
                    flashVars["api_id"] = "5448769";
                    flashVars["viewer_id"] = "146353874";
                    flashVars["sid"] = "bdf6b395622ac77221cf8936a953fc34186f3a31be83f5d7a48592cde76a9b9c855b681ed93e7cd107600";
                    flashVars["secret"] = "4d42d4d4e3";
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
                    g.socialNetwork = new SN_Blank(flashVars);
                } else {
                    flashVars["uid"] = flashVars["logged_user_id"];
                    g.socialNetwork = new SN_OK(flashVars);
                }
                g.user.userSocialId =  flashVars["uid"];
                break;
            case SN_FB_ID:
                if (isDebug) {
                    flashVars["uid"] = " 1402089059863470";
//                    flashVars["uid"] = "444635519203361"; // ivan
                    g.socialNetwork = new SN_Blank_FB(flashVars);
                } else {
                    g.socialNetwork = new SN_FB(flashVars);
                }
                break;
            default:
                break;
        }
    }
}
}