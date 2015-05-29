/**
 * Created by user on 5/25/15.
 */
package temp {
import data.BuildType;

public class DataTrees {
    public static const HARD_CURRENCY:String = 'diamant';
    public static const SOFT_CURRENCY:String = 'coin';

    public var objectTree:Object;

    public function DataTrees() {
        objectTree={};

        fillTree();


    }

    private function fillTree():void {
        var obj:Object;
//        1
        obj = {};
        obj.id = 1;
        obj.name = "tree1";
        obj.width = 1;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -33;
        obj.innerY = -58;
        obj.url = "buildAtlas";
        obj.image = "tree1";
        obj.buildType = BuildType.TEST;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectTree[obj.id ] = obj;
//        2
        obj = {};
        obj.id = 2;
        obj.name = "tree2";
        obj.width = 1;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -33;
        obj.innerY = -63;
        obj.url = "buildAtlas";
        obj.image = "tree2";
        obj.buildType = BuildType.TEST;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 2;
        obj.buildTime = 15000;
        objectTree[obj.id ] = obj;
//         3
        obj = {};
        obj.id = 3;
        obj.name = "tree3";
        obj.width = 1;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -28;
        obj.innerY = -64;
        obj.url = "buildAtlas";
        obj.image = "tree3";
        obj.type = BuildType.TEST;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectTree[obj.id ] = obj;
//         4
        obj = {};
        obj.id = 4;
        obj.name = "tree4";
        obj.width = 1;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -36;
        obj.innerY = -59;
        obj.url = "buildAtlas";
        obj.image = "tree4";
        obj.buildType = BuildType.TEST;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectTree[obj.id ] = obj;
//         5
        obj = {};
        obj.id = 5;
        obj.name = "tree5";
        obj.width = 1;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -27;
        obj.innerY = -60;
        obj.url = "buildAtlas";
        obj.image = "tree5";
        obj.buildType = BuildType.TEST;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectTree[obj.id ] = obj;
//         6
        obj = {};
        obj.id = 6;
        obj.name = "tree6";
        obj.width = 1;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = 0;
        obj.innerY = 0;
        obj.url = " ";
        obj.image = "tile1";
        obj.buildType = BuildType.TEST;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        obj.arrayResources = [];
        obj.skipBuildIt = 1;
        obj.buildTime = 10000;
        objectTree[obj.id ] = obj;
    }
}
}
