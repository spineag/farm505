/**
 * Created by user on 6/2/15.
 */
package windows.buyPlant {
import build.ridge.Ridge;

import starling.events.Event;
import starling.utils.Color;

import windows.Window;

public class WOBuyPlant extends Window {
    private var _ridge:Ridge;
    private var _itemsArr:Array;

    public function WOBuyPlant() {
        super();
        _woHeight = 200;
        _woWidth = 510;
        createTempBG(_woWidth, _woHeight, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        fillItems();
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    public function showItWithParams(ridge:Ridge):void {
        _ridge = ridge;
        super.showIt();
    }

    private function fillItems():void {
        var obj:Object = g.dataPlant.objectPlants;
        var item:WOItem;
        var i:int = 0;

        _itemsArr = [];
        for(var id:String in obj) {
            item = new WOItem();
            item.fillData(obj[id], onClickItem);
            item.source.x = -170 + i*170;
            i++;
            _source.addChild(item.source);
            _itemsArr.push(item);
        }
    }

    private function onClickItem(data:Object):void {
        hideIt();
        _ridge.fillPlant(data);
    }
}
}
