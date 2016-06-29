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
    public static const REASON_BUY_RIDGE:int = 10;

    private static var _arr:Array;

    public function HelperReason() {
        _arr = [];

        var ob:Object = {};
        ob.reason = REASON_ORDER;
        ob.txt = 'Можно выполнить заказ лавки!';
        _arr.push(ob);

//        ob = {};
//        ob.reason = REASON_FEED_ANIMAL;
//        ob.txt = 'Животные проголодались, давай их накормим!';
//        _arr.push(ob);
//
//        ob = {};
//        ob.reason = REASON_CRAFT_PLANT;
//        ob.txt = 'Можно собирать урожай!';
//        _arr.push(ob);
//
//        ob = {};
//        ob.reason = REASON_RAW_PLANT;
//        ob.txt = 'Давай что-нибудь посадим!';
//        _arr.push(ob);
//
//        ob = {};
//        ob.reason = REASON_RAW_FABRICA;
//        ob.txt = 'Давай что-нибудь произведем на фабрике!';
//        _arr.push(ob);
//
//        ob = {};
//        ob.reason = REASON_BUY_FABRICA;
//        ob.txt = 'Давай построим новую фабрику!';
//        _arr.push(ob);
//
//        ob = {};
//        ob.reason = REASON_BUY_FARM;
//        ob.txt = 'Мы можем построить новый питомник!';
//        _arr.push(ob);
//
//        ob = {};
//        ob.reason = REASON_BUY_HERO;
//        ob.txt = 'Можно нанять еще одного помощника';
//        _arr.push(ob);
//
//        ob = {};
//        ob.reason = REASON_BUY_ANIMAL;
//        ob.txt = 'Можно приобрести еще нескольких животных!';
//        _arr.push(ob);
//
//        ob = {};
//        ob.reason = REASON_BUY_RIDGE;
//        ob.txt = 'Давай вскопаем еще несколько грядок!';
//        _arr.push(ob);
    }

    public function get reasons():Array {
        _arr.sort(randomize);
        return _arr.slice();
    }

    private function randomize(a:Object, b:Object):int {
        return ( Math.random() > .5 ) ? 1 : -1;
    }
}
}
