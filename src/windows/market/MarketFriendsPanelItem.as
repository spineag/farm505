/**
 * Created by user on 8/27/15.
 */
package windows.market {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;
import flash.filters.GlowFilter;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import user.NeighborBot;
import user.Someone;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.CartonBackground;
import windows.WOComponents.WOButtonTexture;

public class MarketFriendsPanelItem{
    private var _person:Someone;
    public var source:CSprite;
    private var _ava:Image;
    private var _txt:TextField;
    private var _panel:WOMarket;
    private var _planet:CSprite;
    private var c:CartonBackground;
    private var _shiftFriend:int;

    private var g:Vars = Vars.getInstance();

    public function MarketFriendsPanelItem(f:Someone, p:WOMarket, _shift:int) {
        _shiftFriend = _shift;
        _person = f;
        source = new CSprite();
        source.x = 218;
        _person = f;
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 70, 70);
        _ava.x = 1;
        _ava.y = 1;
        source.addChildAt(_ava,0);
        _txt = new TextField(100, 30, 'loading...', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txt.x = -15;
        _txt.y = 50;
        if (_person.name) _txt.text = _person.name;
        source.addChildAt(_txt,1);
        source.endClickCallback = chooseThis;
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
            } else {
                g.socialNetwork.getTempUsersInfoById([_person.userSocialId], onGettingUserInfo);
            }
        }


        _planet = new CSprite();
        var btn:WOButtonTexture = new WOButtonTexture(65, 25, WOButtonTexture.YELLOW);
        var txtBtn:TextField = new TextField(80,25, "Посетить", g.allData.fonts['BloggerBold'], 12, Color.WHITE);
        txtBtn.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txtBtn.x = -8;
        _planet.addChild(btn);
        _planet.addChild(txtBtn);
        _planet.x = 20;
        _planet.y = -10;
        _planet.visible = false;
        if (_person.userSocialId == g.user.userSocialId) source.removeChild(_planet);
        else source.addChildAt(_planet,1);

        var filter:ColorMatrixFilter = new ColorMatrixFilter();
        filter.tint(Color.WHITE, 1);
        _planet.hoverCallback = function():void {_planet.filter = filter};
        _planet.outCallback = function():void {_planet.filter = null};
        _planet.endClickCallback = visitPerson;
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
//        photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar'));
    }

    private function photoFromTexture(tex:Texture):void {
        _ava = new Image(tex);
        MCScaler.scale(_ava, 70, 70);
        _ava.x = 1;
        _ava.y = 1;
        source.addChildAt(_ava,1);
        var bg:Quad = new Quad(72, 72, Color.WHITE);
        source.addChildAt(bg,0);
    }

    private function chooseThis():void {
        if (g.woMarket.curUser == _person) return;
        _panel.choosePerson(_person);
        _panel.deleteFriends();
        _panel.shiftFriend = _shiftFriend;
        _panel.createMarketTabBtns();
        g.woMarket.closePanelFriend();
    }

    public function clearIt():void {
        _planet.hoverCallback = null;
        _planet.outCallback = null;
        _planet.endClickCallback = null;
        _planet.touchable = false;
        while (source.numChildren) source.removeChildAt(0);
        source.endClickCallback = null;
        source.touchable = false;
        _person = null;
        _ava = null;
        _txt = null;
        _planet = null;
        source = null;
    }
}
}
