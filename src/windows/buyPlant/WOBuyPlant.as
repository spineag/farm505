/**
 * Created by user on 6/2/15.
 */
package windows.buyPlant {
import build.ridge.Ridge;

import data.BuildType;

import starling.events.Event;
import starling.utils.Color;

import windows.Window;

public class WOBuyPlant extends Window {
    private var _ridge:Ridge;
    private var _arrItems:Array;

    public function WOBuyPlant() {
        super();
        _woHeight = 400;
        _woWidth = 560;
        createTempBG(_woWidth, _woHeight, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        createItems();
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    public function showItWithParams(ridge:Ridge):void {
        _ridge = ridge;
        fillItems();
        super.showIt();
    }

    private function createItems():void {
        var item:WOBuyPlantItem;
        _arrItems = [];
        for (var i:int = 0; i < 15; i++) {
            item = new WOBuyPlantItem();
            item.source.x = -220 + i%5 * 110;
            if (i > 9) {
                item.source.y = 120;
            } else if (i > 4) {
                item.source.y = 0;
            } else {
                item.source.y = -120;
            }
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function fillItems():void {
        var obj:Object = g.dataResource.objectResources;
        var i:int = 0;

        for(var id:String in obj) {
            if (obj[id].buildType == BuildType.PLANT) {
                _arrItems[i].fillData(obj[id], onClickItem);
                i++;
            }
        }
    }

    private function onClickItem(data:Object):void {
        var count:int;
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].unfillIt();
        }
        hideIt();
//        if (!g.user.checkResource(data,1)) return;
        _ridge.fillPlant(data);
//        g.userInventory.addResource(data.id,-1);
//        count = g.userInventory.getCountResourceById();

    }
}
}
