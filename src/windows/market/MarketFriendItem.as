/**
 * Created by user on 8/27/15.
 */
package windows.market {
import flash.display.Bitmap;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
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
    private var _ramka:Quad;
    private var _panel:MarketFriendsPanel;

    private var g:Vars = Vars.getInstance();

    public function MarketFriendItem(f:Someone, p:MarketFriendsPanel) {
        _person = f;
        _panel = p;
        source = new CSprite();
        g.load.loadImage(_person.photo, onLoadPhoto);
        _txt = new TextField(100, 30, _person.name, "Arial", 18, Color.RED);
        _txt.y = 70;
        _ramka = new Quad(100, 100, Color.BLACK);
        source.addChild(_ramka);
        _ramka.visible = false;
        source.addChild(_txt);
        source.endClickCallback = chooseThis;
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


}
}
