/**
 * Created by user on 7/31/15.
 */
package ui.friendPanel {
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;
import preloader.miniPreloader.FlashAnimatedPreloader;
import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import tutorial.TutorialAction;
import user.NeighborBot;
import user.Someone;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class FriendItem {
    private var _person:Someone;
    public var source:CSprite;
    private var _ava:Image;
    private var _txt:CTextField;
    public var txtLvl:CTextField;
    private var _preloader:FlashAnimatedPreloader;
    private var _timer:int;
    private var _positionInList:int;
    private var g:Vars = Vars.getInstance();

    public function FriendItem(f:Someone,pos:int =0) {
        _person = f;
        _positionInList = pos;
        if (!_person) {
            Cc.error('FriendItem:: person == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'friendItem');
            return;
        }
//        g.directServer.getFriendsInfo(int(_person.userSocialId),_person,newLevel);

        source = new CSprite();
        source.nameIt = 'friendPanel';
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 50, 50);
        _ava.x = 5;
        _ava.y = 18;
        source.addChildAt(_ava,0);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("friends_panel_bt_fr"));
        source.addChildAt(im,1);
        _preloader = new FlashAnimatedPreloader();
        _preloader.source.x = 30;
        _preloader.source.y = 40;
//        _preloader.source.scaleX = _preloader.source.scaleY = .7;
        source.addChild(_preloader.source);
        _timer = 5;
        g.gameDispatcher.addToTimer(onTimer);
        if (_person is NeighborBot) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (_person.photo) {
                g.load.loadImage(_person.photo, onLoadPhoto);
            } else {
                g.socialNetwork.getTempUsersInfoById([_person.userSocialId], onGettingUserInfo);
            }
        }
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("star"));
        MCScaler.scale(im,30,30);
        im.x = 35;
        im.y = 41;
        source.addChild(im);

        txtLvl = new CTextField(40, 18, "");
        txtLvl.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.TEXT_BROWN_COLOR);
        txtLvl.text = '1';
        txtLvl.text = String(_person.level);
        txtLvl.x = 29;
        txtLvl.y = 50;
        source.addChild(txtLvl);
        if (txtLvl.text == null || int(txtLvl.text) == 0) txtLvl.text = '1';
        if (_person is NeighborBot) txtLvl.text = '10';
        _txt = new CTextField(64, 30, "");
        _txt.setFormat(CTextField.BOLD14, 14, ManagerFilters.TEXT_BROWN_COLOR);
        _txt.y = -5;
        _txt.x = -1;
        if (_person.name) {
            setName(_person.name);
        } else {
            setName('loading');
        }
        source.addChild(_txt);
        source.endClickCallback = visitPerson;
    }

    private function visitPerson():void {
        g.managerHelpers.onUserAction();
        if (g.visitedUser && g.visitedUser == _person) return;
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction == TutorialAction.VISIT_NEIGHBOR && _person == g.user.neighbor) {
                g.managerTutorial.checkTutorialCallback();
            } else {
                return;
            }
        }
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) return;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (_person == g.user) {
            if (g.isAway) g.townArea.backHome();
            g.catPanel.visibleCatPanel(true);
        } else {
            g.townArea.goAway(_person);
        }
        g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
    }

    public function get person():Someone {
        return _person;
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            bitmap = g.pBitmaps[person.photo].create() as Bitmap;
//            if (_preloader) {
//                source.removeChild(_preloader.source);
//                _preloader.deleteIt();
//                _preloader = null;
//            }
        }
        if (!bitmap) {
            if (_preloader) {
                source.removeChild(_preloader.source);
                _preloader.deleteIt();
                _preloader = null;
                g.gameDispatcher.removeFromTimer(onTimer);
            }
            Cc.error('FriendItem:: no photo for userId: ' + _person.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function onGettingUserInfo(ar:Array):void {
        _person.name = ar[0].first_name;
        _person.lastName = ar[0].last_name;
        _person.photo = ar[0].photo_100;
        setName(_person.name);
        g.load.loadImage(_person.photo, onLoadPhoto);
    }

    private function setName(st:String):void {
        if (st.length > 8) {
            _txt.format.size = 11;
        }
        _txt.text = st;
    }

    private function photoFromTexture(tex:Texture):void {
        if (_preloader) {
            source.removeChild(_preloader.source);
            _preloader.deleteIt();
            _preloader = null;
        }
        if (!tex) return;
        _ava = new Image(tex);
        MCScaler.scale(_ava, 50, 50);
        _ava.x = 5;
        _ava.y = 18;
        if (source) source.addChildAt(_ava,1);
//        source.addChildAt(_ava,1);
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

    public function get position():int {
        return _positionInList;
    }

    private function onTimer():void {
        _timer--;
        if (_timer <= 0) {
            g.gameDispatcher.removeFromTimer(onTimer);
            if (_preloader) {
                source.removeChild(_preloader.source);
                _preloader.deleteIt();
                _preloader = null;
            }
        }
    }

//    public function newLevel():void {
//        txtLvl.text = String(_person.level);
//        txtLvl.x = 36;
//        txtLvl.y = 50;
//        source.addChild(txtLvl);
//        if (txtLvl.text == null || int(txtLvl.text) == 0) txtLvl.text = '1';
//        if (_person is NeighborBot) txtLvl.text = '10';
//    }

    public function getItemProperties():Object {
        var ob:Object = {};
        ob.x = source.x;
        ob.y = source.y;
        var p:Point = new Point(ob.x, ob.y);
        p = source.parent.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = 60; //(_arrItems[_shift + a-1] as ShopItem).source.width;
        ob.height = 70; //(_arrItems[_shift + a-1] as ShopItem).source.height;
        return ob;
    }

    public function deleteIt():void {
        _person = null;
        _ava = null;
        _txt = null;
        txtLvl = null;
        if (_preloader) _preloader = null;
        source.deleteIt();
        source = null;

    }

}
}
