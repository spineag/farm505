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

    public function ResourceItem(data:Object) {
        _data = data;

        data.id ?_id = data.id : _id = -1;
        data.name ?_name = data.name : _name = 'noName';
        data.url ? _url = data.url : _url = '';
        data.imageShop ? _imageShop = data.imageShop : _imageShop = '';
        data.currency ? _currency = data.currency : _currency = BuildType.HARD_CURRENCY;
        data.costMax ? _costMax = data.costMax : _costMax = 0;
        data.costMin ? _costMin = data.costMin : _costMin = 0;
        data.priceHard ? _priceHard = data.priceHard : _priceHard = 10000;
        data.priceSkipHard ? _priceSkipHard = data.priceSkipHard : _priceSkipHard = 10000;
        data.blockByLevel ? _blockByLevel = data.blockByLevel : _blockByLevel = 1;
        data.buildTime ? _buildTime = data.buildTime : _buildTime = 30;
        data.builType ? _buildType = data.buildType : _buildType = BuildType.TEST;
        data.craftXP ? craftXP = data.craftXP : craftXP = 1;
        data.image1 ? image1 = data.image1 : image1 = '';
        data.image2 ? image2 = data.image2 : image2 = '';
        data.image3 ? image3 = data.image3 : image3 = '';
        data.image4 ? image4 = data.image4 : image4 = '';
        data.imageHarvested ? imageHarvested = data.imageHarvested : imageHarvested = _imageShop;
        data.innerPositions ? innerPositions = data.innerPositions : innerPositions = [];
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
