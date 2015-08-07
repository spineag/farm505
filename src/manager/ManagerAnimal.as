/**
 * Created by andy on 8/6/15.
 */
package manager {
import build.farm.Farm;

import com.junkbyte.console.Cc;

public class ManagerAnimal {
    private var arrFarm:Array;  // все фермы юзера, которые стоят на поляне и построенны

    private var g:Vars = Vars.getInstance();

    public function ManagerAnimal() {
        var arr:Array = g.townArea.cityObjects;
        arrFarm = [];
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] is Farm) {
                arrFarm.push(arr[i]);
            }
        }
    }

    public function addAnimal(ob:Object):void {
        var i:int;
        var curFarm:Farm;
        for (i = 0; i < arrFarm.length; i++) {
            if (arrFarm[i].dbBuildingId == int(ob.user_db_building_id)) {
                curFarm = arrFarm[i];
                break;
            }
        }
        if (!curFarm) {
            Cc.error('no such Farm with dbId: ' + ob.user_db_building_id);
            return;
        }
        curFarm.addAnimal(true, ob);
    }
}
}
