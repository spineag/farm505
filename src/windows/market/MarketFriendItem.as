/**
 * Created by user on 8/27/15.
 */
package windows.market {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;
import manager.Vars;

import starling.display.Image;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import user.NeighborBot;
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
    private var _planet:CSprite;

    private var g:Vars = Vars.getInstance();

    public function MarketFriendItem(f:Someone, p:MarketFriendsPanel) {
        _person = f;
        if (!_person) {
            Cc.error('MarketFriendItem:: person == null');
            g.woGameError.showIt();
            return;
        }
        _panel = p;
        source = new CSprite();
        _ramka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tamp_ramka'));
        source.addChild(_ramka);
        if (_person is NeighborBot) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
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
        source.endClickCallback = chooseThis;

        _planet = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('planet'));
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
        _txt = null;
        _planet = null;
        source = null;
    }


}
}
