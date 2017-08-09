/**
 * Created by andy on 8/4/17.
 */
package windows.askGift {
import data.StructureDataResource;
import flash.events.Event;
import manager.ManagerFilters;
import starling.display.Image;
import starling.utils.Color;

import user.Friend;
import user.Someone;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.DefaultVerticalScrollSprite;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOChooseGiftFriend extends WindowMain {
    private var _woBG:WindowBackground;
    private var _dataResourse:StructureDataResource;
    private var _isForUser:Boolean;
    private var _txtDescription:CTextField;
    private var _txtDescription2:CTextField;
    private var _txtGift:CTextField;
    private var _txtCount:CTextField;
    private var _btn:CButton;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _friendItems:Array;
    private var _currentChooseFriendCount:int;
    private var _txtAddFriends:CTextField;
    private var _txtBtn:CTextField;

    public function WOChooseGiftFriend() {
        _friendItems = [];
        _windowType = WindowsManager.WO_CHOOSE_GIFT_FRIEND;
        _woWidth = 622;
        _woHeight = 562;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('inbox_window_2'));
        im.x = -_woWidth/2 + 24;
        im.y = -_woHeight/2 + 50;
        im.touchable = false;
        _source.addChild(im);

        _txtGift = new CTextField(200, 60, "Подарки");
        _txtGift.setFormat(CTextField.BOLD30, 30, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        _txtGift.x = -100;
        _txtGift.y = -260;
        _source.addChild(_txtGift);
        _txtDescription =  new CTextField(600, 40, "");
        _txtDescription.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtDescription.x = -300;
        _txtDescription.y = -200;
        _source.addChild(_txtDescription);
        _txtDescription2 =  new CTextField(250, 100, "");
        _txtDescription2.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtDescription2.x = -270;
        _txtDescription2.y = 50;
        _source.addChild(_txtDescription2);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('inbox_window_5'));
        im.x = -300;
        im.y = -130;
        im.touchable = false;
        _source.addChild(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('inbox_window_6'));
        im.x = 26;
        im.y = -155;
        im.touchable = false;
        _source.addChild(im);
        _txtCount = new CTextField(200, 60, "0/7");
        _txtCount.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCount.x = im.x + 27;
        _txtCount.y = im.y + 6;
        _source.addChild(_txtCount);

        _btn = new CButton();
        _btn.addButtonTexture(160, 40, CButton.GREEN, true);
        _btn.y = 270;
        _txtBtn = new CTextField(160, 37, 'Попросить');
        _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(_txtBtn);
        _source.addChild(_btn);
        _btn.clickCallback = onClickSent;

        _scrollSprite = new DefaultVerticalScrollSprite(200, 250, 200, 50);
        _scrollSprite.createScoll(220, 10, 250, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        _scrollSprite.source.x = 32;
        _scrollSprite.source.y = -63;
        _source.addChild(_scrollSprite.source);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _dataResourse = params[0];
        _isForUser = params[1];
        if (_isForUser) _txtDescription.text = "Выберите друзей, у которых хотите попросить подарок";
            else _txtDescription.text = "Выберите друзей, которым хотите подарить подарок";
        if (_isForUser) _txtDescription2.text = "Сообщите друзьям, что хотели бы получить этот подарок";
            else _txtDescription2.text = "Подарите друзьям это подарок";
        var im:Image = new Image(g.allData.atlas[_dataResourse.url].getTexture(_dataResourse.imageShop));
        MCScaler.scale(im, 100, 100);
        im.x = -200;
        im.y = -70;
        _source.addChild(im);
        fillFriends();

        super.showIt();
    }

    private function fillFriends():void {
        var fArr:Array = g.user.arrFriends;
        if (!fArr.length) {
            var item:WOChooseGiftFriendItem;
            for (var i:int = 0; i < fArr.length; i++) {
                item = new WOChooseGiftFriendItem(fArr[i] as Someone, onClickItem, this);
                _friendItems.push(item);
                _scrollSprite.addNewCell(item.source);
                if (_isForUser && !(fArr[i] as Someone).canAskFromFriend || !_isForUser && !(fArr[i] as Someone).canSendToFriend) item.disableIt();
            }
        } else {
            _txtAddFriends =  new CTextField(300, 100, "Больше друзей - больше подарков. Жмите кнопку 'Пригласить'");
            _txtAddFriends.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
            _txtAddFriends.x = -10;
            _txtAddFriends.y = 0;
            _source.addChild(_txtAddFriends);
            _txtBtn.text = 'Пригласить';
        }
    }

    private function onClickItem():void {
        _currentChooseFriendCount=0;
        for (var i:int=0; i<_friendItems.length; i++) {
            if ((_friendItems[i] as WOChooseGiftFriendItem).isCheck) _currentChooseFriendCount++;
        }
        _txtCount.text = String(_currentChooseFriendCount) + '/7';
    }

    private function onClickSent():void {
        if (_friendItems.length) {
            var ar:Array = [];
            for (var i:int = 0; i < _friendItems.length; i++) {
                if ((_friendItems[i] as WOChooseGiftFriendItem).isCheck) ar.push((_friendItems[i] as WOChooseGiftFriendItem).friend);
            }
            if (ar.length) {
                if (_isForUser) g.managerAskGift.askGiftsFromFriends(ar, _dataResourse);
                else g.managerAskGift.sentGiftsFromUserDirectly(ar, _dataResourse);
            }
        } else g.socialNetwork.showInviteWindow();
        onClickExit();
    }

    private function onClickExit(e:Event=null):void { super.hideIt(); }
    public function get isMaxCountFriendsFull():Boolean { return _currentChooseFriendCount >= 7; }

    override protected function deleteIt():void {
        if (!_source) return;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_scrollSprite.source);
        _scrollSprite.resetAll();
        _scrollSprite.deleteIt();
        for (var i:int=0; i<_friendItems.length; i++) {
            (_friendItems[i] as WOChooseGiftFriendItem).deleteIt();
        }
        _friendItems.length=0;
        _source.removeChild(_txtCount);
        _txtCount.deleteIt();
        _source.removeChild(_txtDescription);
        _txtDescription.deleteIt();
        _source.removeChild(_txtDescription2);
        _txtDescription2.deleteIt();
        _source.removeChild(_txtGift);
        _txtGift.deleteIt();
        _source.removeChild(_btn);
        _btn.removeChild(_txtBtn);
        _txtBtn.deleteIt();
        _btn.deleteIt();
        super.deleteIt();
    }
}
}
