/**
 * Created by user on 7/23/15.
 */
package windows.market {
import starling.display.Image;
import starling.events.Event;
import starling.utils.Color;

import windows.Window;

public class WOMarket  extends Window {
    private var item1:MarketItem;
    private var item2:MarketItem;
    private var item3:MarketItem;
    public var marketChoose:WOMarketChoose;

    public function WOMarket() {
        super ();
        createTempBG(550, 150, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x = 275;
        _btnExit.y = -75;
        marketChoose = new WOMarketChoose();
        addItems();
    }
    private function onClickExit(e:Event):void {
        hideIt();
//        clearIt();
    }

    private function addItems():void {
        item1 = new MarketItem();
        item1.source.x = 10 - 275;
        item1.source.y = -65;
        _source.addChild(item1.source);
        item2 = new MarketItem();
        item2.source.x = 190 - 275;
        item2.source.y = -65;
        _source.addChild(item2.source);
        item3 = new MarketItem();
        item3.source.x = 370 - 275;
        item3.source.y = -65;
        _source.addChild(item3.source);
        item1.callbackFill = callbackItem;
        item2.callbackFill = callbackItem;
        item3.callbackFill = callbackItem;
    }

    private function callbackItem():void { }

}
}
