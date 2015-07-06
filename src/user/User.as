/**
 * Created by andy on 6/10/15.
 */
package user {

import data.BuildType;

import manager.Vars;

public class User {
    public var userId:String; // в базе
    public var userSocialId:String; // в соцсети
    public var name:String;
    public var secondName:String;
    public var ambarMaxCount:int;
    public var skladMaxCount:int;
    public var softCurrencyCount:int;
    public var hardCurrency:int;
    public var yellowCouponCount:int;
    public var redCouponCount:int;
    public var blueCouponCount:int;
    public var greenCouponCount:int;
    public var xp:int;
    public var level:int;

    public var imageMenu:String;

    private var g:Vars = Vars.getInstance();
    public function User() {
        level = 1;
        xp = 0;
        ambarMaxCount = 50;
        skladMaxCount = 50;
        softCurrencyCount = 1;
        hardCurrency = 50;
        yellowCouponCount = 10;
        redCouponCount = 10;
        blueCouponCount = 10;
        greenCouponCount = 10;
    }

    public function checkMoney(_data:Object):Boolean {
        var count:int;
        var bol:Boolean = true;
        if (_data.currency == data.BuildType.SOFT_CURRENCY) {
            if (softCurrencyCount < _data.cost) {
                count = _data.cost - softCurrencyCount;
                bol = false;
            }
        }
        if (_data.currency == data.BuildType.HARD_CURRENCY) {
            if (hardCurrency < _data.cost) {
                count = _data.cost - hardCurrency;
                bol = false;
            }
        }
//        if(yellowCouponCount < ) {
//            bol = false
//        }
//        if(redCouponCount < ) {
//            bol = false
//        }
//        if(blueCouponCount < ) {
//            bol = false
//        }
//        if(greenCouponCount < ) {
//            bol = false
//        }
        if (!bol) g.noResources.showItMenu(_data,count);
        return bol;
    }

    public function checkRecipe(_data:Object):Boolean {
        var count:int = 0;
        for (var i:int = 0; i < _data.ingridientsId.length; i++) {
           count =  g.userInventory.getCountResourceById(_data.ingridientsId[i]);
            if (count < _data.ingridientsCount[i]) {
                g.noResources.showItMenu(_data,_data.ingridientsCount[i] - count);
                return false;
            }
        }
        return true;
    }

    public function checkResource(_data:Object, countResource:int):Boolean {
        var count:int;
            if(_data.buildType == BuildType.ANIMAL){
                count = g.userInventory.getCountResourceById(_data.idResourceRaw);
                if (count < countResource) {
                    g.noResources.showItMenu(_data, countResource - count);
                    return false;
                }
            }
            count = g.userInventory.getCountResourceById(_data.id);
            if (count < countResource) {
                g.noResources.showItMenu(_data, countResource - count);
                return false;
            }
        return true;
    }

//    public function checkZakaz():Boolean {
//
//    }
}
}
