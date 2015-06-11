/**
 * Created by user on 6/10/15.
 */
package manager {
import data.BuildType;

public class ResourceItem {
    private var _data:Object;
    private var _id:int;
    private var _name:String;
    private var _url:String;
    private var _imageShop:String;
    private var _currency:String;
    private var _costMax:int;
    private var _costMin:int;
    private var _priceHard:int;  // покупка за хард
    private var _priceSkipHard:int;
    private var _blockByLevel:int;
    private var _buildTime:int;
    private var _buildType:int;
    public var craftXP:int;
    public var image1:String;
    public var image2:String;
    public var image3:String;
    public var image4:String;
    public var imageHarvested:String; // иконка собраного растения, которое летит в изображение склада
    public var innerPositions:Array;
    public var leftTime:int;

    public function ResourceItem() {}

    public function fillIt(dataResource:Object):void {
        _data = dataResource;

        dataResource.id ?_id = dataResource.id : _id = -1;
        dataResource.name ?_name = dataResource.name : _name = 'noName';
        dataResource.url ? _url = dataResource.url : _url = '';
        dataResource.imageShop ? _imageShop = dataResource.imageShop : _imageShop = '';
        dataResource.currency ? _currency = dataResource.currency : _currency = BuildType.HARD_CURRENCY;
        dataResource.costMax ? _costMax = dataResource.costMax : _costMax = 0;
        dataResource.costMin ? _costMin = dataResource.costMin : _costMin = 0;
        dataResource.priceHard ? _priceHard = dataResource.priceHard : _priceHard = 10000;
        dataResource.priceSkipHard ? _priceSkipHard = dataResource.priceSkipHard : _priceSkipHard = 10000;
        dataResource.blockByLevel ? _blockByLevel = dataResource.blockByLevel : _blockByLevel = 1;
        dataResource.buildTime ? _buildTime = dataResource.buildTime : _buildTime = 30;
        dataResource.builType ? _buildType = dataResource.buildType : _buildType = BuildType.TEST;
        dataResource.craftXP ? craftXP = dataResource.craftXP : craftXP = 1;
        dataResource.image1 ? image1 = dataResource.image1 : image1 = '';
        dataResource.image2 ? image2 = dataResource.image2 : image2 = '';
        dataResource.image3 ? image3 = dataResource.image3 : image3 = '';
        dataResource.image4 ? image4 = dataResource.image4 : image4 = '';
        dataResource.imageHarvested ? imageHarvested = dataResource.imageHarvested : imageHarvested = _imageShop;
        dataResource.innerPositions ? innerPositions = dataResource.innerPositions : innerPositions = [];
        leftTime = _buildTime;
    }

    public function get id():int { return _id}
    public function get name():String { return _name}
    public function get url():String { return _url}
    public function get imageShop():String { return _imageShop}
    public function get currency():String { return _currency}
    public function get costMax():int { return _costMax}
    public function get costMin():int { return _costMin}
    public function get priceHard():int { return _priceHard}
    public function get priceSkipHard():int { return _priceSkipHard}
    public function get blockByLevel():int { return _blockByLevel}
    public function get buildTime():int { return _blockByLevel}
    public function get buildType():int { return _buildType}
}
}
