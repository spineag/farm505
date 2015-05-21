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
//        1
        obj = {};
        obj.id = 1;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        2
        obj = {};
        obj.id = 2;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 2;
        obj.buildTime = 15000;
        objectBuilding[obj.id ] = obj;
//         3
        obj = {};
        obj.id = 3;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//         4
        obj = {};
        obj.id = 4;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//         5
        obj = {};
        obj.id = 5;
        obj.name = "3x3";
        obj.width = 3;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//         6
        obj = {};
        obj.id = 6;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//         7
        obj = {};
        obj.id = 7;
        obj.name = "3x3";
        obj.width = 3;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//         8
        obj = {};
        obj.id = 8;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//         9
        obj = {};
        obj.id = 9;
        obj.name = "3x3";
        obj.width = 3;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        10
        obj = {};
        obj.id = 10;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        11
        obj = {};
        obj.id = 11;
        obj.name = "3x3";
        obj.width = 3;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        12
        obj = {};
        obj.id = 12;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        13
        obj = {};
        obj.id = 13;
        obj.name = "3x3";
        obj.width = 3;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        14
        obj = {};
        obj.id = 14;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        15
        obj = {};
        obj.id = 15;
        obj.name = "3x3";
        obj.width = 3;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        16
        obj = {};
        obj.id = 16;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        17
        obj = {};
        obj.id = 17;
        obj.name = "3x3";
        obj.width = 3;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        18
        obj = {};
        obj.id = 18;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        19
        obj = {};
        obj.id = 19;
        obj.name = "3x3";
        obj.width = 3;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
//        20
        obj = {};
        obj.id = 20;
        obj.name = "2x2";
        obj.width = 2;
        obj.height = 2;
        obj.posX = 1;
        obj.posY = 1;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.type = ACTIVE_BUILDING;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectBuilding[obj.id ] = obj;
    }
}
}
