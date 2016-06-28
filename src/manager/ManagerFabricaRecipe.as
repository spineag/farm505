/**
 * Created by andy on 8/5/15.
 */
package manager {
import build.WorldObject;
import build.fabrica.Fabrica;

import com.junkbyte.console.Cc;

import resourceItem.ResourceItem;

public class ManagerFabricaRecipe {
    private var _arrFabrica:Array;  // все фабрики юзера, которые стоят на поляне и построенны

    private var g:Vars = Vars.getInstance();

    public function ManagerFabricaRecipe() {
        var arr:Array = g.townArea.cityObjects;
        _arrFabrica = [];
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] is Fabrica && arr[i].stateBuild == WorldObject.STATE_ACTIVE) {
                _arrFabrica.push(arr[i]);
            }
        }
    }

    public function onAddNewFabrica(fb:Fabrica):void { // add only activated fabrica
        _arrFabrica.push(fb);
    }

    public function addRecipe(ob:Object):void {
        var i:int;
        var curFabrica:Fabrica;
        var resItem:ResourceItem = new ResourceItem();
        for (i=0; i<_arrFabrica.length; i++) {
            if (_arrFabrica[i].dbBuildingId == int(ob.user_db_building_id)) {
                curFabrica = _arrFabrica[i];
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

    public function getFabricaWithPossibleRecipe():Fabrica {
        var k:int;
        var l:int;
        var f:Fabrica;
        var r:Object;
        var isReady:Boolean;
        for (var i:int=0; i<_arrFabrica.length; i++){
            f = _arrFabrica[i];
            for (k=0; f.arrRecipes.length; k++) {
                r = f.arrRecipes[k];
                isReady = true;
                for (l=0; l<r.ingridientsId.length; l++) {
                    if (g.userInventory.getCountResourceById(r.ingridientsId[l]) < r.ingridientsCount[l]) {
                        isReady = false;
                        break;
                    }
                }
                if (isReady) {
                    return f;
                }
            }
        }
        return null;
    }
}
}
