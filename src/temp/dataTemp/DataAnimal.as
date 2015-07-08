/**
 * Created by user on 6/19/15.
 */
package temp.dataTemp {
import data.BuildType;

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
        obj.idResourceRaw = 21;                       // что кушает
        obj.costForceCraft = 5;
        obj.buildType = BuildType.ANIMAL;
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
        obj.idResourceRaw = 25;
        obj.costForceCraft = 5;
        obj.buildType = BuildType.ANIMAL;
        objectAnimal[obj.id ] = obj;

        obj = {};
        obj.id = 3;
        obj.name = "Свинья";
        obj.width = 1;
        obj.height = 1;
        obj.url = "buildAtlas";
        obj.image = "pig";
        obj.cost = 200;
        obj.buildId = 36;
        obj.timeCraft = 40;
        obj.idResource = 36;
        obj.idResourceRaw = 27;
        obj.costForceCraft = 5;
        obj.buildType = BuildType.ANIMAL;
        objectAnimal[obj.id ] = obj;

        obj = {};
        obj.id = 4;
        obj.name = "Овца";
        obj.width = 1;
        obj.height = 1;
        obj.url = "buildAtlas";
        obj.image = "sheep";
        obj.cost = 200;
        obj.buildId = 37;
        obj.timeCraft = 40;
        obj.idResource = 10;
        obj.idResourceRaw = 29;
        obj.costForceCraft = 5;
        obj.buildType = BuildType.ANIMAL;
        objectAnimal[obj.id ] = obj;

        obj = {};
        obj.id = 5;
        obj.name = "Коза";
        obj.width = 1;
        obj.height = 1;
        obj.url = "buildAtlas";
        obj.image = "goat";
        obj.cost = 200;
        obj.buildId = 38;
        obj.timeCraft = 40;
        obj.idResource = 11;
        obj.idResourceRaw = 37;
        obj.costForceCraft = 5;
        obj.buildType = BuildType.ANIMAL;
        objectAnimal[obj.id ] = obj;

        obj = {};
        obj.id = 6;
        obj.name = "Улей";
        obj.width = 1;
        obj.height = 1;
        obj.url = "buildAtlas";
        obj.image = "bee";
        obj.cost = 200;
        obj.buildId = 39;
        obj.timeCraft = 40;
        obj.idResource = 12;
        obj.idResourceRaw = 118;
        obj.costForceCraft = 5;
        obj.buildType = BuildType.ANIMAL;
        objectAnimal[obj.id ] = obj;
    }
}
}
