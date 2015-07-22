/**
 * Created by andy on 6/10/15.
 */
package user {

import manager.Vars;

public class User {
    public var userId:int; // в базе
    public var userSocialId:String; // в соцсети
    public var name:String;
    public var lastName:String;
    public var ambarMaxCount:int;
    public var skladMaxCount:int;
    public var ambarLevel:int;
    public var skladLevel:int;
    public var softCurrencyCount:int;
    public var hardCurrency:int;
    public var yellowCouponCount:int;
    public var redCouponCount:int;
    public var blueCouponCount:int;
    public var greenCouponCount:int;
    public var xp:int = 0;
    public var globalXP:int;
    public var level:int = 1;
    public var photo:String;
    public var sex:String = 'm';
    public var isTester:Boolean;

    private var g:Vars = Vars.getInstance();

    public function User() { }

    public function checkUserLevel():void {
        var levels:Object = g.dataLevel.objectLevels;
        var txp:int = 0;
        for (var st:String in levels) {
            if (txp + levels[st].xp > globalXP) {
                xp = globalXP - txp;
                level = int(levels[st].id) - 1;
                return;
            } else {
                level = levels[st].id;
                txp += levels[st].xp;
            }
        }
    }

}
}
