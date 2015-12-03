/**
 * Created by user on 7/31/15.
 */
package ui.friendPanel {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.ManagerFilters;


import manager.Vars;

import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import user.NeighborBot;
import user.Someone;
import utils.CSprite;
import utils.MCScaler;

public class FriendItem {
    private var _person:Someone;
    public var source:CSprite;
    private var _ava:Image;
    private var _txt:TextField;
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
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("friends_panel_bt_fr"));
        source.addChild(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("star"));
        MCScaler.scale(im,30,30);
        im.x = 35;
        im.y = 41;
        source.addChild(im);

        _txtLvl = new TextField(27, 15, "55", g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtLvl.text = String(g.user.level);
        _txtLvl.x = 37;
        _txtLvl.y = 50;
        source.addChild(_txtLvl);

        if (_person is NeighborBot) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (_person.photo) {
                g.load.loadImage(_person.photo, onLoadPhoto);
            } else {
                g.socialNetwork.getTempUsersInfoById([_person.userSocialId], onGettingUserInfo);
            }
        }
        _txt = new TextField(63, 30, "loading..", g.allData.fonts['BloggerBold'], 14, ManagerFilters.TEXT_BROWN);
        _txt.y = -5;
        if (_person.name) _txt.text = _person.name;
        source.addChild(_txt);

        source.endClickCallback = visitPerson;
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
        MCScaler.scale(_ava, 50, 50);
        _ava.x = 5;
        _ava.y = 18;
        source.addChildAt(_ava, 0);
    }


    public function clearIt():void {
        while (source.numChildren) source.removeChildAt(0);
        source.endClickCallback = null;
        source.touchable = false;
        _person = null;
        _ava.dispose();
        _ava = null;
        _txt = null;
        source = null;
    }
}
}
