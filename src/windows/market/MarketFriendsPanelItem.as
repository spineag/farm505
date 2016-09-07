/**
 * Created by user on 8/27/15.
 */
package windows.market {
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;
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

public class MarketFriendsPanelItem{
    private var _person:Someone;
    public var source:CSprite;
    private var _ava:Image;
    private var _txtPersonName:CTextField;
    private var _wo:WOMarket;
    private var _planet:CSprite;
    private var _shiftFriend:int;
    private var _planetBtn:WOButtonTexture;

    private var g:Vars = Vars.getInstance();

    public function MarketFriendsPanelItem(f:Someone, wo:WOMarket, _shift:int) {
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
        _txtPersonName = new CTextField(100, 30, 'loading...');
        _txtPersonName.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtPersonName.x = -15;
        _txtPersonName.y = 50;
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
                g.socialNetwork.getTempUsersInfoById([_person.userSocialId], onGettingUserInfo);
            }
        }
        if (_person.userSocialId != g.user.userSocialId) {
            _planet = new CSprite();
            _planetBtn = new WOButtonTexture(65, 25, WOButtonTexture.YELLOW);
            var txtBtn:CTextField = new CTextField(80, 25, "Посетить");
            txtBtn.setFormat(CTextField.BOLD14, 12, Color.WHITE, ManagerFilters.BROWN_COLOR);
            txtBtn.x = -8;
            _planet.addChild(_planetBtn);
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

    private function onGettingUserInfo(ar:Array):void {
        _person.name = ar[0].first_name;
        _person.lastName = ar[0].last_name;
        _person.photo = ar[0].photo_100;
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
            _planet.removeChild(_planetBtn);
            _planetBtn.deleteIt();
            _planetBtn = null;
            source.removeChild(_planetBtn);
            _planet.deleteIt();
            _planet = null;
        }
        _ava = null;
        _txtPersonName = null;
        source.deleteIt();
    }
}
}
