/**
 * Created by user on 2/5/16.
 */
package heroes {
import manager.Vars;

public class ManagerOrderCats {
    public var _arrCats:Array;
    private var g:Vars = Vars.getInstance();

    public function ManagerOrderCats() {
        _arrCats = [];
    }

    public function addCatsOnStartGame():void {
        var arr:Array = g.managerOrder.arrOrders;
        var cat:OrderCat;
        for (var i:int=0; i<arr.length; i++) {
            cat = new OrderCat(int(Math.random()*6 + 1));
            cat.setTailPositions(30, 25 - i*2);
            _arrCats.push(cat);
            arr[i].cat = cat;
            cat.idleFrontAnimation();
        }
    }
}
}
