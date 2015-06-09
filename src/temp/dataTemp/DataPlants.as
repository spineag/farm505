/**
 * Created by user on 5/29/15.
 */
package temp.dataTemp {
import data.BuildType;

public class DataPlants {
    public static const HARD_CURRENCY:String = 'diamant';
    public static const SOFT_CURRENCY:String = 'coin';

    public var objectPlants:Object;

    public function DataPlants(){
        objectPlants={};
        fillDataPlants();
    }
    private function fillDataPlants():void {
        var obj:Object;
//        1
        obj = {};
        obj.id = 1;
        obj.name = "Wheat";
        obj.width = 1;
        obj.height = 1;
        obj.url = "plantAtlas";
        obj.image1 = "wheat1";
        obj.image2 = "wheat2";
        obj.image3 = "wheat3";
        obj.image4 = "wheat4";
        obj.imageShop = "wheatShop";
        obj.imageHarvested = "wheatHarvested"; // иконка собраного растения, которое летит в изображение склада
        obj.innerPositions = [-33, 0, -35, 0, -40, -2, -37, -19];
        obj.currency = SOFT_CURRENCY;
        obj.cost = 1;
        obj.costMax = 3;
        obj.costMin = 1;
        obj.priceHard = 1;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        obj.buildTime = 120;
        obj.buildType = BuildType.PLANT;
        obj.xp = 1;
        objectPlants[obj.id ] = obj;
//        2
        obj = {};
        obj.id = 2;
        obj.name = "Corn";
        obj.url = "plantAtlas";
        obj.image1 = "corn1";
        obj.image2 = "corn2";
        obj.image3 = "corn3";
        obj.image4 = "corn4";
        obj.imageShop = "cornShop";
        obj.imageHarvested = "cornHarvested";
        obj.innerPositions = [-32, -5, -36, -16, -36, -22, -37, -32];
        obj.currency = SOFT_CURRENCY;
        obj.cost = 2;
        obj.costMax = 7;
        obj.costMin = 1;
        obj.priceHard = 1;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 2;
        obj.buildTime = 300;
        obj.buildType = BuildType.PLANT;
        obj.xp = 1;
        objectPlants[obj.id ] = obj;
//         3
        obj = {};
        obj.id = 3;
        obj.name = "Soybean";
        obj.url = "plantAtlas";
        obj.image1 = "soybean1";
        obj.image2 = "soybean2";
        obj.image3 = "soybean3";
        obj.image4 = "soybean4";
        obj.imageShop = "soybeanShop";
        obj.imageHarvested = "soybeanHarvested";
        obj.innerPositions = [-34, 2, -35, 0, -42, -11, -42, 26];
        obj.currency = SOFT_CURRENCY;
        obj.cost = 3;
        obj.costMax = 10;
        obj.costMin = 1;
        obj.priceHard = 2;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 5;
        obj.buildTime = 1200;
        obj.buildType = BuildType.PLANT;
        obj.xp = 2;
        objectPlants[obj.id ] = obj;
//         4
//        obj = {};
//        obj.id = 4;
//        obj.name = "Sugarcane";
//        obj.isPlant = true;
//        obj.url = "plantAtlas";
//        obj.image1 = "sugarcane1";
//        obj.image2 = "sugarcane2";
//        obj.image3 = "sugarcane3";
//        obj.image4 = "sugarcane4";
//        obj.imageShop = "sugarcaneShop";
//        obj.imageHarvested = "sugarcaneHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 4;
//        obj.costMax = 14;
//        obj.costMin = 1;
//        obj.priceHard = 3;
//        obj.priceSkipHard = 3;
//        obj.blockByLevel = 7;
//        obj.buildTime = 1800;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 3;
//        objectPlants[obj.id ] = obj;
////         5
//        obj = {};
//        obj.id = 5;
//        obj.name = "Carrot";
//        obj.url = "plantAtlas";
//        obj.image1 = "carrot1";
//        obj.image2 = "carrot2";
//        obj.image3 = "carrot3";
//        obj.image4 = "carrot4";
//        obj.imageShop = "carrotShop";
//        obj.imageHarvested = "carrotHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 2;
//        obj.costMax = 7;
//        obj.costMin = 1;
//        obj.priceHard = 2;
//        obj.priceSkipHard = 2;
//        obj.blockByLevel = 9;
//        obj.buildTime = 600;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 2;
//        objectPlants[obj.id ] = obj;
////         6
//        obj = {};
//        obj.id = 6;
//        obj.name = "Indigo";
//        obj.url = "plantAtlas";
//        obj.image1 = "indigo1";
//        obj.image2 = "indigo2";
//        obj.image3 = "indigo3";
//        obj.image4 = "indigo4";
//        obj.imageShop = "indigoShop";
//        obj.imageHarvested = "indigoHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 7;
//        obj.costMax = 25;
//        obj.costMin = 1;
//        obj.priceHard = 5;
//        obj.priceSkipHard = 5;
//        obj.blockByLevel = 13;
//        obj.buildTime = 12000;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 5;
//        objectPlants[obj.id ] = obj;
//         7
//        obj = {};
//        obj.id = 7;
//        obj.name = "Pumpkin";
//        obj.url = "plantAtlas";
//        obj.image1 = "pumpkin1";
//        obj.image2 = "pumpkin2";
//        obj.image3 = "pumpkin3";
//        obj.image4 = "pumpkin4";
//        obj.imageShop = "pumpkinShop";
//        obj.imageHarvested = "pumpkinHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 9;
//        obj.costMax = 32;
//        obj.costMin = 6;
//        obj.priceHard = 6;
//        obj.priceSkipHard = 1;
//        obj.blockByLevel = 15;
//        obj.buildTime = 18000;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 6;
//        objectPlants[obj.id ] = obj;
////         8
//        obj = {};
//        obj.id = 8;
//        obj.name = "Cotton";
//        obj.url = "plantAtlas";
//        obj.image1 = "cotton1";
//        obj.image2 = "cotton2";
//        obj.image3 = "cotton3";
//        obj.image4 = "cotton4";
//        obj.imageShop = "cottonShop";
//        obj.imageHarvested = "cottonHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 8;
//        obj.costMax = 28;
//        obj.costMin = 1;
//        obj.priceHard = 7;
//        obj.priceSkipHard = 7;
//        obj.blockByLevel = 18;
//        obj.buildTime = 13800;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 6;
//        objectPlants[obj.id ] = obj;
////         9
//        obj = {};
//        obj.id = 9;
//        obj.name = "Chili Pepper";
//        obj.url = "plantAtlas";
//        obj.image1 = "chiliPepper1";
//        obj.image2 = "chiliPepper2";
//        obj.image3 = "chiliPepper3";
//        obj.image4 = "chiliPepper4";
//        obj.imageShop = "chiliPepperShop";
//        obj.imageHarvested = "chiliPepperHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 10;
//        obj.costMax = 36;
//        obj.costMin = 1;
//        obj.priceHard = 7;
//        obj.priceSkipHard = 7;
//        obj.blockByLevel = 25;
//        obj.buildTime = 24000;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 7;
//        objectPlants[obj.id ] = obj;
////        10
//        obj = {};
//        obj.id = 10;
//        obj.name = "Tomato";
//        obj.url = "plantAtlas";
//        obj.image1 = "tomato1";
//        obj.image2 = "tomato2";
//        obj.image3 = "tomato3";
//        obj.image4 = "tomato4";
//        obj.imageShop = "tomatoShop";
//        obj.imageHarvested = "tomatoHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 12;
//        obj.costMax = 43;
//        obj.costMin = 1;
//        obj.priceHard = 8;
//        obj.priceSkipHard = 8;
//        obj.blockByLevel = 30;
//        obj.buildTime = 36000;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 8;
//        objectPlants[obj.id ] = obj;
////        11
//        obj = {};
//        obj.id = 11;
//        obj.name = "Strawberry";
//        obj.url = "plantAtlas";
//        obj.image1 = "strawberry1";
//        obj.image2 = "strawberry2";
//        obj.image3 = "strawberry3";
//        obj.image4 = "strawberry4";
//        obj.imageShop = "strawberryShop";
//        obj.imageHarvested = "strawberryHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 14;
//        obj.costMax = 50;
//        obj.costMin = 1;
//        obj.priceHard = 10;
//        obj.priceSkipHard = 10;
//        obj.blockByLevel = 34;
//        obj.buildTime = 48000;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 10;
//        objectPlants[obj.id ] = obj;
////        12
//        obj = {};
//        obj.id = 12;
//        obj.name = "Potato";
//        obj.url = "plantAtlas";
//        obj.image1 = "potato1";
//        obj.image2 = "potato2";
//        obj.image3 = "potato3";
//        obj.image4 = "potato4";
//        obj.imageShop = "potatoShop";
//        obj.imageHarvested = "potatoHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 10;
//        obj.costMax = 36;
//        obj.costMin = 1;
//        obj.priceHard = 7;
//        obj.priceSkipHard = 7;
//        obj.blockByLevel = 35;
//        obj.buildTime = 20400;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 7;
//        objectPlants[obj.id ] = obj;
////        13
//        obj = {};
//        obj.id = 13;
//        obj.name = "Rice";
//        obj.url = "plantAtlas";
//        obj.image1 = "rice1";
//        obj.image2 = "rice2";
//        obj.image3 = "rice3";
//        obj.image4 = "rice4";
//        obj.imageShop = "riceShop";
//        obj.imageHarvested = "riceHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 5;
//        obj.costMax = 18;
//        obj.costMin = 1;
//        obj.priceHard = 3;
//        obj.priceSkipHard = 3;
//        obj.blockByLevel = 56;
//        obj.buildTime = 2700;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 3;
//        objectPlants[obj.id ] = obj;
////        14
//        obj = {};
//        obj.id = 14;
//        obj.name = "Lettuce";
//        obj.url = "plantAtlas";
//        obj.image1 = "lettuce1";
//        obj.image2 = "lettuce2";
//        obj.image3 = "lettuce3";
//        obj.image4 = "lettuce4";
//        obj.imageShop = "lettuceShop";
//        obj.imageHarvested = "lettuceHarvested";
//        obj.currency = SOFT_CURRENCY;
//        obj.cost = 9;
//        obj.costMax = 32;
//        obj.costMin = 1;
//        obj.priceHard = 7;
//        obj.priceSkipHard = 7;
//        obj.blockByLevel = 58;
//        obj.buildTime = 19800;
//        obj.buildType = BuildType.PLANT;
//        obj.xp = 7;
//        objectPlants[obj.id ] = obj;
    }
}
}
