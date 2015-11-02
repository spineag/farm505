/**
 * Created by user on 10/1/15.
 */
package windows.lockedLand {
import build.lockedLand.LockedLand;

import com.junkbyte.console.Cc;

import starling.events.Event;
import starling.filters.ColorMatrixFilter;
import starling.utils.Color;

import utils.CButton;

import windows.Window;

public class WOLockedLand extends Window{
    private var _dataLand:Object;
    private var _land:LockedLand;
    private var _arrItems:Array;
    private var _btnOpen:CButton;
    private var filter:ColorMatrixFilter;

    public function WOLockedLand() {
        super();
        createTempBG(400, 500, Color.GRAY);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('btn_exit'), '', g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_click'), g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 200;
        _btnExit.y -= 250;
        _arrItems = [];

        _btnOpen = new CButton(g.allData.atlas['interfaceAtlas'].getTexture('btn2'), 'Открыть');
        _btnOpen.x = 50;
        _btnOpen.y = -230;
        _source.addChild(_btnOpen);
        filter = new ColorMatrixFilter();
        filter.adjustSaturation(-1);
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
        clearIt();
        if (_btnOpen.hasEventListener(Event.TRIGGERED))
            _btnOpen.removeEventListener(Event.TRIGGERED, onBtnOpen);
    }

    public function showItWithParams(dataLand:Object, land:LockedLand):void {
        _dataLand = dataLand;
        _land = land;

        if (!_dataLand || !_land) {
            Cc.error('WOLockedLand showIt:: bad _dataLand or _land');
            g.woGameError.showIt();
            return;
        }

        var item:LockedLandItem;
        if (_dataLand.friendsCount > 0) {
            item = new LockedLandItem();
            item.fillWithCurrency(_dataLand.currencyCount);
            item.source.y = -80;
            item.source.x = -195;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithResource(_dataLand.resourceId, _dataLand.resourceCount);
            item.source.y = 30;
            item.source.x = -195;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithFriends(_dataLand.friendsCount);
            item.source.y = 140;
            item.source.x = -195;
            _source.addChild(item.source);
            _arrItems.push(item);
        } else {
            item = new LockedLandItem();
            item.fillWithCurrency(_dataLand.currencyCount);
            item.source.y = -50;
            item.source.x = -195;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithResource(_dataLand.resourceId, _dataLand.resourceCount);
            item.source.y = 100;
            item.source.x = -195;
            _source.addChild(item.source);
            _arrItems.push(item);
        }

        super.showIt();
        checkBtn();
    }

    private function clearIt():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].clearIt();
            _source.removeChild(_arrItems[i].source);
        }
        _arrItems.length = 0;
    }

    private function checkBtn():void {
        _btnOpen.filter = filter;
        for (var i:int=0; i<_arrItems.length; i++) {
            if (!_arrItems[i].isGood) return;
        }
        _btnOpen.addEventListener(Event.TRIGGERED, onBtnOpen);
        _btnOpen.filter = null;
    }

    private function onBtnOpen():void {
        _land.openIt();
        onClickExit();
    }

}
}
