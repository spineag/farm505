/**
 * Created by user on 8/27/15.
 */
package windows.market {
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;

import social.SocialNetworkEvent;

import starling.display.Image;
import starling.display.Quad;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import user.NeighborBot;
import user.Someone;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.WOButtonTexture;
import windows.WindowsManager;

public class MarketAllFriendItem{
    private var _person:Someone;
    public var source:CSprite;
    private var _ava:Image;
    private var _txtPersonName:CTextField;
    private var _wo:WOMarket;
    private var _planet:CSprite;
    private var _shiftFriend:int;
    private var _visitBtn:WOButtonTexture;

    private var g:Vars = Vars.getInstance();

    public function MarketAllFriendItem(f:Someone, wo:WOMarket, _shift:int) {
        _shiftFriend = _shift;
        _person = f;
        source = new CSprite();
        source.x = 218;
        _person = f;
        var bg:Quad = new Quad(72, 72, Color.WHITE);
        source.addChild(bg);
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 70, 70);
        _ava.x = 1;
        _ava.y = 1;
        source.addChild(_ava);
        _txtPersonName = new CTextField(72, 30, 'loading...');
        _txtPersonName.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtPersonName.y = 45;
        if (_person.name) _txtPersonName.text = _person.name;
        source.addChild(_txtPersonName);
        source.endClickCallback = chooseThis;
        if (!_person) {
            Cc.error('MarketFriendItem:: person == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketFriendsPanelItem');
            return;
        }
        _wo = wo;
        if (_person is NeighborBot) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (_person.photo) {

                g.load.loadImage(_person.photo, onLoadPhoto);
            } else {
                g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                g.socialNetwork.getTempUsersInfoById([_person.userSocialId]);
            }
        }
        if (_person.userSocialId != g.user.userSocialId) {
            _planet = new CSprite();
            _visitBtn = new WOButtonTexture(65, 25, WOButtonTexture.YELLOW);
            var txtBtn:CTextField = new CTextField(65, 25, "Посетить");
            txtBtn.setFormat(CTextField.BOLD18, 12, Color.WHITE);
            _planet.addChild(_visitBtn);
            _planet.addChild(txtBtn);
            _planet.x = 20;
            _planet.y = -10;
            _planet.visible = false;
            source.addChildAt(_planet, 1);
            _planet.endClickCallback = visitPerson;
        }
    }

    private function visitPerson():void {
        g.townArea.goAway(_person);
        g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
    }

    public function get person():Someone {
        return _person;
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        if (!_person.name) _person = g.user.getSomeoneBySocialId(_person.userSocialId);
//        _person.name = ar[0].first_name;
//        _person.lastName = ar[0].last_name;
//        _person.photo = ar[0].photo_100;
        _txtPersonName.text = _person.name;
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
        source.addChild(_ava);
        source.removeChild(_txtPersonName);
        source.addChild(_txtPersonName);
    }

    private function chooseThis():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_wo.curUser == _person) return;
        _wo.onChooseFriendOnPanel(_person, _shiftFriend);
    }

    public function deleteIt():void {
        _person = null;
        _wo = null;
        if (_planet) {
            _planet.removeChild(_visitBtn);
            _visitBtn.deleteIt();
            _visitBtn = null;
            source.removeChild(_visitBtn);
            _planet.deleteIt();
            _planet = null;
        }
        _ava = null;
        _txtPersonName = null;
        source.deleteIt();
    }
}
}
