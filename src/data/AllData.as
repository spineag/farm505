/**
 * Created by user on 9/30/15.
 */
package data {
import build.farm.Farm;

import com.junkbyte.console.Cc;

import manager.Vars;

public class AllData {
    public var lockedLandData:Object;
    public var atlas:Object;
    public var fonts:Object;
    public var factory:Object;  // StarlingFactory
    public var dataBuyMoney:Array;
    public var decorGroups:Object;
    private var _recipe:Array;
    private var _resource:Array;
    private var _building:Array;
    private var _animal:Array;
    private var g:Vars = Vars.getInstance();

    public function AllData() {
        atlas = {};
        fonts = {};
        factory = {};
        dataBuyMoney = [];
        decorGroups = {};
        _recipe = [];
        _resource = [];
        _building = [];
        _animal = [];
    }

    public function registerBuilding(b:StructureDataBuilding):void {
        if (b.id > 0) _building.push(b);
            else Cc.error('registerBuilding id <= 0');
    }
    
    public function registerResource(b:StructureDataResource):void {
        if (b.id > 0) _resource.push(b);
            else Cc.error('registerResource id <= 0');
    }

    public function registerRecipe(b:StructureDataRecipe):void {
        if (b.id > 0) _recipe.push(b);
            else Cc.error('registerRecipe id <= 0');
    }

    public function registerAnimal(b:StructureDataAnimal):void {
        if (b.id > 0) _animal.push(b);
        else Cc.error('registerAnimal id <= 0');
    }

    public function addToDecorGroup(dataDecor:StructureDataBuilding):void {
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

    public function getGroup(groupId:int):Array { // for decor
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
        for (var i:int = 0; i < _recipe.length; i++) {
            if (_recipe[i].idResource == rId) return _recipe[i].buildingId;
        }
        return 0;
    }

    public function getFarmIdForResourceId(rId:int):int {
        for (var i:int=0; i<_animal.length; i++) {
            if ((_animal[i] as StructureDataAnimal).idResource == rId) return (_animal[i]  as StructureDataAnimal).buildId;
        }
        return 0;
    }
    
    public function getFarmIdForAnimal(aId:int):int {
        for (var i:int=0; i<_animal.length; i++) {
            if ((_animal[i] as StructureDataAnimal).id == aId) return (_animal[i]  as StructureDataAnimal).buildId;
        }
        return 0;
    }

    public function getResourceById(idResourse:int):StructureDataResource {
        for (var i:int=0; i<_resource.length; i++) {
            if ((_resource[i] as StructureDataResource).id == idResourse) return _resource[i];
        }
        return null;
    }

    public function getRecipeById(idRecipe:int):StructureDataRecipe {
        for (var i:int=0; i<_recipe.length; i++) {
            if ((_recipe[i] as StructureDataRecipe).id == idRecipe) return _recipe[i];
        }
        return null;
    }

    public function getBuildingById(idBuilding:int):StructureDataBuilding {
        for (var i:int=0; i<_building.length; i++) {
            if ((_building[i] as StructureDataBuilding).id == idBuilding) return _building[i];
        }
        return null;
    }

    public function getAnimalById(idAnimal:int):StructureDataAnimal {
        for (var i:int=0; i<_animal.length; i++) {
            if ((_animal[i] as StructureDataAnimal).id == idAnimal) return _animal[i];
        }
        return null;
    }

    public function getAnimalByFarmId(idBuild:int):StructureDataAnimal {
        for (var i:int=0; i<_animal.length; i++) {
            if ((_animal[i] as StructureDataAnimal).buildId == idBuild) return _animal[i];
        }
        return null;
    }

    public function get resource():Array { return _resource; }
    public function get recipe():Array { return _recipe; }
    public function get building():Array { return _building; }
    public function get animal():Array { return _animal; }
}
}
