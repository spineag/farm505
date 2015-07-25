/**
 * Created by user on 7/24/15.
 */
package build.train {
import flash.geom.Point;

import manager.Vars;

import starling.display.Image;

public class TrainCell {
    private var _dataResource:Object;
    private var _count:int;
    private var _isFull:Boolean;

    private var g:Vars = Vars.getInstance();

    public function TrainCell(d:Object, c:int) {
        _dataResource = d;
        _count = c;
        _isFull = false;
    }

    public function canBeFull():Boolean {
        return g.userInventory.getCountResourceById(_dataResource.id) >= _count;
    }

    public function get count():int {
        return _count;
    }

    public function get id():int {
        return _dataResource.id;
    }

    public function get isFull():Boolean {
        return _isFull;
    }

    public function fullIt(im:Image):void {
        g.userInventory.addResource(_dataResource.id, -_count);
        var p:Point = new Point(im.x + im.width/2, im.y + im.height/2);
        p = im.parent.localToGlobal(p);

    }
}
}
