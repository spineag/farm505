package ui.friendPanel {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Linear;

import flash.geom.Point;

import flash.geom.Rectangle;

import manager.ManagerFilters;

import manager.Vars;

import social.SocialNetworkEvent;

import starling.animation.Tween;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;

import tutorial.TutorialAction;

import user.NeighborBot;

import user.Someone;

import utils.CButton;

import utils.CSprite;
import utils.CTextField;

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
        var txt:CTextField = new CTextField(106, 27, "Мои друзья");
        txt.setFormat(CTextField.BOLD18, 14, ManagerFilters.BROWN_COLOR);
        txt.x = 30;
        txt.y = -23;
        _source.addChild(txt);

        _mask = new Sprite();
        _mask.x = 105;
        _mask.y = 7;
        _cont = new Sprite();
        _mask.mask = new Quad(328, 90);
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
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        g.socialNetwork.showInviteWindow();
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
        _leftArrow.clickCallback = onLeftClick;

        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.scaleX = -1;
        _rightArrow.addDisplayObject(im);
        _rightArrow.setPivots();
        _rightArrow.x = 485 - _rightArrow.width/2;
        _rightArrow.y = 15 + _rightArrow.height/2;
        _source.addChild(_rightArrow);
        _rightArrow.clickCallback = onRightClick;
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
        var txt:CTextField;
        if (_arrFriends.length == 0 ) {
            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(64, 50,"Добавить друга");
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 237 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);
            bt.clickCallback = inviteFriends;

            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(64, 50,"Добавить друга");
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 303 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);
            bt.clickCallback = inviteFriends;

            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(64, 50,"Добавить друга");
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 369 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);
            bt.clickCallback = inviteFriends;
        } else if (_arrFriends.length == 1) {
            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(64, 50,"Добавить друга");
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 303 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);
            bt.clickCallback = inviteFriends;

            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(64, 50,"Добавить друга");
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 369 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);
            bt.clickCallback = inviteFriends;

        } else if (_arrFriends.length == 2) {
            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(64, 50,"Добавить друга");
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = -1;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 369 + bt.width/2;
            bt.y = 6 + bt.height/2;
            _source.addChild(bt);
            bt.clickCallback = inviteFriends;
        }
        createLevel();
    }

    private function sortFriend():void {
        var item:FriendItem;
        _arrItems = [];
        _shift = 0;
        _arrFriends.sortOn("level",  Array.NUMERIC);
        _arrFriends.reverse();
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        if (_arrFriends.length > 5) {
            createArrows();
            checkArrows();
        }

        var l:int = _arrFriends.length;
        if (l>5) l = 5;
        for (var i:int = 0; i < l; i++) {
            item = new FriendItem(_arrFriends[i],i);
            _arrItems.push(item);
            item.source.x = i*66;
            item.source.y = -1;
            _cont.addChild(item.source);
        }
    }

    private function onLeftClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        var newCount:int = 5;
        if (_shift - newCount < 0) newCount = _shift;
        _shift -= newCount;

        var item:FriendItem;
        for (var i:int=0; i<newCount; i++) {
            item = new FriendItem(_arrFriends[_shift + i],_shift + i);
//            if(_arrFriends[_shift+i] is NeighborBot){
//            }
            _arrItems.unshift(item);
            item.source.x = 66 * (_shift + i);
            item.source.y = -1;
            _cont.addChild(item.source);
        }

        _arrItems.sortOn('position', Array.NUMERIC);
        var f:Function = function():void {
            for (i=0; i<newCount; i++) {
                item = _arrItems.pop();
                _cont.removeChild(item.source);
                item.deleteIt();
            }
        };
        animList(f);
    }

    private function onRightClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        var newCount:int = 5;
        if (_shift + newCount + 5 >= _arrFriends.length) newCount = _arrFriends.length - _shift - 5;
        var item:FriendItem;
        for (var i:int=0; i<newCount; i++) {
            if (_arrFriends[_shift + 4 + i]) {
                item = new FriendItem(_arrFriends[_shift + 5 + i],_shift + 5 + i);
                item.source.x = 66 * (_shift + 5 + i);
                _cont.addChild(item.source);
                _arrItems.push(item);
            }
        }
        _arrItems.sortOn('position', Array.NUMERIC);
        _shift += newCount;
        var f:Function = function():void {
            for (i=0; i<newCount; i++) {
                item = _arrItems.shift();
                _cont.removeChild(item.source);
                item.deleteIt();
            }
        };
        animList(f);
    }

    private function animList(callback:Function = null):void {
        var tween:Tween = new Tween(_cont, .5);
        tween.moveTo(-_shift*66, _cont.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            if (callback != null) callback.apply();
        };
        g.starling.juggler.add(tween);
        checkArrows();
    }

    private function createLevel():void {
        var arr:Array = [];
        for (var i:int=0; i<_arrFriends.length; i++) {
            arr.push(_arrFriends[i].userSocialId);
        }

        if (arr.length > 0)g.directServer.getAllFriendsInfo(arr, sortFriend);
        else noFriends();
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
    }

    public function noFriends():void {
        var item:FriendItem;
        _arrItems = [];
        _shift = 0;
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        var l:int = _arrFriends.length;
        if (l>5) l = 5;
        for (var i:int = 0; i < l; i++) {
            item = new FriendItem(_arrFriends[i]);
            _arrItems.push(item);
            item.source.x = i*66;
            item.source.y = -1;
            _cont.addChild(item.source);
        }
    }
}
}
