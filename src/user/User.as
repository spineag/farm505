/**
 * Created by andy on 6/10/15.
 */
package user {

import com.junkbyte.console.Cc;

import manager.Vars;

public class User extends Someone {
    public var userId:int; // в базе
    public var ambarMaxCount:int;
    public var skladMaxCount:int;
    public var ambarLevel:int;
    public var skladLevel:int;
    public var softCurrencyCount:int;
    public var hardCurrency:int;
    public var yellowCouponCount:int;
    public var redCouponCount:int;
    public var blueCouponCount:int;
    public var greenCouponCount:int;
    public var xp:int = 0;
    public var sex:String = 'm';
    public var isTester:Boolean;
    public var isMegaTester:Boolean;
    public var userBuildingData:Object; // info about building in build progress
    public var arrFriends:Array;
    public var arrTempUsers:Array;     // users that not your friends, but you interact with them
    public var neighbor:NeighborBot;
    public var countCats:int;
    public var timePaper:int;

    private var g:Vars = Vars.getInstance();

    public function User() {
        if (!g.useDataFromServer) {
            ambarLevel = 1;
            skladLevel = 1;
            ambarMaxCount = 50;
            skladMaxCount = 50;
            softCurrencyCount = 1000;
            hardCurrency = 100;
            yellowCouponCount = 10;
            redCouponCount = 5;
            greenCouponCount = 7;
            blueCouponCount = 8;
            xp = 173;
            level = 1;
            globalXP = 0;
            isTester = true;
        }
        userBuildingData = {};
        arrFriends = [];
        arrTempUsers = [];

        neighbor = new NeighborBot();

//        for (var i:int = 0; i < arrFriends.length; i++) {
//            g.directServer.getFriendsInfo(int(arrFriends[i].userSocialId),arrFriends[i],null);
//        }
    }

    public function checkUserLevel():void {
        var levels:Object = g.dataLevel.objectLevels;
        var txp:int = 0;
        for (var st:String in levels) {
            if (txp + levels[st].xp > globalXP) {
                xp = globalXP - txp;
                level = int(levels[st].id) - 1;
                if (level <= 0) level = 1;
                return;
            } else {
                level = levels[st].id;
                txp += levels[st].xp;
            }
        }
//        if (level <= 0) level = 1;
    }

    public function friendAppUser():void {
        g.socialNetwork.getAppUsers();
    }

    public function addFriendInfo(ob:Object):void {
        var f:Friend;
        var i:int;
        for (i=0; i<arrFriends.length; i++) {
            if (arrFriends[i].userSocialId == ob.uid) {
                f = arrFriends[i];
                break;
            }
        }
        if (!f) {
            Cc.error('User:: error with friend: ' + ob.uid);
            return;
        }
        f.name = ob.first_name;
        f.lastName = ob.last_name;
        f.photo = ob.photo_100;
    }

    public function fillSomeoneMarketItems(arr:Array, socId:String):void {
        var p:Someone;
        var i:int;
        var obj:Object;

        p = getSomeoneBySocialId(socId);
        p.marketItems = [];
        for (i=0; i<arr.length; i++) {
            obj = {};
            obj.id = int(arr[i].id);
            obj.buyerId = arr[i].buyer_id;
            arr[i].buyer_social_id ? obj.buyerSocialId = arr[i].buyer_social_id : obj.buyerSocialId = '0';
            obj.cost = int(arr[i].cost);
            obj.inPapper = Boolean(arr[i].in_papper == '1');
            obj.resourceCount = int(arr[i].resource_count);
            obj.resourceId = int(arr[i].resource_id);
            obj.timeSold = arr[i].time_sold;
            obj.timeStart = arr[i].time_start;
            obj.numberCell = arr[i].number_cell;
            p.marketItems.push(obj);
        }
    }

    public function fillNeighborMarketItems(ob:Object):void {
        var i:int;
        var obj:Object;

        neighbor.marketItems = [];
        for (i=0; i < 6; i++) {
            obj = {};
            obj.id = i+1;
            obj.cost = 1;
            obj.inPapper = false;
            obj.resourceCount = 1;
            obj.buyerId = '0';
            switch (i) {
                case 0: obj.resourceId = int(ob.resource_id1); break;
                case 1: obj.resourceId = int(ob.resource_id2); break;
                case 2: obj.resourceId = int(ob.resource_id3); break;
                case 3: obj.resourceId = int(ob.resource_id4); break;
                case 4: obj.resourceId = int(ob.resource_id5); break;
                case 5: obj.resourceId = int(ob.resource_id6); break;
            }
            obj.timeSold = 0;
            obj.timeStart = 0;
            neighbor.marketItems.push(obj);
        }
    }

    public function getSomeoneBySocialId(socId:String):Someone {
        var p:Someone;
        var i:int;
        if (socId == userSocialId) {
            p = this;
        } else {
            for (i=0; i<arrFriends.length; i++) {
                if (arrFriends[i].userSocialId == socId) {
                    p = arrFriends[i];
                    break;
                }
            }
        }

        if (!p) {
            for (i=0; i<arrTempUsers.length; i++) {
                if (arrTempUsers[i].userSocialId == socId) {
                    p = arrTempUsers[i];
                    break;
                }
            }
        }

        if (!p) {
            p = new TempUser();
            p.userSocialId = socId;
            arrTempUsers.push(p);
        }

        return p;
    }

    public function addTempUsersInfo(ar:Array):void {
        for (var i:int=0; i<ar.length; i++) {
            var p:Someone = getSomeoneBySocialId(ar[i].uid);
            if (p is TempUser || p is Friend) {
                p.name = ar[i].first_name;
                p.lastName = ar[i].last_name;
                p.photo = ar[i].photo_100;
            }
        }
    }
}
}
