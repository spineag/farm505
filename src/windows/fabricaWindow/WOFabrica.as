/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
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

        _list = new WOFabricaWorkList(_source, 3);
        createItems();
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    public function showItWithParams(arr:Array, f:Function):void {
        _callbackOnClick = f;
        fillItems(arr);
        super.showIt();
    }

    private function createItems():void {
        var item:WOItemFabrica;
        _arrItems = [];
        for (var i:int = 0; i < 10; i++) {
            item = new WOItemFabrica();
            item.source.alpha = .5;
            item.source.x = -220 + i%5 * 110;
            i > 4 ? item.source.y = 0 : item.source.y = -120;
            _source.addChild(item.source);
        }
    }

    private function fillItems(arr:Array):void {

    }
}
}
