/**
 * Created by andy on 6/28/16.
 */
package tutorial.helpers {
public class HelperReason {
    public static const REASON_ORDER:int = 1;
    public static const REASON_FEED_ANIMAL:int = 2;
    public static const REASON_CRAFT_PLANT:int = 3;
    public static const REASON_RAW_PLANT:int = 4;
    public static const REASON_RAW_FABRICA:int = 5;
    public static const REASON_BUY_FABRICA:int = 6;
    public static const REASON_BUY_FARM:int = 7;
    public static const REASON_BUY_HERO:int = 8;
    public static const REASON_BUY_ANIMAL:int = 9;

    private static var _arr:Array;

    public function HelperReason() {
        _arr = [];

        var ob:Object = {};
        ob.reason = REASON_ORDER;
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_FEED_ANIMAL;
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_CRAFT_PLANT;
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_RAW_PLANT;
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_RAW_FABRICA;
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_BUY_FABRICA;
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_BUY_FARM;
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_BUY_HERO;
        _arr.push(ob);

        ob = {};
        ob.reason = REASON_BUY_ANIMAL;
        _arr.push(ob);
    }

    public static function get reasons():Array {
        _arr.sort(randomize);
        return _arr.slice();
    }

    private static function randomize(a:Object, b:Object):int {
        return ( Math.random() > .5 ) ? 1 : -1;
    }
}
}
