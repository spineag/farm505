/**
 * Created by user on 5/27/16.
 */
package windows.inviteFriends {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class WOInviteFriendsItem {
    public var source:CSprite;
    public var check:Image;
    private var _ava:Image;
    private var _data:Object;
    private var g:Vars = Vars.getInstance();

    public function WOInviteFriendsItem(data:Object) {
        source = new CSprite();
        _data = data;
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 80, 80);
        _ava.x = 4;
        _ava.y = 2;
        source.addChild(_ava);
        g.load.loadImage(data.photo, onLoadPhoto);
        var txt:TextField = new TextField(100,100,data.name + ' ' + data.lastName);
        txt.format.setTo(g.allData.bFonts['BloggerBold14'], 12, Color.BLACK);
        txt.y = 20;
        ManagerFilters.setEmptyStyle(txt);
        source.addChild(txt);
        check = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        source.addChild(check);
        check.visible = false;
        source.endClickCallback = onClick;

    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            bitmap = g.pBitmaps[_data.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('WOInviteFriendsItem:: no photo for userId: ' + _data.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        _ava = new Image(tex);
        MCScaler.scale(_ava, 80, 80);
        _ava.x = 4;
        _ava.y = 2;
        if (source) source.addChildAt(_ava,1);
    }

    private function onClick():void {
        check.visible = !check.visible;
    }

    public function get data():Object {
        return _data;
    }
}
}
