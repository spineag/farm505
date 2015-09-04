/**
 * Created by user on 8/27/15.
 */
package windows.market {
import flash.display.Bitmap;

import manager.Vars;

import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import user.Someone;

import utils.CSprite;
import utils.MCScaler;

public class MarketFriendItem {
    private var _person:Someone;
    public var source:CSprite;
    private var _ava:Image;
    private var _txt:TextField;
    private var _ramka:Image;
    private var _panel:MarketFriendsPanel;

    private var g:Vars = Vars.getInstance();

    public function MarketFriendItem(f:Someone, p:MarketFriendsPanel) {
        _person = f;
        _panel = p;
        source = new CSprite();
        _ramka = new Image(g.interfaceAtlas.getTexture('tamp_ramka'));
        source.addChild(_ramka);
        if (_person.photo) {
            g.load.loadImage(_person.photo, onLoadPhoto);
        } else {
            g.socialNetwork.getTempUsersInfoById([_person.userSocialId], onGettingUserInfo);
        }
        _txt = new TextField(100, 30, 'loading...', "Arial", 16, Color.RED);
        _txt.y = 70;
        if (_person.name) _txt.text = _person.name;
        _ramka.visible = false;
        source.addChild(_txt);
        source.endClickCallback = chooseThis;
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
        var tex:Texture = Texture.fromBitmap(bitmap);
        _ava = new Image(tex);
        MCScaler.scale(_ava, 98, 98);
        _ava.x = 1;
        _ava.y = 1;
        source.addChildAt(_ava, 0);
    }

    public function activateIt(value:Boolean):void {
        _ramka.visible = value;
    }

    private function chooseThis():void {
        if (g.woMarket.curUser == _person) return;

        _panel.choosePerson(_person);
        activateIt(true);
    }

    public function clearIt():void {
        while (source.numChildren) source.removeChildAt(0);
        source.endClickCallback = null;
        source.touchable = false;
        _ramka = null;
        _person = null;
        _ava = null;
        _txt = null;
        source = null;
    }


}
}
