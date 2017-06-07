/**
 * Created by user on 7/24/15.
 */
package windows.paperWindow {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import data.StructureMarketItem;
import flash.display.Bitmap;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import preloader.miniPreloader.FlashAnimatedPreloader;
import resourceItem.DropItem;

import social.SocialNetwork;
import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import ui.xpPanel.XPStar;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class WOPapperItem {
    public var source:CSprite;
    private var _imageItem:Image;
    private var _txtCountResource:CTextField;
    private var _txtCost:CTextField;
    private var _data:StructureMarketItem;
    private var _dataResource:Object;
    private var _bg:Sprite;
    private var _plawkaSold:Image;
    private var _imageCoins:Image;
    private var _ava:Sprite;
    private var _userAvatar:Image;
    private var _txtUserName:CTextField;
    private var _txtResourceName:CTextField;
    private var _txtSale:CTextField;
    private var _p:Someone;
    private var _wo:WOPapper;
    private var number:int;
    private var _preloader:FlashAnimatedPreloader;
    private var _helpIcon:Image;
    private var _btnBuy:CButton;

    private var g:Vars = Vars.getInstance();

    public function WOPapperItem(i:int, wo:WOPapper) {
        number = i;
        _wo = wo;
        source = new CSprite();
        _bg = new Sprite();
        source.addChild(_bg);
        var q:Quad = new Quad(172, 134, Color.WHITE);
        _bg.addChild(q);
        q = new Quad(172, 1, 0xffeac1);
        _bg.addChild(q);
        q = new Quad(172, 1, 0xffeac1);
        q.y = 134;
        _bg.addChild(q);
        q = new Quad(1, 134, 0xffeac1);
        _bg.addChild(q);
        q = new Quad(1, 134, 0xffeac1);
        q.x = 172;
        _bg.addChild(q);

        if (i%2) q = new Quad(160, 50, 0x8eb8b9);
            else q = new Quad(160, 50, 0x36bf1c);
        q.x = 7;
        q.y = 5;
        _bg.addChild(q);

        _ava = new Sprite();
        _ava.x = 9;
        _ava.y = 7;
        _ava.mask = new Quad(46, 46);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("birka_c"));
        im.x = -5;
        _ava.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("birka_c"));
        im.scaleY = -1;
        im.x = -5;
        im.y = 50;
        _ava.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("birka_cat"));
        MCScaler.scale(im, 38, 38);
        im.rotation = Math.PI/2;
        im.x = 40;
        im.y = 6;
        _ava.addChild(im);
        source.addChild(_ava);

        _imageCoins = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins_small"));
        MCScaler.scale(_imageCoins, 25, 25);
        _imageCoins.x = 143;
        _imageCoins.y = 60;
        source.addChild(_imageCoins);

        _txtCost = new CTextField(84, 62, "");
        _txtCost.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR);
        _txtCost.alignH = Align.RIGHT;
        _txtCost.x = 53;
        _txtCost.y = 42;
        source.addChild(_txtCost);

        _txtCountResource = new CTextField(84, 62, "");
        _txtCountResource.setFormat(CTextField.MEDIUM18, 14, ManagerFilters.BLUE_COLOR);
        _txtCountResource.alignH = Align.RIGHT;
        _txtCountResource.leading = 10;
        _txtCountResource.x = 80;
        _txtCountResource.y = 65;
        source.addChild(_txtCountResource);

        _txtResourceName = new CTextField(100, 30, "");
        _txtResourceName.setFormat(CTextField.MEDIUM18, 14, ManagerFilters.BLUE_COLOR);
        _txtResourceName.alignH= Align.RIGHT;
        _txtResourceName.x = 68;
        _txtResourceName.y = 100;
        source.addChild(_txtResourceName);

        _txtUserName = new CTextField(110, 50, "");
        _txtUserName.setFormat(CTextField.BOLD18, 16, ManagerFilters.BLUE_COLOR);
        _txtUserName.alignH = Align.LEFT;
        _txtUserName.touchable = false;
        _txtUserName.x = 58;
        _txtUserName.y = 8;
        source.addChild(_txtUserName);
        source.visible = false;
    }

    public function updateAvatar():void {
        if (!_data) {
            Cc.error('WOPapperItem updateAvatar:: _data = null');
            return;
        }
        Cc.info('WOPapperItem update avatar');
        if (!_p.photo) _p = g.user.getSomeoneBySocialId(_p.userSocialId);
        _txtUserName.text = _p.name + ' ' + _p.lastName;
        if (_p.photo =='' || _p.photo == 'unknown') _p.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_p.photo, onLoadPhoto);
    }

    public function fillIt(ob:StructureMarketItem):void {
        _data = ob;
        if (!_data) {
            Cc.error('WOPapperItem fillIt:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woPapperItem');
            return;
        }
        source.visible = true;
        _txtCost.text = String(_data.cost);
        _txtCountResource.text = String(_data.resourceCount) + ' ' + String(g.managerLanguage.allTexts[360]);
        _dataResource = g.allData.getResourceById(_data.resourceId);
        _txtResourceName.text = _dataResource.name;
        if (_dataResource.buildType == BuildType.PLANT)
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(_dataResource.imageShop + '_icon'));
        else
            _imageItem = new Image(g.allData.atlas[_dataResource.url].getTexture(_dataResource.imageShop));
        if (!_imageItem) {
            Cc.error('WOPapperItem fillIt:: no such image: ' + _dataResource.imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woPapperItem');
            return;
        }
        MCScaler.scale(_imageItem,50,50);
        _imageItem.x = 39 - _imageItem.width/2;
        _imageItem.y = 83 - +_imageItem.height/2;
        source.addChild(_imageItem);
        if (_data.isBuyed) {
            _plawkaSold = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka_sold'));
            _plawkaSold.x = _bg.width/2 - _plawkaSold.width/2;
            source.addChild(_plawkaSold);
        }
        _p = g.user.getSomeoneBySocialId(ob.userSocialId);
        if (_p.photo) {
            _txtUserName.text = _p.name + ' ' + _p.lastName;
            g.load.loadImage(_p.photo, onLoadPhoto);
        } else {
//            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
//            g.socialNetwork.getTempUsersInfoById([_p.userSocialId]);
//            _txtUserName.text = '. . .';
            var arr:Array = new Array();
            arr.push(String(g.managerLanguage.allTexts[628]));
            arr.push(String(g.managerLanguage.allTexts[629]));
            arr.push(String(g.managerLanguage.allTexts[630]));
            arr.push(String(g.managerLanguage.allTexts[631]));
            arr.push(String(g.managerLanguage.allTexts[632]));
            arr.push(String(g.managerLanguage.allTexts[633]));
            arr.push(String(g.managerLanguage.allTexts[634]));
            arr.push(String(g.managerLanguage.allTexts[635]));
            arr.push(String(g.managerLanguage.allTexts[636]));
            arr.push(String(g.managerLanguage.allTexts[637]));
            arr.push(String(g.managerLanguage.allTexts[638]));
            arr.push(String(g.managerLanguage.allTexts[639]));
            arr.push(String(g.managerLanguage.allTexts[640]));
            arr.push(String(g.managerLanguage.allTexts[641]));
            arr.push(String(g.managerLanguage.allTexts[642]));
            arr.push(String(g.managerLanguage.allTexts[643]));
            arr.push(String(g.managerLanguage.allTexts[644]));
            arr.push(String(g.managerLanguage.allTexts[645]));
            arr.push(String(g.managerLanguage.allTexts[646]));
            arr.push(String(g.managerLanguage.allTexts[647]));
            arr.push(String(g.managerLanguage.allTexts[648]));
            arr.push(String(g.managerLanguage.allTexts[649]));
            arr.push(String(g.managerLanguage.allTexts[650]));
            arr.push(String(g.managerLanguage.allTexts[651]));
            arr.push(String(g.managerLanguage.allTexts[652]));
            arr.push(String(g.managerLanguage.allTexts[653]));
            arr.push(String(g.managerLanguage.allTexts[654]));
            arr.push(String(g.managerLanguage.allTexts[655]));
            arr.push(String(g.managerLanguage.allTexts[656]));
            arr.push(String(g.managerLanguage.allTexts[657]));

            _txtUserName.text = String(arr[int(Math.random()*arr.length-1)]);
        }
        if (_data.needHelp > 0) {
            _helpIcon = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
            MCScaler.scale(_helpIcon, 20, 20);
            _helpIcon.x = 150;
            _helpIcon.y = 2;
            source.addChild(_helpIcon);
        }
        source.endClickCallback = onClickVisit;
        if (_data.isOpened) {
            source.alpha = .5;
        }
        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(70, 24, CButton.GREEN, true);
        var txt:CTextField = new CTextField(60, 30, String(g.managerLanguage.allTexts[355]));
        txt.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.x = 4;
        txt.y = -4;
        _btnBuy.addChild(txt);
        source.addChild(_btnBuy);
        _btnBuy.x = 35;
        _btnBuy.y = 120;
        _btnBuy.clickCallback = onClickVisit;
    }

//    private function onGettingUserInfo(e:SocialNetworkSwitch):void {
//        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
//        if (!_p.name) _p = g.user.getSomeoneBySocialId(_p.userSocialId);
//        _txtUserName.text = _p.name + ' ' + _p.lastName;
//        g.load.loadImage(_p.photo, onLoadPhoto);
//    }


    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!_ava) return;
        if (!bitmap) {
            bitmap = g.pBitmaps[_p.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('WOPapperItem:: no photo for userId: ' + _p.userSocialId);
            return;
        }
        _userAvatar = new Image(Texture.fromBitmap(bitmap));
        MCScaler.scaleMin(_userAvatar, 46, 46);
        while (_ava.numChildren) {
            _ava.removeChildAt(0);
        }
        _ava.addChild(_userAvatar);
    }

    private function onClickVisit():void {
        if (!_data) return;
        _data.isOpened = true;
        source.alpha = .5;
        g.windowsManager.cashWindow = _wo;
        _wo.hideIt();
        _p.idVisitItemFromPaper = _data.resourceId;
        _p.level = _data.level;
        _p.userId = _data.userId;
        g.windowsManager.openWindow(WindowsManager.WO_MARKET, null, _p);

    }

    public function preloader():void {
        source.removeChild(_imageItem);
        source.removeChild(_txtCost);
        source.removeChild(_txtUserName);
        source.removeChild(_txtResourceName);
        source.removeChild(_imageCoins);
        source.removeChild(_txtSale);
        source.removeChild(_txtCountResource);
        source.removeChild(_btnBuy);
        _txtSale = null;
        _imageCoins = null;
        _imageItem = null;
        _txtUserName = null;
        _txtCost = null;
        _txtCountResource = null;
        _txtResourceName = null;
        _preloader = new FlashAnimatedPreloader();
        _preloader.source.x = _bg.width/2;
        _preloader.source.y = _bg.height/2;
        source.addChild(_preloader.source);
    }

    public function deletePreloader():void {
        if (!_preloader) return;
        source.removeChild(_preloader.source);
        _preloader = null;
    }

    public function deleteIt():void {
        _wo = null;
        _data = null;
        _dataResource = null;
        _imageItem = null;
        if (_txtCountResource) {
            source.removeChild(_txtCountResource);
            _txtCountResource.deleteIt();
            _txtCountResource = null;
        }
        if (_txtCost) {
            source.removeChild(_txtCost);
            _txtCost.deleteIt();
            _txtCost = null;
        }
        if (_txtUserName) {
            source.removeChild(_txtUserName);
            _txtUserName.deleteIt();
            _txtUserName = null;
        }
        if (_txtResourceName) {
            source.removeChild(_txtResourceName);
            _txtResourceName.deleteIt();
            _txtResourceName = null;
        }
        if (_txtSale) {
            source.removeChild(_txtSale);
            _txtSale.deleteIt();
            _txtSale = null;
        }
        if (_btnBuy) {
            source.removeChild(_btnBuy);
            _btnBuy.deleteIt();
            _btnBuy = null;
        }
        _imageCoins = null;
        _bg = null;
        _plawkaSold = null;
        _ava = null;
        _userAvatar = null;
        _p = null;
//        source.dispose();
        source = null;
        if (_preloader) {
            _preloader = null;
            if (source) source.removeChild(_preloader.source);
        }
    }

}
}
