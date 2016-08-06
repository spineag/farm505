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
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import windows.WindowsManager;

public class MarketFriendItem {
    private var _person:Someone;
    public var source:CSprite;
    private var _ava:Image;
    private var _txt:TextField;
    private var _wo:WOMarket;
    public var _visitBtn:CButton;
    private var _shiftFriend:int;

    private var g:Vars = Vars.getInstance();

    public function MarketFriendItem(f:Someone, wo:WOMarket, _shift:int) {
        _shiftFriend = _shift;
        source = new CSprite();
        source.x = 218;
        var bg:Quad = new Quad(100, 102, Color.WHITE);
        bg.x = 4;
        bg.y = .5;
        source.addChild(bg);
        _person = f;
        if (!_person) {
            Cc.error('MarketFriendItem:: person == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketFriendMarket');
            return;
        }
        _wo = wo;
        if (_person is NeighborBot) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (_person.photo) {
                _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                MCScaler.scale(_ava, 98, 98);
                _ava.x = 4;
                _ava.y = 2;
                source.addChild(_ava);
                g.load.loadImage(_person.photo, onLoadPhoto);
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
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _visitBtn = new CButton();
        _visitBtn.addButtonTexture(70, 30, CButton.BLUE, true);
        var txtBtn:TextField = new TextField(80, 25, "Посетить", g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        txtBtn.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txtBtn.x = -5;
        txtBtn.y = 3;
        _visitBtn.addChild(txtBtn);
        _visitBtn.x = 55;
        _visitBtn.y = 3;
        source.addChild(_visitBtn);
        _visitBtn.clickCallback = visitPerson;
        if (_person == g.user) {
            _visitBtn.visible = false;
        }
        _visitBtn.visible = false;
    }

    private function visitPerson():void {
        if (g.managerCutScenes.isCutScene) return;
        g.catPanel.visibleCatPanel(false);
        g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
        g.townArea.goAway(_person);
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

    private function onHover():void {
        source.filter = ManagerFilters.BUILD_STROKE;
    }

    private function onOut():void {
        source.filter = null;
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
        _ava.x = 4;
        _ava.y = 2;
        if (source) source.addChild(_ava);
    }

    private function chooseThis():void {
        if (g.managerTutorial.isTutorial) return;
        if (_wo.curUser == _person) return;
        if (_person == g.user && _person.level < 5) return;
        if (!_wo) return;
        _wo.onChooseFriendOnPanel(_person, _shiftFriend);
    }

    public function deleteIt():void {
        _wo = null;
        _ava = null;
        _txt = null;
        _person = null;
        if (_visitBtn) {
            source.removeChild(_visitBtn);
            _visitBtn.deleteIt();
            _visitBtn = null;
        }
        source.filter = null;
        if (source) source.dispose();
        source = null;
    }
}
}