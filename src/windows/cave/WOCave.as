
package windows.cave {

import com.junkbyte.console.Cc;

import starling.events.Event;
import starling.utils.Color;
import windows.Window;

public class WOCave extends Window {
    private var _arrItems:Array;

    public function WOCave() {
        super();
        _woHeight = 200;
        _woWidth = 390;
        createTempBG(_woWidth, _woHeight, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, hideIt);
        callbackClickBG = hideIt;
    }

    override public function hideIt():void {
        clearItems();
        super.hideIt();
    }

    public function fillIt(arrIds:Array, f:Function):void {
        try {
            createItems(arrIds.length);
            var f1:Function = function (id:int):void {
                hideIt();
                if (f != null) {
                    f.apply(null, [id]);
                }
            };
            for (var i:int = 0; i < arrIds.length; i++) {
                _arrItems[i].fillData(g.dataResource.objectResources[arrIds[i]], f1);
            }
        } catch(e:Error) {
            Cc.error('WOCave fillIt error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    private function createItems(k:int):void {
        var item:CaveItem;
        _arrItems = [];
        for (var i:int = 0; i < k; i++) {
            item = new CaveItem();
            item.source.x = (i-1) * 130;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function clearItems():void {
        for (var i:int = 0; i < _arrItems.length; i++) {
            _source.removeChild(_arrItems[i].source);
            _arrItems[i].clearIt();
        }
        _arrItems.length = 0;
    }
}
}
