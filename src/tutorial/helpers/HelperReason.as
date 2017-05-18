/**
 * Created by andy on 6/28/16.
 */
package tutorial.helpers {
import manager.Vars;

public class HelperReason {
    public static const REASON_BUY_RIDGE:int = 1;
    public static const REASON_RAW_PLANT:int = 2;
    public static const REASON_CRAFT_PLANT:int = 3;
    public static const REASON_CRAFT_ANY_PRODUCT:int = 4;
    public static const REASON_ORDER:int = 5;
    public static const REASON_BUY_FABRICA:int = 6;
    public static const REASON_RAW_FABRICA:int = 7;
    public static const REASON_BUY_HERO:int = 8;
    public static const REASON_BUY_FARM:int = 9;
    public static const REASON_BUY_ANIMAL:int = 10;
    public static const REASON_FEED_ANIMAL:int = 11;
    public static const REASON_WILD_DELETE:int = 12;
    public static const REASON_BUY_DECOR:int = 13;
    public static const REASON_BUY_TREE:int = 14;

    private var g:Vars = Vars.getInstance();
    private static var _arr:Array;

    public function HelperReason() {
        _arr = [];

        var ob:Object = {};
        ob.reason = REASON_ORDER;
        ob.txt = String(g.managerLanguage.allTexts[504]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_FEED_ANIMAL;
        ob.txt = String(g.managerLanguage.allTexts[505]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_CRAFT_PLANT;
        ob.txt = String(g.managerLanguage.allTexts[506]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_RAW_PLANT;
        ob.txt = String(g.managerLanguage.allTexts[507]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_RAW_FABRICA;
        ob.txt = String(g.managerLanguage.allTexts[508]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_BUY_FABRICA;
        ob.txt = String(g.managerLanguage.allTexts[509]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_BUY_FARM;
        ob.txt = String(g.managerLanguage.allTexts[510]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_BUY_HERO;
        ob.txt = String(g.managerLanguage.allTexts[511]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_BUY_ANIMAL;
        ob.txt = String(g.managerLanguage.allTexts[512]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_BUY_RIDGE;
        ob.txt = String(g.managerLanguage.allTexts[513]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_CRAFT_ANY_PRODUCT;
        ob.txt = String(g.managerLanguage.allTexts[514]);
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_WILD_DELETE;
        ob.txt = String(g.managerLanguage.allTexts[515]);
        _arr.push(ob);
    }

    public function get reasons():Array {
        _arr.sort(randomize);
        _arr.sort(randomize);
        return _arr.slice();
    }

    private function randomize(a:Object, b:Object):int {
        return ( Math.random() > .5 ) ? 1 : -1;
    }
}
}
