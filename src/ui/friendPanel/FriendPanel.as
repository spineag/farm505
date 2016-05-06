package ui.friendPanel {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Linear;

import flash.geom.Point;

import flash.geom.Rectangle;

import manager.ManagerFilters;

import manager.Vars;

import social.SocialNetworkEvent;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

import tutorial.TutorialAction;

import user.Someone;

import utils.CButton;

import utils.CSprite;

import windows.WOComponents.HorizontalPlawka;

public class FriendPanel {
    private var _source:Sprite;
    private var _mask:Sprite;
    private var _cont:Sprite;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _arrFriends:Array;
    private var _arrItems:Array;
    private var _maxFriend:int;
    private var _count:int;
    private var _shift:int;
    private var _addFriendsBtn:CButton;

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
        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, onGettingInfo);
        _maxFriend = 0;
        _count = 0;
    }

    private function createAddFriendBtn():void {
        _addFriendsBtn = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_bt_add'));
        _addFriendsBtn.addDisplayObject(im);
        _addFriendsBtn.setPivots();
        _addFriendsBtn.x = 5 + _addFriendsBtn.width/2;
        _addFriendsBtn.y = 4 + _addFriendsBtn.height/2;
        _source.addChild(_addFriendsBtn);
       _addFriendsBtn.clickCallback = inviteFriends;
    }

    private function inviteFriends():void {
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.VISIT_NEIGHBOR) {      // temp
            g.managerTutorial.checkTutorialCallback();
            g.townArea.goAway(g.user.neighbor);
            g.catPanel.visibleCatPanel(false);
        }
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

    public function hideIt(direct:Boolean = false):void {
        if (!direct) {
            TweenMax.killTweensOf(_source);
            new TweenMax(_source, .5, {y: Starling.current.nativeStage.stageHeight + 100, ease: Back.easeOut, onComplete: function ():void { _source.visible = false } });
        } else {
            _source.y = Starling.current.nativeStage.stageHeight + 100;
        }
    }

    private function createArrows():void {
        _leftArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        _leftArrow.addDisplayObject(im);
        _leftArrow.setPivots();
        _leftArrow.x = 78 + _leftArrow.width/2;
        _leftArrow.y = 15 + _leftArrow.height/2;
        _source.addChild(_leftArrow);
        _leftArrow.clickCallback = leftArrow;

        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.scaleX = -1;
        _rightArrow.addDisplayObject(im);
        _rightArrow.setPivots();
        _rightArrow.x = 485 - _rightArrow.width/2;
        _rightArrow.y = 15 + _rightArrow.height/2;
        _source.addChild(_rightArrow);
        _rightArrow.clickCallback = rightArrow;
    }

    private var isAnimated:Boolean = false;
    private function leftArrow():void {
        if (g.managerTutorial.isTutorial) return;
        if (isAnimated || !_arrFriends.length) return;
        if (_shift > 0) {
            _shift -= 5;
            if (_shift<0) _shift = 0;
            isAnimated = true;
            new TweenMax(_cont, .5, {x:-_shift*66, ease:Linear.easeNone ,onComplete: function():void {isAnimated = false}});
        }
        checkArrows();
    }

    private function rightArrow():void {
        if (g.managerTutorial.isTutorial) return;
        if (isAnimated || !_arrFriends.length) return;
        var l:int = _arrFriends.length;
        if (_shift +1 < l) {
            _shift += 5;
            if (_shift > l-5) _shift = l-5;
            isAnimated = true;
            new TweenMax(_cont, .5, {x:-_shift*66, ease:Linear.easeNone ,onComplete: function():void {isAnimated = false}});
        }
        checkArrows();
    }

    private function checkArrows():void {
        if (_shift <= 0) {
            _leftArrow.setEnabled = false;
        } else {
            _leftArrow.setEnabled = true;
        }
        if (_shift + 5 >= _arrFriends.length) {
            _rightArrow.setEnabled = false;
        } else {
            _rightArrow.setEnabled = true;
        }
    }

    public function onGettingInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, onGettingInfo);
        _arrFriends = g.user.arrFriends.slice();

        for (var i:int = 0; i < _arrFriends.length; i++) {
            _maxFriend ++;
        }
        var bt:CButton;
        var im:Image;
        var txt:TextField;
        if (_arrFriends.length == 0 ) {
            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new TextField(64, 50,"Добавить друга", g.allData.fonts['BloggerBold'], 12, ManagerFilters.TEXT_BROWN);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 237 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);

            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new TextField(64, 50,"Добавить друга", g.allData.fonts['BloggerBold'], 12, ManagerFilters.TEXT_BROWN);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 303 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);

            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new TextField(64, 50,"Добавить друга", g.allData.fonts['BloggerBold'], 12, ManagerFilters.TEXT_BROWN);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 369 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);
        } else if (_arrFriends.length == 1) {
            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new TextField(64, 50,"Добавить друга", g.allData.fonts['BloggerBold'], 12, ManagerFilters.TEXT_BROWN);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 303 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);

            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new TextField(64, 50,"Добавить друга", g.allData.fonts['BloggerBold'], 12, ManagerFilters.TEXT_BROWN);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 369 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);
        } else if (_arrFriends.length == 2) {
            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new TextField(64, 50,"Добавить друга", g.allData.fonts['BloggerBold'], 12, ManagerFilters.TEXT_BROWN);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 369 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);
        }
        createLevel();
    }

    private function sortFriend():void {
        var item:FriendItem;
        _arrItems = [];
        _shift = 0;
        _arrFriends.sortOn("level",  Array.DESCENDING);
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        if (_arrFriends.length > 5) {
            createArrows();
            checkArrows();
        }
        for (var i:int = 0; i < _arrFriends.length; i++) {
            item = new FriendItem(_arrFriends[i]);
            _arrItems.push(item);
            item.source.x = i*66;
            item.source.y = -1;
            _cont.addChild(item.source);
        }
    }

    private function createLevel():void {
        if (_count == _maxFriend) {
            sortFriend();
            return;
        }
        g.directServer.getFriendsInfo(int(_arrFriends[_count].userSocialId), _arrFriends[_count], createLevel);
        _count++;
    }

    public function checkLevel():void {
        if (_arrFriends && _arrFriends.length) {
            for (var i:int = 0; i < _arrFriends.length; i++) {
                if (_arrFriends[i].userSocialId == g.user.userSocialId) {
                    _arrItems[i].txtLvl.text = String(g.user.level);
                }
            }
        }
    }

    public function getNeighborItemProperties():Object {
//        if (_arrItems && _arrItems.length) {
//            return (_arrItems[1] as FriendItem).getItemProperties();
//        } else {
            var ob:Object = {};
            ob.x = 173;
            ob.y = 7;
            var p:Point = new Point(ob.x, ob.y);
            p = _source.localToGlobal(p);
            ob.x = p.x;
            ob.y = p.y;
            ob.width = 60;
            ob.height = 70;
            return ob;
//        }
    }
}
}
