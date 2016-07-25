/**
 * Created by andy on 7/7/15.
 */
package manager {
import com.junkbyte.console.Cc;

import data.DataMoney;

import resourceItem.DropItem;
import resourceItem.ResourceItem;

import temp.DropResourceVariaty;

public class ManagerDropBonusResource {
    private var arr:Array;
    private var g:Vars = Vars.getInstance();

    public function ManagerDropBonusResource() {
        arr = new DropResourceVariaty().resources;
    }

    public function checkDrop():Boolean {
        return int(Math.random()*100) < DropResourceVariaty.DROP_VARIATY;
    }

    public function makeDrop(_x:int, _y:int):void {
        if (!arr.length) return;
        var prise:Object = getDropPrise();
        if (g.user.level < 17) {
            if (prise.id == DataMoney.YELLOW_COUPONE || prise.id == DataMoney.BLUE_COUPONE || prise.id == DataMoney.RED_COUPONE || prise.id == DataMoney.GREEN_COUPONE) {
//                prise.id = DataMoney.SOFT_CURRENCY;
//                prise.count = 10;
//                prise.type = 'money';
//                prise.variaty = 1;
                prise = null;
                prise = getDropPrise();   // ??
            } else new DropItem(_x, _y, prise);
        } else new DropItem(_x, _y, prise);

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
