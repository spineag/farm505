/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import manager.Vars;

import starling.display.Quad;

import starling.display.Sprite;

import windows.buyPlant.WOItem;

public class WOFabricaWorkList {
    private var _bg:Quad;
    private var _maxCount:int;
    private var _arrItems:Array;

    private var g:Vars = Vars.getInstance();

    public function WOFabricaWorkList(_parent:Sprite, count:int) {
        _maxCount = count;
        _bg = new Quad(450, 120, 0x6fa9ce);
        _bg.x = - 450/2;
        _bg.y = 75;
        _parent.addChild(_bg);

        createItems(count, _parent);
    }

    private function createItems(count:int, parent:Sprite):void {
        var item:WOItem;

        _arrItems = [];
        for (var i:int = 0; i < 3; i++) {
            item = new WOItem();
            item.source.x = -105 + 105*i;
            item.source.y = 135;
            parent.addChild(item.source);
        }
    }
}
}
