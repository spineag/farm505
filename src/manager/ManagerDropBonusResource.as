/**
 * Created by andy on 7/7/15.
 */
package manager {
import com.junkbyte.console.Cc;

import data.DataMoney;

import resourceItem.DropItem;
import resourceItem.ResourceItem;

import social.SocialNetworkSwitch;

import temp.DropResourceVariaty;

public class ManagerDropBonusResource {
    public static const DROP_VARIATY:int = 2; // == 3 %
    public static const DROP_VARIATY_5:int = 5; // == 5 %

    private var _makeDrop:MakeDrop;
//    private var arr:Array;
    private var g:Vars = Vars.getInstance();
    private var _countBonus:int;

    public function ManagerDropBonusResource() {
        _countBonus =0;
    }

    public function checkDrop():Boolean {
        _countBonus ++ ;
            if (g.user.level <= 7 && !g.managerTutorial.isTutorial) return int(Math.random()*100) < DROP_VARIATY_5 + 1;
             else if (_countBonus == 2) {
                _countBonus = 0;
                return int(Math.random()*100) < DROP_VARIATY + 1;
            } else  return false;
    }
    public function createDrop(_x:int, _y:int):void {
        _makeDrop = new MakeDrop(_x, _y);
    }
}
}

import data.DataMoney;

import manager.Vars;

import resourceItem.DropItem;

internal class MakeDrop {
    public static const DROP_TYPE_RESOURSE:String = 'resource';
    public static const DROP_TYPE_MONEY:String = 'money';
    private var g:Vars = Vars.getInstance();
    public function MakeDrop(_x:int, _y:int):void {
        if (g.user.level <= 10 && !g.managerTutorial.isTutorial) makeDropForUpdateAmbar(_x, _y);
        else makeDrop(_x, _y);
    }

    public function makeDropForUpdateAmbar(_x:int, _y:int):void {
        var obj:Object = {};
        if ((g.userInventory.getCountResourceById(2) >= 1 && g.userInventory.getCountResourceById(3) >= 1 && g.userInventory.getCountResourceById(7) >= 1) || g.user.ambarLevel >= 2) {
            makeDropForUpdateSklad(_x,_y);
            return;
        } else if (g.userInventory.getCountResourceById(2) < 1) {
            obj.id = 2;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (g.userInventory.getCountResourceById(3) < 1) {
            obj.id = 3;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (g.userInventory.getCountResourceById(7) < 1) {
            obj.id = 7;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        }
        if (!obj.id) {
            obj.id = 124;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        }
        new DropItem(_x, _y, obj);
    }

    public function makeDropForUpdateSklad(_x:int, _y:int):void {
        var obj:Object = {};
        if ((g.userInventory.getCountResourceById(4) >= 1 && g.userInventory.getCountResourceById(8) >= 1 && g.userInventory.getCountResourceById(9) >= 1) || g.user.skladLevel >= 2) {
            makeDropWildResource(_x,_y);
            return;
        } else if (g.userInventory.getCountResourceById(4) < 1) {
            obj.id = 4;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (g.userInventory.getCountResourceById(8) < 1) {
            obj.id = 8;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (g.userInventory.getCountResourceById(9) < 1) {
            obj.id = 9;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        }
        if (!obj.id) {
            obj.id = 124;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        }
        new DropItem(_x, _y, obj);
    }

    public function makeDropWildResource(_x:int, _y:int):void {
        var obj:Object = {};
        var aR:Number = Math.random();
        if (aR < .3) {
            obj.id = 1;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (aR < .6) {
            obj.id = 124;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (aR < .9) {
            obj.id = 125;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else {
            obj.id = 5;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        }
        new DropItem(_x, _y, obj);
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
}
