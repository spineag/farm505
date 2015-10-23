/**
 * Created by user on 10/1/15.
 */
package windows.lockedLand {
import com.junkbyte.console.Cc;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

public class LockedLandItem {
    public var source:Sprite;
    private var _isGood:Boolean;
    private var _contBtn:CSprite;
    private var g:Vars = Vars.getInstance();
    private var _id:int;
    private var _count:int;

    public function LockedLandItem() {
        source = new Sprite();
        _contBtn = new CSprite();
        var bg:Quad = new Quad(390, 100, Color.WHITE);
        source.addChild(bg);
    }

    public function fillWithCurrency(count:int):void {
        var icon:Image = new Image(g.interfaceAtlas.getTexture('coin'));
        MCScaler.scale(icon, 70, 70);
        icon.x = 10;
        icon.y = 10;
        source.addChild(icon);
        if (g.user.softCurrencyCount >= count) {
            var gal:Image = new Image(g.interfaceAtlas.getTexture('galo4ka'));
            MCScaler.scale(gal, 50, 50);
            gal.x = 315;
            gal.y = 25;
            source.addChild(gal);
            _isGood = true;
        } else {
            var txt:TextField = new TextField(70, 40, String(g.user.softCurrencyCount) + ' / ' + String(count), "Arial", 30, Color.BLACK);
            txt.x = 310;
            txt.y = 15;
            source.addChild(txt);
            _isGood = false;
        }
        var txtDescription:TextField = new TextField(250, 100, 'Необходимо ' +  String(count) + ' монет', "Arial", 20, Color.BLACK);
        txtDescription.x = 70;
        source.addChild(txtDescription);
    }

    public function fillWithResource(id:int, count:int):void {
        var icon:Image;
        if (!g.dataResource.objectResources[id]) {
            Cc.error('LockedLandItem fillWithResource:: g.dataResource.objectResources[id] == null for id: ' + id);
            g.woGameError.showIt();
            return;
        }
        if (g.dataResource.objectResources[id].url == 'plantAtlas') {
            icon = new Image(g.plantAtlas.getTexture(g.dataResource.objectResources[id].imageShop));
        } else if (g.dataResource.objectResources[id].url == 'instrumentAtlas') {
            icon = new Image(g.instrumentAtlas.getTexture(g.dataResource.objectResources[id].imageShop));
        } else {
            icon = new Image(g.resourceAtlas.getTexture(g.dataResource.objectResources[id].imageShop));
        }
        if (!icon) {
            Cc.error('LockedLandItem fillWithResource:: no such image: ' + g.dataResource.objectResources[id].imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(icon, 70, 70);
        icon.x = 10;
        icon.y = 10;
        source.addChild(icon);
        if (g.userInventory.getCountResourceById(id) >= count) {
            var gal:Image = new Image(g.interfaceAtlas.getTexture('galo4ka'));
            MCScaler.scale(gal, 50, 50);
            gal.x = 315;
            gal.y = 25;
            source.addChild(gal);
            _isGood = true;
        } else {
            _count = count - g.userInventory.getCountResourceById(id);
            _id = id;
            var txt:TextField = new TextField(70, 40, String(g.userInventory.getCountResourceById(id)) + ' / ' + String(count), "Arial", 30, Color.BLACK);
            var txtBtn:TextField = new TextField(70, 40, "купить за: " + String((count - g.userInventory.getCountResourceById(id)) * g.dataResource.objectResources[id].priceHard), "Arial", 14, Color.BLACK);
            var im:Image = new Image(g.interfaceAtlas.getTexture("btn2"));
            im.width = im.width/2;
            txt.x = 310;
            txt.y = 15;
            source.addChild(txt);
            source.addChild(_contBtn);
            _contBtn.addChild(im);
            _contBtn.addChild(txtBtn);
            _contBtn.x = source.width - _contBtn.width;
            _contBtn.y = source.height - _contBtn.height;
            _contBtn.endClickCallback = buyItem;
            _isGood = false;
        }
        var txtDescription:TextField = new TextField(250, 100, 'Необходимо ' +  String(count) + ' ресурсов', "Arial", 20, Color.BLACK);
        txtDescription.x = 70;
        source.addChild(txtDescription);
    }

    public function fillWithFriends(count:int):void {
        var icon:Image = new Image(g.interfaceAtlas.getTexture('friends_icon'));
        MCScaler.scale(icon, 70, 70);
        icon.x = 10;
        icon.y = 10;
        source.addChild(icon);
        if (0 > count) {
            var gal:Image = new Image(g.interfaceAtlas.getTexture('galo4ka'));
            MCScaler.scale(gal, 50, 50);
            gal.x = 315;
            gal.y = 25;
            source.addChild(gal);
            _isGood = true;
        } else {
            var txt:TextField = new TextField(70, 40, String(0) + ' / ' + String(count), "Arial", 30, Color.BLACK);
            var txtBtn:TextField = new TextField(70, 40, "Пригласить", "Arial", 14, Color.BLACK);
            var im:Image = new Image(g.interfaceAtlas.getTexture("btn2"));
            im.width = im.width/2;
            txt.x = 310;
            txt.y = 15;
            source.addChild(txt);
            source.addChild(_contBtn);
            _contBtn.addChild(im);
            _contBtn.addChild(txtBtn);
            _contBtn.x = source.width - _contBtn.width;
            _contBtn.y = source.height - _contBtn.height;
            _isGood = false;
        }
        var txtDescription:TextField = new TextField(250, 100, 'Необходимо у ' +  String(count) + ' друзей попросить помощи', "Arial", 20, Color.BLACK);
        txtDescription.x = 70;
        source.addChild(txtDescription);
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
        g.woBuyForHardCurrency.showItWO(_id,_count);
    }


}
}
