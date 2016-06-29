/**
 * Created by user on 9/2/15.
 */
package manager {
import data.BuildType;

public class ManagerPaper {
    private var _arr:Array;
    private var g:Vars = Vars.getInstance();

    public function ManagerPaper() {
        _arr = [];
    }

    public function fillIt(ar:Array):void {
        var ob:Object;
        for (var i:int=0; i<ar.length; i++) {
            if (int(ar[i].user_id == g.user.userId)) continue;
            ob = {};
            ob.id = int(ar[i].id);
            ob.resourceId = int(ar[i].resource_id);
            ob.resourceCount = int(ar[i].resource_count);
            ob.userId = int(ar[i].user_id);
            ob.userSocialId = ar[i].user_social_id;
            ob.cost = int(ar[i].cost);
            ob.isBuyed = false;
            ob.isBotBuy = false;
            ob.isOpened = false;
            _arr.push(ob);
        }
    }

    public function fillBot(ar:Array):void {
        var ob:Object;
        _arr = null;
        _arr = [];
        if (ar.length > 0) {
            for (var i:int = 0; i < ar.length; i++) {
                if (ar[i].visible == true) {
                    if (int(ar[i].user_id == g.user.userId)) continue;
                    ob = {};
                    ob.buyerId = int(ar[i].buyer_id);
                    ob.resourceId = int(ar[i].resource_id);
                    ob.resourceCount = int(ar[i].resource_count);
                    ob.cost = int(ar[i].cost);
                    ob.xp = int(ar[i].xp);
                    ob.type = int(ar[i].type_resource);
                    ob.timeToNext = int(ar[i].time_to_new);
                    ob.isBuyed = false;
                    ob.isBotBuy = true;
                    ob.visible = Boolean(ar[i].visible);
                    _arr.push(ob);
                } else if (ar[i].visible == false && (ar[i].time_to_new - int(new Date().getTime()/1000)) * (-1) >= 1800) {
                    trace ((ar[i].time_to_new - int(new Date().getTime()/1000)) * (-1));
                    newBot(false,ar[i]);
                }
            }
        } else newBot(true);

    }

    private function newBot(firstBot:Boolean = false, objectNew:Object = null):void {
        var id:String;
        var obData:Object = g.dataResource.objectResources;
        var arrMin:Array = [];
        var arr:Array;
        var arrMax:Array = [];
        var ob:Object;
        var ra:int;
        var i:int;
        if (firstBot) {
            for (id in obData) {
                if (obData[id].blockByLevel <= g.user.level && !g.userInventory.getCountResourceById(obData[id].id) && obData[id].visitorPrice > 0) {
                    arrMin.push(obData[id]);
                }
            }
            arr = g.userInventory.gerResourcesForAmbarAndSklad();
            arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
            for (i = 0; i < arr.length; i++) {
                if (arrMax.length >= 3) break;
                if (g.dataResource.objectResources[arr[i].id].visitorPrice > 0) arrMax.push(arr[i]);
            }
            ra =  Math.random() * arrMin.length;
            ob = {};
            ob.buyerId = 1;
            ob.resourceId = arrMin[ra].id;
            ob.resourceCount = 1;
            ob.cost = arrMin[ra].visitorPrice * ob.resourceCount;
            ob.xp = 5;
            ob.type = arrMin[ra].buildType;
            ob.timeToNext = 0;
            ob.isBuyed = false;
            ob.isBotBuy = true;
            ob.visible = true;
            _arr.push(ob);

            ra = Math.random() * arrMax.length;
            ob = {};
            ob.buyerId = 2;
            ob.resourceId = arrMax[ra].id;
            ob.resourceCount = int(Math.random()*arrMax[ra].count) + 1;
            ob.cost = g.dataResource.objectResources[arrMax[ra].id].visitorPrice * ob.resourceCount;
            ob.xp = 5;
            ob.type = g.dataResource.objectResources[arrMax[ra].id].buildType;
            ob.timeToNext = 0;
            ob.isBuyed = false;
            ob.isBotBuy = true;
            ob.visible = true;
            _arr.push(ob);
            for (i = 0; i < 2; i++) {
                g.directServer.addUserPapperBuy(_arr[i].buyerId, _arr[i].resourceId, _arr[i].resourceCount, _arr[i].xp, _arr[i].cost, 1);
            }
        } else  {
            if (objectNew.buyer_id == 1) {
                for (id in obData) {
                    if (obData[id].blockByLevel <= g.user.level && !g.userInventory.getCountResourceById(obData[id].id) && obData[id].visitorPrice > 0) {
                        arrMin.push(obData[id]);
                    }
                }
                ra = Math.random() * arrMin.length;
                ob = {};
                ob.buyerId = 1;
                ob.resourceId = arrMin[ra].id;
                ob.resourceCount = 1;
                ob.cost = arrMin[ra].visitorPrice * ob.resourceCount;
                ob.xp = 5;
                ob.type = arrMin[ra].buildType;
                ob.timeToNext = 0;
                ob.isBuyed = false;
                ob.isBotBuy = true;
                ob.visible = true;
            } else {
                arr = g.userInventory.gerResourcesForAmbarAndSklad();
                arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
                for (i = 0; i < arr.length; i++) {
                    if (arrMax.length >= 3) break;
                    if (g.dataResource.objectResources[arr[i].id].visitorPrice > 0) arrMax.push(arr[i]);
                }
                ra = Math.random() * arrMax.length;
                ob = {};
                ob.buyerId = 2;
                ob.resourceId = arrMax[ra].id;
                ob.resourceCount = int(Math.random()*arrMax[ra].count) + 1;
                ob.cost = g.dataResource.objectResources[arrMax[ra].id].visitorPrice * ob.resourceCount;
                ob.xp = 5;
                ob.type = g.dataResource.objectResources[arrMax[ra].id].buildType;
                ob.timeToNext = 0;
                ob.isBuyed = false;
                ob.isBotBuy = true;
                ob.visible = true;
            }
            _arr.push(ob);
            g.directServer.updateUserPapperBuy(ob.buyerId,ob.resourceId,ob.resourceCount,ob.xp,ob.cost,1,ob.type);
        }
    }

    public function get arr():Array {
        return _arr;
    }

    public function getPaperItems():void {
        g.directServer.getUserPapperBuy(getUserPapperBuy);

    }

    private function getUserPapperBuy ():void {
        g.directServer.getPaperItems(null);
    }
}
}
