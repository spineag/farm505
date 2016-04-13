/**
 * Created by user on 8/27/15.
 */
package user {
public class Someone {
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

    public function Someone() {
        userDataCity = new UserDataCity();
    }
}
}
