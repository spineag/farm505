/**
 * Created by user on 5/29/15.
 */
package temp.dataTemp {
import data.BuildType;

public class DataResources {
    public static const HARD_CURRENCY:String = 'diamant';
    public static const SOFT_CURRENCY:String = 'coin';

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
        obj.url = "resourcesAtlas";
        obj.image = "Bolt";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//        2
        obj = {};
        obj.id = 2;
        obj.name = "Plank";
        obj.url = "resourcesAtlas";
        obj.image = "Plank";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//         3
        obj = {};
        obj.id = 3;
        obj.name = "Duct tape";
        obj.url = "resourcesAtlas";
        obj.image = "Duct tape";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//         4
        obj = {};
        obj.id = 4;
        obj.name = "Nail";
        obj.url = "resourcesAtlas";
        obj.image = "Nail";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//         5
        obj = {};
        obj.id = 5;
        obj.name = "Screw";
        obj.url = "resourcesAtlas";
        obj.image = "Screw";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//         6
        obj = {};
        obj.id = 6;
        obj.name = "Wood Panel";
        obj.url = "resourcesAtlas";
        obj.image = "Wood Panel";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//         7 Материалы для расширения территории
        obj = {};
        obj.id = 7;
        obj.name = "Marker stake";
        obj.url = "resourcesAtlas";
        obj.image = "Marker stake";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 112;
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//         8
        obj = {};
        obj.id = 8;
        obj.name = "Land deed";
        obj.url = "resourcesAtlas";
        obj.image = "Land deed";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 112;
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//         9
        obj = {};
        obj.id = 9;
        obj.name = "Mallet";
        obj.url = "resourcesAtlas";
        obj.image = "Mallet";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 112;
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//        10 Материалы для оасчистки территории
        obj = {};
        obj.id = 10;
        obj.name = "Dynamite";
        obj.url = "resourcesAtlas";
        obj.image = "Dynamite";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 7;
        obj.costMax = 25;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//        11
        obj = {};
        obj.id = 11;
        obj.name = "TNT barrel";
        obj.url = "resourcesAtlas";
        obj.image = "TNT barrel";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 20;
        obj.costMax = 72;
        obj.costMin = 1;
        obj.priceHard = 7;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//        12
        obj = {};
        obj.id = 12;
        obj.name = "Shovel";
        obj.url = "resourcesAtlas";
        obj.image = "Shovel";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 30;
        obj.costMax = 108;
        obj.costMin = 1;
        obj.priceHard = 10;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//        13
        obj = {};
        obj.id = 13;
        obj.name = "Axe";
        obj.url = "resourcesAtlas";
        obj.image = "Axe";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 10;
        obj.costMax = 36;
        obj.costMin = 1;
        obj.priceHard = 4;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//        14
        obj = {};
        obj.id = 14;
        obj.name = "Saw";
        obj.url = "resourcesAtlas";
        obj.image = "Saw";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 15;
        obj.costMax = 54;
        obj.costMin = 1;
        obj.priceHard = 5;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.TEST;
        objectResources[obj.id ] = obj;
//         15
        obj = {};
        obj.id = 15;
        obj.name = "Egg";
        obj.url = "resourcesAtlas";
        obj.image = "Egg";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 5;
        obj.costMax = 18;
        obj.costMin = 1;
        obj.priceHard = 4;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 1200;
        obj.buildType = BuildType.TEST;
        obj.xp = 2;
        objectResources[obj.id ] = obj;
//         16
        obj = {};
        obj.id = 16;
        obj.name = "Milk";
        obj.url = "resourcesAtlas";
        obj.image = "Milk";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 9;
        obj.costMax = 32;
        obj.costMin = 1;
        obj.priceHard = 6;
        obj.priceSkipHard = 4;
        obj.blockByLevel = 6;
        obj.buildTime = 6000;
        obj.buildType = BuildType.TEST;
        obj.xp = 3;
        objectResources[obj.id ] = obj;
//         17
        obj = {};
        obj.id = 17;
        obj.name = "Bacon";
        obj.url = "resourcesAtlas";
        obj.image = "Bacon";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 14;
        obj.costMax = 50;
        obj.costMin = 1;
        obj.priceHard = 10;
        obj.priceSkipHard = 7;
        obj.blockByLevel = 10;
        obj.buildTime = 24000;
        obj.buildType = BuildType.TEST;
        obj.xp = 5;
        objectResources[obj.id ] = obj;
//         18
        obj = {};
        obj.id = 18;
        obj.name = "Wool";
        obj.url = "resourcesAtlas";
        obj.image = "Wool";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 15;
        obj.costMax = 54;
        obj.costMin = 1;
        obj.priceHard = 11;
        obj.priceSkipHard = 8;
        obj.blockByLevel = 16;
        obj.buildTime = 36000;
        obj.buildType = BuildType.TEST;
        obj.xp = 5;
        objectResources[obj.id ] = obj;
//         19
        obj = {};
        obj.id = 19;
        obj.name = "Chiken feed";
        obj.url = "resourcesAtlas";
        obj.image = "Chiken feed";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 2;
        obj.costMax = 7;
        obj.costMin = 1;
        obj.priceHard = 2;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 3;
        obj.buildTime = 300;
        obj.buildTimeUpgrade1 = 240;
        obj.buildTimeUpgrade2 = 240;
        obj.buildTimeUpgrade3 = 240;
        obj.ingedient1 = "Wheat";
        obj.ingedientNumb1 = 2;
        obj.ingedient2 = "Corn";
        obj.ingedientNumb2 = 1;
        obj.buildType = BuildType.TEST;
        obj.xp = 1;
        objectResources[obj.id ] = obj;
//        20
        obj = {};
        obj.id = 20;
        obj.name = "Cow feed";
        obj.url = "resourcesAtlas";
        obj.image = "Cow feed";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 4;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildTimeUpgrade1 = 600;
        obj.buildTimeUpgrade2 = 540;
        obj.buildTimeUpgrade3 = 480;
        obj.ingedient1 = "Corn";
        obj.ingedientNumb1 = 1;
        obj.ingedient2 = "Soybean";
        obj.ingedientNumb2 = 2;
        obj.buildType = BuildType.TEST;
        obj.xp = 2;
        objectResources[obj.id ] = obj;
    }
}
}
