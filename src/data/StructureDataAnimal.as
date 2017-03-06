/**
 * Created by andy on 3/3/17.
 */
package data {
import utils.Utils;

public class StructureDataAnimal {
    private var _id:int;
    private var _buildId:int;
    private var _name:String;
    private var _width:int=1;
    private var _height:int=1;
    private var _url:String;
    private var _image:String;
    private var _cost:int;
    private var _cost2:int;
    private var _cost3:int;
    private var _idResource:int;
    private var _idResourceRaw:int;
    private var _costNew:Array;
    private var _buildType:int;

    public function StructureDataAnimal(ob:Object) {
        _id = int(ob.id);
        _buildId = int(ob.build_id);
        _name = ob.name;
        _width = 1;
        _height = 1;
        _url = ob.url;
        _image = ob.image;
        _cost = int(ob.cost);
        _cost2 = int(ob.cost2);
        _cost3 = int(ob.cost3);
        _idResource = int(ob.craft_resource_id);
        _idResourceRaw = int(ob.raw_resource_id);
        if (ob.cost_new) {
            _costNew = String(ob.cost_new).split('&');
            _costNew = Utils.intArray(_costNew);
        }
        _buildType = BuildType.ANIMAL;
    }

    public function get id():int { return _id; }
    public function get buildId():int { return _buildId; }
    public function get name():String { return _name; }
    public function get width():int { return _width; }
    public function get height():int { return _height; }
    public function get url():String { return _url; }
    public function get image():String { return _image; }
    public function get cost():int { return _cost; }
    public function get cost2():int { return _cost2; }
    public function get cost3():int { return _cost3; }
    public function get idResource():int { return _idResource; }
    public function get idResourceRaw():int { return _idResourceRaw; }
    public function get buildType():int { return _buildType; }
    public function get costNew():Array { return _costNew; }
}
}
