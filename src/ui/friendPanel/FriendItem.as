/**
 * Created by user on 7/31/15.
 */
package ui.friendPanel {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import user.NeighborBot;

import user.Someone;

import utils.CSprite;
import utils.MCScaler;

import windows.market.MarketFriendsPanel;

public class FriendItem {
    private var _person:Someone;
    public var source:CSprite;
    private var _ava:Image;
    private var _txt:TextField;
    private var _ramka:Image;
    private var _planet:CSprite;
    private var _imageLvl:Image;
    private var _txtLvl:TextField;

    private var g:Vars = Vars.getInstance();

    public function FriendItem(f:Someone) {
        _person = f;
        if (!_person) {
            Cc.error('FriendItem:: person == null');
            g.woGameError.showIt();
            return;
        }
        source = new CSprite();
        _ramka = new Image(g.interfaceAtlas.getTexture("friend_frame"));
        _ramka.x = 120;
        _ramka.y = 10;
        source.addChild(_ramka);

        _imageLvl = new Image(g.interfaceAtlas.getTexture("star"));
        _imageLvl.y = 70;
        MCScaler.scale(_imageLvl,25,25);
        source.addChild(_imageLvl);

        _txtLvl = new TextField(100, 30, '', "Arial", 16, Color.BLACK);
        _txtLvl.text = String(Math.round(Math.random()*20));
        _txtLvl.y = 65;
        _txtLvl.x = -45;
        source.addChild(_txtLvl);
        if (_person is NeighborBot) {
            photoFromTexture(g.interfaceAtlas.getTexture('neighbor'));
        } else {
            if (_person.photo) {
                g.load.loadImage(_person.photo, onLoadPhoto);
            } else {
                g.socialNetwork.getTempUsersInfoById([_person.userSocialId], onGettingUserInfo);
            }
        }
        _txt = new TextField(100, 30, 'loading...', "Arial", 16, Color.RED);
        _txt.y = 70;
        if (_person.name) _txt.text = _person.name;
        _ramka.visible = false;
        source.addChild(_txt);

        _planet = new CSprite();
        var im:Image = new Image(g.interfaceAtlas.getTexture('planet'));
        im.x = -im.width/2;
        im.y = -im.height/2;
        _planet.addChild(im);
        _planet.x = 85;
        _planet.y = 15;
        if (_person.userSocialId == g.user.userSocialId) source.removeChild(_planet);
        else source.addChild(_planet);

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

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            bitmap = g.pBitmaps[person.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('FriendItem:: no photo for userId: ' + _person.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function onGettingUserInfo(ar:Array):void {
        _person.name = ar[0].first_name;
        _person.lastName = ar[0].last_name;
        _person.photo = ar[0].photo_100;
        _txt.text = _person.name;
        g.load.loadImage(_person.photo, onLoadPhoto);
    }

    private function photoFromTexture(tex:Texture):void {
        _ava = new Image(tex);
        MCScaler.scale(_ava, 98, 98);
        _ava.x = 1;
        _ava.y = 1;
        source.addChildAt(_ava, 0);
    }


    public function clearIt():void {
        _planet.hoverCallback = null;
        _planet.outCallback = null;
        _planet.endClickCallback = null;
        _planet.touchable = false;
        while (source.numChildren) source.removeChildAt(0);
        source.endClickCallback = null;
        source.touchable = false;
        _ramka = null;
        _person = null;
        _ava = null;
        _imageLvl = null;
        _txt = null;
        _planet = null;
        source = null;
    }
}
}
