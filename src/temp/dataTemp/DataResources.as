/**
 * Created by user on 5/29/15.
 */
package temp.dataTemp {
import data.BuildType;

public class DataResources {
    public var objectResources:Object;

    public function DataResources(){
        objectResources={};
        fillDataResources();
    }
    private function fillDataResources():void {
        var obj:Object;
//        1 Строительные материалы
        obj = {};
        obj.id = 1;
        obj.name = "Bolt";
        obj.url = "instrumentAtlas";
        obj.image = "Bolt";
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//        2
        obj = {};
        obj.id = 2;
        obj.name = "Axe";
        obj.url = "instrumentAtlas";
        obj.image = "Axe";
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//         3
        obj = {};
        obj.id = 3;
        obj.name = "Duct tape";
        obj.url = "instrumentAtlas";
        obj.image = "Duct_Tape";
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//         4
        obj = {};
        obj.id = 4;
        obj.name = "Dynamite";
        obj.url = "instrumentAtlas";
        obj.image = "Dynamite";
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//         5
        obj = {};
        obj.id = 5;
        obj.name = "Land Deep";
        obj.url = "instrumentAtlas";
        obj.image = "LandDeep";
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//         6
        obj = {};
        obj.id = 6;
        obj.name = "Mallet";
        obj.url = "instrumentAtlas";
        obj.image = "Mallet";
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//         7
        obj = {};
        obj.id = 7;
        obj.name = "Marker stake";
        obj.url = "instrumentAtlas";
        obj.image = "MarkerStake";
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//         8
        obj = {};
        obj.id = 8;
        obj.name = "Nail";
        obj.url = "instrumentAtlas";
        obj.image = "Nail";
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//         9
        obj = {};
        obj.id = 9;
        obj.name = "Plank";
        obj.url = "instrumentAtlas";
        obj.image = "Plank";
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//        10
        obj = {};
        obj.id = 10;
        obj.name = "Saw";
        obj.url = "instrumentAtlas";
        obj.image = "Saw";
        obj.costMax = 25;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//        11
        obj = {};
        obj.id = 11;
        obj.name = "Screw";
        obj.url = "instrumentAtlas";
        obj.image = "Screw";
        obj.costMax = 72;
        obj.costMin = 1;
        obj.priceHard = 7;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//        12
        obj = {};
        obj.id = 12;
        obj.name = "Shovel";
        obj.url = "instrumentAtlas";
        obj.image = "Shovel";
        obj.costMax = 108;
        obj.costMin = 1;
        obj.priceHard = 10;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//        13
        obj = {};
        obj.id = 13;
        obj.name = "TNT";
        obj.url = "instrumentAtlas";
        obj.image = "TNT";
        obj.costMax = 36;
        obj.costMin = 1;
        obj.priceHard = 4;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;
//        14
        obj = {};
        obj.id = 14;
        obj.name = "Woo panel";
        obj.url = "instrumentAtlas";
        obj.image = "Wood_Panel";
        obj.costMax = 54;
        obj.costMin = 1;
        obj.priceHard = 5;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        objectResources[obj.id ] = obj;


//         15  Products
        obj = {};
        obj.id = 15;
        obj.name = "Apple";
        obj.url = "resourceAtlas";
        obj.image = "Apple";
        obj.costMax = 18;
        obj.costMin = 1;
        obj.priceHard = 4;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 1200;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//         16
        obj = {};
        obj.id = 16;
        obj.name = "Blackberry";
        obj.url = "resourceAtlas";
        obj.image = "Blackberry";
        obj.costMax = 32;
        obj.costMin = 1;
        obj.priceHard = 6;
        obj.priceSkipHard = 4;
        obj.blockByLevel = 6;
        obj.buildTime = 6000;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//         17
        obj = {};
        obj.id = 17;
        obj.name = "Bread";
        obj.url = "resourceAtlas";
        obj.image = "Bread";
        obj.costMax = 50;
        obj.costMin = 1;
        obj.priceHard = 10;
        obj.priceSkipHard = 7;
        obj.blockByLevel = 10;
        obj.buildTime = 24000;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//         18
        obj = {};
        obj.id = 18;
        obj.name = "Brown Sugar";
        obj.url = "resourceAtlas";
        obj.image = "Brown_Sugar";
        obj.costMax = 54;
        obj.costMin = 1;
        obj.priceHard = 11;
        obj.priceSkipHard = 8;
        obj.blockByLevel = 16;
        obj.buildTime = 36000;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//         19
        obj = {};
        obj.id = 19;
        obj.name = "Buttered Popcorn";
        obj.url = "resourceAtlas";
        obj.image = "Buttered_Popcorn";
        obj.costMax = 7;
        obj.costMin = 1;
        obj.priceHard = 2;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 3;
        obj.buildTime = 300;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        20
        obj = {};
        obj.id = 20;
        obj.name = "Cherry";
        obj.url = "resourceAtlas";
        obj.image = "Cherry";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        21
        obj = {};
        obj.id = 21;
        obj.name = "Chicken Feed";
        obj.url = "resourceAtlas";
        obj.image = "Chicken_Feed";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        22
        obj = {};
        obj.id = 22;
        obj.name = "Chili Popcorn";
        obj.url = "resourceAtlas";
        obj.image = "Chili_Popcorn";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        23
        obj = {};
        obj.id = 23;
        obj.name = "Cookie";
        obj.url = "resourceAtlas";
        obj.image = "Cookie";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        24
        obj = {};
        obj.id = 24;
        obj.name = "Corn Bread";
        obj.url = "resourceAtlas";
        obj.image = "Corn_Bread";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        25
        obj = {};
        obj.id = 25;
        obj.name = "Cow Feed";
        obj.url = "resourceAtlas";
        obj.image = "Cow_Feed";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        26
        obj = {};
        obj.id = 26;
        obj.name = "Egg";
        obj.url = "resourceAtlas";
        obj.image = "Egg";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        25
        obj = {};
        obj.id = 25;
        obj.name = "Hamburger";
        obj.url = "resourceAtlas";
        obj.image = "Hamburger";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        26
        obj = {};
        obj.id = 26;
        obj.name = "Milk";
        obj.url = "resourceAtlas";
        obj.image = "Milk";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        27
        obj = {};
        obj.id = 27;
        obj.name = "Pig Feed";
        obj.url = "resourceAtlas";
        obj.image = "Pig_Feed";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        28
        obj = {};
        obj.id = 28;
        obj.name = "Popcorn";
        obj.url = "resourceAtlas";
        obj.image = "Popcorn";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        29
        obj = {};
        obj.id = 29;
        obj.name = "Sheep Feed";
        obj.url = "resourceAtlas";
        obj.image = "Sheep_Feed";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        30
        obj = {};
        obj.id = 30;
        obj.name = "Syrup";
        obj.url = "resourceAtlas";
        obj.image = "Syrup";
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
    }
}
}
