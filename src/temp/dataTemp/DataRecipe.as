/**
 * Created by user on 6/8/15.
 */
package temp.dataTemp {

public class DataRecipe {
    public static const HARD_CURRENCY:String = 'diamant';
    public static const SOFT_CURRENCY:String = 'coin';

    public var objectRecipe:Object;

    public function DataRecipe() {
        objectRecipe={};
        fillDataRecipe();
    }

    private function fillDataRecipe():void {
        var obj:Object;
//        1
        obj = {};
        obj.id = 1;
        obj.name = "Popcorn";
        obj.idResource = 1;
        obj.ingriedientId1 = 1;
        obj.countIngridient1 = 1;
        obj.ingriedientId2 = 1;
        obj.countIngridient2 = 1;
        obj.ingriedientId3 = 1;
        obj.countIngridient3 = 1;
        obj.ingriedientId4 = 1;
        obj.countIngridient4 = 1;
        obj.buildId = 1;
        obj.buildTime = 120;
        obj.currency = HARD_CURRENCY;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        objectRecipe[obj.id ] = obj;
//        2
        obj = {};
        obj.id = 2;
        obj.name = "Cow Feed";
        obj.idResource = 2;
        obj.ingriedientId1 = 1;
        obj.countIngridient1 = 1;
        obj.ingriedientId2 = 1;
        obj.countIngridient2 = 1;
        obj.ingriedientId3 = 1;
        obj.countIngridient3 = 1;
        obj.ingriedientId4 = 1;
        obj.countIngridient4 = 1;
        obj.buildId = 1;
        obj.buildTime = 120;
        obj.currency = HARD_CURRENCY;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        objectRecipe[obj.id ] = obj;
//         3
        obj = {};
        obj.id = 3;
        obj.name = "Corn Bread";
        obj.idResource = 3;
        obj.ingriedientId1 = 1;
        obj.countIngridient1 = 1;
        obj.ingriedientId2 = 1;
        obj.countIngridient2 = 1;
        obj.ingriedientId3 = 1;
        obj.countIngridient3 = 1;
        obj.ingriedientId4 = 1;
        obj.countIngridient4 = 1;
        obj.buildId = 1;
        obj.buildTime = 120;
        obj.currency = HARD_CURRENCY;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        objectRecipe[obj.id ] = obj;
//         4
        obj = {};
        obj.id = 4;
        obj.name = "Cookie";
        obj.idResource = 4;
        obj.ingriedientId1 = 1;
        obj.countIngridient1 = 1;
        obj.ingriedientId2 = 1;
        obj.countIngridient2 = 1;
        obj.ingriedientId3 = 1;
        obj.countIngridient3 = 1;
        obj.ingriedientId4 = 1;
        obj.countIngridient4 = 1;
        obj.buildId = 1;
        obj.buildTime = 120;
        obj.currency = HARD_CURRENCY;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        objectRecipe[obj.id ] = obj;
////         5
        obj = {};
        obj.id = 5;
        obj.name = "Hamburger";
        obj.idResource = 5;
        obj.ingriedientId1 = 1;
        obj.countIngridient1 = 1;
        obj.ingriedientId2 = 1;
        obj.countIngridient2 = 1;
        obj.ingriedientId3 = 1;
        obj.countIngridient3 = 1;
        obj.ingriedientId4 = 1;
        obj.countIngridient4 = 1;
        obj.buildId = 1;
        obj.buildTime = 120;
        obj.currency = HARD_CURRENCY;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        objectRecipe[obj.id ] = obj;
////         6
        obj = {};
        obj.id = 6;
        obj.name = "Honey apple cake";
        obj.idResource = 6;
        obj.ingriedientId1 = 1;
        obj.countIngridient1 = 1;
        obj.ingriedientId2 = 1;
        obj.countIngridient2 = 1;
        obj.ingriedientId3 = 1;
        obj.countIngridient3 = 1;
        obj.ingriedientId4 = 1;
        obj.countIngridient4 = 1;
        obj.buildId = 1;
        obj.buildTime = 120;
        obj.currency = HARD_CURRENCY;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        objectRecipe[obj.id ] = obj;
////         7
//        obj = {};
//        obj.id = 7;
//        obj.name = "Wheat";
//        obj.idResource = 1;
//        obj.ingriedientId1 = 1;
//        obj.countIngridient1 = 1;
//        obj.ingriedientId2 = 1;
//        obj.countIngridient2 = 1;
//        obj.ingriedientId3 = 1;
//        obj.countIngridient3 = 1;
//        obj.ingriedientId4 = 1;
//        obj.countIngridient4 = 1;
//        obj.buildId =
//        obj.buildTime = 120;
//        obj.currency = HARD_CURRENCY;
//        obj.priceSkipHard = 1;
//        obj.blockByLevel = 1;
//        objectRecipe[obj.id ] = obj;
//////         8
//        obj = {};
//        obj.id = 8;
//        obj.name = "Wheat";
//        obj.idResource = 1;
//        obj.ingriedientId1 = 1;
//        obj.countIngridient1 = 1;
//        obj.ingriedientId2 = 1;
//        obj.countIngridient2 = 1;
//        obj.ingriedientId3 = 1;
//        obj.countIngridient3 = 1;
//        obj.ingriedientId4 = 1;
//        obj.countIngridient4 = 1;
//        obj.buildId =
//        obj.buildTime = 120;
//        obj.currency = HARD_CURRENCY;
//        obj.priceSkipHard = 1;
//        obj.blockByLevel = 1;
//        objectRecipe[obj.id ] = obj;
//////         9
//        obj = {};
//        obj.id = 9;
//        obj.name = "Wheat";
//        obj.idResource = 1;
//        obj.ingriedientId1 = 1;
//        obj.countIngridient1 = 1;
//        obj.ingriedientId2 = 1;
//        obj.countIngridient2 = 1;
//        obj.ingriedientId3 = 1;
//        obj.countIngridient3 = 1;
//        obj.ingriedientId4 = 1;
//        obj.countIngridient4 = 1;
//        obj.buildId =
//        obj.buildTime = 120;
//        obj.currency = HARD_CURRENCY;
//        obj.priceSkipHard = 1;
//        obj.blockByLevel = 1;
//        objectRecipe[obj.id ] = obj;
//////        10
//        obj = {};
//        obj.id = 10;
//        obj.name = "Wheat";
//        obj.idResource = 1;
//        obj.ingriedientId1 = 1;
//        obj.countIngridient1 = 1;
//        obj.ingriedientId2 = 1;
//        obj.countIngridient2 = 1;
//        obj.ingriedientId3 = 1;
//        obj.countIngridient3 = 1;
//        obj.ingriedientId4 = 1;
//        obj.countIngridient4 = 1;
//        obj.buildId =
//        obj.buildTime = 120;
//        obj.currency = HARD_CURRENCY;
//        obj.priceSkipHard = 1;
//        obj.blockByLevel = 1;
//        objectRecipe[obj.id ] = obj;
//////        11
//        obj = {};
//        obj.id = 11;
//        obj.name = "Wheat";
//        obj.idResource = 1;
//        obj.ingriedientId1 = 1;
//        obj.countIngridient1 = 1;
//        obj.ingriedientId2 = 1;
//        obj.countIngridient2 = 1;
//        obj.ingriedientId3 = 1;
//        obj.countIngridient3 = 1;
//        obj.ingriedientId4 = 1;
//        obj.countIngridient4 = 1;
//        obj.buildId =
//        obj.buildTime = 120;
//        obj.currency = HARD_CURRENCY;
//        obj.priceSkipHard = 1;
//        obj.blockByLevel = 1;
//        objectRecipe[obj.id ] = obj;
//////        12
//        obj = {};
//        obj.id = 12;
//        obj.name = "Wheat";
//        obj.idResource = 1;
//        obj.ingriedientId1 = 1;
//        obj.countIngridient1 = 1;
//        obj.ingriedientId2 = 1;
//        obj.countIngridient2 = 1;
//        obj.ingriedientId3 = 1;
//        obj.countIngridient3 = 1;
//        obj.ingriedientId4 = 1;
//        obj.countIngridient4 = 1;
//        obj.buildId =
//        obj.buildTime = 120;
//        obj.currency = HARD_CURRENCY;
//        obj.priceSkipHard = 1;
//        obj.blockByLevel = 1;
//        objectRecipe[obj.id ] = obj;
//////        13
//        obj = {};
//        obj.id = 13;
//        obj.name = "Wheat";
//        obj.idResource = 1;
//        obj.ingriedientId1 = 1;
//        obj.countIngridient1 = 1;
//        obj.ingriedientId2 = 1;
//        obj.countIngridient2 = 1;
//        obj.ingriedientId3 = 1;
//        obj.countIngridient3 = 1;
//        obj.ingriedientId4 = 1;
//        obj.countIngridient4 = 1;
//        obj.buildId =
//        obj.buildTime = 120;
//        obj.currency = HARD_CURRENCY;
//        obj.priceSkipHard = 1;
//        obj.blockByLevel = 1;
//        objectRecipe[obj.id ] = obj;
//////        14
//        obj = {};
//        obj.id = 14;
//        obj.name = "Wheat";
//        obj.idResource = 1;
//        obj.ingriedientId1 = 1;
//        obj.countIngridient1 = 1;
//        obj.ingriedientId2 = 1;
//        obj.countIngridient2 = 1;
//        obj.ingriedientId3 = 1;
//        obj.countIngridient3 = 1;
//        obj.ingriedientId4 = 1;
//        obj.countIngridient4 = 1;
//        obj.buildId =
//        obj.buildTime = 120;
//        obj.currency = HARD_CURRENCY;
//        obj.priceSkipHard = 1;
//        obj.blockByLevel = 1;
//        objectRecipe[obj.id ] = obj;
}

}
}
