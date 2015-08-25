package windows.market {

import starling.display.Image;
import starling.events.Event;
import ui.scrolled.DefaultVerticalScrollSprite;
import windows.Window;

public class WOMarketChoose extends Window {
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrCells:Array;
    private var _callback:Function;

    public function WOMarketChoose() {
        super();
        _woHeight = 500;
        _woWidth = 534;
        _bg = new Image(g.interfaceAtlas.getTexture('wo_ambar'));
        _bg.pivotX = _bg.width/2;
        _bg.pivotY = _bg.height/2;
        _source.addChild(_bg);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.x -= 28;
        _btnExit.y += 40;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);

        _arrCells = [];
        _scrollSprite = new DefaultVerticalScrollSprite(395, 297, 99, 99);
        _scrollSprite.source.x = 40 - _woWidth/2;
        _scrollSprite.source.y = 79 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(440, 0, 300, g.interfaceAtlas.getTexture('scroll_line'), g.interfaceAtlas.getTexture('scroll_box'));
    }

    public function set callback(f:Function):void {
        _callback = f;
    }

    private function onClickExit(e:Event):void {
        unfillItems();
        _scrollSprite.resetAll();
        hideIt();
        if (_callback != null) {
            _callback.apply(null, [0]);
            _callback = null;
        }
    }

    override public function showIt():void {
        fillItems();
        super.showIt();
    }

    private function fillItems():void {
        var cell:MarketCell;
        var arr:Array = g.userInventory.getResourcesForAmbar();
        var arr2:Array = g.userInventory.getResourcesForSklad();
        arr = arr.concat(arr2);
        arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
        for (var i:int = 0; i < arr.length; i++) {
            cell = new MarketCell(arr[i]);
            cell.clickCallback = onCellClick;
            _arrCells.push(cell);
            _scrollSprite.addNewCell(cell.source);
        }
    }

    private function unfillItems():void {
        for (var i:int = 0; i < _arrCells.length; i++) {
            _arrCells[i].clearIt();
        }
        _arrCells.length = 0;
    }

    private function onCellClick(a:int):void {
        unfillItems();
        _scrollSprite.resetAll();
        hideIt();
        if (_callback != null) {
            var count:int = g.userInventory.getCountResourceById(a);
            count = int(count/2 + .5);
            _callback.apply(null, [a, count]);
            _callback = null;
        }
    }

}
}
