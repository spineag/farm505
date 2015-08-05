/**
 * Created by andy on 8/5/15.
 */
package manager {
import build.WorldObject;
import build.fabrica.Fabrica;

import com.junkbyte.console.Cc;

import resourceItem.ResourceItem;

public class ManagerFabricaRecipe {
    private var arrFabrica:Array;  // все фабрики юзера, которые стоят на поляне и построенны

    private var g:Vars = Vars.getInstance();

    public function ManagerFabricaRecipe() {
        var arr:Array = g.townArea.cityObjects;
        arrFabrica = [];
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] is Fabrica && arr[i].stateBuild == WorldObject.STATE_ACTIVE) {
                arrFabrica.push(arr[i]);
            }
        }
    }

    public function addRecipe(ob:Object):void {
        var i:int;
        var curFabrica:Fabrica;
        var resItem:ResourceItem = new ResourceItem();
        for (i=0; i<arrFabrica.length; i++) {
            if (arrFabrica[i].dbBuildingId == int(ob.user_db_building_id)) {
                curFabrica = arrFabrica[i];
                break;
            }
        }
        if (!curFabrica) {
            Cc.error('no such Fabrica with dbId: ' + ob.user_db_building_id);
            return;
        }
        resItem.fillIt(g.dataResource.objectResources[g.dataRecipe.objectRecipe[int(ob.recipe_id)].idResource]);
        resItem.idFromServer = ob.id;
        if (int(ob.delay) > int(ob.time_work)) {
            curFabrica.callbackOnChooseRecipe(resItem, g.dataRecipe.objectRecipe[int(ob.recipe_id)], true);
        } else if (int(ob.delay) + resItem.buildTime <= int(ob.time_work)) {
            curFabrica.craftResource(resItem);
        } else {
            curFabrica.callbackOnChooseRecipe(resItem, g.dataRecipe.objectRecipe[int(ob.recipe_id)], true, int(ob.time_work) - int(ob.delay));
        }
    }

    public function onCraft(item:ResourceItem):void {
        g.directServer.craftFabricaRecipe(item.idFromServer, null);
    }
}
}
