/**
 * Created by andy on 6/10/15.
 */
package user {
import build.tree.Tree;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.StructureMarketItem;
import manager.Vars;

public class User extends Someone {
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
    public var sex:String = 'w';
    public var isTester:Boolean;
    public var isMegaTester:Boolean;
    public var userBuildingData:Object; // info about building in build progress
    public var arrFriends:Array;
    public var arrTempUsers:Array;     // users that not your friends, but you interact with them
    public var neighbor:NeighborBot;
    public var countCats:int;
    public var tutorialStep:int;
    public var lastVisitAmbar:Boolean;
    public var cutScenes:Array;
    public var miniScenes:Array;
    public var villageNotification:int;
    public var fabricaNotification:int;
    public var plantNotification:int;
    public var decorNotification:int;
    public var allNotification:int;
    public var arrNoAppFriend:Array;
    public var wallTrainItem:Boolean;
    public var wallOrderItem:Boolean;
    public var decorShop:Boolean;
    public var decorShiftShop:int;
    public var userGAcid:String = 'unknown';
    public var paperShift:int;
    public var buyShopTab:int;
    public var animalIdArrow:int;
    public var shopDecorFilter:int = 1;
    public var sessionKey:String;
    public var fabricItemNotification:Array = [];
    public var bornDate:String;
    public var countAwayMouse:int;
    public var dayDailyGift:int;
    public var countDailyGift:int;
    public var starterPack:Boolean;
    public var salePack:Boolean;
    public var day:int;
    public var language:int;

    private var g:Vars = Vars.getInstance();

    public function User() {
        userBuildingData = {};
        arrFriends = [];
        arrTempUsers = [];
        arrNoAppFriend = [];
        lastVisitAmbar = true;
        countAwayMouse = 0;
    }

    public function set visitAmbar(b:Boolean):void  { lastVisitAmbar = b; }
    public function createNeighbor():void { neighbor = new NeighborBot(); }

    public function checkUserLevel():void {
//        var tempLevel:int;
//        var levels:Object = g.dataLevel.objectLevels;
//        var txp:int = 0;
//        for (var st:String in levels) {
//            if (txp + levels[st].xp > globalXP) {
//                xp = globalXP - txp;
//                tempLevel = int(levels[st].id) - 1;
//                if (tempLevel <= 0) tempLevel = 1;
//                break;
//            } else {
//                tempLevel = levels[st].id;
//                txp += levels[st].xp;
//            }
//        }

// temporary fix for levels
            if (g.dataLevel.objectLevels[level].totalXP > globalXP) {
                xp = globalXP;
                globalXP = g.dataLevel.objectLevels[level].totalXP + xp;
                g.directServer.addUserXP(globalXP, null);
            } else {
                xp = globalXP - g.dataLevel.objectLevels[level].totalXP;
            }
        g.userValidates.updateInfo('xp', xp);
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

    public function fillSomeoneMarketItems(arr:Array, socId:String, marketCell:int):void {
        var p:Someone;
        var i:int;
        var obj:StructureMarketItem;

        p = getSomeoneBySocialId(socId);
        p.marketCell = marketCell;
        p.marketItems = [];
        for (i=0; i<arr.length; i++) {
            obj = new StructureMarketItem(arr[i]);
            p.marketItems.push(obj);
        }
    }

    public function fillYoursMarketItems(arr:Array, cell:int):void {
        var i:int;
        var obj:StructureMarketItem;
        marketCell = cell;
        marketItems = [];
        for (i=0; i<arr.length; i++) {
            obj = new StructureMarketItem(arr[i]);
            marketItems.push(obj);
        }
    }

    public function fillNeighborMarketItems(ob:Object):void {
        var i:int;
        var obj:StructureMarketItem;

        neighbor.marketCell = 8;
        neighbor.marketItems = [];
        for (i=0; i < 6; i++) {
            obj = new StructureMarketItem({});
            obj.id = i+1;
            obj.inPapper = false;
            obj.resourceCount = 1;
            obj.buyerId = 0;
            obj.level = 1;
            switch (i) {
                case 0: obj.resourceId = int(ob.resource_id1); break;
                case 1: obj.resourceId = int(ob.resource_id2); break;
                case 2: obj.resourceId = int(ob.resource_id3); break;
                case 3: obj.resourceId = int(ob.resource_id4); break;
                case 4: obj.resourceId = int(ob.resource_id5); break;
                case 5: obj.resourceId = int(ob.resource_id6); break;
            }
            if (obj.resourceId > -1) {
                obj.cost = g.allData.getResourceById(obj.resourceId).costDefault;
                obj.timeSold = '0';
                obj.timeStart = '0';
                neighbor.marketItems.push(obj);
            }
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

    public function addInfoAboutFriendsFromServer(d:Array):void {
        var someOne:Someone;
        for (var i:int=0; i<d.length; i++) {
            someOne = getSomeoneBySocialId(d[i].social_id);
            someOne.level = int(d[i].level);
            someOne.needHelpCount = int(d[i].need_help);
            someOne.userId = int(d[i].id);
        }
    }

    public function calculateReasonForHelpAway():void {
        var ar:Array = g.townArea.getAwayCityObjectsByType(BuildType.TREE);
        var ar2:Array = [];
        for (var i:int=0; i<ar.length; i++) {
            if ((ar[i] as Tree).stateTree == Tree.ASK_FIX) ar2.push(ar[i]);
        }
        g.visitedUser.needHelpCount = ar2.length;
        if (g.visitedUser.needHelpCount > 0) g.bottomPanel.addHelpIcon();
    }

    public function onMakeHelpAway():void {
        if (!g.visitedUser) return;
        g.visitedUser.needHelpCount--;
        if (g.visitedUser.needHelpCount <= 0) {
            g.bottomPanel.removeHelpIcon();
            if (g.visitedUser is Friend) {
                g.friendPanel.updateFriendsPanel();
            }
        }
    }
}
}
