/**
 * Created by user on 5/20/15.
 */
package temp {
public class DataBuildings {
    public static const STATIC_BUILDING:String = "static building";
    public static const ACTIVE_BUILDING:String = "active building";

    public static const HARD_CURRENCY:String = 'diamant';
    public static const SOFT_CURRENCY:String = 'coin';

    public var objectBuilding:Object;

    public function DataBuildings() {
        objectBuilding={};

        filldatabuilding();


    }

    private function filldatabuilding():void {
        var obj:Object;

        obj = {};
        obj.id = 1;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile 3x3";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;

        obj = {};
        obj.id = 2;
        obj.name = "3x3";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile 4x4";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 2;
        obj.buildTime = 15000;
        objectBuilding[obj.id ] = obj;
    }
}
}
