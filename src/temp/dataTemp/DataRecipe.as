/**
 * Created by user on 6/8/15.
 */
package temp.dataTemp {

public class DataRecipe {
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
        obj.idResource = 27;
        obj.numberCreate = 3;
        obj.ingridientsId = [31, 32];
        obj.ingridientsCount = [1, 1];
        obj.buildingId = 3;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        objectRecipe[obj.id ] = obj;
//        2
        obj = {};
        obj.id = 2;
        obj.idResource = 29;
        obj.numberCreate = 3;
        obj.ingridientsId = [32, 33];
        obj.ingridientsCount = [1, 1];
        obj.buildingId = 3;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        objectRecipe[obj.id ] = obj;
//        3
        obj = {};
        obj.id = 3;
        obj.idResource = 25;
        obj.numberCreate = 3;
        obj.ingridientsId = [31, 33];
        obj.ingridientsCount = [1, 1];
        obj.buildingId = 3;
        obj.priceSkipHard = 1;
        obj.blockByLevel = 1;
        objectRecipe[obj.id ] = obj;
}

}
}
