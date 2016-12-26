package social {
import flash.events.Event;

public class SocialNetworkEvent extends Event {
    public static const INIT:String = "init";
    public static const GET_PROFILES:String = "getProfiles";
    public static const GET_FRIENDS:String = "getFriends";
    public static const GET_FRIENDS_BY_IDS:String = "getFriendsByIDs";
    public static const GET_USERS_BY_IDS:String = "getUsersByIDs";
    public static const GET_TEMP_USERS_BY_IDS:String = "getTempUsersByIDs";
    public static const GET_APP_USERS:String = "getAppUsers";
    public static const GET_USERS_ONLINE:String = "getUsersOnline";
    public static const WALL_SAVE:String = "wallSave";
    public static const WALL_CANCEL:String = "wallCancel";
    public static const INVITE_WINDOW_COMPLETE:String = "InviteWindowComplete";
    public static const SAVESCREENSHOT_COMPLETE:String = "SaveScreenshotComplete";
    public static const ORDER_WINDOW_SUCCESS:String = "OrderWindowSuccess";
    public static const ORDER_WINDOW_CANCEL:String = "OrderWindowCancel";
    public static const ORDER_WINDOW_FAIL:String = "OrderWindowFail";

    public static const REQUEST_WINDOW_COMPLETE:String = "RequestWindowComplete";
    public static const GET_POST_INFO:String = "getPostInfo";
    public static const REQUEST_WINDOW_CANCEL:String = "RequestWindowCancel";

    public var params:Object;

    public function SocialNetworkEvent(eventtype:String, bubbles:Boolean = false, cancelable:Boolean = false, params:Object = null) {
        this.params = params;
        super(eventtype, bubbles, cancelable);
    }

}

}