/**
 * Created by user on 10/1/15.
 */
package windows.lockedLand {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.filters.GlowFilter;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;
import windows.WOComponents.WOButtonTexture;
import windows.WindowsManager;

public class LockedLandItem {
    public var source:Sprite;
    private var _isGood:Boolean;
    private var g:Vars = Vars.getInstance();
    private var _id:int;
    private var _count:int;
    private var _iconCoins:Image;
    private var _galo4ka:Image;
    private var _bg:CartonBackgroundIn;
    private var _btn:CButton;

    public function LockedLandItem() {
        source = new Sprite();
        _bg = new CartonBackgroundIn(428, 88);
        source.addChild(_bg);
    }

    public function fillWithCurrency(count:int):void {
        _iconCoins = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        MCScaler.scale(_iconCoins, 50, 50);
        _iconCoins.x = 20;
        _iconCoins.y = 12;
        _iconCoins.filter = ManagerFilters.SHADOW_LIGHT;
        source.addChild(_iconCoins);
        var txt:TextField = new TextField(150,40,String(count),g.allData.fonts['BloggerBold'],16,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 55;
        txt.x = -30;
        source.addChild(txt);
        txt = new TextField(200,90,'Накопи состояние - '+ String(count)+ ' монет (спишутся после открытия)',g.allData.fonts['BloggerBold'],16,ManagerFilters.TEXT_BROWN_COLOR);
        txt.x = 90;
        txt.y = -2;
        source.addChild(txt);

        if (g.user.softCurrencyCount >= count) {
            _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            _galo4ka.x = 351;
            _galo4ka.y = 31;
            _galo4ka.filter = ManagerFilters.SHADOW_TINY;
            source.addChild(_galo4ka);
            _isGood = true;
        } else {
            _btn= new CButton();
            _btn.addButtonTexture(120, 30, CButton.GREEN, true);
            txt = new TextField(120,30,'Купить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
            _btn.addChild(txt);
            _btn.x = 362;
            _btn.y = 50;
            source.addChild(_btn);
            var f1:Function = function ():void {
                g.windowsManager.hideWindow(WindowsManager.WO_LOCKED_LAND);
                g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, false);
            };
            _btn.clickCallback = f1;
            _isGood = false;
        }
    }

    public function fillWithResource(id:int, count:int):void {
        if (!g.dataResource.objectResources[id]) {
            Cc.error('LockedLandItem fillWithResource:: g.dataResource.objectResources[id] == null for id: ' + id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'LockedLandItem');
            return;
        }
        var icon:Image;
        _id = id;
        _count = count;
        if (g.dataResource.objectResources[id].buildType == BuildType.PLANT)
            icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[id].imageShop + '_icon'));
        else
            icon = new Image(g.allData.atlas[g.dataResource.objectResources[id].url].getTexture(g.dataResource.objectResources[id].imageShop));
        if (!icon) {
            Cc.error('LockedLandItem fillWithResource:: no such image: ' + g.dataResource.objectResources[id].imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'lockedLandItem');
            return;
        }
        MCScaler.scale(icon, 50, 50);
        icon.x = 41 - icon.width/2;
        icon.y = 34 - icon.height/2;
        source.addChild(icon);
        var txt:TextField = new TextField(150,40,String(g.userInventory.getCountResourceById(id)) + '/' + String(count),g.allData.fonts['BloggerBold'],16,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 55;
        txt.x = -40;
        source.addChild(txt);
        txt = new TextField(200,90,'Собрать '+String(count)+' '+g.dataResource.objectResources[id].name + ' (пропадут после открытия)',g.allData.fonts['BloggerBold'],16,ManagerFilters.TEXT_BROWN_COLOR);
        txt.x = 90;
        txt.y = -2;
        source.addChild(txt);

        if (g.userInventory.getCountResourceById(id) >= count) {
            _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            _galo4ka.x = 351;
            _galo4ka.y = 31;
            _galo4ka.filter = ManagerFilters.SHADOW_TINY;
            source.addChild(_galo4ka);
            _isGood = true;
        } else {
            _btn = new CButton();
            _btn.addButtonTexture(120, 30, CButton.GREEN, true);
            txt = new TextField(120,30,'Купить ' + String(g.dataResource.objectResources[id].priceHard *(count - g.userInventory.getCountResourceById(id))), g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
            txt.x = -15;
            _btn.addChild(txt);
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            MCScaler.scale(im,25,25);
            im.x = 90;
            im.y = 3;
            _btn.addChild(im);
            _btn.x = 362;
            _btn.y = 45;
            source.addChild(_btn);
            _btn.clickCallback = buyItem;
//            btn = new CButton();
//            btn.addButtonTexture(112, 30, CButton.YELLOW, true);
//            txt = new TextField(112,30,'Показать',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
//            txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
//            btn.addChild(txt);
//            btn.x = 362;
//            btn.y = 25;
//            source.addChild(btn);
//            btn.endClickCallback = show;
            _isGood = false;
        }
    }

    public function fillWithFriends(count:int):void {
        var icon:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_icon'));
        MCScaler.scale(icon, 50, 50);
        icon.x = 41 - icon.width/2;
        icon.y = 34 - icon.height/2;
        source.addChild(icon);
        var txt:TextField = new TextField(150,40,'0/' +String(count),g.allData.fonts['BloggerMedium'],16,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = -35;
        txt.y = 55;
        source.addChild(txt);
        txt = new TextField(200,60,'Пригласить ' +String(count) + ' друзей',g.allData.fonts['BloggerBold'],16,ManagerFilters.TEXT_BROWN_COLOR);
        txt.x = 90;
        txt.y = 15;
        source.addChild(txt);

        if (0 > count) {
            _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            _galo4ka.x = 351;
            _galo4ka.y = 31;
            _galo4ka.filter = ManagerFilters.SHADOW_TINY;
            source.addChild(_galo4ka);
            _isGood = true;
        } else {
            _btn = new CButton();
            _btn.addButtonTexture(120, 30, CButton.YELLOW, true);
            txt = new TextField(120,30,'Пригласить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
            _btn.addChild(txt);
            _btn.x = 362;
            _btn.y = 50;
            source.addChild(_btn);
            var f1:Function = function ():void {
                g.windowsManager.hideWindow(WindowsManager.WO_LOCKED_LAND);
                g.windowsManager.openWindow(WindowsManager.WO_INVITE_FRIENDS, null, false);
            };
            _btn.clickCallback = f1;
            _isGood = false;
        }
    }

    public function deleteIt():void {
        if (_iconCoins) _iconCoins.filter = null;
        if (_galo4ka) _galo4ka.filter = null;
        if (_btn) {
            source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        source.removeChild(_bg);
        _bg.deleteIt();
        _bg = null;
        source.dispose();
        source = null;
    }

    public function get isGood():Boolean {
        return _isGood;
    }

    private function buyItem():void {
        g.windowsManager.hideWindow(WindowsManager.WO_LOCKED_LAND);
        g.windowsManager.openWindow(WindowsManager.WO_BUY_FOR_HARD, null, _id, _count);
    }


}
}
