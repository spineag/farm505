/**
 * Created by user on 5/20/15.
 */
package temp {
import data.BuildType;

public class DataBuildings {
    public static const HARD_CURRENCY:String = 'diamant';
    public static const SOFT_CURRENCY:String = 'coin';

    public var objectBuilding:Object;

    public function DataBuildings() {
        objectBuilding={};

        fillDataBuilding();


    }

    private function fillDataBuilding():void {
        var obj:Object;
//        1
        obj = {};
        obj.id = 1;
        obj.name = "build1";
        obj.width = 3;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -71;
        obj.innerY = -77;
        obj.url = "buildAtlas";
        obj.image = "build1";
        obj.buildType = BuildType.TEST;
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
        obj.name = "build2";
        obj.width = 5;
        obj.height = 4;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -74;
        obj.innerY = -46;
        obj.url = "buildAtlas";
        obj.image = "build2";
        obj.buildType = BuildType.TEST;
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
        obj.name = "build3";
        obj.width = 4;
        obj.height = 4;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -77;
        obj.innerY = -39;
        obj.url = "buildAtlas";
        obj.image = "build3";
        obj.buildType = BuildType.TEST;
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
        obj.name = "build4";
        obj.width = 4;
        obj.height = 4;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -78;
        obj.innerY = -21;
        obj.url = "buildAtlas";
        obj.image = "build4";
        obj.buildType = BuildType.TEST;
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
        obj.name = "build5";
        obj.width = 5;
        obj.height = 5;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -75;
        obj.innerY = 12;
        obj.url = "buildAtlas";
        obj.image = "build5";
        obj.buildType = BuildType.TEST;
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
        obj.name = "build6";
        obj.width = 4;
        obj.height = 4;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -21;
        obj.innerY = -79;
        obj.url = "buildAtlas";
        obj.image = "build6";
        obj.buildType = BuildType.TEST;
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
        obj.name = "build7";
        obj.width = 4;
        obj.height = 4;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -108;
        obj.innerY = -83;
        obj.url = "buildAtlas";
        obj.image = "build7";
        obj.buildType = BuildType.TEST;
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
        obj.name = "build8";
        obj.width = 4;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -47;
        obj.innerY = -48;
        obj.url = "buildAtlas";
        obj.image = "build8";
        obj.buildType = BuildType.TEST;
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
        obj.name = "build9";
        obj.width = 1;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -15;
        obj.innerY = -39;
        obj.url = "buildAtlas";
        obj.image = "build9";
        obj.buildType = BuildType.TEST;
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
        obj.name = "build10";
        obj.width = 2;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -18;
        obj.innerY = -56;
        obj.url = "buildAtlas";
        obj.image = "build10";
        obj.buildType = BuildType.TEST;
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
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.buildType = BuildType.TEST;
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
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.buildType = BuildType.TEST;
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
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.buildType = BuildType.TEST;
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
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.buildType = BuildType.TEST;
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
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.buildType = BuildType.TEST;
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
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.buildType = BuildType.TEST;
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
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.buildType = BuildType.TEST;
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
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.buildType = BuildType.TEST;
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
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile3x3";
        obj.buildType = BuildType.TEST;
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
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile2x2";
        obj.buildType = BuildType.TEST;
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
