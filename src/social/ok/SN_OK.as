package social.ok {
import com.junkbyte.console.Cc;
import data.DataMoney;
import flash.display.Bitmap;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.utils.getTimer;
import quest.ManagerQuest;
import social.SocialNetwork;
import user.Friend;

public class SN_OK extends SocialNetwork {
    private static const API_SECRET_KEY:String = "864364A475EBF25367549586";

    private var _friendsRest:Array;

    public function SN_OK(flashVars:Object) {
        flashVars["channelGUID"] ||= "6697c149-8270-48fb-b3e5-8cea9f04e307";

        _friendsRest = [];
        URL_AVATAR_BLANK = g.dataPath.getGraphicsPath() + "/social/iconNeighbor.png";

        if (ExternalInterface.available) {
//            ExternalInterface.addCallback('onConnect', onConnect);
            ExternalInterface.addCallback('getProfileHandler', getProfileHandler);
            ExternalInterface.addCallback('getAllFriendsHandler', getAllFriendsHandler);
            ExternalInterface.addCallback('getUsersInfoHandler', getUsersInfoHandler);
            ExternalInterface.addCallback('getAppUsersHandler', getAppUsersHandler);
            ExternalInterface.addCallback('getFriendsByIdsHandler', getFriendsByIdsHandler);
            ExternalInterface.addCallback('onPaymentCallback', onPaymentCallback);
            ExternalInterface.addCallback('getTempUsersInfoByIdHandler', getTempUsersInfoByIdCallback);
            ExternalInterface.addCallback('isInGroupCallback', isInGroupCallback);
            ExternalInterface.addCallback('wallPostSave', wallSavePublic);
            ExternalInterface.addCallback('wallPostCancel', wallCancelPublic);
        }
        super(flashVars);
    }

    override public function get currentUID():String {
        return _flashVars["logged_user_id"];
    }

    override public function get referrer():String {
        var result:String;

        result = _flashVars["custom_args"] || _flashVars["refplace"] || "direct";
        if (result == "param" || result == "customAttr=customValue") {
            result = "friend_invitation";
        }
        if (result == "param1=wall") {
            result = "friend_feed";
        }
        if (_flashVars["first_start"] == "1" && result == "user_apps") {
            result = "unknown";
        }

        return result;
    }

    override public function get urlApp():String {
        return "https://ok.ru/game/1248696832";
    }

    override public function getProfile(uid:String):void {
        super.getProfile(uid);
        ExternalInterface.call("getProfile", uid, ["first_name", "last_name", "pic_5", "gender", "birthday"]);
    }

    private function getProfileHandler(e:Object):void {
        Cc.ch('social', 'OK: getProfileHandler:');
        Cc.obj('social', e);
        try {
            _paramsUser = {};
            _paramsUser.firstName = String(e.first_name);
            _paramsUser.lastName = String(e.last_name);
            _paramsUser.photo = String(e.pic_5) || URL_AVATAR_BLANK;
            _paramsUser.sex = String(e.gender);
            _paramsUser.bdate = String(e.birthday);

            super.getProfileSuccess(_paramsUser);
        } catch (e:Error) {
            Cc.error("SN_OK:: getProfileHandler crashed");
        }
    }

    override public function getAllFriends():void {
        super.getAllFriends();
        ExternalInterface.call("getAllFriends", g.user.userSocialId);
    }

    private function getAllFriendsHandler(e:Object = null):void {
        Cc.ch('social', 'OK: getAllFriendsHandler:');
        if (e) Cc.obj('social', e);
        var friends:Array = e as Array;
        if (!friends.length) {
            super.getFriendsSuccess(0);
            return;
        }
        _friendsRest = friends.slice(100);
        ExternalInterface.call("getUsersInfo", friends.slice(0, 100), ["first_name", "last_name", "pic_5"]);
    }

    private function getUsersInfoHandler(e:Object):void {
        Cc.ch('social', 'OK: getUsersInfoHandler:');
        Cc.obj('social', e);
        var buffer:Object;
        if (!e) {
            super.getFriendsSuccess(0);
            return;
        }
        if (e.error_code) {
            Cc.obj('error', e, "OK get friends error:");
        }
        for (var key:String in e) {
            if (key != "method") {
                buffer = e[key];
                setFriendInfo(buffer.uid, buffer.first_name, buffer.last_name, buffer.pic_5);
                _friendsApp.push(buffer);
            }
        }
        if (_friendsRest.length) {
            getAllFriendsHandler(_friendsRest);
        } else {
            super.getFriendsSuccess("x");
        }
    }

    override public function getTempUsersInfoById(arr:Array):void {
        super.getTempUsersInfoById(arr);
        ExternalInterface.call("getTempUsersInfoById", arr, ["first_name", "last_name", "pic_5"]);
    }

    private function getTempUsersInfoByIdCallback(e:Object):void {
        Cc.ch('social', 'OK: getTempUsersInfoByIdCallback:');
        if (e) Cc.obj('social', e);
        var ar:Array = [];
        var ob:Object;
        for (var key:String in e) {
            ob = {};
            ob.uid = e[key].uid;
            ob.first_name = e[key].first_name;
            ob.last_name = e[key].last_name;
            ob.photo_100 = e[key].pic_5;
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
        Cc.ch('social', 'OK: getAppUsersHandler:');
        if (e) Cc.obj('social', e);
        _friendsApp = e["uids"] as Array;
        var f:Friend;
        for (var i:int=0; i<_friendsApp.length; i++) {
            f = new Friend();
            f.userSocialId = _friendsApp[i];
            g.user.arrFriends.push(f);
        }
        super.getAppUsersSuccess(_friendsApp);
        if (_friendsApp.length) this.getFriendsByIDs(_friendsApp);
    }

    override protected function getFriendsByIDs(friends:Array):void {
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
        var arr:Array = [];
        for (var i:int = 0; i < ids.length; i++) {
            arr.push(ids[i]);
        }
        ExternalInterface.call("getFriendsByIds", arr, ["first_name", "last_name", "pic_5"]);
    }

    private function getFriendsByIdsHandler(e:Object):void {
        Cc.ch('social', 'OK: getFriendsByIdsHandler:');
        Cc.obj('social', e);
        var ob:Object;
        for (var key:String in e) {
            ob = {};
            ob.uid = e[key].uid;
            ob.first_name = e[key].first_name;
            ob.last_name = e[key].last_name;
            ob.photo_100 = e[key].pic_5;
            g.user.addFriendInfo(ob);
        }
        if (_friendsApp.length) {
            getFriendsByIDs(_friendsApp);
        } else {
            super.getFriendsByIDsSuccess(e);
        }
    }

    override public function getUsersOnline():void {
        super.getUsersOnline();
    }

    private function getUsersOnlineHandler(e:Object):void {
        _friendsApp = e as Array;
        super.getUsersOnlineSuccess(_friendsApp);
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

    override public function requestBox(uid:String, message:String, requestKey:String):void {
        showInviteWindow();
    }

    override public function showInviteWindow():void {
        ExternalInterface.call("showInviteWindowAll");
    }

    private var orderPackID:int = 0;
    override public function showOrderWindow(e:Object):void {
        var st:String ='';
        try {
            if (e.id == 13) { // e.price we already have for this
                orderPackID = 13;
                e.type = DataMoney.SOFT_CURRENCY;
                st = 'Уникальное предложение!';
            } else if (e.id == 14) {
                orderPackID = 14;
                e.type = DataMoney.SOFT_CURRENCY;
                st = 'Специальное предложение!';
            } else {
                var ar:Array = g.allData.dataBuyMoney;
                for (var i:int = 0; i < ar.length; i++) {
                    if (ar[i].id == e.id) {
                        orderPackID = int(e.id);
                        e.type = ar[i].typeMoney;
                        e.price = ar[i].cost;
                        e.count = ar[i].count;
                        st += String(e.count) + ' ';
                        if (e.type == DataMoney.SOFT_CURRENCY) st += 'монет';
                        else st += 'рубинов';
                        break;
                    }
                }
            }
            Cc.ch('social', 'add stageDeActivate listener');
            g.starling.nativeStage.addEventListener(flash.events.Event.DEACTIVATE, onStageDeActivate);
            if (!e.type) {
                Cc.error('OK showOrderWindow:: unknown money pack');
            } else {
                Cc.ch('social', 'try makePayment:');
                Cc.obj('social', e);
                ExternalInterface.call("makePayment", st, 'Хорошая идея!', e.id, e.price);
            }
        } catch(e:Error) {
            Cc.error('OK showOrderWindow:: error: ' + e.message);
        }
    }

    private function onStageDeActivate(e:flash.events.Event):void {
        Cc.ch('social', 'add stageActivate and remove stageDeActivate');
        g.starling.nativeStage.removeEventListener(flash.events.Event.DEACTIVATE, onStageDeActivate);
        g.starling.nativeStage.addEventListener(flash.events.Event.ACTIVATE, onStageActivate);
    }

    private function onStageActivate(e:flash.events.Event):void {
        Cc.ch('social', 'remove stageActivate listener');
        g.starling.nativeStage.removeEventListener(flash.events.Event.ACTIVATE, onStageActivate);
        if (orderPackID > 0) {
            var f1:Function = function (message:String):void {
                if (message == 'FIND') {
                    orderSuccess();
                    orderPackID = 0;
                } else if (message == 'NO_ROW') {
                    orderCancel();
                    Cc.ch('social', 'OKtransaction:: no row in DB:transaction_lost for this user and packID: ' + orderPackID, 10); // it's only warning, not error
                    orderPackID = 0;
                }
            };
            g.directServer.onOKTransaction(f1, 0, orderPackID);
        }
    }

    private function onPaymentCallback(result:String):void {
        Cc.ch('social', 'remove stageActivate listener at paymentCallback');
        g.mainStage.removeEventListener(flash.events.Event.ACTIVATE, onStageActivate);
        if (result =='ok') {
            super.orderSuccess();
            g.directServer.onOKTransaction(null, 1, orderPackID);
            orderPackID = 0;
        } else {
            super.orderCancel();
            orderPackID = 0;
        }
    }

    override public function get idSocialGroup():String {
        return "55141755191315";
    }

    override public function get urlForAnySocialGroup():String {
        return "https://ok.ru/group/";
    }

    public override function checkIsInSocialGroup(id:String):void {
//        _apiConnection.api("groups.isMember", {group_id: idSocialGroup, user_id: g.user.userSocialId}, getIsInGroupHandler, onError);
        ExternalInterface.call("isInGroup", id, g.user.userSocialId);
        super.checkIsInSocialGroup(id);
    }

    private function isInGroupCallback(e:*):void {
        Cc.obj('social', e[0], 'is in group');
        if (e[0].status == 'ACTIVE') {
            g.managerQuest.onActionForTaskType(ManagerQuest.ADD_TO_GROUP);
//        } else {
//            Link.openURL(urlSocialGroup);
        }
    }

    override public function reloadGame():void {
        try {
            Cc.stackch("info", "SocialNetwork:: game reloading");
            ExternalInterface.call("reloadGame");
        } catch (e:Error) {
            Cc.warn("SocialNetwork:: cannot reload game");
        }
    }


}
}
