/**
 * Created by user on 9/2/15.
 */
package manager {
import com.junkbyte.console.Cc;

import data.StructureMarketItem;

import user.Someone;

public class ManagerPaper {
    private var _arr:Array;
    private var g:Vars = Vars.getInstance();

    public function ManagerPaper() {
        _arr = [];
    }

    public function fillIt(ar:Array):void {
        var ob:StructureMarketItem;
        _arr = null;
        _arr = [];
        for (var i:int=0; i<ar.length; i++) {
            if (int(ar[i].user_id == g.user.userId)) continue;
            ob = new StructureMarketItem(ar[i]);
            if (ob.resourceCount > 0 && ob.cost > 0) _arr.push(ob);
        }
    }

    public function get arr():Array { return _arr; }
    public function getPaperItems():void { g.directServer.getPaperItems(null); }

    public function onBuyAtMarket(ob:StructureMarketItem):void {
        var arr:Array = g.user.arrFriends.concat(g.user.arrTempUsers);
        for (var j:int = 0; j< arr.length; j++) {
            if ((arr[j] as Someone).userSocialId == ob.userSocialId) {
                for (var i:int = 0; i < arr[j].marketItems.length; i++) {
                    if ((arr[j].marketItems[i] as StructureMarketItem).id == ob.id) {
                        (arr[j].marketItems[i] as StructureMarketItem).buyerId = g.user.userId;
                        (arr[j].marketItems[i] as StructureMarketItem).inPapper = false;
                        (arr[j].marketItems[i] as StructureMarketItem).buyerSocialId = g.user.userSocialId;
                        break;
                    }
                }
                return;
            }
        }
        Cc.error('ManagerPaper onBuyAtMarket:: no user for such StructureMarketItem');
    }
}
}
