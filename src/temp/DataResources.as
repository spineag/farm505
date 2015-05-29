/**
 * Created by user on 5/29/15.
 */
package temp {
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
        obj.isPlant = false;
        obj.url = "Болт";
        obj.image = "Болт";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//        2
        obj = {};
        obj.id = 2;
        obj.name = "Plank";
        obj.isPlant = false;
        obj.url = "Доска";
        obj.image = "Доска";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//         3
        obj = {};
        obj.id = 3;
        obj.name = "Duct tape";
        obj.isPlant = false;
        obj.url = "Скотч";
        obj.image = "Скотч";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//         4
        obj = {};
        obj.id = 4;
        obj.name = "Nail";
        obj.isPlant = false;
        obj.url = "Гвоздь";
        obj.image = "Гвоздь";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//         5
        obj = {};
        obj.id = 5;
        obj.name = "Screw";
        obj.isPlant = false;
        obj.url = "Шуруп";
        obj.image = "Шуруп";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//         6
        obj = {};
        obj.id = 6;
        obj.name = "Wood Panel";
        obj.isPlant = false;
        obj.url = "Деревянная панель";
        obj.image = "Деревянная панель";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 75;
        obj.costMax = 270;
        obj.costMin = 1;
        obj.priceHard = 8;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//         7 Материалы для расширения территории
        obj = {};
        obj.id = 7;
        obj.name = "Marker stake";
        obj.isPlant = false;
        obj.url = "Колышек";
        obj.image = "Колышек";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 112;
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        objectResources[obj.id ] = obj;
//         8
        obj = {};
        obj.id = 8;
        obj.name = "Land deed";
        obj.isPlant = false;
        obj.url = "Купчая на землю";
        obj.image = "Купчая на землю";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 112;
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        objectResources[obj.id ] = obj;
//         9
        obj = {};
        obj.id = 9;
        obj.name = "Mallet";
        obj.isPlant = false;
        obj.url = "Молот";
        obj.image = "Молот";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 112;
        obj.costMax = 403;
        obj.costMin = 1;
        obj.priceHard = 12;
        obj.blockByLevel = 22;
        objectResources[obj.id ] = obj;
//        10 Материалы для оасчистки территории
        obj = {};
        obj.id = 10;
        obj.name = "Dynamite";
        obj.isPlant = false;
        obj.url = "Динамит";
        obj.image = "Динамит";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 7;
        obj.costMax = 25;
        obj.costMin = 1;
        obj.priceHard = 3;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//        11
        obj = {};
        obj.id = 11;
        obj.name = "TNT barrel";
        obj.isPlant = false;
        obj.url = "Бочка с тротилом";
        obj.image = "Бочка с тротилом";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 20;
        obj.costMax = 72;
        obj.costMin = 1;
        obj.priceHard = 7;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//        12
        obj = {};
        obj.id = 12;
        obj.name = "Shovel";
        obj.isPlant = false;
        obj.url = "Лопата";
        obj.image = "Лопата";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 30;
        obj.costMax = 108;
        obj.costMin = 1;
        obj.priceHard = 10;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//        13
        obj = {};
        obj.id = 13;
        obj.name = "Axe";
        obj.isPlant = false;
        obj.url = "Топор";
        obj.image = "Топор";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 10;
        obj.costMax = 36;
        obj.costMin = 1;
        obj.priceHard = 4;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//        14
        obj = {};
        obj.id = 14;
        obj.name = "Saw";
        obj.isPlant = false;
        obj.url = "Пила";
        obj.image = "Пила";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 15;
        obj.costMax = 54;
        obj.costMin = 1;
        obj.priceHard = 5;
        obj.blockByLevel = 1;
        objectResources[obj.id ] = obj;
//         15
        obj = {};
        obj.id = 15;
        obj.name = "Egg";
        obj.isPlant = false;
        obj.url = "Яйцо";
        obj.image = "Яйцо";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 5;
        obj.costMax = 18;
        obj.costMin = 1;
        obj.priceHard = 4;
        obj.priceSkipHard = 2;
        obj.blockByLevel = 1;
        obj.buildTime = 1200;
        obj.xp = 2;
        objectResources[obj.id ] = obj;
//         16
        obj = {};
        obj.id = 16;
        obj.name = "Milk";
        obj.isPlant = false;
        obj.url = "Молоко";
        obj.image = "Молоко";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 9;
        obj.costMax = 32;
        obj.costMin = 1;
        obj.priceHard = 6;
        obj.priceSkipHard = 4;
        obj.blockByLevel = 6;
        obj.buildTime = 6000;
        obj.xp = 3;
        objectResources[obj.id ] = obj;
//         17
        obj = {};
        obj.id = 17;
        obj.name = "Bacon";
        obj.isPlant = false;
        obj.url = "Бекон";
        obj.image = "Бекон";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 14;
        obj.costMax = 50;
        obj.costMin = 1;
        obj.priceHard = 10;
        obj.priceSkipHard = 7;
        obj.blockByLevel = 10;
        obj.buildTime = 24000;
        obj.xp = 5;
        objectResources[obj.id ] = obj;
//         18
        obj = {};
        obj.id = 18;
        obj.name = "Wool";
        obj.isPlant = false;
        obj.url = "Шерсть";
        obj.image = "Шерсть";
        obj.currency = SOFT_CURRENCY;
        obj.cost = 15;
        obj.costMax = 54;
        obj.costMin = 1;
        obj.priceHard = 11;
        obj.priceSkipHard = 8;
        obj.blockByLevel = 16;
        obj.buildTime = 36000;
        obj.xp = 5;
        objectResources[obj.id ] = obj;
//         19
        obj = {};
        obj.id = 19;
        obj.name = "Chiken feed";
        obj.isPlant = false;
        obj.url = "Корм для куриц";
        obj.image = "Корм для куриц";
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
        obj.xp = 1;
        objectResources[obj.id ] = obj;
//        20
        obj = {};
        obj.id = 20;
        obj.name = "Cow feed";
        obj.isPlant = false;
        obj.url = "Корм для коров";
        obj.image = "Корм для коров";
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
        obj.xp = 2;
        objectResources[obj.id ] = obj;
    }
}
}
