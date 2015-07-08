/**
 * Created by andy on 7/7/15.
 */
package manager {
import com.junkbyte.console.Cc;

import resourceItem.DropItem;
import resourceItem.ResourceItem;

import temp.DropResourceVariaty;

public class ManagerDropBonusResource {
    private var arr:Array;

    public function ManagerDropBonusResource() {
        arr = new DropResourceVariaty().resources;
    }

    public function checkDrop():Boolean {
        return int(Math.random()*10000) < DropResourceVariaty.DROP_VARIATY*100;
    }

    public function makeDrop(_x:int, _y:int):void {
        if (!arr.length) return;
        var prise:Object = getDropPrise();
        new DropItem(_x, _y, prise);
    }

    private function getDropPrise():Object {
        var i:int;
        var sum:int = 0;
        var r:int;

        for (i=0; i < arr.length; i++) {
            sum += arr[i].variaty;
        }

        r = int(Math.random()*sum) + 1;
        sum = 0;
        for (i=0; i < arr.length; i++) {
            sum += arr[i].variaty;
            if (sum >= r) return arr[i];
        }

        Cc.error('ManagerDropBonusResource:: Wrong with random');
        return arr[0];
    }
}
}
