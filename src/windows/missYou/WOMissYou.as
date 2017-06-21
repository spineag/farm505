/**
 * Created by user on 5/30/17.
 */
package windows.missYou {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.display.Bitmap;
import flash.geom.Point;

import manager.ManagerFilters;
import manager.ManagerLanguage;

import resourceItem.DropItem;

import social.SocialNetwork;

import social.SocialNetworkEvent;

import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Quad;
import starling.events.Event;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import user.Someone;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;

public class WOMissYou extends WindowMain {
    private var _woBG:WindowBackground;
    private var _btnYes:CButton;
    private var _btnNo:CButton;
    private var _imName:Image;
    private var _txtDescription:CTextField;
    private var _person:Someone;
    private var _ava:Image;

    public function WOMissYou() {
        super ();
        _woWidth = 520;
        _woHeight = 400;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        if (g.user.language == ManagerLanguage.ENGLISH) _imName = new Image(g.allData.atlas['missAtlas'].getTexture('miss_you_window_3'));
        else _imName = new Image(g.allData.atlas['missAtlas'].getTexture('miss_you_window_1'));
        _source.addChild(_imName);
        _imName.x = -_imName.width/2 + 10;
        _imName.y = - _woHeight/2 + 50;
        var im:Image = new Image(g.allData.atlas['missAtlas'].getTexture('miss_you_window_2'));
        im.x = -275;
        im.y = -225;
        _source.addChild(im);
        _txtDescription = new CTextField(340,80,String(g.managerLanguage.allTexts[1068]));
        _txtDescription.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtDescription.x = -_txtDescription.textBounds.width/2;
        _txtDescription.y = 10;
        _source.addChild(_txtDescription);
        var txt:CTextField;
        _btnYes = new CButton();
        _btnYes.addButtonTexture(160, 50, CButton.GREEN, true);
        txt = new CTextField(160,50,String(g.managerLanguage.allTexts[1069] + ' +5'));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.x = -18;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        _btnYes.addChild(im);
        im.x = 117;
        im.y = 10;
        _btnYes.addChild(txt);
        _btnYes.x = 100;
        _btnYes.y = 125;
        _btnYes.clickCallback = onClickYes;

        _source.addChild(_btnYes);
        _btnNo = new CButton();
        _btnNo.addButtonTexture(160, 50, CButton.PINK, true);
        txt = new CTextField(160,50,String(g.managerLanguage.allTexts[309]));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.RED_COLOR);
        _btnNo.addChild(txt);
        _source.addChild(_btnNo);
        _btnNo.x = -100;
        _btnNo.y = 125;
        _btnNo.clickCallback = onClickNo;

        var bg:Quad = new Quad(84, 84, Color.WHITE);
        bg.x = -bg.width/2 + 10;
        bg.y = -67;
        _source.addChild(bg);

        txt = new CTextField(80, 100, 'Петро');
        txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = - txt.textBounds.width/2 + 10;
        txt.y = -50;
        _source.addChild(txt);
    }

    private function onClickNo():void {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.MISSING);
        arr[0].visibleBuild(false);
        g.directServer.updateUserMiss(_person.userSocialId, 0, false);
        onClickExit();
    }

    private function onClickYes():void {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.MISSING);
        arr[0].visibleBuild(false);
        g.directServer.updateUserMiss(_person.userSocialId, 1, true);
        var obj:Object;
        obj = {};
        obj.count = 5;
        var p:Point = new Point(0, 0);
        p = _source.localToGlobal(p);
        obj.id =  1;
        new DropItem(p.x + 30, p.y + 30, obj);
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) g.directServer.notificationFbMiss(_person.userSocialId, null);
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) g.directServer.notificationVkMiss(_person.userSocialId, null);
        onClickExit();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _person = params[0];
        if (_person) {
            if (_person.photo) {
                g.load.loadImage(_person.photo, onLoadPhoto);
            } else {
                g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                g.socialNetwork.getTempUsersInfoById([_person.userSocialId]);
            }
        }
        super.showIt();
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!_person) {
            Cc.error('FriendItem onLoadPhoto:: no _person');
            return;
        }
        Cc.ch('social', 'FriendItem on load photo: ' + _person.photo);
        if (!bitmap) {
            bitmap = g.pBitmaps[_person.photo].create() as Bitmap;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        if (!tex) return;

        var bg:Quad = new Quad(84, 84, Color.WHITE);
        bg.x = -bg.width/2 + 10;
        bg.y = -67;
        _source.addChild(bg);

        _ava = new Image(tex);
        MCScaler.scale(_ava, 80, 80);
        _ava.x = -_ava.width/2 + 10;
        _ava.y = -65;
        _source.addChild(_ava);

        var txt:CTextField = new CTextField(80, 100, '');
        txt.needCheckForASCIIChars = true;
        txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.alignH = Align.LEFT;
        txt.text = String(_person.name);
        txt.x = - txt.textBounds.width/2 + 10;
        txt.y = -50;
        _source.addChild(txt);
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        if (!_person.name) _person = g.user.getSomeoneBySocialId(_person.userSocialId);
        if (_person.photo =='' || _person.photo == 'unknown') _person.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_person.photo, onLoadPhoto);
    }

    private function onClickExit(e:Event=null):void {
        super.hideIt();
    }

}
}
