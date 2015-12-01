/**
 * Created by user on 8/26/15.
 */
package windows.market {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import flash.filters.GlowFilter;

import flash.geom.Rectangle;

import manager.Vars;

import social.SocialNetworkEvent;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import user.Someone;
import user.TempUser;

import utils.CSprite;

import windows.WOComponents.CartonBackground;

public class MarketFriendsPanel {
    public var _source:Sprite;
    private var _wo:WOMarket;
    private var _cont:Sprite;
    private var _arrFriends:Array;
    private var _arrItems:Array;
    private var _shift:int = 0;
    private var _additionalFriendItem:MarketFriendItem;

    private var g:Vars = Vars.getInstance();

    public function MarketFriendsPanel(w:WOMarket) {
        _source = new Sprite();
        _wo = w;
        _source.x = 225;
        _source.y = -160;
        _wo.source.addChild(_source);
        _cont = new Sprite();
        _source.addChild(_cont);
        _arrItems = [];
        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, fillFriends);
        var txt:TextField = new TextField(80, 30, 'ДРУЗЬЯ', g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        txt.nativeFilters = [new GlowFilter(0x4b3600, 1, 4, 4, 5)];

        txt.y = -45;
        txt.x = 10;
        _source.addChild(txt);
    }

    private function fillFriends(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, fillFriends);
        var item:MarketFriendItem;
        _arrFriends = g.user.arrFriends.slice();
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        for (var i:int = 0; i < 3; i++) {
            item = new MarketFriendItem(_arrFriends[i], this);
            item.source.y = i*115;
            _cont.addChild(item.source);
            _arrItems.push(item);
        }

    }

    public function choosePerson(_person:Someone):void {
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].activateIt(false);
        }
        if (_additionalFriendItem) _additionalFriendItem.activateIt(false);
        _wo.unFillItems();
        _wo.fillItemsByUser(_person);
    }

    public function addAdditionalUser(p:Someone):void {
        var i:int;
        for (i = 0; i < _arrItems.length; i++) {
            _arrItems[i].activateIt(false);
        }
        if (p is TempUser) {
            _additionalFriendItem = new MarketFriendItem(p, this);
            _additionalFriendItem.source.y = 0;
            _cont.addChild(_additionalFriendItem.source);
            _additionalFriendItem.activateIt(true);
            for (i = 0; i < _arrItems.length; i++) {
                _arrItems[i].source.y = (i + 1) * 110;
            }
        } else {
            _wo.unFillItems();
            _wo.fillItemsByUser(p);
            var index:int = _arrFriends.indexOf(p);
            if (index > _arrFriends.length - 3) index = _arrFriends.length -3;
            _shift = index;
            _cont.y = _shift*(-110);
        }
    }

    public function checkRemoveAdditionalUser():void {
        if (_additionalFriendItem) {
            _cont.removeChild(_additionalFriendItem.source);
            _additionalFriendItem.clearIt();
            _additionalFriendItem = null;
            for (var i:int = 0; i < _arrItems.length; i++) {
                _arrItems[i].source.y = i * 110;
            }
        }
    }

    public function activateUser(_curUser:Someone):void {
        var i:int;
        for (i = 0; i < _arrItems.length; i++) {
            _arrItems[i].person == _curUser ? _arrItems[i].activateIt(true) : _arrItems[i].activateIt(false);
        }
        if (_additionalFriendItem) _additionalFriendItem.person == _curUser ? _additionalFriendItem.activateIt(true) : _additionalFriendItem.activateIt(false);
    }

    public function resetIt():void {
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].activateIt(false);
        }
        _shift = 0;
        _cont.y = 0;
    }
}
}
