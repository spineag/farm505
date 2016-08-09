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
        var j:int;
        var l:int;
        var f:Fabrica;
        var r:Object;
        var isReady:Boolean;
        for (var i:int=0; i<_arrFabrica.length; i++){
            f = _arrFabrica[i];
            if (f.arrList.length >= f.dataBuild.countCell) continue;
            for (j=0; j<f.arrRecipes.length; j++) {
                r = f.arrRecipes[j];
                if (!r) continue;
                if (r.blockByLevel > g.user.level) continue;
                isReady = true;
                for (l=0; l<r.ingridientsId.length; l++) {
                    if (g.userInventory.getCountResourceById(int(r.ingridientsId[l])) < int(r.ingridientsCount[l])) {
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
    
    public function getAllFabricasWithPossibleRecipe():Array {
        var j:int;
        var l:int;
        var f:Fabrica;
        var r:Object;
        var isReady:Boolean;
        var arr:Array = [];
        for (var i:int=0; i<_arrFabrica.length; i++){
            f = _arrFabrica[i];
            if (f.arrList.length >= f.dataBuild.countCell) continue;
            for (j=0; j<f.arrRecipes.length; j++) {
                r = f.arrRecipes[j];
                if (!r) continue;
                if (r.blockByLevel > g.user.level) continue;
                isReady = true;
                for (l=0; l<r.ingridientsId.length; l++) {
                    if (g.userInventory.getCountResourceById(int(r.ingridientsId[l])) < int(r.ingridientsCount[l])) {
                        isReady = false;
                        break;
                    }
                }
                if (isReady) {
                    arr.push(f);
                }
            }
        }
        return arr;
    }
    
    public function getAllFabricaWithCraft():Array {
        var arr:Array = [];
        for (var i:int=0; i<_arrFabrica.length; i++) {
            if ((_arrFabrica[i] as Fabrica).isAnyCrafted) {
                arr.push(_arrFabrica[i]);
            }
        }
        return arr;
    }

    public function onGoAwayCats(v:Boolean):void {
        for (var i:int=0; i<_arrFabrica.length; i++) {
            (_arrFabrica[i] as Fabrica).onGoAway(v);
        }
    }
}
}
