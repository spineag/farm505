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

public class LockedLandItem {
    public var source:Sprite;
    private var _isGood:Boolean;
    private var g:Vars = Vars.getInstance();
    private var _id:int;
    private var _count:int;

    public function LockedLandItem() {
        source = new Sprite();
        var bg:Sprite = new CartonBackgroundIn(428, 88);
        source.addChild(bg);
    }

    public function fillWithCurrency(count:int):void {
        var icon:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        MCScaler.scale(icon, 50, 50);
        icon.x = 20;
        icon.y = 12;
        icon.filter = ManagerFilters.SHADOW_LIGHT;
        source.addChild(icon);
        var txt:TextField = new TextField(150,40,String(g.user.softCurrencyCount) + '/' + String(count),g.allData.fonts['BloggerMedium'],16,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 55;
        txt.x = -30;
        source.addChild(txt);
        txt = new TextField(200,60,'Приобрести разрешение на строительство',g.allData.fonts['BloggerBold'],16,ManagerFilters.TEXT_BROWN);
        txt.x = 103;
        txt.y = 15;
        source.addChild(txt);

        if (g.user.softCurrencyCount >= count) {
            var gal:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            gal.x = 351;
            gal.y = 31;
            gal.filter = ManagerFilters.SHADOW_TINY;
            source.addChild(gal);
            _isGood = true;
        } else {
            var btn:CButton = new CButton();
            btn.addButtonTexture(112, 30, CButton.GREEN, true);
            txt = new TextField(112,30,'Купить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
            btn.addChild(txt);
            btn.x = 362;
            btn.y = 50;
            source.addChild(btn);
            var f1:Function = function ():void {
                g.woLockedLand.onClickExit();
                g.woBuyCurrency.showItMenu(false);
            };
            btn.clickCallback = f1;
            _isGood = false;
        }
    }

    public function fillWithResource(id:int, count:int):void {
        if (!g.dataResource.objectResources[id]) {
            Cc.error('LockedLandItem fillWithResource:: g.dataResource.objectResources[id] == null for id: ' + id);
            g.woGameError.showIt();
            return;
        }
        var icon:Image;
        if (g.dataResource.objectResources[id].buildType == BuildType.PLANT)
            icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[id].imageShop + '_icon'));
        else
            icon = new Image(g.allData.atlas[g.dataResource.objectResources[id].url].getTexture(g.dataResource.objectResources[id].imageShop));
        if (!icon) {
            Cc.error('LockedLandItem fillWithResource:: no such image: ' + g.dataResource.objectResources[id].imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(icon, 50, 50);
        icon.x = 41 - icon.width/2;
        icon.y = 34 - icon.height/2;
        source.addChild(icon);
        var txt:TextField = new TextField(150,40,String(g.userInventory.getCountResourceById(id)) + '/' + String(count),g.allData.fonts['BloggerMedium'],16,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 55;
        txt.x = -40;
        source.addChild(txt);
        txt = new TextField(200,60,'Собрать '+String(count)+' '+g.dataResource.objectResources[id].name,g.allData.fonts['BloggerBold'],16,ManagerFilters.TEXT_BROWN);
        txt.x = 103;
        txt.y = 15;
        source.addChild(txt);

        if (g.userInventory.getCountResourceById(id) >= count) {
            var gal:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            gal.x = 351;
            gal.y = 31;
            gal.filter = ManagerFilters.SHADOW_TINY;
            source.addChild(gal);
            _isGood = true;
        } else {
            var btn:CButton = new CButton();
            btn.addButtonTexture(112, 30, CButton.GREEN, true);
            txt = new TextField(112,30,'Купить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
            btn.addChild(txt);
            btn.x = 362;
            btn.y = 64;
            source.addChild(btn);
            btn.clickCallback = buyItem;
            btn = new CButton();
            btn.addButtonTexture(112, 30, CButton.YELLOW, true);
            txt = new TextField(112,30,'Показать',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
            btn.addChild(txt);
            btn.x = 362;
            btn.y = 30;
            source.addChild(btn);
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
        var txt:TextField = new TextField(150,40,String(count),g.allData.fonts['BloggerMedium'],16,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 55;
        source.addChild(txt);
        txt = new TextField(200,60,'Попросите помощи у друзей',g.allData.fonts['BloggerBold'],16,ManagerFilters.TEXT_BROWN);
        txt.x = 103;
        txt.y = 15;
        source.addChild(txt);

        if (0 > count) {
            var gal:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            gal.x = 351;
            gal.y = 31;
            gal.filter = ManagerFilters.SHADOW_TINY;
            source.addChild(gal);
            _isGood = true;
        } else {
            var btn:CButton = new CButton();
            btn.addButtonTexture(112, 30, CButton.YELLOW, true);
            txt = new TextField(112,30,'Пригласить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
            btn.addChild(txt);
            btn.x = 362;
            btn.y = 50;
            source.addChild(btn);
//            btn.endClickCallback = f1;
            _isGood = false;
        }
    }

    public function clearIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
    }

    public function get isGood():Boolean {
        return _isGood;
    }

    private function buyItem():void {
        g.woLockedLand.onClickExit();
        g.woBuyForHardCurrency.showItWO(_id,_count);
    }


}
}
