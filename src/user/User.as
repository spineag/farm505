/**
 * Created by andy on 6/10/15.
 */
package user {

import manager.Vars;

public class User {
    public var userId:String; // в базе
    public var userSocialId:String; // в соцсети
    public var name:String;
    public var secondName:String;
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
    public var xp:int;
    public var level:int;

    public var imageMenu:String;

    private var g:Vars = Vars.getInstance();
    public function User() {
        level = 1;
        xp = 0;
        ambarLevel = 1;
        skladLevel = 1;
        ambarMaxCount = 50;
        skladMaxCount = 50;
        softCurrencyCount = 10;
        hardCurrency = 50;
        yellowCouponCount = 10;
        redCouponCount = 10;
        blueCouponCount = 10;
        greenCouponCount = 10;
    }

}
}
