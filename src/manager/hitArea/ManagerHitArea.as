/**
 * Created by user on 4/26/16.
 */
package manager.hitArea {
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.system.ApplicationDomain;
import starling.display.Sprite;

public class ManagerHitArea {
    public static const TYPE_CREATE:int = 1;
    public static const TYPE_LOADED:int = 2;
    public static const TYPE_TILES:int = 3;
    public static const TYPE_FROM_ATLAS:int = 4;
    public static const TYPE_RIDGE:int = 5;
    public static const TYPE_SIMPLE:int = 6;

    private var _areas:Object;
    private var _obLoaded:Object;
    private var _bitmapDataFromAtlas:Object;

    public function ManagerHitArea() {
        _areas = {};
        _obLoaded = {};
        _bitmapDataFromAtlas = {};
    }

    public function getHitArea(sp:starling.display.Sprite, name:String, type:int = 0, sizeX:int=0, sizeY:int=0, additional:starling.display.Sprite=null):OwnHitArea {
        if (_areas[name]) {
            return _areas[name];
        } else {
            var area:OwnHitArea = new OwnHitArea();
            if (type == TYPE_CREATE) {
                if (name == 'bt_close') {
                    area.createCircle(sp, name);
                } else {
                    area.createFromStarlingSprite(sp, name);
                }
            } else if (type == TYPE_LOADED) {
                if (_obLoaded[name]) {
                    area.createFromLoaded(_obLoaded[name], sp, name);
                } else {
                    Cc.error('ManagerHitArea getHitArea - no such loaded for name:' + name);
                    area.createFromStarlingSprite(sp, name);
                }
            } else if (type == TYPE_TILES) {
                area.createTiled(sp, name, sizeX, sizeY);
            } else if (type == TYPE_FROM_ATLAS) {
                if (_bitmapDataFromAtlas[name]) {
                    area.createFromBitmapData(_bitmapDataFromAtlas[name], sp, name);
                } else {
                    Cc.error('ManagerHitArea getHitArea - no such bitmap for name:' + name);
                    area.createFromStarlingSprite(sp, name);
                }
            } else if (type == TYPE_RIDGE) {
                area.createForRidge(sp, name, additional);
            } else if (type == TYPE_SIMPLE) {
                area.createSimple(sp, name);
            } else {
                Cc.error('managerHitArea getHitArea:: unknown type for name:' + name);
            }
            _areas[name] = area;
            return area;
        }
    }

    public function deleteHitArea(name:String):void {
        if (_areas[name]) {
            _areas[name].deleteIt();
            delete _areas[name];
        }
    }
    
    public function registerLoadedHitArea(response:ApplicationDomain):void {
        var cl:Class;
        var sp:flash.display.Sprite;
        var arr:Array = ['order_area', 'aerial_tram', 'buildingBuild', 'sklad', 'chest', 'bbq_grill', 'bakery', 'dairy', 'feed_mill', 'fryer', 'juice_press', 'loom', 'pie_oven',
                        'pizza_maker', 'smelter', 'smoke_house', 'sugar_mill', 'mine', 'apple1', 'apple2', 'apple3', 'cherry1', 'cherry2', 'cherry3',
                        'blueberry1', 'blueberry2', 'blueberry3', 'raspberry1', 'raspberry2', 'raspberry3', 'newspaper', 'market', 'daily_bonus', 'cat_nail','confectionery',
                        'ice_cream_maker', 'jam_machine', 'jeweler', 'toy_factory', 'yogurt_machine', 'arbor', 'beach_chair_red', 'bridge', 'dandelion', 'teleskope', 'tent',
                        'trampoline_yellow', 'umbrella_green', 'well_white', 'well_yellow', 'ghost', 'witch_pot', 'scarecrow', 'picnic_pink','kakao1', 'kakao2', 'kakao3',
                        'lemon1', 'lemon2', 'lemon3', 'orange1', 'orange2', 'orange3'];
        var n:Array = ['order_area', 'aerial_tram', 'buildingBuild', 'sklad', 'chest', 'bbq_grill', 'bakery', 'dairy', 'feed_mill', 'fryer', 'juice_press', 'loom', 'pie_oven',
                        'pizza_maker', 'smelter', 'smoke_house', 'sugar_mill', 'mine', 'apple1', 'apple2', 'apple3', 'cherry1', 'cherry2', 'cherry3',
                        'blueberry1', 'blueberry2', 'blueberry3', 'raspberry1', 'raspberry2', 'raspberry3', 'newspaper', 'market', 'daily_bonus', 'cat_nail','confectionery',
                        'ice_cream_maker', 'jam_machine', 'jeweler', 'toy_factory', 'yogurt_machine', 'arbor', 'beach_chair_red', 'bridge', 'dandelion', 'teleskope', 'tent',
                        'trampoline_yellow', 'umbrella_green', 'well_white', 'well_yellow', 'ghost', 'witch_pot', 'scarecrow', 'picnic_pink','kakao1', 'kakao2', 'kakao3',
                        'lemon1', 'lemon2', 'lemon3', 'orange1', 'orange2', 'orange3'];
        for (var i:int=0; i<arr.length; i++) {
            if (response.hasDefinition(arr[i])) {
                cl = response.getDefinition(arr[i]) as Class;
                sp = new cl();
                _obLoaded[n[i]] = sp as flash.display.Sprite;
            }
        }
    }

    public function registerFromAtlas(b:Bitmap, xl:XML):void {
        var resultBD:BitmapData;
        var ob:Object;
        for each (var prop:XML in xl.SubTexture) {
            resultBD = new BitmapData(int(prop.@width), int(prop.@height));
            var m:Matrix = new Matrix();
            m.translate(-int(prop.@x), -int(prop.@y));
            resultBD.draw(b, m);
            ob = {};
            ob.x = int(prop.@x);
            ob.y = int(prop.@y);
            ob.width = int(prop.@width);
            ob.height = int(prop.@height);
            ob.bitmapData = resultBD;
            _bitmapDataFromAtlas[prop.@name] = ob;
        }
    }
}
}
