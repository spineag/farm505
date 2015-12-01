/**
 * Created by user on 7/23/15.
 */
package windows.market {
import com.junkbyte.console.Cc;

import flash.filters.GlowFilter;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import user.NeighborBot;

import user.Someone;

import utils.CSprite;

import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOMarket  extends Window {

    public var marketChoose:WOMarketChoose;
    private var _shopSprite:Sprite;
    private var _woBG:WindowBackground;
    private var _friendsPanel:MarketFriendsPanel;
    private var _arrItems:Array;
    private var _curUser:Someone;
    private var _btnRefresh:CSprite;
    private var _btnFriends:CSprite;

    public function WOMarket() {
        super ();
        _shopSprite = new Sprite();
        _woWidth = 750;
        _woHeight = 520;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('bt_close'), '');
        _btnExit.x += _woWidth/2;
        _btnExit.y -= _woHeight/2;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        var c:CartonBackground = new CartonBackground(550, 445);
        _shopSprite.addChild(c);
        _shopSprite.x = -_woWidth/2 + 43;
        _shopSprite.y = -_woHeight/2 + 40;
        _shopSprite.filter = BlurFilter.createDropShadow(1, 0.785, 0, 1, 1.0, 0.5);
        _source.addChild(_shopSprite);
        _btnFriends = new CSprite();
        var btn:WOButtonTexture = new WOButtonTexture(95, 40, WOButtonTexture.GREEN);
        _btnFriends.x = _woWidth/2 - 145;
        _btnFriends.y = _woHeight/2 - 78;
        _btnFriends.addChild(btn);
        var txt:TextField = new TextField(80, 25, 'Все друзья', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.nativeFilters = [new GlowFilter(0x4b3600, 1, 4, 4, 5)];
        txt.x = 8;
        txt.y = 8;
        _btnFriends.addChild(txt);
        _source.addChild(_btnFriends);
        marketChoose = new WOMarketChoose();
        addItems();
        _friendsPanel = new MarketFriendsPanel(this);
        _btnRefresh = new CSprite();
        var ref:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('refresh_icon'));
        _btnRefresh.addChild(ref);
        _btnRefresh.x = -320;
        _btnRefresh.y = 155;
        _source.addChild(_btnRefresh);
        _btnRefresh.endClickCallback = makeRefresh;
        callbackClickBG = hideIt;

        new Birka('РЫНОК', _source, _woWidth, _woHeight);
    }
    private function onClickExit(e:Event):void {
        hideIt();
    }

    override public function hideIt():void {
        _friendsPanel.checkRemoveAdditionalUser();
        unFillItems();
        super.hideIt();
    }

    public function resetAll():void {
        _friendsPanel.resetIt();
    }

    public function set curUser(p:Someone):void {
        _curUser = p;
        fillItemsByUser(_curUser);
    }

    public function get curUser():Someone {
        return _curUser;
    }

    private function addItems():void {
        var item:MarketItem;
        _arrItems = [];
        for (var i:int=0; i<6; i++) {
            item = new MarketItem();
            item.source.x = 125*(i%3) - 300;
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
            if (p is NeighborBot) {
                g.directServer.getUserNeighborMarket(fillItems);
            } else {
                g.directServer.getUserMarketItem(_curUser.userSocialId, fillItems);
            }
        }
    }

    public function unFillItems():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].unFillIt();
        }
    }

    private function fillItems():void {
        try {
            for (var i:int = 0; i < _arrItems.length; i++) {
                if (_curUser.marketItems[i]) {
                    if (_curUser == g.user.neighbor && _curUser.marketItems[i].resourceId == -1) continue;
                    _arrItems[i].fillFromServer(_curUser.marketItems[i], _curUser);
                } else {
                    _arrItems[i].isUser = _curUser == g.user;
                }
            }
            _friendsPanel.activateUser(_curUser);
        } catch (e:Error) {
            Cc.error('WOMarket fillItems:: error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    private function makeRefresh():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].unFillIt();
        }
        g.directServer.getUserMarketItem(_curUser.userSocialId, fillItems);
    }

    public function refreshMarket():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].unFillIt();
        }
        g.directServer.getUserMarketItem(_curUser.userSocialId, fillItems);
    }

    public function addAdditionalUser(ob:Object):void {
        _curUser = g.user.getSomeoneBySocialId(ob.userSocialId);
        _friendsPanel.addAdditionalUser(_curUser);
        g.woMarket.refreshMarket();
    }

}
}
