/**
 * Created by user on 4/26/16.
 */
package manager.hitArea {
import starling.display.Sprite;

public class ManagerHitArea {
    private var _areas:Object;

    public function ManagerHitArea() {
        _areas = {};
    }

    public function getHitArea(sp:Sprite, name:String):OwnHitArea {
        if (_areas[name]) {
            return _areas[name];
        } else {
            var area:OwnHitArea = new OwnHitArea(sp);
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
}
}
