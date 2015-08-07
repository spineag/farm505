package social.vk {

import com.adobe.images.JPGEncoder;
import com.adobe.serialization.json.JSONuse;
import com.junkbyte.console.Cc;
import com.vk.APIConnection;
import com.vk.CustomEvent;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.ByteArray;
import flash.utils.getTimer;

import manager.Vars;

import social.SocialNetwork;
import social.SocialNetworkEvent;

import user.Friend;


public class SN_Vkontakte extends SocialNetwork {
    private static const MASK_ADD_LEFT_MENU:int = 256;

    private var _uidWall:String;
    private var _apiConnection:APIConnection;
    private var _messageWall:String;
    private var _urlWall:String;
    private var _isAlbum:Boolean = false;
    private var _idAlbum:int;
    private var _typePost:String = "";

    protected static var g:Vars = Vars.getInstance();

    public function SN_Vkontakte(flashVars:Object, pathArg:String) {
        _channelMark = "vk";

        _serverPath = pathArg;
        _contentPath = pathArg;

        flashVars["channelGuid"] ||= "d3a603c8017548938c30c3f13a2d7741";
        flashVars["applicationGuid"] ||= '42815205f51644a1abe3774fb9a68d22';
        //flashVars["sessionKEY"] ||= GUID.create();

        _apiConnection = new APIConnection(flashVars);
        _apiConnection.addEventListener(CustomEvent.WALL_SAVE, wallPostSaveHandler);
        _apiConnection.addEventListener(CustomEvent.WALL_CANCEL, wallPostCancelHandler);
        _apiConnection.addEventListener(CustomEvent.ORDER_CANCEL, orderCancelHandler);
        _apiConnection.addEventListener(CustomEvent.ORDER_FAIL, orderFailHandler);
        _apiConnection.addEventListener(CustomEvent.ORDER_SUCCESS, orderSuccessHandler);

        if (ExternalInterface.available) {
            try {
                ExternalInterface.addCallback("showPayment", showPayment);
                ExternalInterface.addCallback("useActiveOffers", getOffersInfoHandler);
            } catch (e:Error) {
                Cc.error(e.toString(), "Social network do not use ExternalInterface. Callback showPayment ignored.");
            }
        }

        super(flashVars);
    }

    private function forSimpleDevelopers():void {
        var forSimpleDevelopers:String = "FlashVars for simple developers:";
        forSimpleDevelopers += "\n-----------------------------------------------------";
        forSimpleDevelopers += "\n    flashVars[\"" + "api_id" + "\"] = \"" + g.flashVars["api_id"] + "\";";
        forSimpleDevelopers += "\n    flashVars[\"" + "viewer_id" + "\"] = \"" + g.flashVars["viewer_id"] + "\";";
        forSimpleDevelopers += "\n    flashVars[\"" + "sid" + "\"] = \"" + g.flashVars["sid"] + "\";";
        forSimpleDevelopers += "\n    flashVars[\"" + "secret" + "\"] = \"" + g.flashVars["secret"] + "\";";
        forSimpleDevelopers += "\n    flashVars[\"" + "access_token" + "\"] = \"" + g.flashVars["access_tokern"] + "\";";
        forSimpleDevelopers += "\n-----------------------------------------------------";
        Cc.info(forSimpleDevelopers);
    }

    override public function get currentUID():String {
        return _flashVars["viewer_id"];
    }

    override public function get referrer():String {
        var result:String;

        result = _flashVars["referrer"] || "unknown";
        if (result.indexOf("wall") > 0) {
            var st:String = result;
            result = "wall_post";
            var i:int = st.lastIndexOf('_');
            if (i >= 0) {
                st = st.substr(i);
                result += st;
            }
        } else if (result.indexOf("group_posting") > 0) {
            result = result.replace("ad=", "");
        }

        return result;
    }

    override public function get urlApp():String {
        return "http://vk.com/app4993465";
    }

    override public function get protocol():String {
        return (_flashVars["protocol"] || "http");
    }

    override public function getProfile(uid:String):void {
        super.getProfile(uid);
        _apiConnection.api("users.get", {fields: "first_name, last_name, photo_100, bdate, sex, city, country", https: 1}, getProfileHandler, onError);
    }

    private function getProfileHandler(e:Object):void {
        Cc.ch('social', "SN_Vkontakte:: got info about current user and start processing it");
        _paramsUser = {};
        _paramsUser.firstName = e[0].first_name;
        _paramsUser.lastName = e[0].last_name;
        _paramsUser.photo = String(e[0].photo_100).indexOf(".gif") > 0 ? URL_AVATAR_BLANK : e[0].photo_100;
        _paramsUser.sex = e[0].sex;
        _paramsUser.bdate = e[0].bdate;
        _paramsUser.city = e[0].city;
        _paramsUser.country = e[0].country;

        super.getProfileSuccess(_paramsUser);
        forSimpleDevelopers();
    }

    override public function getFriends():void {
        super.getFriends();
        _apiConnection.api("friends.get", {fields: "", https: 1}, getFriendsHandler, onError);
    }

    private function getFriendsHandler(e:Object = null):void {
        for (var key:String in e) {
            addNoAppFriend(e[key]);
        }
        super.getFriendsSuccess(e.length);
    }

    private var friendsNoApp:Array;
    private var friendsApp:Array;
    private var _timerRender:uint = 0;
    private const COUNT_PER_ONCE_IN_GAME:int = 100;

    // friends in App
    override public function getFriendsByIDs(friends:Array):void {
        var arr:Array;

        friendsApp = friends;
        if (friendsApp.length > COUNT_PER_ONCE_IN_GAME) {
            arr = friendsApp.slice(0, COUNT_PER_ONCE_IN_GAME);
            friendsApp.splice(0, COUNT_PER_ONCE_IN_GAME);
        } else {
            arr = friendsApp.slice();
            friendsApp = [];
        }

        super.getFriendsByIDs(arr);
        if (getTimer() - _timerRender < 1000) {
            g.gameDispatcher.addToTimerWithParams(getFriendsByIDsWithDelay, 1000, 1, arr);
        } else {
            _timerRender = getTimer();
            getFriendsByIDsWithDelay(arr);
        }
    }

    public function getFriendsByIDsWithDelay(ids:Array):void {
        var arr:Array = [];

        for (var i:int = 0; i < ids.length; i++) {
            arr.push(ids[i].uid);
        }
        _apiConnection.api("users.get", {fields: "first_name, last_name, photo_100", user_ids: arr.join(",")}, getFriendsByIdsHandler, onError);
    }

    private function getFriendsByIdsHandler(e:Array):void {
        var buffer:Object;
        var bufferIds:Array = [];

        for (var i:int = 0; i < e.length; i++) {
            buffer = e[i];
            buffer.photo_100 = String(buffer.photo_100).indexOf(".gif") > 0 ? URL_AVATAR_BLANK : buffer.photo_100;
            bufferIds.push(buffer);
            setFriendInfo(buffer.uid, buffer.first_name, buffer.last_name, buffer.photo_100);
        }

        if (friendsApp.length) {
            getFriendsByIDs(friendsApp);
        } else {
            super.getFriendsByIDsSuccess(bufferIds);
        }
    }

    private const COUNT_PER_ONCE:int = 100;
    // friends not in App
    override public function getNoAppFriendsByIDs(friends:Array):void {
        var arr:Array;

        friendsNoApp = friends;
        if (friendsNoApp.length > COUNT_PER_ONCE) {
            arr = friendsNoApp.slice(0, COUNT_PER_ONCE);
            friendsNoApp.splice(0, COUNT_PER_ONCE);
        } else {
            arr = friendsNoApp.slice();
            friendsNoApp = [];
        }

        super.getNoAppFriendsByIDs(arr);
        if (getTimer() - _timerRender < 1000) {
            g.gameDispatcher.addToTimerWithParams(getNoAppFriendsByIDsWithDelay, 1000, 1, arr);
        } else {
            _timerRender = getTimer();
            getNoAppFriendsByIDsWithDelay(arr);
        }
    }

    public function getNoAppFriendsByIDsWithDelay(ids:Array):void {
        var arr:Array = [];

        for (var i:int = 0; i < ids.length; i++) {
            arr.push(ids[i].uid);
        }
        _apiConnection.api("users.get", {fields: "first_name, last_name, photo_100", user_ids: arr.join(",")}, getNoAppFriendsByIdsHandler, onError);
    }

    private function getNoAppFriendsByIdsHandler(e:Array):void {
        var buffer:Object;
        var bufferIds:Array = [];

        for (var i:int = 0; i < e.length; i++) {
            buffer = e[i];
            buffer.photo_100 = String(buffer.photo_100).indexOf(".gif") > 0 ? URL_AVATAR_BLANK : buffer.photo_100;
            bufferIds.push(buffer);
            setFriendInfo(buffer.uid, buffer.first_name, buffer.last_name, buffer.photo_100);
        }

        if (friendsNoApp.length) {
            getNoAppFriendsByIDs(friendsNoApp);
        } else {
            //g.user.checkEmptyNoAppFriends();
            super.getFriendsByIDsSuccess(bufferIds);
        }
    }

    override public function getPostsByIds(postIds:String):void {
        super.getPostsByIds(postIds);
        _apiConnection.api("wall.getById", {posts: postIds, extended: 0, v: 5.21}, getPostsByIdsHandler, onError);
    }

    override public function getAppUsers():void {
        super.getAppUsers();
        _apiConnection.api("friends.getAppUsers", {https: 1}, getAppUsersHandler, onError);
    }

    private function getAppUsersHandler(e:Object):void {
        _appFriends = e as Array;
//        var f:Friend;
//        for (var i:int=0; i < _appFriends.length; i++) {
//            f = new Friend();
//            f.name = _appFriends[i].name;
//            g.user.arry.push(f)
//        }
        super.getAppUsersSuccess(e);
    }

    override public function getUsersOnline():void {
        super.getUsersOnline();
        _paramsFriends = [];
        _apiConnection.api("friends.getOnline", {https: 1}, getUsersOnlineHandler, onError);
    }

    private function getUsersOnlineHandler(e:Object):void {
        for (var key:String in e) {
            _paramsFriends.push(String(e[key]));
        }

        super.getUsersOnlineSuccess(_paramsFriends);
    }

    override public function wallPost(uid:String, message:String, image:DisplayObject, url:String = null, title:String = null, posttype:String = null, idObj:String = '0'):void {
        wallPostBitmap(uid, message, image as Bitmap, url, title, posttype);
    }

    override public function wallPostBitmap(uid:String, message:String, image:Bitmap, url:String = null, title:String = null, posttype:String = null):void {
        url = url || "icon_vk.png";
        title = title || "Птичий островок";

        super.wallPostBitmap(uid, message, image, url, title, posttype);

        if (g.isDebug) {
            super.wallSave();
            return;
        }

        new VKWallPost(uid, message, image, url, title, posttype, this, _apiConnection);
    }

    public function wallCancelPublic():void {
        super.wallCancel();
    }

    public function wallSavePublic():void {
        super.wallSave();
    }

    private function wallPostSaveHandler(e:CustomEvent):void {
        super.wallSave();
    }

    private function wallPostCancelHandler(e:CustomEvent):void {
        super.wallCancel();
    }

    override public function showInviteWindow():void {
        if (g.isDebug) {
            return;
        }
        _apiConnection.callMethod("showInviteBox");
        _apiConnection.addEventListener(CustomEvent.WINDOW_FOCUS, inviteBoxCompleteHandler);
        super.showInviteWindow();
    }

    private function inviteBoxCompleteHandler(e:CustomEvent):void {
        _apiConnection.removeEventListener(CustomEvent.WINDOW_FOCUS, inviteBoxCompleteHandler);
        super.inviteBoxComplete();
    }

    private var _requestBoxArray:Array;
    private var _requestBoxMessage:String;
    private var  _isSendingNow:Boolean = false;

    override public function requestBoxArray(arr:Array, message:String, requestKey:String):void {
        super.requestBoxArray(arr, message, requestKey);

        _requestBoxArray = arr;
        _requestBoxMessage = message;

        releaseArrayRequestBox();
    }

    private function releaseArrayRequestBox():void {
        var uid:String;

        if (_requestBoxArray.length) {
            uid = _requestBoxArray.shift();
            requestBox(uid, _requestBoxMessage, g.user.userSocialId);
        }
    }

    override public function requestBox(uid:String, message:String, requestKey:String):void {
        if (g.isDebug) {
            dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.REQUEST_WINDOW_CANCEL, false, false));
            return;
        }

        if (_isSendingNow) {
            _requestBoxArray.push(uid);
            return;
        }

        if (uid) {
            _isSendingNow = true;
            _apiConnection.callMethod("showRequestBox", int(uid), message, requestKey);
            _apiConnection.addEventListener(CustomEvent.REQUEST_COMPLETE, requestBoxCompleteHandler);
            _apiConnection.addEventListener(CustomEvent.REQUEST_CANCEL, requestBoxCancelHandler);
            _apiConnection.addEventListener(CustomEvent.REQUEST_FAIL, requestBoxFailHandler);
            super.requestBox(uid, message, requestKey);
        } else {
            showInviteWindow();
        }
    }

    private function requestBoxCompleteHandler(e:CustomEvent):void {
        _apiConnection.removeEventListener(CustomEvent.REQUEST_COMPLETE, requestBoxCompleteHandler);
        _apiConnection.removeEventListener(CustomEvent.REQUEST_CANCEL, requestBoxCancelHandler);
        _apiConnection.removeEventListener(CustomEvent.REQUEST_FAIL, requestBoxFailHandler);

        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.REQUEST_WINDOW_COMPLETE, false, false));
        super.inviteBoxComplete();

        _isSendingNow = false;
        releaseArrayRequestBox();
    }

    private function requestBoxCancelHandler(e:CustomEvent):void {
        _apiConnection.removeEventListener(CustomEvent.REQUEST_COMPLETE, requestBoxCompleteHandler);
        _apiConnection.removeEventListener(CustomEvent.REQUEST_CANCEL, requestBoxCancelHandler);
        _apiConnection.removeEventListener(CustomEvent.REQUEST_FAIL, requestBoxFailHandler);

        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.REQUEST_WINDOW_CANCEL, false, false));

        _isSendingNow = false;
        releaseArrayRequestBox();
    }

    private function requestBoxFailHandler(e:CustomEvent):void {
        _apiConnection.removeEventListener(CustomEvent.REQUEST_COMPLETE, requestBoxCompleteHandler);
        _apiConnection.removeEventListener(CustomEvent.REQUEST_CANCEL, requestBoxCancelHandler);
        _apiConnection.removeEventListener(CustomEvent.REQUEST_FAIL, requestBoxFailHandler);

        dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.REQUEST_WINDOW_CANCEL, false, false));

        _isSendingNow = false;
        releaseArrayRequestBox();
    }

    override public function saveScreenshotToAlbum(oid:String):void {
        //g.managerCutSceneWarning.visible = false;
        findAlbum(oid);

        super.saveScreenshotToAlbum(oid);
    }

    private function onGetAlbums(data:Object):void {
        for (var Key:String in data) {
            if (data[Key].title == "Птичий Островок") {
                _isAlbum = true;
                _idAlbum = data[Key].aid;

                _apiConnection.api("photos.getUploadServer", {aid: _idAlbum, save_big: 1, https: 1}, getAlbumUploadServerComplete, onError);
            }
        }
//        if (!_isAlbum) {
//            createAlbum("Птичий Островок", "http://vk.com/app4677235");
//        }

    }

    private function findAlbum(oid:String):void {
        _apiConnection.api("photos.getAlbums", {oid: oid, https: 1}, onGetAlbums, onError);
    }

    private function createAlbum(title:String, description:String, comment_privacy:int = 0, privacy:int = 0):void {
        _apiConnection.api("photos.createAlbum", {title: title, description: description, comment_privacy: comment_privacy, privacy: privacy, https: 1}, onCreateAlbum);
    }

    private function onCreateAlbum(data:Object):void {
        _idAlbum = data.aid;
        _isAlbum = true;

        _apiConnection.api("photos.getUploadServer", {aid: _idAlbum, save_big: 1, https: 1}, getAlbumUploadServerComplete, onError);
    }

    private function getAlbumUploadServerComplete(e:Object):void {
//        var bitMap:Bitmap;
//        var loader:URLLoader = new URLLoader();
//
//        bitMap = g.makeLevelScreenShot.getScreenShot();
//        if (!bitMap) {
//            g.makeLevelScreenShot.onError();
//            return;
//        }
//        Cc.obj("social", e, "before loading", 5);
//        var form:Multipart = new Multipart(e.upload_url);
//        var enc:JPGEncoder = new JPGEncoder(80);
//        var jpg:ByteArray = enc.encode(bitMap.bitmapData);
//        form.addFile("file1", jpg, "application/octet-stream", "Screenshot.jpg");
//
//        loader.addEventListener(Event.COMPLETE, photoLoadedToVkAlbum);
//        try {
//            Cc.ch("social", "after loading screenshot to VK", 5);
//            loader.load(form.request);
//        } catch (error:Error) {
//            g.makeLevelScreenShot.onError();
//            Cc.ch("social", "Problem with save screenshot to album on VK: " + error.message, 9);
//        }
    }

    private function photoLoadedToVkAlbum(e:Event):void {
//        var obj:Object = JSONuse.decode(e.target.data);
//        var _caption:String = g.makeLevelScreenShot.getCaption();
//
//        Cc.obj("social", obj, "save to album", 5);
//        _apiConnection.api("photos.save", {aid: obj.aid, server: obj.server, caption: _caption, photos_list: obj.photos_list, hash: obj.hash, https: 1}, onCompleteSave, g.makeLevelScreenShot.onError);
    }

    private function onCompleteSave(data:Object):void {
//        var _comment:String = g.makeLevelScreenShot.getComment();
//        _isAlbum = false;
//        Cc.obj("social", data, "Screenshot already saved to the album", 1);
//        _apiConnection.api("photos.createComment", {oid: g.currentUser.uid, pid: data.pid, message: _comment, https: 1}, onCompleteSaveComment, onCompleteSaveComment);
    }

    private function onCompleteSaveComment(data:Object = null):void {
//        g.makeLevelScreenShot.onComplete();
    }

    private function saveScreenshotToAlbumCompleteHandler(e:CustomEvent):void {
        _apiConnection.removeEventListener(CustomEvent.WINDOW_FOCUS, saveScreenshotToAlbumCompleteHandler);
        super.saveScreenshotToAlbumComplete();
    }

    override public function showOrderWindow(e:Object):void {
        if (g.isDebug) {
            super.showOrderWindow(e);
            return;
        }
        var item:String = "item_" + String(e.id);

        _apiConnection.callMethod("showOrderBox", {"type": "item", item: item});
        super.showOrderWindow(e);
    }

    private function orderCancelHandler(e:CustomEvent):void {
        super.orderCancel();
    }

    private function orderFailHandler(e:CustomEvent):void {
        super.orderFail();
    }

    private function orderSuccessHandler(e:CustomEvent):void {
        super.orderSuccess();
    }

    private function showPayment(e:Object):void {
//        if (ManagerTutorial.isTutorial || g.selectedBuilding || g.area.areaVisitCity.isAway || g.area.handler.selectedBuild) {
//            return;
//        }
//
//        if (WOHandler.countOpenedWindows() > 0 || g.managerCutScene.isActivate || g.area.areaLoadedCity.isLoad) {
//            return;
//        }
//
//        g.woAddCoins.indexActivateTabButton = 0;
//        g.woAddCoins.handler.init();
    }


    private function getOffersInfo():void {
        Cc.ch("offer", "Send ExternalInterface.call(getOffers) request");
        if (ExternalInterface.available) {
            try {
                ExternalInterface.call("getOffers");
            } catch (e:Error) {
                Cc.error(e.toString(), "Social network do not use ExternalInterface. Aplly callback getOffers ignored.");
            }
        } else {
            _apiConnection.api("account.getActiveOffers", {v: "5.2", https: 1}, getOffersInfoHandler, onError);
        }
    }

    private function getOffersInfoHandler(e:Object):void {
//        for testing offers system uncomment next line
//        (e.items as Array).push({currency_amount:6, description:"test", id:2169, price:1, img:"http://cs310421.vk.me/u00100/b_3a685ddb.jpg",title:"", short_description:"TestOffer"});

        Cc.ch("offer", "Got " + e.count + " offers");
        //g.managerOffer.setSocialOffer(e.items);
    }

    override public function showOfferBox(offer_id:String):void {
        if (g.isDebug) {
            return;
        }
        _apiConnection.callMethod("showOrderBox", {"type": "offers", offer_id: offer_id});
        super.showOfferBox(offer_id);
    }

    public function onError(e:Object):void {
        Cc.obj('error', e, "API VK error:");
    }

    override public function checkLeftMenu():void {
        _apiConnection.api("getUserSettings", {}, getUserSettings, onError);
    }

    private function getUserSettings(value:int, needCheck:Boolean = true):void {
        var curTask:Object;

//        if (Boolean(value & MASK_ADD_LEFT_MENU)) {
//            curTask = g.managerQuest.findTask(TypesQuest.ADD_LEFT_MENU);
//            if (curTask) {
//                g.server.inquiry(BirdsServer.COMMAND_CLICK, BirdsServer.INQ_TASK_COMPLETE, [g.currentUser.uid, curTask.id_task, MD5.hash('joy_rocks_complete_task' + curTask.id_task)]);
//            }
//        } else {
            if (needCheck) {
                _apiConnection.addEventListener(CustomEvent.SETTINGS_CHANGED, onSettingsChanged);
                _apiConnection.callMethod("showSettingsBox", MASK_ADD_LEFT_MENU);
            }
//        }
    }

    private function onSettingsChanged(e:CustomEvent):void {
        _apiConnection.removeEventListener(CustomEvent.SETTINGS_CHANGED, onSettingsChanged);

        if (e.params[0]) {
            getUserSettings(int(e.params[0]), false);
        } else {
            Cc.ch('social', 'no value e.params[0] at onSettingsChanged');
        }
    }
}
}


import com.adobe.images.JPGEncoder;
import com.adobe.serialization.json.JSONuse;
import com.junkbyte.console.Cc;
import com.vk.APIConnection;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.net.URLLoader;
import flash.utils.ByteArray;

import manager.Vars;

import social.vk.SN_Vkontakte;

internal class VKWallPost {
    private var _uidWall:String;
    private var _messageWall:String;
    private var _urlWall:String;
    private var _typePost:String = "";
    private var _imageWallPost:Bitmap;
    private var _network:SN_Vkontakte;
    private var _apiConnection:APIConnection;
    private var _saveWallPhoto:Object;
    private var _idObj:int;

    protected var g:Vars = Vars.getInstance();

    public function VKWallPost(uid:String, message:String, image:Bitmap, url:String = null, title:String = null, posttype:String = null, network:SN_Vkontakte = null, apiConnection:APIConnection = null):void {
        _uidWall = uid;
        _messageWall = message;
        _urlWall = url;
        _typePost = posttype;
        _imageWallPost = image;
        _network = network;
        _apiConnection = apiConnection;

        Cc.ch('social', 'start photos.getWallUploadServer');
        _apiConnection.api("photos.getWallUploadServer", {uid: _uidWall, https: 1}, continueWallPost, _network.onError);
    }

    private function continueWallPostSavePhoto():void {
        _apiConnection.api("photos.saveWallPhoto", {server: _saveWallPhoto.server, photo: _saveWallPhoto.photo, hash: _saveWallPhoto.hash, https: 1}, wallPostSavePhotoComplete, _network.onError);
    }

    private function destroy():void {
        _uidWall = null;
        _messageWall = null;
        _urlWall = null;
        _typePost = null;
        _imageWallPost = null;
        _network = null;
        _apiConnection = null;
        _saveWallPhoto = null;
    }

    private function continueWallPost(e:Object):void {
//        var loader:URLLoader = new URLLoader();
//        if (!_imageWallPost || !e) {
//            return;
//        }
//
//        Cc.obj("social", e, "before loading", 5);
//        var form:Multipart = new Multipart(e.upload_url);
//        var enc:JPGEncoder = new JPGEncoder(100);
//        var jpg:ByteArray = enc.encode(_imageWallPost.bitmapData);
//        form.addFile("file1", jpg, "application/octet-stream", "wallpost.jpg");
//
//        loader.addEventListener(Event.COMPLETE, wallPostSavePhoto);
//        try {
//            loader.load(form.request);
//        } catch (error:Error) {
//            Cc.ch("social", "Problem with wallpost on VK: " + error.message, 9);
//        }
    }

    private function wallPostSavePhoto(e:Event):void {
        _saveWallPhoto = JSONuse.decode(e.target.data);

        continueWallPostSavePhoto();
    }

    private function wallPostSavePhotoComplete(e:Object):void {
        var message:String;

        message = 'Птичий Островок' + "\n" + _messageWall + "\n" + _network.urlApp + "?ad_id=wall" + _uidWall + "_" + _network.currentUID + "_" + _typePost;
        _apiConnection.api("wall.post", {owner_id: _uidWall, message: message, attachments: e[0].id, https: 1}, wallPostSavePostComplete, onErrorPost);
    }

    private function onErrorPost(e:Object):void {
        switch (e.error_code) {
            case 10007:
                _network.wallCancelPublic();
                break;
            default :
                _network.wallCancelPublic();
        }
    }

    private function wallPostSavePostComplete(e:Object):void {
        _network.wallSavePublic();
    }
}
