/**
 * Created by user on 8/27/15.
 */
package user {
public class Someone {
    public var userId:int; // в базе
    public var userSocialId:String;
    public var name:String;
    public var lastName:String;
    public var level:int;
    public var globalXP:int;
    public var photo:String;
    public var marketItems:Array;
    public var idVisitItemFromPaper:int;
    public var marketCell:int = -1;
    public var userDataCity:UserDataCity;
    public var needHelpCount:int;
    public var isOpenOrder:Boolean = true;
    public var lastVisitDate:int;
    public var canAskFromFriend:Boolean = true;
    public var canSendToFriend:Boolean = true;

    public function Someone() {
        needHelpCount = 0;
        userDataCity = new UserDataCity();
    }
}
}
