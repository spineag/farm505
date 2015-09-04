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
        _arr = [];
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
            _arr.push(ob);
        }
    }

    public function get arr():Array {
        return _arr;
    }
}
}
