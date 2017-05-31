/**
 * Created by user on 5/30/17.
 */
package windows.missYou {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.ManagerFilters;
import manager.ManagerLanguage;

import social.SocialNetwork;

import social.SocialNetworkEvent;

import social.SocialNetworkSwitch;

import starling.display.Image;
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
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        if (g.user.language == ManagerLanguage.ENGLISH) _imName = new Image(g.allData.atlas['missAtlas'].getTexture('miss_you_window_3'));
        else _imName = new Image(g.allData.atlas['missAtlas'].getTexture('miss_you_window_1'));
        var im:Image = new Image(g.allData.atlas['missAtlas'].getTexture('miss_you_window_2'));
        im.x = -50;
        im.y = -50;
        _source.addChild(im);
        _txtDescription = new CTextField(89,62,String(g.managerLanguage.allTexts[292]));
        _txtDescription.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtDescription.x = 5;
        _txtDescription.y = -12;
        _source.addChild(_txtDescription);
        var txt:CTextField;
        _btnYes = new CButton();
        _btnYes.addButtonTexture(120, 40, CButton.GREEN, true);
        txt = new CTextField(120,40,String(g.managerLanguage.allTexts[292]));
        txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.x = 5;
        txt.y = -12;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        _btnYes.addChild(im);
        _btnYes.addChild(txt);
        _source.addChild(_btnYes);
        _btnNo = new CButton();
        _btnNo.addButtonTexture(120, 40, CButton.PINK, true);
        txt = new CTextField(120,40,String(g.managerLanguage.allTexts[309]));
        txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.RED_COLOR);
        _btnNo.addChild(txt);
        _source.addChild(_btnNo);

    }

    override public function showItParams(callback:Function, params:Array):void {
        _person = params[0];
       if (_person.photo) {
            g.load.loadImage(_person.photo, onLoadPhoto);
        } else {
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
            g.socialNetwork.getTempUsersInfoById([_person.userSocialId]);
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
        _ava = new Image(tex);
        MCScaler.scale(_ava, 50, 50);
        _ava.x = 55;
        _ava.y = 10;
        _source.addChild(_ava);
        var txt:CTextField;
        if (_person) txt = new CTextField(80, 100, String(_person.name));
        else txt = new CTextField(80, 100, String(g.user.name));
        txt.setFormat(CTextField.BOLD18, 12, Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = 105 - txt.textBounds.width/2;
        txt.y = -3;
        _source.addChild(txt);
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        if (!_person.name) _person = g.user.getSomeoneBySocialId(_person.userSocialId);
        if (_person.photo =='' || _person.photo == 'unknown') _person.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_person.photo, onLoadPhoto);
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerCutScenes.isCutScene) return;
        super.hideIt();
    }

}
}
