/**
 * Created by user on 7/23/15.
 */
package windows.market {
import starling.events.Event;
import starling.utils.Color;

import user.Someone;

import windows.Window;

public class WOMarket  extends Window {
    public var marketChoose:WOMarketChoose;
    private var _friendsPanel:MarketFriendsPanel;
    private var _arrItems:Array;
    private var _curUser:Someone;

    public function WOMarket() {
        super ();
        createTempBG(660, 390, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x = 330;
        _btnExit.y = -195;
        marketChoose = new WOMarketChoose();
        addItems();
        _friendsPanel = new MarketFriendsPanel(this);
    }
    private function onClickExit(e:Event):void {
        hideIt();
//        clearIt();
    }

    override public function showIt():void {
        super.showIt();
        _curUser = g.user;
        fillItemsByUser(_curUser);
    }

    private function addItems():void {
        var item:MarketItem;
        _arrItems = [];
        for (var i:int=0; i<6; i++) {
            item = new MarketItem();
            item.source.x = 180*(i%3) - 325;
            if (i >= 3) {
                item.source.y = -10;
            } else {
                item.source.y = -160;
            }
            _source.addChild(item.source);
            item.callbackFill = callbackItem;
            _arrItems.push(item);
        }
    }

    private function callbackItem():void { }

    public function fillItemsByUser(p:Someone):void {
    _curUser = p;
        if (p.marketItems) {
            fillItems();
        } else {
            g.directServer.getUserMarketItem(_curUser.userSocialId, fillItems);
        }
    }

    public function unFillItems():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].unFillIt();
        }
    }

    private function fillItems():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            if (_curUser.marketItems[i]) {
                _arrItems[i].fillFromServer(_curUser.marketItems[i], _curUser == g.user);
            } else {
                _arrItems[i].isUser = _curUser == g.user;
            }
        }
    }

    public function get curUser():Someone {
        return _curUser;
    }

}
}
