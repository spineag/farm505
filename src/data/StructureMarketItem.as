/**
 * Created by andy on 2/23/17.
 */
package data {
public class StructureMarketItem {
    public var id:int;
    public var level:int;
    public var resourceId:int;
    public var resourceCount:int;
    public var userId:int;
    public var userSocialId:String;
    public var cost:int=0;
    public var needHelp:int=0; // user need help
    public var isBuyed:Boolean=false; // was buyed in paper
    public var isOpened:Boolean=false; // was already opened in paper
    public var shardName:String='0';
    public var buyerId:int=0;
    public var buyerSocialId:String = '';
    public var inPapper:Boolean = false;
    public var timeSold:String = '';
    public var timeStart:String = '';
    public var numberCell:int=0;
    public var timeInPapper:int=0;

    public function StructureMarketItem(ob:Object) {
        if (ob.id) id = int(ob.id);
        if (ob.level) level = int(ob.level);
        if (ob.resource_id) resourceId = int(ob.resource_id);
        if (ob.resource_count) resourceCount = int(ob.resource_count);
        if (ob.user_id) userId = int(ob.user_id);
        if (ob.user_social_id) userSocialId = ob.user_social_id;
        if (ob.cost) cost = int(ob.cost);
        if (ob.need_help) needHelp = int(ob.need_help);
        if (ob.shard_name) shardName = ob.shard_name;
        if (ob.buyer_id) buyerId = int(ob.buyer_id);
        if (ob.buyer_social_id) buyerSocialId = ob.buyer_social_id;
        if (ob.in_papper) inPapper = Boolean(ob.in_papper == '1');
        if (ob.time_sold) timeSold = ob.time_sold;
        if (ob.time_start) timeStart = ob.time_start;
        if (ob.number_cell) numberCell = int(ob.number_cell);
        if (ob.time_in_papper) timeInPapper = int(ob.time_in_papper);
    }
}
}
