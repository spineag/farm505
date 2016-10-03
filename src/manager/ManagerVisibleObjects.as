/**
 * Created by user on 10/3/16.
 */
package manager {
import heroes.AddNewHero;
import heroes.BasicCat;
import heroes.OrderCat;

public class ManagerVisibleObjects {
    private var g:Vars = Vars.getInstance();
    private var _arr:Array;
    private var _arrAway:Array;

    public function ManagerVisibleObjects() {
        _arr = g.townArea.cityObjects;
        _arrAway = g.townArea.cityAwayObjects;
    }

    private function enableIt():void {
        for (var i:int=0; i<_arr.length; i++) {
            if (_arr[i] is BasicCat || _arr[i] is OrderCat || _arr[i] is AddNewHero) continue;

        }
    }

    private function disableIt():void {
        for (var i:int=0; i<_arr.length; i++) {
            if (_arr[i] is BasicCat || _arr[i] is OrderCat || _arr[i] is AddNewHero) continue;

        }
    }

    public function activateItOnDrag(isStartDrag:Boolean):void {
        if (isStartDrag) {
            enableIt();
        } else {
            disableIt();
        }
    }
}
}
