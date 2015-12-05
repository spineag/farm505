package ui.friendPanel {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Linear;

import flash.geom.Rectangle;

import manager.ManagerFilters;

import manager.Vars;

import social.SocialNetworkEvent;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

import utils.CSprite;

import windows.WOComponents.HorizontalPlawka;

public class FriendPanel {
    private var _source:Sprite;
    private var _mask:Sprite;
    private var _cont:Sprite;
    private var _leftArrow:CSprite;
    private var _rightArrow:CSprite;
    private var _arrFriends:Array;
    private var _arrItems:Array;
    private var _shift:int;

    private var g:Vars = Vars.getInstance();
    public function FriendPanel() {
        _source = new Sprite();
        onResize();
        g.cont.interfaceCont.addChild(_source);
        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_back_left'), g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_back_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_back_right'), 465);
        _source.addChild(pl);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_tab'));
        im.x = 20;
        im.y = -23;
        _source.addChild(im);
        var txt:TextField = new TextField(106, 27, "Мои друзья", g.allData.fonts['BloggerBold'], 14, ManagerFilters.TEXT_BROWN);
        txt.x = 30;
        txt.y = -23;
        _source.addChild(txt);

        _mask = new Sprite();
        _mask.x = 105;
        _mask.y = 7;
        _cont = new Sprite();
        _mask.clipRect = new flash.geom.Rectangle(0,0,328,90);
        _mask.addChild(_cont);
        _source.addChild(_mask);

        createAddFriendBtn();
        createArrows();
        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, onGettingInfo);

    }

    private function createAddFriendBtn():void {
        var bt:CSprite = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_bt_add'));
        bt.addChild(im);
        bt.x = 13;
        bt.y = 4;
        _source.addChild(bt);
//        bt.endClickCallback = inviteFriends();
    }

    public function onResize():void {
        _source.x = Starling.current.nativeStage.stageWidth - 740;
        if (_source.visible) {
            _source.y = Starling.current.nativeStage.stageHeight - 89;
        } else {
            _source.y = Starling.current.nativeStage.stageHeight + 100;
        }
    }

    public function showIt():void {
        _source.visible  = true;
//        _source.x = Starling.current.nativeStage.stageWidth - 271;
        TweenMax.killTweensOf(_source);
        new TweenMax(_source, .5, {y:Starling.current.nativeStage.stageHeight - 89, ease:Back.easeOut, delay:.2});
    }

    public function hideIt():void {
        TweenMax.killTweensOf(_source);
        new TweenMax(_source, .5, {y:Starling.current.nativeStage.stageHeight + 100, ease:Back.easeOut, onComplete: function():void {_source.visible = false}});
    }

    private function createArrows():void {
        _leftArrow = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        _leftArrow.addChild(im);
        _leftArrow.x = 78;
        _leftArrow.y = 15;
        _source.addChild(_leftArrow);
        _leftArrow.endClickCallback = leftArrow;

        _rightArrow = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.scaleX = -1;
        im.x = -im.width;
        _rightArrow.addChild(im);
        _rightArrow.x = 485;
        _rightArrow.y = 15;
        _source.addChild(_rightArrow);
        _rightArrow.endClickCallback = rightArrow;
    }

    private var isAnimated:Boolean = false;
    private function leftArrow():void {
        if (isAnimated) return;
        if (_shift > 0) {
            _shift -= 5;
            if (_shift<0) _shift = 0;
            isAnimated = true;
            new TweenMax(_cont, .5, {x:-_shift*66, ease:Linear.easeNone ,onComplete: function():void {isAnimated = false}});
        }
    }

    private function rightArrow():void {
        if (isAnimated) return;
        var l:int = _arrFriends.length;
        if (_shift +1 < l) {
            _shift += 5;
            if (_shift > l-5) _shift = l-5;
            isAnimated = true;
            new TweenMax(_cont, .5, {x:-_shift*66, ease:Linear.easeNone ,onComplete: function():void {isAnimated = false}});
        }
    }

    public function onGettingInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, onGettingInfo);
        var item:FriendItem;
        _arrItems = [];
        _shift = 0;
        _arrFriends = g.user.arrFriends.slice();
        trace('arrFriends length: ' + _arrFriends.length);
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        _arrFriends.sortOn("level", Array.DESCENDING | Array.NUMERIC);
        for (var i:int = 0; i < _arrFriends.length; i++) {
            item = new FriendItem(_arrFriends[i]);
            _arrItems.push(item);
            item.source.x = i*66;
            item.source.y = -1;
            _cont.addChild(item.source);
        }
    }

}
}
