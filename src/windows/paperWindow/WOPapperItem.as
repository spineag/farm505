/**
 * Created by user on 7/24/15.
 */
package windows.paperWindow {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.display.Bitmap;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import preloader.miniPreloader.FlashAnimatedPreloader;
import resourceItem.DropItem;
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
    public var isBotBuy:Boolean;
    private var _imageItem:Image;
    private var _imBuy:Image;
    private var _txtCountResource:CTextField;
    private var _txtCost:CTextField;
    private var _data:Object;
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
    private var _btnBuyBot:CButton;
    private var _btnDelete:CButton;
    private var _preloader:FlashAnimatedPreloader;

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
        _txtCountResource.setFormat(CTextField.MEDIUM14, 14, ManagerFilters.BLUE_COLOR);
        _txtCountResource.alignH = Align.RIGHT;
        _txtCountResource.leading = 10;
        _txtCountResource.x = 80;
        _txtCountResource.y = 70;
        source.addChild(_txtCountResource);

        _txtResourceName = new CTextField(100, 30, "");
        _txtResourceName.setFormat(CTextField.MEDIUM14, 14, ManagerFilters.BLUE_COLOR);
        _txtResourceName.alignH= Align.RIGHT;
        _txtResourceName.x = 70;
        _txtResourceName.y = 98;
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
        if (!_data) return;
        _txtUserName.text = _p.name + ' ' + _p.lastName;
        g.load.loadImage(_p.photo, onLoadPhoto);
    }

    public function fillIt(ob:Object):void {
        _data = ob;
        isBotBuy = false;
        if (!_data) {
            Cc.error('WOPapperItem fillIt:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woPapperItem');
            return;
        }
        source.visible = true;
        _txtCost.text = String(_data.cost);
        _txtCountResource.text = String(_data.resourceCount) + ' шт.';
        _dataResource = g.dataResource.objectResources[_data.resourceId];
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
//            _txtUserName.text = _p.name + ' ' + _p.lastName;
            var arr:Array = new Array();
            arr.push('Александр Лугинин');
            arr.push('Вадим Бойцов');
            arr.push('Вадим Чебаненко');
            arr.push('Мария Головина');

            _txtUserName.text =   String(arr[int(Math.random()*arr.length)]);
        }
        source.endClickCallback = onClickVisit;
        if (_data.isOpened) {
            source.alpha = .5;
        }
        _btnBuyBot = new CButton();
        _btnBuyBot.addButtonTexture(70, 24, CButton.GREEN, true);
        var txt:CTextField = new CTextField(60, 30, 'купить');
        txt.setFormat(CTextField.BOLD14, 14, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.x = 4;
        txt.y = -4;
        _btnBuyBot.addChild(txt);
        source.addChild(_btnBuyBot);
        _btnBuyBot.x = 35;
        _btnBuyBot.y = 120;
        _btnBuyBot.clickCallback = onClickVisit;
    }

    public function fillItBot(ob:Object):void {
        _data = ob;
        isBotBuy = true;
        source.endClickCallback = null;
        if (!_data) {
            Cc.error('WOPapperItem fillItBot:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woPapperItem');
            return;
        }
        source.visible = true;
        _txtCost.text = 'за ' + String(_data.cost);
        _txtCost.y = 55;
        _imageCoins.y = 75;
        _txtCountResource.text = String(_data.resourceCount) + ' шт.';
        _txtCountResource.x = 30;
        _txtCountResource.y = 42;
        _dataResource = g.dataResource.objectResources[_data.resourceId];
        _txtResourceName.text = _dataResource.name;

        _txtResourceName.alignH = Align.LEFT;
        _txtResourceName.x = 8;
        _txtResourceName.y = 45;
        _txtUserName.text = '';
        if (_dataResource.buildType == BuildType.PLANT)
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(_dataResource.imageShop + '_icon'));
        else
            _imageItem = new Image(g.allData.atlas[_dataResource.url].getTexture(_dataResource.imageShop));
        if (!_imageItem) {
            Cc.error('WOPapperItem fillItBot:: no such image: ' + _dataResource.imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woPapperItem');
            return;
        }
        MCScaler.scale(_imageItem,50,50);
        _imageItem.x = 30 - _imageItem.width/2;
        _imageItem.y = 100 - +_imageItem.height/2;
        source.addChild(_imageItem);
        if (_data.buyerId == 1) {
            _userAvatar = new Image(g.allData.atlas['interfaceAtlas'].getTexture('avatar_2'));
            MCScaler.scaleMin(_userAvatar, 46, 46);
            while (_ava.numChildren) {
                _ava.removeChildAt(0);
            }
            _ava.addChild(_userAvatar);
        } else {
            while (_ava.numChildren) {
                _ava.removeChildAt(0);
            }
            _userAvatar = new Image(g.allData.atlas['interfaceAtlas'].getTexture('avatar_3'));
            MCScaler.scaleMin(_userAvatar, 46, 46);
            _ava.addChild(_userAvatar);
        }
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_3'));
        MCScaler.scale(im,80,115);
        im.x = 50;
        im.y = 5;
        source.addChild(im);
        var txt:CTextField = new CTextField(60,30,'я куплю');
        txt.setFormat(CTextField.BOLD14, 14, ManagerFilters.BLUE_COLOR);
        txt.x = 80;
        txt.y = 10;
        source.addChild(txt);
        _btnBuyBot = new CButton();
        _btnBuyBot.addButtonTexture(70, 30, CButton.GREEN, true);
        txt = new CTextField(60, 30, 'продать');
        txt.setFormat(CTextField.BOLD18, 15, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.x = 4;
        txt.autoScale = true;
        _btnBuyBot.addChild(txt);
        source.addChild(_btnBuyBot);
        _btnBuyBot.x = 95;
        _btnBuyBot.y = 115;
        _btnBuyBot.clickCallback = onClickBuyBot;
        _btnDelete = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_decline'));
        _btnDelete.addDisplayObject(im);
        _btnDelete.x = 130;
        _btnDelete.y = 97;
        _btnDelete.clickCallback = onClickDelete;
        _btnDelete.hoverCallback = function ():void { g.hint.showIt('отменить заказ'); };
        _btnDelete.outCallback = function ():void { g.hint.hideIt();  };
        source.addChild(_btnDelete);

        _txtSale =  new CTextField(120,30,'продано');
        _txtSale.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR);
        _txtSale.x = 48;
        _txtSale.y = 95;
        _txtSale.visible = false;
        source.addChild(_txtSale);
        if (!_data.visible) {
            _btnBuyBot.visible = false;
            _btnDelete.visible = false;
            source.alpha = .5;
            _txtSale.visible = true;
        }
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('visitor_back'));
        source.addChildAt(im,1);

    }

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
        g.windowsManager.cashWindow = _wo;
        _wo.hideIt();
        _p.idVisitItemFromPaper = _data.resourceId;
        _p.level = _data.level;
        g.windowsManager.openWindow(WindowsManager.WO_MARKET, null, _p);
        _data.isOpened = true;

    }

    private function onClickBuyBot(noResource:Boolean = false):void {
        if (!_data.visible == .5) return;
        var ob:Object = {};
        if (g.userInventory.getCountResourceById(_data.resourceId) < _data.resourceCount) {
            g.windowsManager.cashWindow = _wo;
            ob.data = g.dataResource.objectResources[_data.resourceId];
            ob.count = _data.resourceCount - g.userInventory.getCountResourceById(_data.resourceId);
            _wo.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClickBuyBot, 'papper', ob);
            return;
        }
        if (!noResource && _data.type == BuildType.PLANT && g.userInventory.getCountResourceById(_data.resourceId) == _data.resourceCount &&  !g.userInventory.checkLastResource(_data.resourceId)) {
            g.windowsManager.cashWindow = _wo;
            _wo.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, onClickBuyBot, {id:_data.resourceId}, 'market');
            return;
        }
        var p:Point = new Point(_ava.x, _ava.y);
        p = _ava.localToGlobal(p);
        ob.id = DataMoney.SOFT_CURRENCY;
        ob.count = _data.cost;
        new DropItem(p.x,p.y,ob);
        _data.visible = false;
        new XPStar(p.x,p.y, 5);
        g.userInventory.addResource(_data.resourceId,-_data.resourceCount);
        g.directServer.updateUserPapperBuy(_data.buyerId,0,0,0,0,0,0);
        _btnBuyBot.clickCallback = null;
        source.alpha = .5;
        _btnBuyBot.visible = false;
        _btnDelete.visible = false;
        _txtSale.visible = true;
    }

    private function onClickDelete():void {
        if (!_data.visible == .5) return;
        _data.timeToNext = int(new Date().getTime()/1000);
        g.directServer.updateUserPapperBuy(_data.buyerId,0,0,0,0,0,0);
        source.alpha = .5;
        g.hint.hideIt();
        _data.visible = false;
        _btnBuyBot.visible = false;
        _btnDelete.visible = false;
    }

    public function preloader():void {
        source.removeChild(_imageItem);
        source.removeChild(_txtCost);
        source.removeChild(_txtUserName);
        source.removeChild(_txtResourceName);
        source.removeChild(_imageCoins);
        source.removeChild(_txtSale);
        source.removeChild(_btnBuyBot);
        source.removeChild(_txtCountResource);
        _btnBuyBot = null;
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
        _txtCountResource = null;
        _txtCost = null;
        _imageCoins = null;
        _bg = null;
        _plawkaSold = null;
        _ava = null;
        _userAvatar = null;
        _txtUserName = null;
        _txtResourceName = null;
        _txtSale = null;
        _p = null;
        source.dispose();
        source = null;
        if (_preloader) {
            _preloader = null;
            source.removeChild(_preloader.source);
        }
    }

}
}
