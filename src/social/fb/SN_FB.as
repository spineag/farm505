/**
 * Created by andy on 3/15/17.
 */
package social.fb {
import com.junkbyte.console.Cc;
import com.vk.CustomEvent;

import flash.display.Bitmap;
import flash.external.ExternalInterface;
import flash.utils.getTimer;

import quest.ManagerQuest;

import social.SocialNetwork;

import starling.display.Quad;

import starling.utils.Color;

import user.Friend;

import utils.CSprite;

public class SN_FB extends SocialNetwork  {
    private static const API_SECRET_KEY:String = "dd3c1b11a323f01a3ac23a3482724c49";

    private var _friendsRest:Array;
    private var _black:CSprite;

    public function SN_FB(flashVars:Object) {
        _friendsRest = [];

        if (ExternalInterface.available) {
            ExternalInterface.addCallback('getProfileHandler', getProfileHandler);
            ExternalInterface.addCallback('getAllFriendsHandler', getAllFriendsHandler);
            ExternalInterface.addCallback('getAppUsersHandler', getAppUsersHandler);
            ExternalInterface.addCallback('getFriendsByIdsHandler', getFriendsByIdsHandler);
            ExternalInterface.addCallback('getTempUsersInfoByIdHandler', getTempUsersInfoByIdCallback);
            ExternalInterface.addCallback('isInGroupCallback', isInGroupCallback);
            ExternalInterface.addCallback('wallPostSave', wallSavePublic);
            ExternalInterface.addCallback('wallPostCancel', wallCancelPublic);
            ExternalInterface.addCallback('onOpenLanguage', onOpenLanguage);
            ExternalInterface.addCallback('onHideLanguage', onHideLanguage);
            ExternalInterface.addCallback('changeLanguage', changeLanguage);
            ExternalInterface.addCallback('successPayment', orderSuccessHandler);
            ExternalInterface.addCallback('failPayment', orderFailHandler);
            ExternalInterface.addCallback('onViralInvite', onViralInviteHandler);
        }
        super(flashVars);
    }

    override public function get currentUID():String {
        return g.user.userSocialId;
    }

    override public function getProfile(uid:String):void {
        super.getProfile(uid);
        ExternalInterface.call("getProfile", uid);
    }

    private function getProfileHandler(e:Object):void {
        Cc.ch('social', 'FB: getProfileHandler:');
        Cc.obj('social', e);
        try {
            g.flashVars["uid"] = String(e.id);
            g.user.userSocialId = String(e.id);
            _paramsUser = {};
            _paramsUser.firstName = String(e.first_name);
            _paramsUser.lastName = String(e.last_name);
            _paramsUser.photo = String(e.picture) || SocialNetwork.getDefaultAvatar();
            _paramsUser.sex = String(e.gender);
            _paramsUser.bdate = String(e.birthday);
//            _paramsUser.timeZone = Number(e.timezone);
//            Cc.ch('social', 'FB: TIMEZONE TIMEZONE TIMEZONE TIMEZONE TIMEZONETIMEZONETIMEZONETIMEZONE TIMEZONETIMEZONETIMEZONETIMEZONETIMEZONETIMEZONETIMEZONETIMEZONETIMEZONE' + _paramsUser.timeZone );
            _userLocale = String(e.locale);

            super.getProfileSuccess(_paramsUser);
        } catch (e:Error) {
            Cc.error("SN_FB:: getProfileHandler crashed");
        }
    }

    override public function getAllFriends():void {
        super.getAllFriends();
        ExternalInterface.call("getAllFriends", g.user.userSocialId);
    }

    private function getAllFriendsHandler(e:Object = null):void {
        Cc.ch('social', 'FB: getAllFriendsHandler:');
        if (e) Cc.obj('social', e);
        var buffer:Object;
        for (var key:String in e) {
            if (key != "method") {
                buffer = e[key];
                setFriendInfo(buffer.id, buffer.first_name, buffer.last_name, buffer.picture.data.url);
                _friendsApp.push(buffer);
            }
        }
        super.getFriendsSuccess("x");
    }

    override public function getTempUsersInfoById(arr:Array):void {
        super.getTempUsersInfoById(arr);
        if (arr && arr.length) {
            //        ExternalInterface.call("getTempUsersInfoById", arr);
            g.directServer.FBgetUsersProfiles(arr, getTempUsersInfoByIdCallbackFromServer);
        } else {
            Cc.error("FB getTempUsersInfoById:: empty array or not exist");
            super.getTempUsersInfoByIdSucces();
        }
    }

    private function getTempUsersInfoByIdCallback(e:Object):void { // from fb
        Cc.ch('social', 'FB: getTempUsersInfoByIdCallback:');
        if (e) Cc.obj('social', e);
        var ar:Array = [];
        var ob:Object;
        for (var key:String in e) {
            ob = {};
            ob.uid = e[key].id;
            ob.first_name = e[key].first_name;
            ob.last_name = e[key].last_name;
            ob.photo_100 = e[key].picture.data.url || SocialNetwork.getDefaultAvatar();
            ar.push(ob);
        }
        g.user.addTempUsersInfo(ar);
        super.getTempUsersInfoByIdSucces();
    }

    private function getTempUsersInfoByIdCallbackFromServer(e:Object):void {
        Cc.ch('social', 'getTempUsersInfoByIdCallbackFromServer:');
        if (e) Cc.obj('social', e);
        var ar:Array = [];
        var ob:Object;
        for (var i:int = 0; i < e.length; i++) {
            ob = {};
            ob.dbId = e[i].id;
            ob.uid = e[i].social_id;
            ob.first_name = e[i].name;
            ob.last_name = e[i].last_name;
            ob.photo_100 = e[i].photo_url;
            if (ob.photo_100 == '' || ob.photo == 'unknown') ob.photo = SocialNetwork.getDefaultAvatar();
            ar.push(ob);
        }
        g.user.addTempUsersInfo(ar);
        super.getTempUsersInfoByIdSucces();
    }

    // friends in App
    override public function getAppUsers():void {
        super.getAppUsers();
        ExternalInterface.call("getAppUsers", g.user.userSocialId);
    }

    private function getAppUsersHandler(e:Object):void {
        Cc.ch('social', 'FB: getAppUsersHandler:');
        var ob:Object = e.context.friends_using_app.data;
        if (e) Cc.obj('social', ob);
        _friendsApp = [];
        for(var st:String in ob) {
            _friendsApp.push(ob[st].id);
        }
        var f:Friend;
        for (var i:int=0; i<_friendsApp.length; i++) {
            f = new Friend();
            f.userSocialId = _friendsApp[i];
            g.user.arrFriends.push(f);
        }
        super.getAppUsersSuccess(_friendsApp);
        if (_friendsApp.length) getFriendsByIDs(_friendsApp); 
    }

    override protected function getFriendsByIDs(friends:Array):void {
        if (!friends || !friends.length) {
            Cc.error("FB getFriendsByIDs:: empty array or not exist");
            super.getTempUsersInfoByIdSucces();
        }
        var arr:Array;
        _friendsApp = friends;
        if (_friendsApp.length > COUNT_PER_ONCE) {
            arr = _friendsApp.slice(0, COUNT_PER_ONCE);
            _friendsApp.splice(0, COUNT_PER_ONCE);
        } else {
            arr = _friendsApp.slice();
            _friendsApp = [];
        }
        super.getFriendsByIDs(arr);
        if (getTimer() - _timerRender < 1000) {
            g.gameDispatcher.addToTimerWithParams(getFriendsByIDsWithDelay, 1000, 1, arr);
        } else {
            _timerRender = getTimer();
            getFriendsByIDsWithDelay(arr);
        }
    }

    private function getFriendsByIDsWithDelay(ids:Array):void {
        ExternalInterface.call("getFriendsByIds", ids);
    }

    private function getFriendsByIdsHandler(e:Object):void {
        Cc.ch('social', 'FB: getFriendsByIdsHandler:');
        Cc.obj('social', e);
        var ob:Object;
        for (var key:String in e) {
            ob = {};
            ob.uid = e[key].id;
            ob.first_name = e[key].first_name;
            ob.last_name = e[key].last_name;
            ob.photo_100 = e[key].picture.data.url || SocialNetwork.getDefaultAvatar();
            g.user.addFriendInfo(ob);
        }
        if (_friendsApp.length) {
            getFriendsByIDs(_friendsApp);
        } else {
            super.getFriendsByIDsSuccess(e);
        }
//        if (g.user.isTester) g.user.checkMiss();
    }

    override public function showInviteWindow():void {
        ExternalInterface.call("showInviteWindowAll", g.user.language);
    }

    override public function showViralInviteWindow():void {
        ExternalInterface.call("showInviteWindowViral");
    }
    
    private function onViralInviteHandler(ar:Array):void {
        super.onViralInvite(ar);
    }

    override public function reloadGame():void {
        try {
            Cc.stackch("info", "SocialNetwork:: game reloading");
            ExternalInterface.call("reloadGame");
        } catch (e:Error) {
            Cc.warn("SocialNetwork:: cannot reload game");
        }
    }

    override public function wallPostBitmap(uid:String, message:String, image:Bitmap, url:String = null, title:String = null, posttype:String = null):void {
        super.wallPostBitmap(uid, message, image, url, title, posttype);
        ExternalInterface.call("makeWallPost", uid, message, url);
    }

    public function wallCancelPublic():void {
        super.wallCancel();
    }

    public function wallSavePublic():void {
        super.wallSave();
    }

    override public function get urlForAnySocialGroup():String {
        return "https://www.facebook.com/";
    }

    public override function checkIsInSocialGroup(id:String):void {
        // temp
        g.managerQuest.onActionForTaskType(ManagerQuest.ADD_TO_GROUP);
         
//        ExternalInterface.call("isInGroup", id, g.user.userSocialId);
        super.checkIsInSocialGroup(id);
    }

    private function isInGroupCallback(status:int):void {
        Cc.obj('social', status, 'is in group');
        if (status == 1) {
            g.managerQuest.onActionForTaskType(ManagerQuest.ADD_TO_GROUP);
//        } else {
//            Link.openURL(urlSocialGroup);
        }
    }
    
    override public function checkUserLanguageForIFrame():void {
        super.checkUserLanguageForIFrame();
        ExternalInterface.call("checkUserLanguageForIFrame", g.user.userSocialId);
    }

    private function onOpenLanguage():void {
        if (_black) return;
        var onBlackClick:Function = function():void {
            ExternalInterface.call("hideLanguage");
            onHideLanguage();
        };
        _black = new CSprite();
        _black.addChild(new Quad(g.managerResize.stageWidth, g.managerResize.stageHeight, Color.BLACK));
        g.cont.mouseCont.addChildAt(_black, 0);
        _black.alpha = .8;
        _black.endClickCallback = onBlackClick;
    }

    private function onHideLanguage():void {
        if (_black) {
            if (g.cont.mouseCont.contains(_black)) g.cont.mouseCont.removeChild(_black);
            _black.deleteIt();
            _black = null;
        }
    }
    
    private function changeLanguage(v:int):void {
        Cc.ch('social', 'change language to: ' + v);
        onHideLanguage();
        g.managerLanguage.changeLanguage(v);
    }

    override public function checkLocaleForLanguage():int {
        var lang:int = 2;
        if (_userLocale == 'ru_RU' || _userLocale == 'be_BY' || _userLocale == 'uk_UA') lang = 1;
        return lang;
    }

    private var orderPackID:int = 0;
    override public function showOrderWindow(e:Object):void {
        if (g.isDebug) {
            super.showOrderWindow(e);
            return;
        }
        orderPackID = e.id;
        ExternalInterface.call("makePayment", e.id, g.user.userSocialId);
        super.showOrderWindow(e);
    }

    private function orderFailHandler():void {
        super.orderFail();
    }

    private function orderSuccessHandler():void {
        g.directServer.onFBTransaction(null, 1, orderPackID);
        super.orderSuccess();
    }

}
}
