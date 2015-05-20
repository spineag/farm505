/**
 * Created by user on 5/20/15.
 */
package temp {
public class DataBuildings {
    public static const STATIC_BUILDING:String = "static building";
    public static const ACTIVE_BUILDING:String = "active building";

    public var objectBuilding:Object;

    public function DataBuildings() {
        objectBuilding={};

        filldatabuilding();


    }

    private function filldatabuilding():void {
        var obj:Object;

        obj = {};
        obj.id = 1;
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile 3x3";
        obj.type = ACTIVE_BUILDING;
        objectBuilding[obj.id ] = obj;

        obj.id = 2;
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile 4x4";
        obj.type = ACTIVE_BUILDING;
        objectBuilding[obj.id ] = obj;
    }
}
}
