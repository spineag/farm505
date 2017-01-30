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
import utils.CTextField;
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
    private var _txtBtn:CTextField;
    private var _txtCount:CTextField;
    private var _txtInfo:CTextField;
    private var _arrCTex:Array;

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
        _txtCount = new CTextField(150,40,String(count));
        _txtCount.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtCount.y = 52;
        _txtCount.x = -25;
        source.addChild(_txtCount);
        _txtInfo = new CTextField(200,90,'Накопи состояние - '+ String(count)+ ' монет (спишутся после открытия)');
        _txtInfo.setFormat(CTextField.BOLD18, 16, ManagerFilters.BROWN_COLOR);
        _txtInfo.x = 90;
        _txtInfo.y = -2;
        source.addChild(_txtInfo);

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
            _txtBtn = new CTextField(120,30,'Купить');
            _txtBtn.setFormat(CTextField.MEDIUM18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            _txtBtn.y = 2;
            _btn.addChild(_txtBtn);
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
        _txtCount = new CTextField(150,40,String(g.userInventory.getCountResourceById(id)) + '/' + String(count));
        _txtCount.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtCount.y = 50;
        _txtCount.x = -35;
        source.addChild(_txtCount);
        _txtInfo = new CTextField(200,90,'Собрать '+String(count)+' '+g.dataResource.objectResources[id].name + ' (пропадут после открытия)');
        _txtInfo.setFormat(CTextField.BOLD18, 16, ManagerFilters.BROWN_COLOR);
        _txtInfo.x = 90;
        _txtInfo.y = -2;
        source.addChild(_txtInfo);

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
            _txtBtn = new CTextField(120,30,'Купить ' + String(g.dataResource.objectResources[id].priceHard *(count - g.userInventory.getCountResourceById(id))));
            _txtBtn.setFormat(CTextField.MEDIUM18, 16, Color.WHITE);
            _txtBtn.x = -15;
            _txtBtn.y = 2;
            _btn.addChild(_txtBtn);
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
        _arrCTex = [];
        var txt:CTextField = new CTextField(150,40,'0/' +String(count));
        txt.setFormat(CTextField.MEDIUM18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.x = -35;
        txt.y = 55;
        source.addChild(txt);
        _arrCTex.push(txt);
        txt = new CTextField(200,60,'Пригласить ' +String(count) + ' друзей');
        txt.setFormat(CTextField.BOLD18, 16, ManagerFilters.BROWN_COLOR);
        txt.x = 90;
        txt.y = 15;
        source.addChild(txt);
        _arrCTex.push(txt);
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
            txt = new CTextField(120,30,'Пригласить');
            txt.setFormat(CTextField.MEDIUM18, 16, Color.WHITE, ManagerFilters.YELLOW_COLOR);
            _btn.addChild(txt);
            _btn.x = 362;
            _btn.y = 50;
            source.addChild(_btn);
            _arrCTex.push(txt);
            var f1:Function = function ():void {
                g.windowsManager.hideWindow(WindowsManager.WO_LOCKED_LAND);
                g.windowsManager.openWindow(WindowsManager.WO_INVITE_FRIENDS, null, false);
            };
            _btn.clickCallback = f1;
            _isGood = false;
        }
    }

    public function updateTextField():void {
        if (_txtBtn) _txtBtn.updateIt();
        if (_txtCount) _txtCount.updateIt();
        if (_txtInfo) _txtInfo.updateIt();
    }

    public function deleteIt():void {
        if (_iconCoins) _iconCoins.filter = null;
        if (_galo4ka) _galo4ka.filter = null;
        if (_arrCTex) {
            for (var i:int = 0; i < _arrCTex.length; i++) {
                _arrCTex[i].deleteIt();
                _arrCTex[i] = null;
            }
        }
        if (_btn) {
            source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        if (_txtCount) {
            source.removeChild(_txtCount);
            _txtCount.deleteIt();
            _txtCount = null;
        }
        if (_txtBtn) {
            _btn.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        if (_txtInfo) {
            source.removeChild(_txtInfo);
            _txtInfo.deleteIt();
            _txtInfo = null;
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
        g.windowsManager.openWindow(WindowsManager.WO_BUY_FOR_HARD, null,'lockedLand', _id, _count);
    }


}
}
