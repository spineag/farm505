/**
 * Created by user on 7/23/15.
 */
package windows.market {
import com.junkbyte.console.Cc;

import flash.filters.GlowFilter;

import manager.ManagerFilters;

import social.SocialNetworkEvent;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;
import starling.utils.Color;

import user.NeighborBot;

import user.Someone;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.DefaultVerticalScrollSprite;
import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOMarket  extends Window {

    public var marketChoose:WOMarketChoose;
    private var _shopSprite:Sprite;
    private var _woBG:WindowBackground;
    private var _arrItems:Array;
    private var _arrItemsFriend:Array;
    private var _curUser:Someone;
    private var _btnRefresh:CSprite;
    private var _btnFriends:CButton;
    private var _cont:Sprite;
    private var _contItem:CSprite;
    private var _item:MarketFriendItem;
    private var _item2:MarketFriendItem;
    private var _item3:MarketFriendItem;
    private var ma:MarketAllFriend;
    private var _shiftFriend:int = 0;
    private var _arrFriends:Array;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _txtName:TextField;
    private var _panelBool:Boolean;
    private var _callbackState:Function;

    public function WOMarket() {
        super ();
        _cont = new Sprite();
        _contItem = new CSprite();
        _arrItemsFriend = [];
        _shopSprite = new Sprite();
        _woWidth = 750;
        _woHeight = 520;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        callbackClickBG = onClickExit;
        _source.addChild(_contItem);
        _contItem.filter = ManagerFilters.SHADOW_LIGHT;
        _btnFriends = new CButton();
        _btnFriends.addButtonTexture(96, 40, CButton.GREEN, true);
        _btnFriends.x = _woWidth/2 - 97;
        _btnFriends.y = _woHeight/2 - 58;
        _source.addChild(_cont);
        var c:CartonBackground = new CartonBackground(550, 445);
        c.x = -_woWidth/2 + 43;
        c.y = -_woHeight/2 + 40;
        _cont.filter = ManagerFilters.SHADOW_LIGHT;
        _cont.addChild(c);
        var txt:TextField = new TextField(80, 25, 'Все друзья', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.nativeFilters = [new GlowFilter(0x4b3600, 1, 4, 4, 5)];
        txt.x = 8;
        txt.y = 8;
        _btnFriends.addChild(txt);
        _source.addChild(_btnFriends);
        _btnFriends.clickCallback = btnFriend;
        marketChoose = new WOMarketChoose();
        addItems();
//        _friendsPanel = new MarketFriendsPanelItem(this,_source);
        _btnRefresh = new CSprite();
        var ref:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('refresh_icon'));
        _btnRefresh.addChild(ref);
        _btnRefresh.x = -320;
        _btnRefresh.y = 155;
        _source.addChild(_btnRefresh);
        _btnRefresh.endClickCallback = makeRefresh;
        callbackClickBG = hideIt;
        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, fillFriends);
        new Birka('РЫНОК', _source, _woWidth, _woHeight);
        _panelBool = false;

    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }
    private function fillFriends(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, fillFriends);
        _arrFriends = g.user.arrFriends.slice();
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        _txtName = new TextField(300, 30, '', g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtName.y = -200;
        _txtName.x = -170;
        ma = new MarketAllFriend(_arrFriends,this);
        _source.addChild(ma.source);
    }

    public function showItWithParams(f:Function):void {
        createMarketTabBtns();
        _callbackState = f;
//        fillItems();
//        fillItemsByUser(g.user);
        showIt();
    }

    public function showItPapper(p:Someone):void {
        for (var i:int=0; i < _arrFriends.length; i++) {
            if (_arrFriends[i].userSocialId == p.userSocialId){
                _shiftFriend = i;
            }
        }

        if(_shiftFriend == 0) {
            _curUser = p;
            createMarketTabBtns(true);
        }else createMarketTabBtns();
        fillItemsByUser(p);
        showIt();
    }

    override public function hideIt():void {
        _panelBool = false;
        deleteFriends();
        unFillItems();
        super.hideIt();
        closePanelFriend();
        _shiftFriend = 0;
        callbackState();
    }

    public function resetAll():void {
//        _friendsPanel.resetIt();
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
            item = new MarketItem(i);
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
        var i:int;
        try {
            var n:int = 0;
//            unFillItems();
            if (_curUser is NeighborBot) {
                for (i = 0; i < _arrItems.length; i++) {
                    _arrItems[i].friendAdd();
                    if (_curUser.marketItems[i]) {
                        if (_curUser == g.user.neighbor && _curUser.marketItems[i].resourceId == -1) continue;
                        _arrItems[i].fillFromServer(_curUser.marketItems[i], _curUser);
                    }
                }
                return;
            }
            for (i=0; i < _arrItems.length; i++) {
                if (_curUser.marketItems[i]) {
                    n = 0;
                    if (_curUser == g.user.neighbor && _curUser.marketItems[i].resourceId == -1) continue;
                    n = _curUser.marketItems[i].numberCell;
                    _arrItems[n].fillFromServer(_curUser.marketItems[i], _curUser);
                    _arrItems[i].isUser = _curUser == g.user;
                } else {
                    _arrItems[i].isUser = _curUser == g.user;
                }
                if (_curUser != g.user) _arrItems[i].friendAdd();
                if (_curUser == g.user)  _arrItems[i].friendAdd(true);
//                _arrItems[n].friendAdd();
            }
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
        createMarketTabBtns();
    }

    public function addAdditionalUser(ob:Object):void {
        _curUser = g.user.getSomeoneBySocialId(ob.userSocialId);
//        _friendsPanel.addAdditionalUser(_curUser);
//        g.woMarket.refreshMarket();
    }

    public function createMarketTabBtns(paper:Boolean = false):void {
        if (paper) _txtName.text = _curUser.name + ' продает:';
        else _txtName.text = _arrFriends[_shiftFriend].name + ' продает:';
        _source.addChild(_txtName);
        if (_arrFriends.length <= 2) {
            _item = new MarketFriendItem(_arrFriends[_shiftFriend], this, _shiftFriend);
            _item.source.y = -180;
            if (_arrFriends[_shiftFriend] == g.user) {
                _item._visitBtn.visible = false;
            } else _item._visitBtn.visible = true;
            var c:CartonBackground = new CartonBackground(125, 115);
            c.x = 208 - 5;
            c.y = -185;
            _cont.addChild(c);
            _source.addChild(_item.source);
            if (_shiftFriend + 2 >= _arrFriends.length) {
                _shiftFriend = -1;
            }
            _item2 = new MarketFriendItem(_arrFriends[_shiftFriend + 1], this, _shiftFriend + 1);
            _item2.source.y = 1 * 120 - 180;
            c = new CartonBackground(125, 115);
//            c.filter = ManagerFilters.SHADOW_LIGHT;
            c.x = 208 - 5;
            c.y = 1 * 120 - 185;
            _contItem.addChild(c);
            _source.addChild(_item2.source);
            _item2.source.y = 5;
            _item2.source.width = _item2.source.height = 100;
            return;
        }
        if (paper) {
            _item = new MarketFriendItem(_curUser, this, 0);
            _item.source.y = -180;
            _item._visitBtn.visible = true;
            c = new CartonBackground(125, 115);
            c.x = 208 - 5;
            c.y = -185;
            _cont.addChild(c);
            _source.addChild(_item.source);
            if (_shiftFriend + 2 >= _arrFriends.length) {
                _shiftFriend = -1;
            }
        } else {
            _item = new MarketFriendItem(_arrFriends[_shiftFriend], this, _shiftFriend);
            _item.source.y = -180;
            if (_arrFriends[_shiftFriend] == g.user) {
                _item._visitBtn.visible = false;
            } else _item._visitBtn.visible = true;
            c = new CartonBackground(125, 115);
            c.x = 208 - 5;
            c.y = -185;
            _cont.addChild(c);
            _source.addChild(_item.source);
            if (_shiftFriend + 2 >= _arrFriends.length) {
                _shiftFriend = -1;
            }
        }
        _item2 = new MarketFriendItem(_arrFriends[_shiftFriend + 1], this, _shiftFriend + 1);
        _item2.source.y = 1 * 120 - 177;
        c = new CartonBackground(120, 110);
        c.x = 208 - 5;
        c.y = 1 * 120 - 185;
        _contItem.addChild(c);
        _source.addChild(_item2.source);
        _item2.source.width = _item2.source.height = 100;


        _item3 = new MarketFriendItem(_arrFriends[_shiftFriend + 2],this,_shiftFriend + 2);
        _item3.source.y = 2 * 120-182;
        c = new CartonBackground(120, 110);
        c.x = 208-5;
        c.y = 2 * 120-190;
        _contItem.addChild(c);
        _source.addChild(_item3.source);
        _item3.source.width = _item3.source.height = 100;
    }

    public function choosePerson(_person:Someone):void {
        unFillItems();
        fillItemsByUser(_person);
    }

    public function set shiftFriend(a:int):void  {
        _shiftFriend = a;
    }

    public function deleteFriends():void {
        _source.removeChild(_item.source);
        _source.removeChild(_item2.source);
        _source.removeChild(_item3.source);
        _source.removeChild(_txtName);
    }

    private function btnFriend ():void {
        if (!_panelBool){
            ma.showIt();
            _panelBool = true;
        } else if (_panelBool) {
            ma.hideIt();
            _panelBool = false;
        }

    }

    public function closePanelFriend():void {
        ma.hideIt();
        _panelBool = false;
    }

    public function callbackState():void {
        if (_callbackState != null) {
            _callbackState.apply(null);
            _callbackState = null;
        }
    }
}
}
