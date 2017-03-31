package social {

import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.EventDispatcher;
import flash.external.ExternalInterface;
import flash.geom.Matrix;

import manager.Vars;

import quest.ManagerQuest;

public class SocialNetwork extends EventDispatcher {
    protected var URL_AVATAR_BLANK:String = null;
    protected const COUNT_PER_ONCE:int = 200;

    protected var _flashVars:Object;
    protected var _paramsUser:Object;
    protected var _friendsNoApp:Array;
    protected var _friendsApp:Array;
    protected var _timerRender:uint = 0;
    protected var _userLocale:String = 'none';

    protected static var g:Vars = Vars.getInstance();

    private var _friendsIDs:Array;

    public function SocialNetwork(flashVars:Object) {
        super();

        _flashVars = flashVars;
        if (ExternalInterface.available) {
            try {
                ExternalInterface.addCallback("getLog", getLog);
            } catch (e:Error) {
                Cc.error(e.toString(), "Social network do not use ExternalInterface. Callback getLog ignored.");
            }
        }
    }

    public function checkLocaleForLanguage():int { return 1; }
    public function get userLocale():String { return _userLocale;}
    public function get currentUID():String { return ""; }
    public function get referrer():String { return "unknown"; }
    public function get urlApp():String { return null; }
    public function get urlSocialGroup():String { return null; }
    public function get idSocialGroup():String { return null; }
    public function get urlForAnySocialGroup():String { return ""; }
    public function get protocol():String { return "http"; }
    public function get applicationGUID():String { return _flashVars["applicationGUID"]; }
    public function get channelGUID():String { return _flashVars["channelGUID"]; }
    public function get sessionGUID():String { return _flashVars["sessionGUID"]; }
    public function get friendIDs():Array { return _friendsIDs || []; }
    public function setUserLevel():void {}
    public function checkUserLanguageForIFrame():void { Cc.ch('social', 'checkUserLanguageForIFrame') };

    public function init():void {
        Cc.ch("social", "SocialNetwork:: channel API initialization finished successfully", 14);
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.INIT));
    }

    public function getProfile(uid:String):void {
        Cc.ch("social", "SocialNetwork:: send request to get info about current user with socUID " + uid, 14);
        _paramsUser = {};
    }

    protected function getProfileSuccess(e:Object):void {
        Cc.ch('social', "SocialNetwork:: request to get info about current user completed successfully");
        Cc.obj("social", _paramsUser, "SocialNetwork:: user info", 18);

        g.user.name = _paramsUser.firstName;
        g.user.lastName = _paramsUser.lastName || "";
        g.user.photo = _paramsUser.photo || "";
        g.user.sex = _paramsUser.sex || "";
        g.user.bornDate = _paramsUser.bdate;
//        g.user.city = _paramsUser.city || "";
//        g.user.country = _paramsUser.country || "";
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.GET_PROFILES));
    }

    protected function getProfileErrorAtDebug(e:Object):void {
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.GET_PROFILES));
    }

    public function getAllFriends():void {
        Cc.ch('social', "SocialNetwork:: request to get info about friends of current user");
        _friendsApp = [];
    }

    protected function setFriendInfo(socUID:String, firstName:String, lastName:String = "", photo:String = ""):void {
//        g.user.addFriendsInfo(socUID, firstName, lastName, photo);
    }

    protected function addNoAppFriend(data:Object):void {
        var ob:Object = {};
        ob.name = data.first_name;
        ob.lastName = data.last_name;
        ob.online = data.online;
        ob.photo = data.photo_100;
        ob.userSocialId = data.user_id;
        g.user.arrNoAppFriend.push(ob);
    }

    protected function getFriendsSuccess(e:Object):void {
        Cc.ch('social', "SocialNetwork:: request to get info about friends of current user completed successfully");
        Cc.ch("social", "SocialNetwork:: got " + e + " friends", 18);
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.GET_FRIENDS));
    }

    protected function getFriendsByIDs(ids:Array):void {
        Cc.ch('social', "SocialNetwork:: request to get info by ids about " + ids.length + " friends of current user");
    }

    public function getNoAppFriendsByIDs(ids:Array):void {
        Cc.ch('social', "SocialNetwork:: request to get info by ids about " + ids.length + " no app friends of current user");
    }

    protected function getFriendsByIDsSuccess(params:Object = null):void {
        Cc.ch('social', "SocialNetwork:: request to get info about friends by ids of current user completed successfully");
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.GET_FRIENDS_BY_IDS, false, false, params));
    }

    public function getUsersByIDs(ids:Array):void {
        Cc.ch('social', "SocialNetwork:: request to get info by ids about " + ids.length + " users");
    }

    protected function getUsersByIDsSuccess(params:Object = null):void {
        Cc.ch('social', "SocialNetwork:: request to get info about friends by ids of current user completed successfully");
//        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.GET_USERS_BY_IDS, false, false, params));
    }

    public function getPostsByIds(postIds:String):void {
        Cc.ch('social', "SocialNetwork:: request to get info by ids about " + postIds + " post on wall");
    }

    protected function getPostsByIdsHandler(params:Object = null):void {
        Cc.ch('social', "SocialNetwork:: request to get info about posts by ids of current user completed successfully with params: " + String(params));
//        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.GET_POST_INFO, false, false, params));
    }

    public function getAppUsers():void {
        Cc.ch('social', "SocialNetwork:: request to get info about app friends of current user");
        _friendsApp = [];
    }

    protected function getAppUsersSuccess(e:Object):void {
        Cc.ch('social', "SocialNetwork:: request to get info about friends of current user completed successfully");
        Cc.ch("social", "SocialNetwork:: got " + _friendsApp.length + " app friends", 18);
        //_friendsIDs = _paramsFriends.concat();
//        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.GET_APP_USERS, false, false));
    }

    public function getUsersOnline():void {
        _friendsApp = [];
    }

    public function getTempUsersInfoById(arr:Array):void {
        Cc.ch('social', 'SocialNetwork:: getTempUsersInfoById');
    }

    protected function getTempUsersInfoByIdSucces():void {
        Cc.ch('social', 'SocialNetwork:: getTempUsersInfoByIdSucces');
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, false, false));
    }

    protected function getUsersOnlineSuccess(e:Object):void {
        //dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.GET_USERS_ONLINE, false, false, _paramsFriends));
//        g.user.setOnlineFriends(_paramsFriends);
    }

    public function requestBoxArray(arr:Array, message:String, requestKey:String):void {

    }

    public function requestBox(uid:String, message:String, requestKey:String):void {
        Cc.ch('social', "SocialNetwork:: requestBox for uid " + uid + ".\nMessage: " + message + "\nrequestBox: " + requestKey);
        clearScreen();
    }

    public function saveScreenshotToAlbum(oid:String):void {
        Cc.ch('social', "SocialNetwork:: save screenshot to album of uid " + oid);
    }

    public function wallPost(uid:String, message:String, image:DisplayObject, url:String = null, title:String = null, posttype:String = null, idObj:String = '0'):void {
        Cc.ch('social', "SocialNetwork:: wallpost for uid " + uid + ".\nMessage: " + message + "\nImage: " + image + "\nURL: " + url + "\nTitle: " + title + "\nType: " + posttype);
//        v.plugins.sendActivity("posting", "show", {uids: [g.socialNetwork.currentUID, uid].join(","), typeObj: posttype, idObj: idObj});
        clearScreen();
    }

    public function wallPostBitmap(uid:String, message:String, image:Bitmap, url:String = null, title:String = null, posttype:String = null):void {
        Cc.ch('social', "SocialNetwork:: wallpostBitmap for uid " + uid + " with message: " + message);
        //v.plugins.sendActivity("posting", "show", {uids: [g.socialNetwork.currentUID, uid].join(","), typeObj: posttype, idObj: '0'});
        clearScreen();
    }

    public function showInviteWindow():void {
        Cc.ch('social', "SocialNetwork:: called request to show window of invite friend");
        clearScreen();
    }

    public function showOrderWindow(e:Object):void {
        Cc.ch("social", "SocialNetwork:: show order window. item id: " + e.id, 18);
        clearScreen();
    }

    public function showOfferBox(offer_id:String):void {
        Cc.ch('social', "Show offer window with id" + offer_id);
    }

    protected function wallSave():void {
        Cc.ch('social', "SocialNetwork:: wall post was published");
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.WALL_SAVE, false, false));
        g.managerWallPost.callbackAward();
    }

    protected function wallCancel():void {
        Cc.ch('social', "SocialNetwork:: wall post was canceled");
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.WALL_CANCEL, false, false));
    }

    protected function inviteBoxComplete():void {
        Cc.ch('social', "SocialNetwork:: completed request to show window of invite friend");
//        v.friendsWindow.checkQuest();
        g.managerQuest.onActionForTaskType(ManagerQuest.INVITE_FRIENDS);
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.INVITE_WINDOW_COMPLETE, false, false));
    }

    protected function saveScreenshotToAlbumComplete():void {
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.SAVESCREENSHOT_COMPLETE, false, false));
    }

    protected function orderSuccess():void {
        Cc.ch('social', "SocialNetwork:: order request was successful");
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, false, false));
    }

    protected function orderCancel():void {
        Cc.ch('social', "SocialNetwork:: order request was canceled");
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.ORDER_WINDOW_CANCEL, false, false));
    }

    protected function orderFail():void {
        Cc.ch('social', "SocialNetwork:: order request has failed");
        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.ORDER_WINDOW_FAIL, false, false));
    }
    
    public function checkIsInSocialGroup(id:String):void {
        Cc.ch('social', "SocialNetwork:: check is in social group with id:" + id);
    }


    private function clearScreen():void {
//        if (g.mainStage.displayState == StageDisplayState.FULL_SCREEN) {
//            g.mainStage.displayState = StageDisplayState.NORMAL;
//        }
    }

    private function getLog(obj:Object = null):void {
        try {
            Cc.obj("social", obj, "SocialNetwork:: processing info for sending log with params");
//            ExternalInterface.call("setLog", Cc.getLogHTML());
        } catch (e:Error) {
            Cc.warn("SocialNetwork:: cannot send log");
        }
    }

    public function makeScreenShot(isAfterError:Boolean = false):Bitmap {
        var _bitmap:Bitmap;
        var _matrix:Matrix;
        visiblePanels(false);

        try {
            _bitmap = new Bitmap();
            _matrix = new Matrix();
            _bitmap.bitmapData = new BitmapData(g.mainStage.stageWidth, g.mainStage.stageHeight, false);
            _matrix.translate(0, 0);
        } catch (error:Error) {
            visiblePanels(true);
            if (isAfterError) {
                return null;
            }
            Cc.error("SocialNetwork:: problem with screenshot at draw() with error: " + error.errorID);
            return null;
        }

        visiblePanels(true);
        return _bitmap;
    }

    private function visiblePanels(value:Boolean = false):void {
//        if (v.gameContainer.contains(v.bInterfaceBottom.source)) {
//            !value && g.gameContainer.removeChild(g.bInterfaceBottom.source);
//        } else {
//            value && g.gameContainer.addChild(g.bInterfaceBottom.source);
//        }
    }

    public function reloadGame():void {
        try {
            Cc.stackch("social", "SocialNetwork:: game reloading");
            ExternalInterface.call("FarmNinja.reload");
        } catch (e:Error) {
            Cc.warn("SocialNetwork:: cannot reload game");
        }
    }

    public function getUserGAsid(callback:Function):void {
        function getGAcidfromJS(s:String):void {
            g.user.userGAcid = s;
            Cc.ch('analytic', 'on getting GAcid:: ' + s);
            if (callback != null) {
                callback.apply();
            }
        }
        Cc.ch('analytic', 'try get GAcid');
        try {
            ExternalInterface.addCallback("sendGAcidToAS", getGAcidfromJS);
            ExternalInterface.call("FarmNinja.getUserGAcidForAS");
        } catch (e:Error) {
            Cc.error('SocialNetwork getUserGASid:: error at ExternalInterface');
            g.user.userGAcid = 'undefined';
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function checkLeftMenu():void {
        Cc.ch('social', "SocialNetwork:: checkLeftMenu");
    }

}
}
