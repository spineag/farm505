/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import resourceItem.ResourceItem;

import starling.events.Event;
import starling.utils.Color;

import windows.Window;

public class WOFabrica extends Window {
    private var _list:WOFabricaWorkList;
    private var _arrItems:Array;
    private var _callbackOnClick:Function;

    public function WOFabrica() {
        super();
        _woHeight = 400;
        _woWidth = 560;
        createTempBG(_woWidth, _woHeight, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);

        _list = new WOFabricaWorkList(_source);
        createItems();
    }

    private function onClickExit(e:Event):void {
        unfillItems();
        _list.unfillIt();
        hideIt();
    }

    public function showItWithParams(arrRecipes:Array, arrList:Array, maxCount:int, f:Function):void {
        _callbackOnClick = f;
        fillItems(arrRecipes, arrList, maxCount);
        super.showIt();
    }

    private function createItems():void {
        var item:WOItemFabrica;
        _arrItems = [];
        for (var i:int = 0; i < 10; i++) {
            item = new WOItemFabrica();
            item.source.x = -220 + i%5 * 110;
            i > 4 ? item.source.y = 0 : item.source.y = -120;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }
    
    private function unfillItems():void {
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].unfillIt();
        }
    }

    private function fillItems(arrAllRecipes:Array, arrList:Array, maxCount:int):void {
        unfillItems();
        if (arrAllRecipes.length > 10) arrAllRecipes.length = 10; // временно, пока не сделана нормальная прокрутка
        for (var i:int = 0; i < arrAllRecipes.length; i++) {
            _arrItems[i].fillData(arrAllRecipes[i], onItemClick);
        }
        _list.fillIt(arrList, maxCount);
    }

    private function onItemClick(dataRecipe:Object):void {
        if (_list.isFull) return;
        var resource:ResourceItem = new ResourceItem();
        resource.fillIt(g.dataResource.objectResources[dataRecipe.idResource]);
        _list.addResource(resource);
        if (_callbackOnClick != null) {
            _callbackOnClick.apply(null, [resource]);
        }
    }
}
}
