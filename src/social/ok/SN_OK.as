package social.ok {

import com.adobe.images.JPGEncoder;
import com.adobe.serialization.json.JSONuse;
import com.junkbyte.console.Cc;
import com.odnoklassniki.Odnoklassniki;
import com.odnoklassniki.events.ApiCallbackEvent;
import com.odnoklassniki.events.ApiServerEvent;
import com.odnoklassniki.sdk.friends.Friends;
import com.odnoklassniki.sdk.photos.Photos;
import com.odnoklassniki.sdk.users.Users;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.net.URLLoader;
import flash.utils.ByteArray;
import social.SocialNetwork;
import starling.core.Starling;
import utils.Multipart;

public class SN_OK extends SocialNetwork {
    private static const API_SECRET_KEY:String = "864364A475EBF25367549586";

    private var _friendsRest:Array;
    private var _wallRequest:Object;

    private var _isLonely:Boolean = false;
    private var _isAlbum:Boolean = false;
    private var _idAlbum:String;
    private var _oid:String;
    private var _idPhoto:String;

    public function SN_OK(flashVars:Object) {
        flashVars["channelGUID"] ||= "6697c149-8270-48fb-b3e5-8cea9f04e307";

        _friendsRest = [];
        URL_AVATAR_BLANK = g.dataPath.getGraphicsPath() + "/social/iconNeighbor.png";
        Odnoklassniki.addEventListener(ApiServerEvent.CONNECTED, onConnect);
        Odnoklassniki.addEventListener(ApiServerEvent.CONNECTION_ERROR, onErrorConnection);
        Odnoklassniki.addEventListener(ApiServerEvent.PROXY_NOT_RESPONDING, onErrorConnection);
        Odnoklassniki.addEventListener(ApiServerEvent.NOT_YET_CONNECTED, onErrorConnection);

        Odnoklassniki.addEventListener(ApiCallbackEvent.CALL_BACK, callbackHandler);

        if (ExternalInterface.available) {
            ExternalInterface.addCallback("showPayment", showPayment);
        }
        super(flashVars);
    }

    override public function init():void {
        Odnoklassniki.initialize(Starling.current.nativeStage, API_SECRET_KEY);
    }

    private function onConnect(e:ApiServerEvent):void {
        super.init();
    }

    private function onErrorConnection(e:ApiServerEvent):void {
        Cc.error("OK API connection fail: " + e.type + " " + e.data);
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
        Users.getInfo([uid], ["first_name", "last_name", "pic_5", "gender", "birthday"], getProfileHandler);
    }

    private function getProfileHandler(e:Object):void {
        try {
            _paramsUser = {};
            _paramsUser.firstName = String(e[0].first_name);
            _paramsUser.lastName = String(e[0].last_name);
            _paramsUser.photo = String(e[0].pic_5) || URL_AVATAR_BLANK;
            _paramsUser.sex = String(e[0].gender);
            _paramsUser.bdate = String(e[0].birthday);

            super.getProfileSuccess(_paramsUser);
        } catch (e:Error) {
            Cc.error("SN_OK:: getProfileHandler crashed");
        }
    }

    override public function getFriends():void {
        super.getFriends();
        Friends.get(getFriendsHandler, Odnoklassniki.session.uid);
    }

    private function getFriendsHandler(e:Object = null):void {
        var friends:Array = e as Array;

        if (!friends.length) {
            _isLonely = true;
            super.getFriendsSuccess(0);
            return;
        }

        _friendsRest = friends.slice(100);
        Users.getInfo(friends.slice(0, 100), ["first_name", "last_name", "pic_5"], getFriendsLoaded);
    }

    private function getFriendsLoaded(e:Object):void {
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
                _paramsFriends.push(buffer);
            }
        }

        if (_friendsRest.length) {
            getFriendsHandler(_friendsRest);
        } else {
            super.getFriendsSuccess("x");
        }
    }

    override public function getAppUsers():void {
        super.getAppUsers();

        if (_isLonely) {
            super.getAppUsersSuccess(_paramsFriends);
            return;
        }

        Friends.getAppUsers(getAppUsersHandler);
    }

    private function getAppUsersHandler(e:Object):void {
        _paramsFriends = e["uids"] as Array;
        super.getAppUsersSuccess(_paramsFriends);
    }

    override public function getUsersOnline():void {
        super.getUsersOnline();

        if (_isLonely) {
            super.getUsersOnlineSuccess(null);
            return;
        }

        Friends.getOnline(getUsersOnlineHandler);
    }

    private function getUsersOnlineHandler(e:Object):void {
        _paramsFriends = e as Array;
        super.getUsersOnlineSuccess(_paramsFriends);
    }

    override public function wallPost(uid:String, message:String, image:DisplayObject, url:String = null, title:String = null, posttype:String = null, idObj:String = '0'):void {
        _wallRequest = {method: "stream.publish", message: message + " Прислал " + g.user.name + " " + g.user.lastName};
        if (uid) {
            _wallRequest.uid = uid;
        }

        url = url || "ok/icon.jpg";
        title = title || "Птичий городок";

        _wallRequest.attachment = JSONuse.encode({caption: title, media: [
            {href: "link", src: url, "type": "image"}
        ]});
        _wallRequest.action_links = JSONuse.encode([
            {text: "Посмотреть..."}
        ]);
        _wallRequest = Odnoklassniki.getSignature(_wallRequest, false);
        Odnoklassniki.showConfirmation("stream.publish", message, _wallRequest.sig);
        super.wallPost(uid, message, image, url, title, posttype);
    }

    override public function requestBox(uid:String, message:String, requestKey:String):void {
        showInviteWindow();
    }

    override public function showInviteWindow():void {
        Odnoklassniki.showInvite("Приглашаю посетить игру Птичий городок.");
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
        Users.hasAppPermission("PHOTO CONTENT", isAppPermission, g.user.userSocialId);
    }

    private function isAppPermission(response:Boolean):void {
        Cc.ch("OK", "ask for permission PHOTO_CONTENT response: " + response, 2);
        if (response) {
            findAlbum(_oid);
            super.saveScreenshotToAlbum(_oid);
        }
        else {
            Odnoklassniki.showPermissions(["PHOTO CONTENT"]);
        }
    }

    private function findAlbum(oid:String):void {
        Photos.getAlbums(onGetAlbums, oid);
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
            Photos.createAlbum("Птичий Городок", "public", onCreateAlbum);
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
        Odnoklassniki.callRestApi("photosV2.getUploadUrl", takeUploadUrl, Odnoklassniki.getSendObject({ uid:g.user.userSocialId, aid:_idAlbum }) );
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

        Odnoklassniki.callRestApi("photosV2.commit", onCompleteSave, Odnoklassniki.getSendObject({ photo_id:_idPhoto, token:obj.photos[_idPhoto].token, comment:urlApp}) );
    }

    private function onCompleteSave(data:Object):void {
        _isAlbum = false;
        Cc.obj("social", data, "Screenshot already saved to the album", 1);
    }

    private function callbackHandler(e:ApiCallbackEvent):void {
        Cc.infoch("social", "Odnoklassniki callback:\n" + e.method + "\n" + e.data + "\n" + e.result);
        switch (e.method) {
            case "showPayment":
                if (e.result == "ok") {
                    super.orderSuccess();
                } else {
                    super.orderFail();
                }
                break;
            case "showNotification":
                if (e.result == "ok") {
                    super.wallSave();
                } else {
                    super.wallCancel();
                }
                break;
            case "showInvite":
                super.inviteBoxComplete();
                break;
            case "showConfirmation":
                if (e.result == "ok") {
                    _wallRequest["resig"] = e.data;
                    Odnoklassniki.callRestApi("stream.publish", streamCall, _wallRequest);
                    super.wallSave();
                } else {
                    streamCall({ "cancel": "notification has been canceled" });
                    super.wallCancel();
                }
                break;
            case "showPermissions":
                if (e.result == "ok") {
                    Cc.ch("OK", "OK for PHOTO CONTENT permission", 6);
                    findAlbum(_oid);
                    super.saveScreenshotToAlbum(_oid);
                } else {
                    Cc.ch("OK", "user don\"t set PHOTO CONTENT permission", 9);
                }
        }
    }

    private function streamCall(e:Object):void {
//        Cc.ch("social", e + "\n" + Debugger.debugObject(e), 6);
    }

    private function showPayment(e:Object):void {
//        g.woAddCoins.handler.init();
    }
}
}
