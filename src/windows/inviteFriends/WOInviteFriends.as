/**
 * Created by user on 5/27/16.
 */
package windows.inviteFriends {
import manager.ManagerFilters;

import social.SocialNetworkEvent;

import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;

import windows.WOComponents.CartonBackground;
import windows.WOComponents.DefaultVerticalScrollSprite;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOInviteFriends extends WindowMain {
    private var _woBG:WindowBackground;
    private var _cartonBackground:CartonBackground;
    private var _txt:CTextField;
    private var _btn:CButton;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrItem:Array;

    public function WOInviteFriends() {
        // nyjno popravit teksta  !!!!
        
        super();
        _windowType = WindowsManager.WO_INVITE_FRIENDS;
        _woWidth = 450;
        _woHeight = 500;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _arrItem = [];
        _cartonBackground = new CartonBackground(330, 300);
        _cartonBackground.y = -165;
        _cartonBackground.x = -165;
        _source.addChild(_cartonBackground);
        _txt = new CTextField(300,30,'ПРИГЛАСИ ДРУЗЕЙ');
        _txt.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -150;
        _txt.y = -200;
        _source.addChild(_txt);
        _btn = new CButton();
        _btn.addButtonTexture(100, 34, CButton.BLUE, true);
        var txt:CTextField = new CTextField(100,30,'Пригласить');
        txt.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _btn.addChild(txt);
        _btn.x = 0;
        _btn.y = 200;
        _source.addChild(_btn);
        _btn.clickCallback = onClick;
        _scrollSprite = new DefaultVerticalScrollSprite(270, 270, 90, 90);
        _scrollSprite.createScoll(-275, 0,270, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));

        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
    }


    private function onClickExit(e:Event=null):void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void{
        if (g.user.arrNoAppFriend.length) {
            createFriend();
        } else {
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_FRIENDS, createFriend);
            g.socialNetwork.getAllFriends();
        }
    }

    private function createFriend(e:SocialNetworkEvent=null):void {
        if (g.socialNetwork.hasEventListener(SocialNetworkEvent.GET_FRIENDS)) g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_FRIENDS, createFriend);
        var item:WOInviteFriendsItem;
        for (var i:int = 0; i < g.user.arrNoAppFriend.length; i++) {
            item = new WOInviteFriendsItem(g.user.arrNoAppFriend[i]);
            _scrollSprite.addNewCell(item.source);
            _arrItem.push(item);
        }
        _source.addChild(_scrollSprite.source);
        _scrollSprite.source.x = -140;
        _scrollSprite.source.y = -150;
        super.showIt();
    }

    private function onClick():void {
        var arr:Array = [];
        for (var i:int = 0; i < _arrItem.length; i++) {
            if (_arrItem[i].check.visible) {
                arr.push(_arrItem[i].data.userSocialId);
            }
        }
        g.socialNetwork.requestBoxArray(arr,'Приглашаю играть со мной в Умелых Лапках!','1');
    }


}
}
