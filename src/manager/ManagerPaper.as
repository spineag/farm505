/**
 * Created by user on 9/2/15.
 */
package manager {

public class ManagerPaper {
    private var _arr:Array;
    private var g:Vars = Vars.getInstance();

    public function ManagerPaper() {
        _arr = [];
    }

    public function fillIt(ar:Array):void {
        var ob:Object;
        _arr = null;
        _arr = [];
        for (var i:int=0; i<ar.length; i++) {
            if (int(ar[i].user_id == g.user.userId)) continue;
            ob = {};
            ob.id = int(ar[i].id);
            ob.level = int(ar[i].level);
            ob.resourceId = int(ar[i].resource_id);
            ob.resourceCount = int(ar[i].resource_count);
            ob.userId = int(ar[i].user_id);
            ob.userSocialId = ar[i].user_social_id;
            ob.cost = int(ar[i].cost);
            ob.needHelp = int(ar[i].need_help);
            ob.isBuyed = false;
            ob.isBotBuy = false;
            ob.isOpened = false;
            if (ob.resourceCount > 0 && ob.cost > 0) _arr.push(ob);
        }
//        if (g.isDebug) fillArrayRandomly(); //- only for test paper
    }

    public function get arr():Array {
        return _arr;
    }

    public function getPaperItems():void {
       g.directServer.getPaperItems(null);

    }
}
}
