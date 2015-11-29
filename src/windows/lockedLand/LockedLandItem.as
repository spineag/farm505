/**
 * Created by user on 10/1/15.
 */
package windows.lockedLand {
import com.junkbyte.console.Cc;

import flash.filters.GlowFilter;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
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
        source.addChild(icon);
        var txt:TextField = new TextField(150,40,String(count) + '/' + String(g.user.softCurrencyCount),g.allData.fonts['BloggerMedium'],16,Color.WHITE);
        txt.nativeFilters = [new GlowFilter(0x744d0c, 1, 4, 4, 5)];
        txt.y = 55;
        source.addChild(txt);
        txt = new TextField(200,60,'Приобрести разрешение на строительство',g.allData.fonts['BloggerMedium'],16,0x744d0c);
        txt.x = 103;
        txt.y = 15;
        source.addChild(txt);

        if (g.user.softCurrencyCount >= count) {
            var gal:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            gal.x = 351;
            gal.y = 31;
            source.addChild(gal);
            _isGood = true;
        } else {
            var btn:CSprite = new CSprite();
            var s:Sprite = new WOButtonTexture(112, 30, WOButtonTexture.GREEN);
            btn.addChild(s);
//            icon = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
//            MCScaler.scale(icon, 20, 20);
//            icon.x = 90;
//            icon.y = 6;
//            btn.addChild(icon);
//            txt = new TextField(90,30,'Купить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt = new TextField(112,30,'Купить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = [new GlowFilter(0x0e6328, 1, 4, 4, 5)];
            btn.addChild(txt);
            btn.x = 306;
            btn.y = 35;
            source.addChild(btn);
            var f1:Function = function ():void {
                g.woLockedLand.onClickExit();
                g.woBuyCurrency.showItMenu(false);
            };
            btn.endClickCallback = f1;
            _isGood = false;
        }
    }

    public function fillWithResource(id:int, count:int):void {
        if (!g.dataResource.objectResources[id]) {
            Cc.error('LockedLandItem fillWithResource:: g.dataResource.objectResources[id] == null for id: ' + id);
            g.woGameError.showIt();
            return;
        }
        var icon:Image = new Image(g.allData.atlas[g.dataResource.objectResources[id].url].getTexture(g.dataResource.objectResources[id].imageShop));
        if (!icon) {
            Cc.error('LockedLandItem fillWithResource:: no such image: ' + g.dataResource.objectResources[id].imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(icon, 50, 50);
        icon.x = 41 - icon.width/2;
        icon.y = 34 - icon.height/2;
        source.addChild(icon);
        var txt:TextField = new TextField(150,40,String(count) + '/' + String(g.userInventory.getCountResourceById(id)),g.allData.fonts['BloggerMedium'],16,Color.WHITE);
        txt.nativeFilters = [new GlowFilter(0x744d0c, 1, 4, 4, 5)];
        txt.y = 55;
        source.addChild(txt);
        txt = new TextField(200,60,'Собрать '+String(count)+' '+g.dataResource.objectResources[id].name,g.allData.fonts['BloggerMedium'],16,0x744d0c);
        txt.x = 103;
        txt.y = 15;
        source.addChild(txt);

        if (g.userInventory.getCountResourceById(id) >= count) {
            var gal:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            gal.x = 351;
            gal.y = 31;
            source.addChild(gal);
            _isGood = true;
        } else {
            var btn:CSprite = new CSprite();
            var s:Sprite = new WOButtonTexture(112, 30, WOButtonTexture.GREEN);
            btn.addChild(s);
//            icon = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
//            MCScaler.scale(icon, 20, 20);
//            icon.x = 90;
//            icon.y = 6;
//            btn.addChild(icon);
//            txt = new TextField(90,30,'Купить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt = new TextField(112,30,'Купить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = [new GlowFilter(0x0e6328, 1, 4, 4, 5)];
            btn.addChild(txt);
            btn.x = 306;
            btn.y = 49;
            source.addChild(btn);
            btn.endClickCallback = buyItem;
            btn = new CSprite();
            s = new WOButtonTexture(112, 30, WOButtonTexture.YELLOW);
            btn.addChild(s);
            txt = new TextField(112,30,'Показать',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = [new GlowFilter(0x84570e, 1, 4, 4, 5)];
            btn.addChild(txt);
            btn.x = 306;
            btn.y = 15;
            source.addChild(btn);
//            btn.endClickCallback = show;
            _isGood = false;
        }
    }

    public function fillWithFriends(count:int):void {
        var icon:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_icon'));
        MCScaler.scale(icon, 50, 50);
        icon.x = 41 - icon.width/2;
        icon.y = 34 - icon.height/2;
        source.addChild(icon);
        var txt:TextField = new TextField(150,40,String(count),g.allData.fonts['BloggerMedium'],16,Color.WHITE);
        txt.nativeFilters = [new GlowFilter(0x744d0c, 1, 4, 4, 5)];
        txt.y = 55;
        source.addChild(txt);
        txt = new TextField(200,60,'Попросите помощи у друзей',g.allData.fonts['BloggerMedium'],16,0x744d0c);
        txt.x = 103;
        txt.y = 15;
        source.addChild(txt);

        if (0 > count) {
            var gal:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            gal.x = 351;
            gal.y = 31;
            source.addChild(gal);
            _isGood = true;
        } else {
            var btn:CSprite = new CSprite();
            var s:Sprite = new WOButtonTexture(112, 30, WOButtonTexture.YELLOW);
            btn.addChild(s);
            txt = new TextField(112,30,'Пригласить',g.allData.fonts['BloggerMedium'],16,Color.WHITE);
            txt.nativeFilters = [new GlowFilter(0x84570e, 1, 4, 4, 5)];
            btn.addChild(txt);
            btn.x = 306;
            btn.y = 35;
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
