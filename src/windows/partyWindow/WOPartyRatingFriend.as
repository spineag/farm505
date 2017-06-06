/**
 * Created by user on 5/24/17.
 */
package windows.partyWindow {
import com.junkbyte.console.Cc;

import data.BuildType;

import data.StructureDataBuilding;

import flash.display.Bitmap;

import manager.ManagerFilters;

import manager.Vars;

import social.SocialNetwork;

import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Quad;

import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import starling.utils.Color;

import utils.CTextField;

import utils.MCScaler;

public class WOPartyRatingFriend {
    public var source:Sprite;
    private var _person:Object;
    private var _ava:Image;
    private var _txtCountResource:CTextField;
    private var _txtNamePerson:CTextField;
    private var _imResource:Image;

    private var g:Vars = Vars.getInstance();

    public function WOPartyRatingFriend(ob:Object, number:int, user:Boolean = false) {
//        return;
        _person = ob;
        source = new Sprite();
        if (user) g.load.loadImage(g.user.photo, onLoadPhoto);
        else if (_person.photo) {
            g.load.loadImage(_person.photo, onLoadPhoto);
        } else {
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
            g.socialNetwork.getTempUsersInfoById([_person.userSocialId]);
        }

        if (g.managerParty.typeParty == 3) _imResource = new Image(g.allData.atlas['partyAtlas'].getTexture('zefir_100'));
        else {
            if (g.allData.getResourceById(g.managerParty.idResource).buildType == BuildType.RESOURCE) {
                _imResource = new Image(g.allData.atlas[g.allData.getResourceById(g.managerParty.idResource).url].getTexture(g.allData.getResourceById(g.managerParty.idResource).imageShop));
            } else if (g.allData.getResourceById(g.managerParty.idResource).buildType == BuildType.PLANT) {
                _imResource = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(g.managerParty.idResource).imageShop + '_icon'));
            }
        }
        MCScaler.scale(_imResource,50,50);
        source.addChild(_imResource);
        _imResource.x = 215;
        _imResource.y = -5;

        if (user) _txtCountResource = new CTextField(250, 100, String(g.managerParty.userParty.countResource));
        else _txtCountResource = new CTextField(250, 100, String(_person.countResource));
        _txtCountResource.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountResource.alignH = Align.LEFT;
        source.addChild(_txtCountResource);
        _txtCountResource.x = 242 - _txtCountResource.textBounds.width/2;
        _txtCountResource.y = -5;

        var txt:CTextField = new CTextField(250, 100, String(number));
        if (user || _person.userId == g.user.userId)txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        else txt.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.y = -15;
        txt.x = 28 - txt.textBounds.width/2;
        source.addChild(txt);
        if (user) _txtNamePerson = new CTextField(90, 120, String(g.user.name + ' ' + g.user.lastName));
        else _txtNamePerson = new CTextField(90, 120, String(_person.name));
        if (user || _person.userId == g.user.userId) _txtNamePerson.setFormat(CTextField.BOLD18, 18,Color.WHITE, ManagerFilters.BLUE_COLOR);
        else _txtNamePerson.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        _txtNamePerson.alignH = Align.LEFT;
        _txtNamePerson.x = 120;
        _txtNamePerson.y = -27;
        source.addChild(_txtNamePerson);
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 50, 50);
        _ava.x = 55;
        _ava.y = 10;
        source.addChild(_ava);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small'));
        MCScaler.scale(im, im.height-5, im.width-5);
        im.x = 89;
        im.y = 35;
        source.addChild(im);
        if (_person) txt = new CTextField(80, 100, String(_person.level));
        else txt = new CTextField(80, 100, String(g.user.level));
        txt.setFormat(CTextField.BOLD18, 12, Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = 105 - txt.textBounds.width/2;
        txt.y = -3;
        source.addChild(txt);
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
        source.addChild(_ava);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small'));
        MCScaler.scale(im, im.height-5, im.width-5);
        im.x = 89;
        im.y = 35;
        source.addChild(im);
        var txt:CTextField;
        if (_person) txt = new CTextField(80, 100, String(_person.level));
        else txt = new CTextField(80, 100, String(g.user.level));
        txt.setFormat(CTextField.BOLD18, 12, Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = 105 - txt.textBounds.width/2;
        txt.y = -3;
        source.addChild(txt);
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        if (!_person.name) _person = g.user.getSomeoneBySocialId(_person.userSocialId);
        if (_person.photo =='' || _person.photo == 'unknown') _person.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_person.photo, onLoadPhoto);
    }
}
}
