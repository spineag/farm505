/**
 * Created by user on 5/27/16.
 */
package windows.inviteFriends {
import manager.ManagerFilters;

import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import windows.WOComponents.CartonBackground;
import windows.WOComponents.DefaultVerticalScrollSprite;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOInviteFriends extends WindowMain {
    private var _woBG:WindowBackground;
    private var _cartonBackground:CartonBackground;
    private var _txt:TextField;
    private var _btn:CButton;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrItem:Array;

    public function WOInviteFriends() {
        super();
        if (g.user.arrNoAppFriend.length == 0) g.socialNetwork.getFriends();
        _windowType = WindowsManager.WO_INVITE_FRIENDS;
        _woWidth = 450;
        _woHeight = 500;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _arrItem = [];
//        _cartonBackground = new CartonBackground(666, 320);
//        _source.addChild(_cartonBackground);
        _txt = new TextField(300,30,'ПРИГЛАСИ ДРУЗЕЙ', g.allData.fonts['BloggerBold'],22,Color.WHITE);
        _txt.x = -150;
        _txt.y = -200;
        _txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _source.addChild(_txt);
        _btn = new CButton();
        _btn.addButtonTexture(100, 34, CButton.BLUE, true);
        var txt:TextField = new TextField(100,30,'Пригласить', g.allData.fonts['BloggerBold'],14,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(txt);
        _btn.x = 0;
        _btn.y = 200;
        _source.addChild(_btn);
        _btn.clickCallback = onClick;
        _scrollSprite = new DefaultVerticalScrollSprite(360, 270, 90, 90);
        _scrollSprite.createScoll(360, 0, 360, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));

        createExitButton(onClickExit);
    }


    private function onClickExit(e:Event=null):void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void{
        super.showIt();
        createFriend();
    }

    private function createFriend():void {
        var item:WOInviteFriendsItem;
        for (var i:int = 0; i < g.user.arrNoAppFriend.length; i++) {
            item = new WOInviteFriendsItem(g.user.arrNoAppFriend[i]);
            _scrollSprite.addNewCell(item.source);
            _arrItem.push(item);
        }
        _source.addChild(_scrollSprite.source);
        _scrollSprite.source.x = -180;
        _scrollSprite.source.y = -150;
    }

    private function onClick():void {
        for (var i:int = 0; i < _arrItem.length; i++) {
            if (_arrItem[i].check) {
                g.socialNetwork.requestBox(String(_arrItem[i].data.userSocialId),'ЭЙ БРАТТТТ ФЮЮЮЮЮЮ ДАВАЙ ИГРАТЬ БРААТТ','1');
            }
        }
    }


}
}
