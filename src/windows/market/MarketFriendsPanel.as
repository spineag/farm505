/**
 * Created by user on 8/26/15.
 */
package windows.market {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import flash.geom.Rectangle;

import manager.Vars;

import social.SocialNetworkEvent;

import starling.display.Image;
import starling.display.Sprite;

import user.Someone;
import user.TempUser;

import utils.CSprite;

public class MarketFriendsPanel {
    public var _source:Sprite;
    private var _wo:WOMarket;
    private var _btnUp:CSprite;
    private var _btnDown:CSprite;
    private var _cont:Sprite;
    private var _arrFriends:Array;
    private var _arrItems:Array;
    private var _shift:int = 0;
    private var _additionalFriendItem:MarketFriendItem;

    private var g:Vars = Vars.getInstance();

    public function MarketFriendsPanel(w:WOMarket) {
        _source = new Sprite();
        _wo = w;
        _source.clipRect = new Rectangle(0, 0, 100, 320);
        _source.x = 225;
        _source.y = -160;
        _wo.source.addChild(_source);
        _cont = new Sprite();
        _source.addChild(_cont);
        var im:Image = new Image(g.interfaceAtlas.getTexture('shop_arrow'));
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        im.scaleX = im.scaleY = .7;
        im.rotation = -Math.PI/2;
        _btnUp = new CSprite();
        _btnUp.addChild(im);
        _btnUp.x = 275;
        _btnUp.y = -180;
        _wo.source.addChild(_btnUp);
        im = new Image(g.interfaceAtlas.getTexture('shop_arrow'));
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        im.scaleX = im.scaleY = .7;
        im.rotation = Math.PI/2;
        _btnDown = new CSprite();
        _btnDown.addChild(im);
        _btnDown.x = 275;
        _btnDown.y = 180;
        _wo.source.addChild(_btnDown);
        _arrItems = [];

        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, fillFriends);
    }

    private function fillFriends(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, fillFriends);
        var item:MarketFriendItem;
        _arrFriends = g.user.arrFriends.slice();
        _arrFriends.unshift(g.user);
        for (var i:int = 0; i < _arrFriends.length; i++) {
            item = new MarketFriendItem(_arrFriends[i], this);
            item.source.y = i*110;
            _cont.addChild(item.source);
            _arrItems.push(item);
        }

        checkBtns();
        _btnDown.endClickCallback = function():void {moveCont(true)};
        _btnUp.endClickCallback = function():void {moveCont(false)};
    }

    private function moveCont(isTop:Boolean):void {
        if (isTop) {
            if (_shift < _arrFriends.length - 3 + int(Boolean(_additionalFriendItem))) {
                _shift++;
                new TweenMax(_cont, .3, {y: _shift * (-110), ease:Linear.easeOut});
            }
        } else {
            if (_shift > 0) {
                _shift--;
                new TweenMax(_cont, .3, {y: _shift * (-110), ease:Linear.easeOut});
            }
        }
        checkBtns();
    }

    private function checkBtns():void {
        if (_shift <= 0) {
            _btnUp.isTouchable = false;
            _btnUp.alpha = .5;
        } else {
            _btnUp.isTouchable = true;
            _btnUp.alpha = 1;
        }
        if (_shift >= _arrFriends.length - 3  + int(Boolean(_additionalFriendItem))) {
            _btnDown.isTouchable = false;
            _btnDown.alpha = .5;
        } else {
            _btnDown.isTouchable = true;
            _btnDown.alpha = 1;
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
