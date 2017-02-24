/**
 * Created by user on 9/30/15.
 */
package data {
import manager.Vars;

public class AllData {
    public var lockedLandData:Object;
    public var atlas:Object;
    public var fonts:Object;
    public var factory:Object;  // StarlingFactory
    public var dataBuyMoney:Array;
    public var decorGroups:Object;
    public var recipe:Array;
    public var resource:Array;

    private var g:Vars = Vars.getInstance();

    public function AllData() {
        atlas = {};
        fonts = {};
        factory = {};
        dataBuyMoney = [];
        decorGroups = {};
        recipe = [];
        resource = [];
    }

    public function addToDecorGroup(dataDecor:Object):void {
        if (!decorGroups[dataDecor.group]) decorGroups[dataDecor.group] = [];
        decorGroups[dataDecor.group].push(dataDecor);
    }

    public function sortDecorData():void {
        for(var id:String in decorGroups) {
            (decorGroups[id] as Array).sortOn('id', Array.NUMERIC);
        }
    }

    public function isFirstInGroupDecor(groupId:int, id:int):Boolean {
        if (!decorGroups[groupId] || !decorGroups[groupId].length) return true;
        for (var i:int = 0; i<decorGroups[groupId].length; i++) {
            if (decorGroups[groupId][i].visibleTester) {
                if (g.user.isMegaTester || g.user.isTester) {
                    if (decorGroups[groupId][i].id == id) return true;
                    else return false;
                }
            } else {
                if (decorGroups[groupId][i].id == id) return true;
                else return false;
            }
        }
        return true;
    }

    public function getGroup(groupId:int):Array {
        if (groupId < 100) return []; // temp

        if (!decorGroups[groupId] || !decorGroups[groupId].length) return [];
        var arr:Array = [];
        for (var i:int=0 ;i<decorGroups[groupId].length; i++) {
            if (decorGroups[groupId][i].visibleTester) {
                if (g.user.isMegaTester || g.user.isTester) arr.push(decorGroups[groupId][i]);
            } else arr.push(decorGroups[groupId][i]);
        }
        return arr;
    }

    public function getFabricaIdForResourceIdFromRecipe(rId:int):int {
        for (var i:int = 0; i < recipe.length; i++) {
            if (g.allData.recipe[i] && recipe[i].idResource == rId) {
                return recipe[i].buildingId;
            }
        }
        return 0;
    }

    public function getFarmIdForResourceId(rId:int):int {
        var d:Object = g.dataAnimal.objectAnimal;
        for(var id:String in d) {
            if (d[id].idResource == rId) {
                return d[id].buildId;
            }
        }
        return 0;
    }
    
    public function getFarmIdForAnimal(aId:int):int {
        var d:Object = g.dataAnimal.objectAnimal;
        for(var id:String in d) {
            if (d[id].id == aId) {
                return d[id].buildId;
            }
        }
        return 0;
    }
}
}
