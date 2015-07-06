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
        var obj:Object = g.dataResource.objectResources;
        var item:WOItem;
        var i:int = 0;

        _itemsArr = [];
        for(var id:String in obj) {
            if (obj[id].buildType == BuildType.PLANT) {
                item = new WOItem();
                item.fillData(obj[id], onClickItem);
                item.source.x = -170 + i * 170;
                i++;
                _source.addChild(item.source);
                _itemsArr.push(item);
            }
        }
    }

    private function onClickItem(data:Object):void {
        var count:int;
        hideIt();
//        if (!g.user.checkResource(data,1)) return;
        _ridge.fillPlant(data);
//        g.userInventory.addResource(data.id,-1);
//        count = g.userInventory.getCountResourceById();

    }
}
}
