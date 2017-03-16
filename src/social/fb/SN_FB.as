/**
 * Created by andy on 3/15/17.
 */
package social.fb {
import com.junkbyte.console.Cc;
import flash.external.ExternalInterface;
import flash.utils.getTimer;
import social.SocialNetwork;
import user.Friend;

public class SN_FB extends SocialNetwork  {
    private static const API_SECRET_KEY:String = "dd3c1b11a323f01a3ac23a3482724c49";

    private var _friendsRest:Array;

    public function SN_FB(flashVars:Object) {
        _friendsRest = [];
        URL_AVATAR_BLANK = g.dataPath.getGraphicsPath() + "/social/iconNeighbor.png";

        if (ExternalInterface.available) {
            ExternalInterface.addCallback('getProfileHandler', getProfileHandler);
            ExternalInterface.addCallback('getAllFriendsHandler', getAllFriendsHandler);
//            ExternalInterface.addCallback('getUsersInfoHandler', getUsersInfoHandler);
            ExternalInterface.addCallback('getAppUsersHandler', getAppUsersHandler);
            ExternalInterface.addCallback('getFriendsByIdsHandler', getFriendsByIdsHandler);
//            ExternalInterface.addCallback('onPaymentCallback', onPaymentCallback);
            ExternalInterface.addCallback('getTempUsersInfoByIdHandler', getTempUsersInfoByIdCallback);
//            ExternalInterface.addCallback('isInGroupCallback', isInGroupCallback);
//            ExternalInterface.addCallback('wallPostSave', wallSavePublic);
//            ExternalInterface.addCallback('wallPostCancel', wallCancelPublic);
        }
        super(flashVars);
    }

    override public function getProfile(uid:String):void {
        super.getProfile(uid);
        ExternalInterface.call("getProfile", uid);
    }

    private function getProfileHandler(e:Object):void {
        Cc.ch('social', 'FB: getProfileHandler:');
        Cc.obj('social', e);
        try {
            _paramsUser = {};
            _paramsUser.firstName = String(e.first_name);
            _paramsUser.lastName = String(e.last_name);
            _paramsUser.photo = String(e.picture) || URL_AVATAR_BLANK;
            _paramsUser.sex = String(e.gender);
            _paramsUser.bdate = String(e.birthday);

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
                setFriendInfo(buffer.id, buffer.first_name, buffer.last_name, buffer.picture);
                _friendsApp.push(buffer);
            }
        }
        super.getFriendsSuccess("x");
    }

    override public function getTempUsersInfoById(arr:Array):void {
        super.getTempUsersInfoById(arr);
        ExternalInterface.call("getTempUsersInfoById", arr);
    }

    private function getTempUsersInfoByIdCallback(e:Object):void {
        Cc.ch('social', 'OK: getTempUsersInfoByIdCallback:');
        if (e) Cc.obj('social', e);
        var ar:Array = [];
        var ob:Object;
        for (var key:String in e) {
            ob = {};
            ob.uid = e[key].id;
            ob.first_name = e[key].first_name;
            ob.last_name = e[key].last_name;
            ob.photo_100 = e[key].picture;
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
        ExternalInterface.call("getFriendsByIds", arr);
    }

    private function getFriendsByIdsHandler(e:Object):void {
        Cc.ch('social', 'OK: getFriendsByIdsHandler:');
        Cc.obj('social', e);
        var ob:Object;
        for (var key:String in e) {
            ob = {};
            ob.uid = e[key].id;
            ob.first_name = e[key].first_name;
            ob.last_name = e[key].last_name;
            ob.photo_100 = e[key].picture;
            g.user.addFriendInfo(ob);
        }
        if (_friendsApp.length) {
            getFriendsByIDs(_friendsApp);
        } else {
            super.getFriendsByIDsSuccess(e);
        }
    }
}
}
