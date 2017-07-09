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

import user.Someone;

import utils.CSprite;

import utils.CTextField;

import utils.MCScaler;

import windows.WindowsManager;

public class WOPartyRatingFriendItem {
    public var source:Sprite;
    private var _srcAva:CSprite;
    private var _ava:Image;
    private var _txtCountResource:CTextField;
    private var _txtNamePerson:CTextField;
    private var _imResource:Image;
    private var _personS:Someone;
    private var _data:Object;

    private var g:Vars = Vars.getInstance();

    public function WOPartyRatingFriendItem(ob:Object, number:int, user:Boolean = false) {
        _personS = new Someone();
        if (ob) {
            _personS.userId = ob.userId;
            _personS.userSocialId = ob.userSocialId;
            _personS.photo = ob.photo;
            _personS.name = ob.name;
            _personS.level = ob.level;
            _data = ob;
        } else if (user) {
            _personS.userId = g.user.userId;
            _personS.userSocialId = g.user.userSocialId;
            _personS.photo = g.user.photo;
            _personS.name = g.user.name;
            _personS.level = g.user.level;
            _data = {};
            _data.level = _personS.level;
            _data.userId = _personS.userId;
            _data.userSocialId = _personS.userSocialId;
        }
        source = new Sprite();
        source.y = 35;
        if (number == 1) {
            var im:Image = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_top_1'));
            source.addChild(im);
            im.y =-55;
            im.x = 9;
            var cSp:CSprite  = new CSprite();
            source.addChild(cSp);
            im = new Image(g.allData.atlas['partyAtlas'].getTexture('star_event_winner_45x45'));
            MCScaler.scale(im,45,45);
            cSp.addChild(im);
            cSp.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[1085])); };
            cSp.outCallback = function():void { g.hint.hideIt(); };
            cSp.y =-43;
            cSp.x = 125;
        }
        if ((user || ob.userSocialId == g.user.userSocialId) && g.pBitmaps[_personS.photo]) {
//            _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
//            MCScaler.scale(_ava, 50, 50);
//            _ava.x = 55;
//            _ava.y = 10;
//            source.addChild(_ava);
            onLoadPhoto(g.pBitmaps[_personS.photo].create() as Bitmap);
        }

        if (g.managerParty.typeParty == 3 || g.managerParty.typeParty == 5) _imResource = new Image(g.allData.atlas['partyAtlas'].getTexture('usa_badge'));
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
//        _imResource.y = -5;

        if (user) _txtCountResource = new CTextField(250, 100, String(g.managerParty.userParty.countResource));
        else _txtCountResource = new CTextField(250, 100, String(ob.countResource));
        _txtCountResource.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountResource.alignH = Align.LEFT;
        source.addChild(_txtCountResource);
        _txtCountResource.x = 241 - _txtCountResource.textBounds.width/2;
        _txtCountResource.y = -5;

        var txt:CTextField = new CTextField(250, 100, String(number));
        if (user || _personS.userId == g.user.userId && number != 1) txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        else if (user || _personS.userId == g.user.userId && number == 1) txt.setFormat(CTextField.BOLD18, 18, 0xfdffd3, 0xc78d00);
        else if (number == 1) txt.setFormat(CTextField.BOLD18, 18, 0xfdffd3, 0xc78d00);
        else txt.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.y = -15;
        txt.x = 28 - txt.textBounds.width/2;
        source.addChild(txt);
        _txtNamePerson = new CTextField(90, 120, '');
        _txtNamePerson.needCheckForASCIIChars = true;
        if (user || _personS.userId == g.user.userId && number != 1) _txtNamePerson.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        else if (user || _personS.userId == g.user.userId && number == 1) _txtNamePerson.setFormat(CTextField.BOLD18, 18, 0xfdffd3, 0xc78d00);
        else if (number == 1) _txtNamePerson.setFormat(CTextField.BOLD18, 18, 0xfdffd3, 0xc78d00);
        else _txtNamePerson.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        _txtNamePerson.alignH = Align.LEFT;
        if (user) _txtNamePerson.text = g.user.name + ' ' + g.user.lastName;
        else _txtNamePerson.text = _personS.name;
        _txtNamePerson.x = 120;
        _txtNamePerson.y = -27;
        source.addChild(_txtNamePerson);
    }

    public function updateAvatar():void {
        Cc.info('WOPartyRatingFriendItem update avatar');
        if (!_personS.photo) _personS = g.user.getSomeoneBySocialId(_personS.userSocialId);
        if (_personS.photo =='' || _personS.photo == 'unknown') _personS.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_personS.photo, onLoadPhoto);
        _personS.level = _data.level;
        _personS.userId = _data.userId;
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!_personS) {
            Cc.error('WOPartyRatingFriendItem onLoadPhoto:: no _person');
            return;
        }
        Cc.ch('social', 'WOPartyRatingFriendItem on load photo: ' + _personS.photo);
        if (!bitmap) bitmap = g.pBitmaps[_personS.photo].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        if (!tex) return;
        _srcAva = new CSprite();
        source.addChild(_srcAva);
        _ava = new Image(tex);
        MCScaler.scale(_ava, 50, 50);
        _ava.x = 55;
        _ava.y = 10;
        _srcAva.addChild(_ava);
        if (_data.userSocialId != g.user.userSocialId) {
            _srcAva.endClickCallback = visitPerson;
            _srcAva.hoverCallback = function ():void {
                g.hint.showIt(String(g.managerLanguage.allTexts[386]));
            };
            _srcAva.outCallback = function ():void {
                g.hint.hideIt();
            };
        }
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small'));
        MCScaler.scale(im, im.height-5, im.width-5);
        im.x = 89;
        im.y = 35;
        source.addChild(im);
        var txt:CTextField;
        if (_data && _data.level > 0) txt = new CTextField(80, 100, String(_data.level));
        else txt = new CTextField(80, 100, String(g.user.level));
        txt.setFormat(CTextField.BOLD18, 12, Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = 105 - txt.textBounds.width/2;
        txt.y = -3;
        source.addChild(txt);
    }

    private function visitPerson():void {
        g.townArea.goAway(_personS);
        g.windowsManager.hideWindow(WindowsManager.WO_PARTY);
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        if (!_personS.name) _personS = g.user.getSomeoneBySocialId(_personS.userSocialId);
        if (_personS.photo =='' || _personS.photo == 'unknown') _personS.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_personS.photo, onLoadPhoto);
    }
}
}
