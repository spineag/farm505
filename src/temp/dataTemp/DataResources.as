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

                                    //   ---------------------------  INSTRUMENTS  ----------------------------------
//        1
        obj = {};
        obj.id = 1;
        obj.name = "Bolt";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Bolt";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//        2
        obj = {};
        obj.id = 2;
        obj.name = "Axe";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Axe";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//         3
        obj = {};
        obj.id = 3;
        obj.name = "Duct tape";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Duct_Tape";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//         4
        obj = {};
        obj.id = 4;
        obj.name = "Dynamite";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Dynamite";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//         5
        obj = {};
        obj.id = 5;
        obj.name = "Land Deep";
        obj.url = "instrumentAtlas";
        obj.imageShop = "LandDeep";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//         6
        obj = {};
        obj.id = 6;
        obj.name = "Mallet";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Mallet";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//         7
        obj = {};
        obj.id = 7;
        obj.name = "Marker stake";
        obj.url = "instrumentAtlas";
        obj.imageShop = "MarkerStake";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//         8
        obj = {};
        obj.id = 8;
        obj.name = "Nail";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Nail";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//         9
        obj = {};
        obj.id = 9;
        obj.name = "Plank";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Plank";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//        10
        obj = {};
        obj.id = 10;
        obj.name = "Saw";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Saw";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 25;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//        11
        obj = {};
        obj.id = 11;
        obj.name = "Screw";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Screw";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 72;
        obj.costMin = 1;
        obj.priceHard = 7;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//        12
        obj = {};
        obj.id = 12;
        obj.name = "Shovel";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Shovel";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 108;
        obj.costMin = 1;
        obj.priceHard = 10;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//        13
        obj = {};
        obj.id = 13;
        obj.name = "TNT";
        obj.url = "instrumentAtlas";
        obj.imageShop = "TNT";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 36;
        obj.costMin = 1;
        obj.priceHard = 4;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;
//        14
        obj = {};
        obj.id = 14;
        obj.name = "Woo panel";
        obj.url = "instrumentAtlas";
        obj.imageShop = "Wood_Panel";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 54;
        obj.costMin = 1;
        obj.priceHard = 5;
        obj.blockByLevel = 1;
        obj.buildType = BuildType.INSTRUMENT;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        objectResources[obj.id ] = obj;

                                    //   ---------------------------   RESOURCES  ----------------------------------
//         15
        obj = {};
        obj.id = 15;
        obj.name = "Apple";
        obj.url = "resourceAtlas";
        obj.imageShop = "Apple";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 18;
        obj.costMin = 1;
        obj.priceHard = 4;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 12;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_AMBAR;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//         16
        obj = {};
        obj.id = 16;
        obj.name = "Blackberry";
        obj.url = "resourceAtlas";
        obj.imageShop = "Blackberry";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 32;
        obj.costMin = 1;
        obj.priceHard = 6;
        obj.priceSkipHard = 4;
        obj.blockByLevel = 6;
        obj.buildTime = 6000;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_AMBAR;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//         17
        obj = {};
        obj.id = 17;
        obj.name = "Bread";
        obj.url = "resourceAtlas";
        obj.imageShop = "Bread";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 50;
        obj.costMin = 1;
        obj.priceHard = 10;
        obj.priceSkipHard = 7;
        obj.blockByLevel = 10;
        obj.buildTime = 24000;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//         18
        obj = {};
        obj.id = 18;
        obj.name = "Brown Sugar";
        obj.url = "resourceAtlas";
        obj.imageShop = "Brown_Sugar";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 54;
        obj.costMin = 1;
        obj.priceHard = 11;
        obj.priceSkipHard = 8;
        obj.blockByLevel = 16;
        obj.buildTime = 36000;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//         19
        obj = {};
        obj.id = 19;
        obj.name = "Buttered Popcorn";
        obj.url = "resourceAtlas";
        obj.imageShop = "Buttered_Popcorn";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 7;
        obj.costMin = 1;
        obj.priceHard = 2;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 3;
        obj.buildTime = 300;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        20
        obj = {};
        obj.id = 20;
        obj.name = "Cherry";
        obj.url = "resourceAtlas";
        obj.imageShop = "Cherry";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_AMBAR;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        21
        obj = {};
        obj.id = 21;
        obj.name = "Chicken Feed";
        obj.url = "resourceAtlas";
        obj.imageShop = "Chicken_Feed";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 50;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        22
        obj = {};
        obj.id = 22;
        obj.name = "Chili Popcorn";
        obj.url = "resourceAtlas";
        obj.imageShop = "Chili_Popcorn";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        23
        obj = {};
        obj.id = 23;
        obj.name = "Cookie";
        obj.url = "resourceAtlas";
        obj.imageShop = "Cookie";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        24
        obj = {};
        obj.id = 24;
        obj.name = "Corn Bread";
        obj.url = "resourceAtlas";
        obj.imageShop = "Corn_Bread";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        25
        obj = {};
        obj.id = 25;
        obj.name = "Cow Feed";
        obj.url = "resourceAtlas";
        obj.imageShop = "Cow_Feed";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 15;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        26
        obj = {};
        obj.id = 26;
        obj.name = "Egg";
        obj.url = "resourceAtlas";
        obj.imageShop = "Egg";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        27
        obj = {};
        obj.id = 27;
        obj.name = "Pig Feed";
        obj.url = "resourceAtlas";
        obj.imageShop = "Pig_Feed";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 20;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        28
        obj = {};
        obj.id = 28;
        obj.name = "Popcorn";
        obj.url = "resourceAtlas";
        obj.imageShop = "Popcorn";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        29
        obj = {};
        obj.id = 29;
        obj.name = "Sheep Feed";
        obj.url = "resourceAtlas";
        obj.imageShop = "Sheep_Feed";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 10;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        30
        obj = {};
        obj.id = 30;
        obj.name = "Syrup";
        obj.url = "resourceAtlas";
        obj.imageShop = "Syrup";
        obj.costMax = 14;
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;

                              //   ---------------------------   PLANTS  ----------------------------------
//        31
        obj = {};
        obj.id = 31;
        obj.name = "Wheat";
        obj.url = "plantAtlas";
        obj.image1 = "wheat1";
        obj.image2 = "wheat2";
        obj.image3 = "wheat3";
        obj.image4 = "wheat4";
        obj.imageShop = "wheatShop";
        obj.imageHarvested = "wheatHarvested"; // иконка собраного растения, которое летит в изображение склада
        obj.innerPositions = [-33, 0, -35, 0, -40, -2, -37, -19];
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.cost = 1;
        obj.costMax = 3;
        obj.costMin = 1;
        obj.priceHard = 1;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        obj.buildTime = 120;
        obj.buildType = BuildType.PLANT;
        obj.placeBuild = BuildType.PLACE_AMBAR;
        obj.craftXP = 1;
        objectResources[obj.id ] = obj;
//        32
        obj = {};
        obj.id = 32;
        obj.name = "Corn";
        obj.url = "plantAtlas";
        obj.image1 = "corn1";
        obj.image2 = "corn2";
        obj.image3 = "corn3";
        obj.image4 = "corn4";
        obj.imageShop = "cornShop";
        obj.imageHarvested = "cornHarvested";
        obj.innerPositions = [-32, -5, -36, -16, -36, -22, -37, -32];
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.cost = 2;
        obj.costMax = 7;
        obj.costMin = 1;
        obj.priceHard = 1;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 2;
        obj.buildTime = 300;
        obj.buildType = BuildType.PLANT;
        obj.placeBuild = BuildType.PLACE_AMBAR;
        obj.craftXP = 1;
        objectResources[obj.id ] = obj;
//         33
        obj = {};
        obj.id = 33;
        obj.name = "Soybean";
        obj.url = "plantAtlas";
        obj.image1 = "soybean1";
        obj.image2 = "soybean2";
        obj.image3 = "soybean3";
        obj.image4 = "soybean4";
        obj.imageShop = "soybeanShop";
        obj.imageHarvested = "soybeanHarvested";
        obj.innerPositions = [-34, 2, -35, 0, -42, -11, -42, 26];
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.cost = 3;
        obj.costMax = 10;
        obj.costMin = 1;
        obj.priceHard = 2;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 5;
        obj.buildTime = 1200;
        obj.buildType = BuildType.PLANT;
        obj.placeBuild = BuildType.PLACE_AMBAR;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//         34
//        obj = {};
//        obj.id = 34;
//        obj.name = "Sugarcane";
//        obj.isPlant = true;
//        obj.url = "plantAtlas";
//        obj.image1 = "sugarcane1";
//        obj.image2 = "sugarcane2";
//        obj.image3 = "sugarcane3";
//        obj.image4 = "sugarcane4";
//        obj.imageShop = "sugarcaneShop";
//        obj.imageHarvested = "sugarcaneHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 4;
//        obj.costMax = 14;
//        obj.costMin = 1;
//        obj.priceHard = 3;
//        obj.priceSkipHard = 3;
//        obj.blockByLevel = 7;
//        obj.buildTime = 1800;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 3;
//        objectResources[obj.id ] = obj;
////         35
//        obj = {};
//        obj.id = 35;
//        obj.name = "Carrot";
//        obj.url = "plantAtlas";
//        obj.image1 = "carrot1";
//        obj.image2 = "carrot2";
//        obj.image3 = "carrot3";
//        obj.image4 = "carrot4";
//        obj.imageShop = "carrotShop";
//        obj.imageHarvested = "carrotHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 2;
//        obj.costMax = 7;
//        obj.costMin = 1;
//        obj.priceHard = 2;
//        obj.priceSkipHard = 2;
//        obj.blockByLevel = 9;
//        obj.buildTime = 600;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 2;
//        objectResources[obj.id ] = obj;
////         36
//        obj = {};
//        obj.id = 36;
//        obj.name = "Indigo";
//        obj.url = "plantAtlas";
//        obj.image1 = "indigo1";
//        obj.image2 = "indigo2";
//        obj.image3 = "indigo3";
//        obj.image4 = "indigo4";
//        obj.imageShop = "indigoShop";
//        obj.imageHarvested = "indigoHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 7;
//        obj.costMax = 25;
//        obj.costMin = 1;
//        obj.priceHard = 5;
//        obj.priceSkipHard = 5;
//        obj.blockByLevel = 13;
//        obj.buildTime = 12000;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 5;
//        objectResources[obj.id ] = obj;
//         37
//        obj = {};
//        obj.id = 37;
//        obj.name = "Pumpkin";
//        obj.url = "plantAtlas";
//        obj.image1 = "pumpkin1";
//        obj.image2 = "pumpkin2";
//        obj.image3 = "pumpkin3";
//        obj.image4 = "pumpkin4";
//        obj.imageShop = "pumpkinShop";
//        obj.imageHarvested = "pumpkinHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 9;
//        obj.costMax = 32;
//        obj.costMin = 6;
//        obj.priceHard = 6;
//        obj.priceSkipHard = 1;
//        obj.blockByLevel = 15;
//        obj.buildTime = 18000;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 6;
//        objectResources[obj.id ] = obj;
////         38
//        obj = {};
//        obj.id = 38;
//        obj.name = "Cotton";
//        obj.url = "plantAtlas";
//        obj.image1 = "cotton1";
//        obj.image2 = "cotton2";
//        obj.image3 = "cotton3";
//        obj.image4 = "cotton4";
//        obj.imageShop = "cottonShop";
//        obj.imageHarvested = "cottonHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 8;
//        obj.costMax = 28;
//        obj.costMin = 1;
//        obj.priceHard = 7;
//        obj.priceSkipHard = 7;
//        obj.blockByLevel = 18;
//        obj.buildTime = 13800;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 6;
//        objectResources[obj.id ] = obj;
////         39
//        obj = {};
//        obj.id = 39;
//        obj.name = "Chili Pepper";
//        obj.url = "plantAtlas";
//        obj.image1 = "chiliPepper1";
//        obj.image2 = "chiliPepper2";
//        obj.image3 = "chiliPepper3";
//        obj.image4 = "chiliPepper4";
//        obj.imageShop = "chiliPepperShop";
//        obj.imageHarvested = "chiliPepperHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 10;
//        obj.costMax = 36;
//        obj.costMin = 1;
//        obj.priceHard = 7;
//        obj.priceSkipHard = 7;
//        obj.blockByLevel = 25;
//        obj.buildTime = 24000;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 7;
//        objectResources[obj.id ] = obj;
////        40
//        obj = {};
//        obj.id = 40;
//        obj.name = "Tomato";
//        obj.url = "plantAtlas";
//        obj.image1 = "tomato1";
//        obj.image2 = "tomato2";
//        obj.image3 = "tomato3";
//        obj.image4 = "tomato4";
//        obj.imageShop = "tomatoShop";
//        obj.imageHarvested = "tomatoHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 12;
//        obj.costMax = 43;
//        obj.costMin = 1;
//        obj.priceHard = 8;
//        obj.priceSkipHard = 8;
//        obj.blockByLevel = 30;
//        obj.buildTime = 36000;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 8;
//        objectResources[obj.id ] = obj;
////        41
//        obj = {};
//        obj.id = 41;
//        obj.name = "Strawberry";
//        obj.url = "plantAtlas";
//        obj.image1 = "strawberry1";
//        obj.image2 = "strawberry2";
//        obj.image3 = "strawberry3";
//        obj.image4 = "strawberry4";
//        obj.imageShop = "strawberryShop";
//        obj.imageHarvested = "strawberryHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 14;
//        obj.costMax = 50;
//        obj.costMin = 1;
//        obj.priceHard = 10;
//        obj.priceSkipHard = 10;
//        obj.blockByLevel = 34;
//        obj.buildTime = 48000;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 10;
//        objectResources[obj.id ] = obj;
////        42
//        obj = {};
//        obj.id = 42;
//        obj.name = "Potato";
//        obj.url = "plantAtlas";
//        obj.image1 = "potato1";
//        obj.image2 = "potato2";
//        obj.image3 = "potato3";
//        obj.image4 = "potato4";
//        obj.imageShop = "potatoShop";
//        obj.imageHarvested = "potatoHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 10;
//        obj.costMax = 36;
//        obj.costMin = 1;
//        obj.priceHard = 7;
//        obj.priceSkipHard = 7;
//        obj.blockByLevel = 35;
//        obj.buildTime = 20400;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 7;
//        objectResources[obj.id ] = obj;
////        43
//        obj = {};
//        obj.id = 43;
//        obj.name = "Rice";
//        obj.url = "plantAtlas";
//        obj.image1 = "rice1";
//        obj.image2 = "rice2";
//        obj.image3 = "rice3";
//        obj.image4 = "rice4";
//        obj.imageShop = "riceShop";
//        obj.imageHarvested = "riceHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 5;
//        obj.costMax = 18;
//        obj.costMin = 1;
//        obj.priceHard = 3;
//        obj.priceSkipHard = 3;
//        obj.blockByLevel = 56;
//        obj.buildTime = 2700;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 3;
//        objectResources[obj.id ] = obj;
////        44
//        obj = {};
//        obj.id = 44;
//        obj.name = "Lettuce";
//        obj.url = "plantAtlas";
//        obj.image1 = "lettuce1";
//        obj.image2 = "lettuce2";
//        obj.image3 = "lettuce3";
//        obj.image4 = "lettuce4";
//        obj.imageShop = "lettuceShop";
//        obj.imageHarvested = "lettuceHarvested";
//        obj.currency = BuildType.SOFT_CURRENCY;
//        obj.cost = 9;
//        obj.costMax = 32;
//        obj.costMin = 1;
//        obj.priceHard = 7;
//        obj.priceSkipHard = 7;
//        obj.blockByLevel = 58;
//        obj.buildTime = 19800;
//        obj.buildType = BuildType.PLANT;
//        obj.placeBuild = BuildType.PLACE_AMBAR;
//        obj.craftXP = 7;
//        objectResources[obj.id ] = obj;

//        45
        obj = {};
        obj.id = 45;
        obj.name = "Hamburger";
        obj.url = "resourceAtlas";
        obj.imageShop = "Hamburger";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
//        46
        obj = {};
        obj.id = 46;
        obj.name = "Milk";
        obj.url = "resourceAtlas";
        obj.imageShop = "Milk";
        obj.currency = BuildType.SOFT_CURRENCY;
        obj.costMax = 14;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 600;
        obj.buildType = BuildType.RESOURCE;
        obj.placeBuild = BuildType.PLACE_SKLAD;
        obj.craftXP = 2;
        objectResources[obj.id ] = obj;
    }
}
}
