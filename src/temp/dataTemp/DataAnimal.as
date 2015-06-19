/**
 * Created by user on 6/19/15.
 */
package temp.dataTemp {
public class DataAnimal {
    public var objectAnimal:Object;

    public function DataAnimal() {
        objectAnimal = {};

        fillDataAnimal();
    }

    private function fillDataAnimal():void {
        var obj:Object;

        obj = {};
        obj.id = 1;
        obj.name = "Кура";
        obj.width = 1;
        obj.height = 1;
        obj.url = "buildAtlas";
        obj.image = "chicken";
        obj.cost = 100;
        obj.buildId = 14;                               // здание -> куриная ферма
        obj.timeCraft = 30;
        obj.idResource = 26;                           // что дает
        obj.idResourceFeed = 21;                       // что кушает
        obj.costForceCraft = 5;
        objectAnimal[obj.id ] = obj;

        obj = {};
        obj.id = 2;
        obj.name = "Корова";
        obj.width = 1;
        obj.height = 1;
        obj.url = "buildAtlas";
        obj.image = "cow";
        obj.cost = 200;
        obj.buildId = 15;
        obj.timeCraft = 40;
        obj.idResource = 35;
        obj.idResourceFeed = 25;
        obj.costForceCraft = 5;
        objectAnimal[obj.id ] = obj;
    }
}
}
