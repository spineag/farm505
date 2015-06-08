/**
 * Created by user on 6/8/15.
 */
package temp.dataTemp {
import data.BuildType;

public class DataDecor {
    public static const HARD_CURRENCY:String = 'diamant';
    public static const SOFT_CURRENCY:String = 'coin';

    public var objectDecor:Object;

    public function DataDecor() {
        objectDecor = {};

        fillDataDecor();
    }

    private function fillDataDecor():void {
        var obj:Object;
//        1
        obj = {};
        obj.id = 1;
        obj.name = "Fence";
        obj.width = 1;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -3;
        obj.innerY = -22;
        obj.url = "buildAtlas";
        obj.image = "stolb";
        obj.imageLenta = "lenta";
        obj.buildType = BuildType.DECOR_POST_FENCE;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id] = obj;
//
        obj = {};
        obj.id = 2;
        obj.name = "build2";
        obj.width = 5;
        obj.height = 4;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -74;
        obj.innerY = -46;
        obj.url = "buildAtlas";
        obj.image = "build2";
        obj.buildType = BuildType.DECOR;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id ] = obj;
//
        obj = {};
        obj.id = 3;
        obj.name = "build3";
        obj.width = 4;
        obj.height = 4;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -77;
        obj.innerY = -39;
        obj.url = "buildAtlas";
        obj.image = "build3";
        obj.buildType = BuildType.DECOR;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id ] = obj;
//
        obj = {};
        obj.id = 4;
        obj.name = "build4";
        obj.width = 4;
        obj.height = 4;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -78;
        obj.innerY = -21;
        obj.url = "buildAtlas";
        obj.image = "build4";
        obj.buildType = BuildType.DECOR;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id ] = obj;
//
        obj = {};
        obj.id = 5;
        obj.name = "build5";
        obj.width = 5;
        obj.height = 5;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -105;
        obj.innerY = 0;
        obj.url = "buildAtlas";
        obj.image = "build5";
        obj.buildType = BuildType.DECOR;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id ] = obj;
//
        obj = {};
        obj.id = 6;
        obj.name = "build6";
        obj.width = 1;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -21;
        obj.innerY = -79;
        obj.url = "buildAtlas";
        obj.image = "build6";
        obj.buildType = BuildType.DECOR;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id ] = obj;
//
        obj = {};
        obj.id = 7;
        obj.name = "build7";
        obj.width = 4;
        obj.height = 4;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -108;
        obj.innerY = -83;
        obj.url = "buildAtlas";
        obj.image = "build7";
        obj.buildType = BuildType.DECOR;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id ] = obj;
//
        obj = {};
        obj.id = 8;
        obj.name = "build8";
        obj.width = 4;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -47;
        obj.innerY = -48;
        obj.url = "buildAtlas";
        obj.image = "build8";
        obj.buildType = BuildType.DECOR;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id ] = obj;
//
        obj = {};
        obj.id = 9;
        obj.name = "build9";
        obj.width = 1;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -15;
        obj.innerY = -39;
        obj.url = "buildAtlas";
        obj.image = "build9";
        obj.buildType = BuildType.DECOR;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id ] = obj;
//
        obj = {};
        obj.id = 10;
        obj.name = "build10";
        obj.width = 2;
        obj.height = 1;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -18;
        obj.innerY = -56;
        obj.url = "buildAtlas";
        obj.image = "build10";
        obj.buildType = BuildType.DECOR;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id ] = obj;
        //
        obj = {};
        obj.id = 11;
        obj.name = "build1";
        obj.width = 3;
        obj.height = 3;
        obj.posX = 1;
        obj.posY = 1;
        obj.innerX = -71;
        obj.innerY = -77;
        obj.url = "buildAtlas";
        obj.image = "build1";
        obj.buildType = BuildType.DECOR;
        obj.cost = 10;
        obj.currency = SOFT_CURRENCY;
        obj.blockByLevel = 1;
        objectDecor[obj.id ] = obj;
    }


}
}
