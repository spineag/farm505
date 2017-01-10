/**
 * Created by andy on 7/7/15.
 */
package manager {
import com.junkbyte.console.Cc;

import data.DataMoney;

import resourceItem.DropItem;
import resourceItem.ResourceItem;

import temp.DropResourceVariaty;

public class ManagerDropBonusResource {
    public static const DROP_VARIATY:int = 3; // == 2 %
    public static const DROP_TYPE_RESOURSE:String = 'resource';
    public static const DROP_TYPE_MONEY:String = 'money';

//    private var arr:Array;
    private var g:Vars = Vars.getInstance();


    public function ManagerDropBonusResource() {
//        arr = new DropResourceVariaty().resources;
    }

    public function checkDrop():Boolean {
        return int(Math.random()*100) < DROP_VARIATY;
    }

    public function makeDrop(_x:int, _y:int):void {
        var obj:Object = {};
        var aR:Number = Math.random();
        var iR:Number = Math.random();
        if (g.user.level >= 17 && aR < .1) {
            if (iR < .1) {
                obj.count = 1;
                obj.id = DataMoney.RED_COUPONE;
                obj.variaty = 1;
                obj.type = DROP_TYPE_MONEY;
            } else if (iR <.2) {
                obj.count = 1;
                obj.id = DataMoney.YELLOW_COUPONE;
                obj.variaty = 1;
                obj.type = DROP_TYPE_MONEY;
            } else if (iR < .3){
                obj.count = 1;
                obj.id = DataMoney.BLUE_COUPONE;
                obj.variaty = 1;
                obj.type = DROP_TYPE_MONEY;
            } else {
                obj.count = 1;
                obj.id = DataMoney.GREEN_COUPONE;
                obj.variaty = 1;
                obj.type = DROP_TYPE_MONEY;
            }
        } else if (aR < .2) {
            if (iR < .16) {
                obj.count = 1;
                obj.id = 7;
                obj.variaty = 1;
                obj.type = DROP_TYPE_RESOURSE;
            } else if (iR <.32) {
                obj.count = 1;
                obj.id = 9;
                obj.variaty = 1;
                obj.type = DROP_TYPE_RESOURSE;
            } else if (iR < .48){
                obj.count = 1;
                obj.id = 2;
                obj.variaty = 1;
                obj.type = DROP_TYPE_RESOURSE;
            } else if (iR < .64) {
                obj.count = 1;
                obj.id = 8;
                obj.variaty = 1;
                obj.type = DROP_TYPE_RESOURSE;
            } else if (iR < .8) {
                obj.count = 1;
                obj.id = 4;
                obj.variaty = 1;
                obj.type = DROP_TYPE_RESOURSE;
            } else {
                obj.count = 1;
                obj.id = 3;
                obj.variaty = 1;
                obj.type = DROP_TYPE_RESOURSE;
            }
        } else if (aR < .3) {
            if (iR < .25) {
                if (g.userInventory.getCountResourceById(1) > 5 &&  Math.random() < .5) {
                    obj = instrumentRandom();
                } else {
                    obj.count = 1;
                    obj.id = 124;
                    obj.variaty = 1;
                    obj.type = DROP_TYPE_RESOURSE;
                }
            } else if (iR <.5) {
                if (g.userInventory.getCountResourceById(124) > 5 &&  Math.random() < .5) {
                    obj = instrumentRandom();
                } else {
                    obj.count = 1;
                    obj.id = 5;
                    obj.variaty = 1;
                    obj.type = DROP_TYPE_RESOURSE;
                }
            } else if (iR < .75){
                if (g.userInventory.getCountResourceById(6) > 5 &&  Math.random() < .5) {
                    obj = instrumentRandom();
                } else {
                    obj.count = 1;
                    obj.id = 1;
                    obj.variaty = 1;
                    obj.type = DROP_TYPE_RESOURSE;
                }
            } else if (iR < .9) {
                if (g.userInventory.getCountResourceById(5) > 5 &&  Math.random() < .5) {
                    obj = instrumentRandom();
                } else {
                    obj.count = 1;
                    obj.id = 6;
                    obj.variaty = 1;
                    obj.type = DROP_TYPE_RESOURSE;
                }
            } else {
                if (g.userInventory.getCountResourceById(125) > 5 &&  Math.random() < .5) {
                    obj = instrumentRandom();
                } else {
                    obj.count = 1;
                    obj.id = 125;
                    obj.variaty = 1;
                    obj.type = DROP_TYPE_RESOURSE;
                }
            }
        } else {
                obj.count = 100;
                obj.id = DataMoney.SOFT_CURRENCY;
                obj.variaty = 1;
                obj.type = DROP_TYPE_MONEY;
        }

        var prise:Object = obj;



//        if (!arr.length) return;
//        var prise:Object = getDropPrise();
//        if (g.user.level < 17) {
//            if (prise.id == DataMoney.YELLOW_COUPONE || prise.id == DataMoney.BLUE_COUPONE || prise.id == DataMoney.RED_COUPONE || prise.id == DataMoney.GREEN_COUPONE) {
//                prise.id = DataMoney.SOFT_CURRENCY;
//                prise.count = 10;
//                prise.type = 'money';
//                prise.variaty = 1;
//                prise = null;
//                prise = getDropPrise();   // ??
//            } else new DropItem(_x, _y, prise);
//        } else new DropItem(_x, _y, prise);
        new DropItem(_x, _y, prise);

    }

    private function instrumentRandom():Object {
        var obj:Object = {};
        var iR:int = Math.random();
        if (iR < .25) {
            obj.count = 1;
            obj.id = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (iR <.5) {
            obj.count = 1;
            obj.id = 124;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (iR < .75){
            obj.count = 1;
            obj.id = 6;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (iR < .9) {
            obj.count = 1;
            obj.id = 5;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else {
            obj.count = 1;
            obj.id = 125;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        }

        return obj;
    }

//    private function getDropPrise():Object {
//        var i:int;
//        var sum:int = 0;
//        var r:int;
//
//        for (i=0; i < arr.length; i++) {
//            sum += arr[i].variaty;
//        }
//
//        r = int(Math.random()*sum) + 1;
//        sum = 0;
//        for (i=0; i < arr.length; i++) {
//            sum += arr[i].variaty;
//            if (sum >= r) return arr[i];
//        }
//
//        Cc.error('ManagerDropBonusResource:: Wrong with random');
//        return arr[0];
//    }
}
}
