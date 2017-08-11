/**
 * Created by andy on 8/7/17.
 */
package data {
public class StructureUserGift {
    public var dbId:int;  // id in user_ask_gift
    public var userId1:int;  // someone who give a gift for somebody (userId2)
    public var userId2:int;  // some who take a gift from somebody (userId1)
    public var resourceId:int;
    public var timeAsked:int;
    public var isSend:int;  // 0 = only ask, not send yet, 1 = was send and wait for accept, 2 = was accept
    public var forAsk:Boolean;  // true = this user ask somebody, false = somebody ask this user

    public function StructureUserGift(d:Object) {
        dbId = int(d.id);
        userId1 = int(d.user_id);
        userId2 = int(d.user2_id);
        resourceId = int(d.resource_id);
        timeAsked = int(d.time_ask);
        isSend = int(d.is_send);
    }
}
}
