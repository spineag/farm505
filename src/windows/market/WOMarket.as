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
    private var _item:MarketFriendItem;
    private var _item2:MarketFriendItem;
    private var _item3:MarketFriendItem;
    private var _shiftFriend:int = 0;
    private var _arrFriends:Array;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _txtName:TextField;
    private var _panelBool:Boolean;

    public function WOMarket() {
        super ();
        _arrItemsFriend = [];
        _shopSprite = new Sprite();
        _woWidth = 750;
        _woHeight = 520;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _btnFriends = new CButton();
        _btnFriends.addButtonTexture(96, 40, CButton.GREEN, true);
        _btnFriends.x = _woWidth/2 - 97;
        _btnFriends.y = _woHeight/2 - 58;
        var c:CartonBackground = new CartonBackground(550, 445);
        c.x = -_woWidth/2 + 43;
        c.y = -_woHeight/2 + 40;
        c.filter = ManagerFilters.SHADOW_LIGHT;
        _source.addChildAt(c,1);
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
        _shopSprite.x = -100;
        _shopSprite.filter = ManagerFilters.SHADOW;
//        _shopSprite.y = _woHeight/2;
        _source.addChild(_shopSprite);
        _panelBool = false;
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }
    private function fillFriends(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, fillFriends);
        _arrFriends = g.user.arrFriends.slice();
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        _txtName = new TextField(150, 30, '', g.allData.fonts['BloggerBold'], 20, 0xfbf4cf);
        _txtName.nativeFilters = [new GlowFilter(0x4b3600, 1, 4, 4, 5)];
        _txtName.y = -200;
        _txtName.x = -100;
    }

    public function showItWithParams():void {
        createMarketTabBtns();
        super.showIt();
    }
    override public function hideIt():void {
//        _friendsPanel.checkRemoveAdditionalUser();
        _shopSprite.visible = false;
        _panelBool = false;
        deleteFriends();
        unFillItems();
        super.hideIt();
        _shiftFriend = 0;
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
        g.woMarket.refreshMarket();
    }

    public function createMarketTabBtns():void {
        _txtName.text = _arrFriends[_shiftFriend].name + ' продает:';
        _source.addChildAt(_txtName,2);
        _item = new MarketFriendItem(_arrFriends[_shiftFriend],this,_shiftFriend);
        _item.source.y = -200;
        _item._planet.visible = true;
        _source.addChildAt(_item.source, 2);
        if (_shiftFriend+2 >= _arrFriends.length){
            _shiftFriend = -1;
        }
        _item2 = new MarketFriendItem(_arrFriends[_shiftFriend + 1], this,_shiftFriend + 1);
        _item2.source.y = 1 * 125-200;
        _source.addChildAt(_item2.source,2);
        _item3 = new MarketFriendItem(_arrFriends[_shiftFriend + 2],this,_shiftFriend + 2);
        _item3.source.y = 2 * 125-200;
        _source.addChildAt(_item3.source,2);
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
            _shopSprite.visible = true;
            _panelBool = true;
        } else if (_panelBool) {
            _shopSprite.visible = false;
            _panelBool = false;
            return;
        }
        _scrollSprite = new DefaultVerticalScrollSprite(200, 225, 84, 76);
        _scrollSprite.source.x = 12;
        _scrollSprite.source.y = 55;
        _scrollSprite.createScoll(285, 0, 200, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        var woWidth:int = 314;
        var woHeight:int = 0;
        if (_arrFriends.length <= 3) {
            woHeight = 143;
        } else if (_arrFriends.length > 3 && _arrFriends.length <= 6) {
            woHeight = 218;
        } else if (_arrFriends.length > 6 && _arrFriends.length <= 9){
            woHeight = 300;
        } else {
            woHeight = 300;
        }
        var c:CartonBackground = new CartonBackground(woWidth, woHeight);
        _shopSprite.addChild(c);
        for (var i:int=0; i < _arrFriends.length; i++) {
            var item:MarketFriendsPanelItem = new MarketFriendsPanelItem(_arrFriends[i],this, i);
            _scrollSprite.addNewCell(item.source);
        }
        _shopSprite.addChild(_scrollSprite.source);
        var txtPanel:TextField = new TextField(220, 25, 'Быстрый доступ к друзьям по игре:', g.allData.fonts['BloggerBold'], 13, Color.WHITE);
        txtPanel.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txtPanel.x = 42;
        txtPanel.y = 11;
        _shopSprite.addChild(txtPanel);
    }

}
}
