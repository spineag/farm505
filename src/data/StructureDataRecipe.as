/**
 * Created by user on 2/24/17.
 */
package data {
import manager.Vars;

import utils.Utils;

public class StructureDataRecipe {
//    public var
    private var _id:int;
    private var _idResource:int;
    private var _ingridientsId:Array;
    private var _ingridientsCount:Array;
    private var _numberCreate:int;
    private var _buildingId:int;
    private var _priceSkipHard:int;
    private var _blockByLevel:int;
    private var _buildType:int;
    private var g:Vars = Vars.getInstance();

    public function StructureDataRecipe(ob:Object) {
        _id = int(ob.id);
        _idResource = int(ob.resource_id);
        _numberCreate = int(ob.count_create);
        _ingridientsId = Utils.intArray(String(ob.ingredients_id).split('&'));
        _ingridientsCount = Utils.intArray(String(ob.ingredients_count).split('&'));
        _buildingId = int(ob.building_id);
        _priceSkipHard = int(ob.prise_skip);
        _blockByLevel = g.dataResource.objectResources[_idResource].blockByLevel;
        _buildType = g.dataResource.objectResources[_idResource].buildType;
//        g.allData.recipe[_id] = obj;
    }

    public function get id():int {return _id;}
    public function get idResource():int {return _idResource;}
    public function get numberCreate():int {return _numberCreate;}
    public function get ingridientsId():Array {return _ingridientsId;}
    public function get ingridientsCount():Array {return _ingridientsCount;}
    public function get buildingId():int {return _buildingId;}
    public function get priceSkipHard():int {return _priceSkipHard;}
    public function get blockByLevel():int {return _blockByLevel;}
    public function get buildType():int {return _buildType;}
}
}
