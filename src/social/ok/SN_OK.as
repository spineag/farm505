package social.ok {
import com.adobe.images.JPGEncoder;
import com.adobe.serialization.json.JSONuse;
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.net.URLLoader;
import flash.utils.ByteArray;
import flash.utils.getTimer;
import social.SocialNetwork;
import user.Friend;
import utils.Multipart;

public class SN_OK extends SocialNetwork {
    private static const API_SECRET_KEY:String = "864364A475EBF25367549586";

    private var _friendsRest:Array;
    private var _wallRequest:Object;

    private var _isAlbum:Boolean = false;
    private var _idAlbum:String;
    private var _oid:String;
    private var _idPhoto:String;

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
        }
        super(flashVars);
    }

//    override public function init():void {
//        ExternalInterface.call("initSocialNetwork", API_SECRET_KEY);
//    }
//
////    private function onConnect(e:ApiServerEvent):void {
//    private function onConnect():void {
//        super.init();
//    }

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
//        Users.getInfo([uid], ["first_name", "last_name", "pic_5", "gender", "birthday"], getProfileHandler);
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
//        Friends.get(getFriendsHandler, Odnoklassniki.session.uid);
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
//        Users.getInfo(friends.slice(0, 100), ["first_name", "last_name", "pic_5"], getFriendsLoaded);
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

    // friends in App
    override public function getAppUsers():void {
        super.getAppUsers();
//        Friends.getAppUsers(getAppUsersHandler);
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
//        Users.getInfo(arr, ["first_name", "last_name", "pic_5"], getFriendsByIdsHandler);
        ExternalInterface.call("getFriendsByIds", arr, ["first_name", "last_name", "pic_5"]);
    }

    private function getFriendsByIdsHandler(e:Array):void {
        Cc.ch('social', 'OK: getFriendsByIdsHandler:');
        Cc.obj('social', e);
        var ob:Object;
        for (var i:int = 0; i < e.length; i++) {
            ob = {};
            ob.uid = e[i].uid;
            ob.first_name = e[i].first_name;
            ob.last_name = e[i].last_name;
            ob.photo_100 = e[i].pic_5;
            g.user.addFriendInfo(e[i]);
        }
        if (_friendsApp.length) {
            getFriendsByIDs(_friendsApp);
        } else {
            super.getFriendsByIDsSuccess(e);
        }
    }

    override public function getUsersOnline():void {
        super.getUsersOnline();

//        Friends.getOnline(getUsersOnlineHandler);
    }

    private function getUsersOnlineHandler(e:Object):void {
        _friendsApp = e as Array;
        super.getUsersOnlineSuccess(_friendsApp);
    }

    // https://apiok.ru/dev/methods/rest/mediatopic/mediatopic.post
    override public function wallPost(uid:String, message:String, image:DisplayObject, url:String = null, title:String = null, posttype:String = null, idObj:String = '0'):void {
        _wallRequest = {method: "stream.publish", message: message};
        if (uid) {
            _wallRequest.uid = uid;
        }

//        url = url || "ok/icon.jpg";
        title = title || "Умелые Лапки";

        _wallRequest.attachment = JSONuse.encode({caption: title, media: [
            {href: "link", src: url, "type": "image"}
        ]});
        _wallRequest.action_links = JSONuse.encode([
            {text: "Посмотреть..."}
        ]);
//        _wallRequest = Odnoklassniki.getSignature(_wallRequest, false);
//        Odnoklassniki.showConfirmation("stream.publish", message, _wallRequest.sig);
        super.wallPost(uid, message, image, url, title, posttype);
    }

    override public function requestBox(uid:String, message:String, requestKey:String):void {
        showInviteWindow();
    }

    override public function showInviteWindow():void {
//        Odnoklassniki.showInvite("Приглашаю посетить игру Умелые Лапки.");
    }

    override public function showOrderWindow(e:Object):void {
//        var currencyName:String = e.isMoney ? g.language.buildingHint.money : g.language.buildingHint.bucks;
//        currencyName = " " + currencyName + " ";
//        var bonusText:String = uint(e.bonus) > 0 ? "+" + String(e.bonus) + " " + g.language.addCoinsWindow.superPrice : "";
//        var param:Object = {};
//        param.service_id = e.id;
//        param.service_name = uint(e.count) + currencyName + bonusText;
//        param.ok_price = e.price;
//
//        if (e.pack && e.pack.length > 0) {
//            param.service_name = "";
//            for (var i:int = 0; i < e.pack.length; i++) {
//                var object:Object = e.pack[i];
//
//                i && (param.service_name += " + ");
//
//                switch (object.resource_id){
//                    case "1":
//                        param.service_name += object.resource_count + " " + g.language.buildingHint.money;
//                        break;
//                    case "2":
//                        param.service_name += object.resource_count + " " + g.language.buildingHint.bucks;
//                        break;
//                    case "7":
//                        param.service_name += g.language.starterPackWindow.energy;
//                        break;
//                }
//
//            }
//        }

//        ExternalInterface.call("makePayment", 0, e.price, param.service_name, e.id);
//
//        Odnoklassniki.showPayment(param.service_name, param.service_name, e.id, e.price, null, null, null, "true");
    }

    override public function saveScreenshotToAlbum(oid:String):void {
        _oid = oid;
        Cc.ch("OK", "check hasAppPermission for PHOTO CONTENT", 2);
//        Users.hasAppPermission("PHOTO CONTENT", isAppPermission, g.user.userSocialId);
    }

    private function isAppPermission(response:Boolean):void {
        Cc.ch("OK", "ask for permission PHOTO_CONTENT response: " + response, 2);
        if (response) {
            findAlbum(_oid);
            super.saveScreenshotToAlbum(_oid);
        }
        else {
//            Odnoklassniki.showPermissions(["PHOTO CONTENT"]);
        }
    }

    private function findAlbum(oid:String):void {
//        Photos.getAlbums(onGetAlbums, oid);
    }

    private function onGetAlbums(data:Object):void {
        var arr:Array = data.albums;
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i].title == "Птичий Городок") {
                _isAlbum = true;
                _idAlbum = String(arr[i].aid);
                Cc.ch("OK", "album is finding with id: " + _idAlbum,+  2);
                uploadScreenshot();
                return;
            }
        }
        if (!_isAlbum) {
            Cc.ch("OK", "create album", 9);
//            Photos.createAlbum("Птичий Городок", "public", onCreateAlbum);
        }
    }

    private function onCreateAlbum(data:String):void {
        Cc.ch("OK", "onCreateAlbum data:" + data, 5);
        _idAlbum = data;
        _isAlbum = true;
        uploadScreenshot();
    }

    private function uploadScreenshot():void {
        Cc.ch("OK", "social before loading", 5);
//        Odnoklassniki.callRestApi("photosV2.getUploadUrl", takeUploadUrl, Odnoklassniki.getSendObject({ uid:g.user.userSocialId, aid:_idAlbum }) );
    }

    private function takeUploadUrl(data:Object):void {
        var loader:URLLoader = new URLLoader();
        var _bitmapScreenShot:Bitmap;
        var url:String;

        Cc.obj("OK", data, "takeUploadUrl data: ", 6);
        if (!data.upload_url) {
            return;
        }

        url = data.upload_url;

        _idPhoto = data.photo_ids[0];

        _bitmapScreenShot = makeScreenShot();
        if (!_bitmapScreenShot) {
            return;
        }

        var form:Multipart = new Multipart(url);
        var enc:JPGEncoder = new JPGEncoder(80);
        var jpg:ByteArray = enc.encode(_bitmapScreenShot.bitmapData);
        form.addFile("file1", jpg, "application/octet-stream", "Screenshot.jpg");

        loader.addEventListener(Event.COMPLETE, photoLoadedToOKAlbum);
        try {
            Cc.ch("OK", "after loading", 5);
            loader.load(form.request);
        } catch (error:Error) {
            Cc.ch("OK", "Problem with save screenshot to album on OK: " + error.message, 9);
        }
    }

    private function photoLoadedToOKAlbum(e:Event):void {
        var obj:Object = JSONuse.decode(e.target.data);

        Cc.obj("OK", obj.photos, "save to album", 7);
        Cc.obj("OK", obj.photos[_idPhoto], "obj.photos 222:", 2);
        Cc.ch("OK", "token 333:" + obj.photos[_idPhoto].token, 6);

//        Odnoklassniki.callRestApi("photosV2.commit", onCompleteSave, Odnoklassniki.getSendObject({ photo_id:_idPhoto, token:obj.photos[_idPhoto].token, comment:urlApp}) );
    }

    private function onCompleteSave(data:Object):void {
        _isAlbum = false;
        Cc.obj("social", data, "Screenshot already saved to the album", 1);
    }

//    private function callbackHandler(e:ApiCallbackEvent):void {
//        Cc.infoch("social", "Odnoklassniki callback:\n" + e.method + "\n" + e.data + "\n" + e.result);
//        switch (e.method) {
//            case "showPayment":
//                if (e.result == "ok") {
//                    super.orderSuccess();
//                } else {
//                    super.orderFail();
//                }
//                break;
//            case "showNotification":
//                if (e.result == "ok") {
//                    super.wallSave();
//                } else {
//                    super.wallCancel();
//                }
//                break;
//            case "showInvite":
//                super.inviteBoxComplete();
//                break;
//            case "showConfirmation":
//                if (e.result == "ok") {
//                    _wallRequest["resig"] = e.data;
////                    Odnoklassniki.callRestApi("stream.publish", streamCall, _wallRequest);
//                    super.wallSave();
//                } else {
//                    streamCall({ "cancel": "notification has been canceled" });
//                    super.wallCancel();
//                }
//                break;
//            case "showPermissions":
//                if (e.result == "ok") {
//                    Cc.ch("OK", "OK for PHOTO CONTENT permission", 6);
//                    findAlbum(_oid);
//                    super.saveScreenshotToAlbum(_oid);
//                } else {
//                    Cc.ch("OK", "user don\"t set PHOTO CONTENT permission", 9);
//                }
//        }
//    }

    private function streamCall(e:Object):void {
//        Cc.ch("social", e + "\n" + Debugger.debugObject(e), 6);
    }

    private function showPayment(e:Object):void {
//        g.woAddCoins.handler.init();
    }
}
}
