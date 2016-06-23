/**
 * Created by user on 5/9/16.
 */
package windows.paperWindow {
import com.junkbyte.console.Cc;
import data.BuildType;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import starling.utils.HAlign;
import user.Someone;
import utils.CSprite;
import utils.MCScaler;
import windows.WindowsManager;

public class WOPapperBuyerItem {
    public var source:CSprite;

    private var _imageItem:Image;
    private var _txtCountResource:TextField;
    private var _txtCost:TextField;
    private var _data:Object;
    private var _dataResource:Object;
    private var _bg:Sprite;
    private var _plawkaSold:Image;
    private var _ava:Sprite;
    private var _userAvatar:Image;
    private var _txtUserName:TextField;
    private var _txtResourceName:TextField;
    private var _p:Someone;
    private var _wo:WOPapper;
    private var number:int;

    private var g:Vars = Vars.getInstance();

    public function WOPapperBuyerItem(i:int, wo:WOPapper) {
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
        _ava.clipRect = new Rectangle(0, 0, 46, 46);
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

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins_small"));
        MCScaler.scale(im, 25, 25);
        im.x = 143;
        im.y = 60;
        source.addChild(im);

        _txtCost = new TextField(84, 62, "1500", g.allData.fonts['BloggerBold'], 20, ManagerFilters.TEXT_BLUE);
        _txtCost.hAlign = HAlign.RIGHT;
        _txtCost.touchable = false;
        _txtCost.x = 53;
        _txtCost.y = 42;
        source.addChild(_txtCost);

        _txtCountResource = new TextField(84, 62, "10 шт.", g.allData.fonts['BloggerMedium'], 14, ManagerFilters.TEXT_BLUE);
        _txtCountResource.hAlign = HAlign.RIGHT;
        _txtCountResource.touchable = false;
        _txtCountResource.x = 80;
        _txtCountResource.y = 70;
        source.addChild(_txtCountResource);

        _txtResourceName = new TextField(200, 30, "Смаженый кабаньчик", g.allData.fonts['BloggerMedium'], 14, ManagerFilters.TEXT_BLUE);
        _txtResourceName.hAlign = HAlign.RIGHT;
        _txtResourceName.touchable = false;
        _txtResourceName.x = -38;
        _txtResourceName.y = 103;
        source.addChild(_txtResourceName);

        _txtUserName = new TextField(120, 50, "Станислав Йованович", g.allData.fonts['BloggerBold'], 16, ManagerFilters.TEXT_BLUE);
        _txtUserName.hAlign = HAlign.LEFT;
        _txtUserName.touchable = false;
        _txtUserName.x = 56;
        _txtUserName.y = 12;
        source.addChild(_txtUserName);

        source.visible = false;
//        source.endClickCallback = onClickVisit;
    }

//    public function updateAvatar():void {
//        if (!_data) return;
//        _txtUserName.text = _p.name + ' ' + _p.lastName;
//        g.load.loadImage(_p.photo, onLoadPhoto);
//    }

    public function fillIt(ob:Object):void {
        _data = ob;
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
//        if (_p.photo) {
//            _txtUserName.text = _p.name + ' ' + _p.lastName;
//            g.load.loadImage(_p.photo, onLoadPhoto);
//        } else {
//            _txtUserName.text = ob.userSocialId;
//        }
    }


    public function deleteIt():void {
        _wo = null;
        _data = null;
        _dataResource = null;
        _imageItem = null;
        _txtCountResource = null;
        _txtCost = null;
        _bg = null;
        _plawkaSold = null;
        _ava = null;
        _userAvatar = null;
        _txtUserName = null;
        _txtResourceName = null;
        _p = null;
        source.dispose();
        source = null;
    }

}
}
