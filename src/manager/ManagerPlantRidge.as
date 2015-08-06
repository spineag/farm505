/**
 * Created by andy on 8/6/15.
 */
package manager {
import build.ridge.Ridge;
import com.junkbyte.console.Cc;

public class ManagerPlantRidge {
    private var arrRidge:Array; // список всех грядок юзера

    private var g:Vars = Vars.getInstance();

    public function ManagerPlantRidge() {
        var arr:Array = g.townArea.cityObjects;
        arrRidge = [];
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] is Ridge) {
                arrRidge.push(arr[i]);
            }
        }
    }

    public function addPlant(ob:Object):void {
        var curRidge:Ridge;
        var i:int;
        for (i=0; i<arrRidge.length; i++) {
            if (arrRidge[i].dbBuildingId == int(ob.user_db_building_id)) {
                curRidge = arrRidge[i];
                break;
            }
        }
        if (!curRidge) {
            Cc.error('no such Ridge with dbId: ' + ob.user_db_building_id);
            return;
        }
        curRidge.fillPlant(g.dataResource.objectResources[int(ob.plant_id)], true, int(ob.time_work));
        curRidge.plant.idFromServer = ob.id;
    }

    public function onCraft(plantIdFromServer:String):void {
        g.directServer.craftPlantRidge(plantIdFromServer, null);
    }
}
}
