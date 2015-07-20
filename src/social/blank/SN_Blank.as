package social.blank {
import com.adobe.images.JPGEncoder;
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.net.FileReference;
import flash.utils.ByteArray;
import social.SocialNetwork;

public class SN_Blank extends SocialNetwork {

    public function SN_Blank(flashVars:Object, channelMark:String, serverPath:String, contentPath:String = null) {
        _channelMark = channelMark;

        flashVars["channelGUID"] ||= "d3a603c8017548938c30c3f13a2d7741";

        _serverPath = serverPath;
        _contentPath = (contentPath || serverPath);

        super(flashVars);
    }

    override public function getProfile(uid:String):void {
        super.getProfile(uid);
        _paramsUser.firstName = String(uid);
        super.getProfileSuccess(_paramsUser);
    }

    override public function getFriends():void {
        super.getFriends();
        super.getFriendsSuccess(0);
    }

    override public function getAppUsers():void {
        super.getAppUsers();
        super.getAppUsersSuccess(0);
    }

    override public function getUsersOnline():void {
        super.getUsersOnline();
        super.getUsersOnlineSuccess(null);
    }


    override public function requestBox(uid:String, message:String, requestKey:String):void {
        Cc.info("Clicked add me button.");
        showInviteWindow();
    }

    override public function showInviteWindow():void {
        Cc.info("Clicked invite friends button.");
    }

    override public function wallPost(uid:String, message:String, image:DisplayObject, url:String = null, title:String = null, posttype:String = null, idObj:String = '0'):void {
        super.wallPost(uid, message, image, url, title, posttype);
        super.wallSave();
    }

//    override public function get currentUID():String {
//        return _flashVars["uid"];
//    }

    override public function showOrderWindow(e:Object):void {
        Cc.info("Clicked show order window button.");
        super.showOrderWindow(e);
    }

    override public function getUserParams():Object {
//        return {auth_key: g.sessionKey};
    }

    override public function saveScreenshotToAlbum(oid:String):void {
        //g.managerCutSceneWarning.visible = false;
        saveLocal();
        super.saveScreenshotToAlbum(oid);
    }

    private function saveLocal():void {
        return;

        var bitMap:Bitmap;
        var jpgEncoder:JPGEncoder = new JPGEncoder(90);

        bitMap = makeScreenShot();
        if (!bitMap) {
            return;
        }

        var byteArray:ByteArray = jpgEncoder.encode(bitMap.bitmapData);
        var fileReference:FileReference = new FileReference();

        fileReference.save(byteArray, "BirdsIsland.jpg");
    }
}
}