/**
 * Created by user on 8/27/15.
 */
package windows.market {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import user.NeighborBot;
import user.Someone;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.CartonBackground;

public class MarketFriendItem {
    private var _person:Someone;
    public var source:CSprite;
    public var cloneSource:CSprite;
    private var cont:Sprite;
    private var _ava:Image;
    private var _txt:TextField;
    private var _panel:WOMarket;
    public var _planet:CButton;
    private var c:CartonBackground;
    private var _shiftFriend:int;

    private var g:Vars = Vars.getInstance();

    public function MarketFriendItem(f:Someone, p:WOMarket, _shift:int) {
        _shiftFriend = _shift;
        source = new CSprite();
        cloneSource = new CSprite();
        source.x = 218;
        cont = new Sprite();
         c = new CartonBackground(115, 115);
        c.x = -5;
        c.y = -5;
        source.addChildAt(c,0);
        _person = f;
        if (!_person) {
            Cc.error('MarketFriendItem:: person == null');
            g.woGameError.showIt();
            return;
        }
        _panel = p;
        if (_person is NeighborBot) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (_person.photo) {
                g.load.loadImage(_person.photo, onLoadPhoto);
                _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                _ava.filter = ManagerFilters.WHITE_STROKE;
                MCScaler.scale(_ava, 98, 98);
                _ava.x = 1;
                _ava.y = 1;
                source.addChildAt(_ava,1);
            } else {
                g.socialNetwork.getTempUsersInfoById([_person.userSocialId], onGettingUserInfo);
            }
        }
        _txt = new TextField(100, 30, 'loading...', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txt.y = 70;
        if (_person.name) _txt.text = _person.name;
        source.addChild(_txt);
        source.endClickCallback = chooseThis;

        if (_person == g.user) {
            _planet = new CButton();
            _planet.addButtonTexture(66, 26, CButton.YELLOW, true);
            var txtBtn:TextField = new TextField(80, 25, "Посетить", g.allData.fonts['BloggerBold'], 12, Color.WHITE);
            txtBtn.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
            txtBtn.x = -8;
            _planet.addChild(txtBtn);
            _planet.x = 55;
            _planet.y = 3;
            _planet.visible = false;
            source.addChild(_planet);
            _planet.clickCallback = visitPerson;
        }
    }

    private function visitPerson():void {
        g.townArea.goAway(_person);
        g.woMarket.hideIt();
    }

    public function get person():Someone {
        return _person;
    }

    private function onGettingUserInfo(ar:Array):void {
        _person.name = ar[0].first_name;
        _person.lastName = ar[0].last_name;
        _person.photo = ar[0].photo_100;
        _txt.text = _person.name;
        g.load.loadImage(_person.photo, onLoadPhoto);
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            bitmap = g.pBitmaps[person.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('MarketFriendItem:: no photo for userId: ' + _person.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        _ava = new Image(tex);
        _ava.filter = ManagerFilters.WHITE_STROKE;
        MCScaler.scale(_ava, 98, 98);
        _ava.x = 1;
        _ava.y = 1;
        source.addChildAt(_ava,1);
    }

    private function chooseThis():void {
        if (g.woMarket.curUser == _person) return;
        _panel.choosePerson(_person);
        _panel.deleteFriends();
        _panel.shiftFriend = _shiftFriend;
        _panel.createMarketTabBtns();
    }

    public function clearIt():void {
        if (_planet) {
            _planet.clickCallback = null;
            _planet.touchable = false;
            _planet = null;
        }
        while (source.numChildren) source.removeChildAt(0);
        source.endClickCallback = null;
        source.touchable = false;
        _person = null;
        _ava = null;
        _txt = null;
        source = null;
    }
}
}