package social.blank_FB {
import com.adobe.images.JPGEncoder;
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.net.FileReference;
import flash.utils.ByteArray;
import social.SocialNetwork;

import user.Friend;

public class SN_Blank_FB extends SocialNetwork {

    public function SN_Blank_FB(flashVars:Object) {

        flashVars["channelGUID"] ||= "d3a603c8017548938c30c3f13a2d7741";
        g.user.userSocialId = flashVars['uid'];
        super(flashVars);
    }

    override public function get currentUID():String { return g.user.userSocialId; }

    override public function getProfile(uid:String):void {
        super.getProfile(g.user.userSocialId);
        g.directServer.FBfake_getProfile(g.user.userSocialId, onGetProfile);
    }
    
    private function onGetProfile(ob:Object):void {
        _paramsUser.firstName = ob.firstName;
        _paramsUser.lastName = ob.lastName;
        _paramsUser.photo = ob.photo;
        _paramsUser.sex = ob.sex;
        _paramsUser.bdate = '0';
        _paramsUser.timezone = ob.timezone;
        super.getProfileSuccess(_paramsUser);
    }

    override public function getAllFriends():void {
        super.getAllFriends();
        super.getFriendsSuccess(0);
    }

    override public function getAppUsers():void {
        super.getAppUsers();
        g.directServer.FBfake_getAppUsers(onGetAppUsers);
    }
        
    private function onGetAppUsers(ob:Object):void {
        var f:Friend;
        for (var i:int=0; i<ob.length; i++) {
            if (ob[i].social_id == g.user.userSocialId) continue;
            f = new Friend();
            f.userId = ob[i].id;
            f.userSocialId = ob[i].social_id;
            f.name = ob.first_name;
            f.lastName = ob.last_name;
            f.photo = ob.photo_url;
            if (f.photo == '' || f.photo == 'unknown') ob.photo = SocialNetwork.getDefaultAvatar();
            g.user.arrFriends.push(f);
        }
        super.getAppUsersSuccess(0);
        super.getFriendsByIDsSuccess();
    }

    override public function getTempUsersInfoById(arr:Array):void {
        super.getTempUsersInfoById(arr);
        if (arr && arr.length) {
            g.directServer.FBgetUsersProfiles(arr, getTempUsersInfoByIdCallbackFromServer);
        } else {
            Cc.error("FB getTempUsersInfoById:: empty array or not exist");
            super.getTempUsersInfoByIdSucces();
        }
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
            if (ob.photo_100 == '' || ob.photo_100 == 'unknown') ob.photo = SocialNetwork.getDefaultAvatar();
            ar.push(ob);
        }
        g.user.addTempUsersInfo(ar);
        super.getTempUsersInfoByIdSucces();
    }

    override public function wallPost(uid:String, message:String, image:DisplayObject, url:String = null, title:String = null, posttype:String = null, idObj:String = '0'):void {
        super.wallPost(uid, message, image, url, title, posttype);
        super.wallSave();
    }

}
}