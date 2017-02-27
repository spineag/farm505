/**
 * Created by user on 2/24/17.
 */
package data {
import manager.Vars;

import utils.Utils;

public class StructureDataResource {
    private var _id:int;
    private var _blockByLevel:int;
    private var _priceHard:int;
    private var _name:String;
    private var _url:String;
    private var _imageShop:String;
    private var _currency:int;
    private var _costDefault:int;
    private var _costMax:int;
    private var _orderPrice:int;
    private var _orderXP:int;
    private var _visitorPrice:int;
    private var _buildType:int;
    private var _placeBuild:int;
    private var _orderType:int;
    private var _opys:String;
    private var _priceSkipHard:String;
    private var _buildTime:String;
    private var _craftXP:String;
    private var _timeToGrow2:int;
    private var g:Vars = Vars.getInstance();

    public function StructureDataResource(ob:Object) {
        _id = int(ob.id);
        _blockByLevel = int(ob.block_by_level);
        _priceHard = int(ob.cost_hard);
        _name = ob.name;
        _url = ob.url;
        _imageShop = ob.image_shop;
        _currency = int(ob.currency);
        _costDefault = int(ob.cost_default);
        _costMax = int(ob.cost_max);
        _orderPrice = int(ob.order_price);
        _orderXP = int(ob.order_xp);
        _visitorPrice = int(ob.visitor_price);
        _buildType = int(ob.resource_type);
        _placeBuild = int(ob.resource_place);
        _orderType = int(ob.order_type);
        _opys = ob.descript;
        if (ob.cost_skip) _priceSkipHard = ob.cost_skip;
        if (ob.build_time) _buildTime = ob.build_time;
        if (ob.craft_xp) _craftXP = ob.craft_xp;
    }

    public function get id():int {return _id;}
    public function get blockByLevel():int {return _blockByLevel;}
    public function get priceHard():int {return _priceHard;}
    public function get name():String {return _name;}
    public function get url():String {return _url;}
    public function get imageShop():String {return _imageShop;}
    public function get currency():int {return _currency;}
    public function get costDefault():int {return _costDefault;}
    public function get costMax():int {return _costMax;}
    public function get orderPrice():int {return _orderPrice;}
    public function get orderXP():int {return _orderXP;}
    public function get visitorPrice():int {return _visitorPrice;}
    public function get buildType():int {return _buildType;}
    public function get placeBuild():int {return _placeBuild;}
    public function get orderType():int {return _orderType;}
    public function get opys():String {return _opys;}
    public function get priceSkipHard():String {return _priceSkipHard;}
    public function get buildTime():String {return _buildTime;}
    public function get craftXP():String {return _craftXP;}
}
}
