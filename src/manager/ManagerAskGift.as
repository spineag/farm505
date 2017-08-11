/**
 * Created by andy on 8/3/17.
 */
package manager {
import data.StructureDataResource;
import data.StructureUserGift;
import social.SocialNetworkSwitch;
import user.Someone;
import utils.Utils;
import windows.WindowsManager;

public class ManagerAskGift {
    private var g:Vars = Vars.getInstance();
    private var _arrAsk:Array;
    private var _arrSend:Array;

    public function ManagerAskGift() {
        if (!g.user.isTester || g.socialNetworkID != SocialNetworkSwitch.SN_FB_ID) return;
        _arrAsk = [];
        _arrSend = [];
        g.directServer.getUserDataGifts(onGetData);
    }

    private function onGetData(d:Object):void {
        g.friendPanel.showAskGiftButton();
        var i:int;
        var st:StructureUserGift;
        var ar:Array = d.message.ask;
        var p:Someone;
        for (i=0; i<ar.length; i++) {
            st = new StructureUserGift(ar[i]);
            st.forAsk = true;
            _arrAsk.push(st);
            p = g.user.getFriendById((_arrAsk[i] as StructureUserGift).userId2);
            if (p) p.canAskFromFriend = false;
        }
        ar = d.message.send;
        for (i=0; i<ar.length; i++) {
            st = new StructureUserGift(ar[i]);
            st.forAsk = false;
            _arrSend.push(st);
            p = g.user.getFriendById((_arrAsk[i] as StructureUserGift).userId2);  // simple and wrong logic ...or not)
            if (p) p.canSendToFriend = false;
        }
        Utils.createDelay(5, function():void { 
            if (_arrAsk.length || _arrSend.length) g.windowsManager.openWindow(WindowsManager.WO_ACCEPT_SENT_GIFT);
        });
    }

    public function get availableForGifts():Array {
        var ar:Array;
        if (g.user.level < 5) ar = [2,3,4,7,8,9];
        else ar = [2,3,4,6,7,8,5,6,124,125];
        return ar;
    }

    public function askGiftsFromFriends(arrFriends:Array, dataResourse:StructureDataResource):void {
        var ar:Array = [];
        for (var i:int=0; i<arrFriends.length; i++) {
            ar.push((arrFriends[i] as Someone).userId);
        }
        g.directServer.askGiftsFromFriends(ar, dataResourse.id);
    }

    public function sentGiftsFromUserDirectly(arrFriends:Array, dataResourse:StructureDataResource):void {
        var ar:Array = [];
        for (var i:int=0; i<arrFriends.length; i++) {
            ar.push((arrFriends[i] as Someone).userId);
        }
        g.directServer.sentGiftsFromUserDirectly(ar, dataResourse.id);
    }

    public function get possibleArrayForAcceptSentGifts():Array {
        var ar:Array = [];
        for (var i:int=0; i<_arrAsk.length; i++) {
            if (_arrAsk[i].isSend == 1) ar.push(_arrAsk[i]);
        }
        for (i=0; i<_arrSend.length; i++) {
            if (_arrSend[i].isSend == 0)ar.push(_arrSend[i]);
        }
        return ar;
    }
    
    public function onAcceptGiftFromFriend(d:StructureUserGift):void {
        _arrAsk.removeAt(_arrAsk.indexOf(d));
        g.directServer.acceptGiftFromFriendsByDbId([d.dbId]);
    }
    
    public function onSendGiftToFriend(d:StructureUserGift):void {
        _arrSend.removeAt(_arrSend.indexOf(d));
        g.directServer.sentGiftToFriendsByDbId([d.dbId], [d.userId1]);
    }
    
    public function acceptAllGifts():void {
        var ar:Array = [];
        for (var i:int=0; i<_arrAsk.length; i++) {
            ar.push((_arrAsk[i] as StructureUserGift).dbId);
        }
        _arrAsk.length = 0;
        g.directServer.acceptGiftFromFriendsByDbId(ar);
    }
    
    public function sentAllGifts():void {
        var ar:Array = [];
        var ar2:Array = [];
        for (var i:int=0; i<_arrSend.length; i++) {
            ar.push((_arrSend[i] as StructureUserGift).dbId);
            ar2.push((_arrSend[i] as StructureUserGift).userId1);
        }
        _arrSend.length = 0;
        g.directServer.sentGiftToFriendsByDbId(ar, ar2);
    }
}
}
