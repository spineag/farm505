/**
 * Created by user on 7/24/15.
 */
package windows.dailyBonusWindow {


import manager.ManagerDailyBonus;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

import utils.MCScaler;

public class WODailyBonusItem {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _parent:Sprite;
    private var im:Image;

    public function WODailyBonusItem(obj:Object, index:int, p:Sprite) {
        _parent = p;

        switch (obj.type) {
            case ManagerDailyBonus.RESOURCE:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[obj.id].imageShop));
                break;
            case ManagerDailyBonus.PLANT:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[obj.id].imageShop + '_icon'));
                break;
            case ManagerDailyBonus.SOFT_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                break;
            case ManagerDailyBonus.HARD_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                break;
            case ManagerDailyBonus.DECOR:
                im = new Image(g.allData.atlas['decorAtlas'].getTexture(g.dataBuilding.objectBuilding[obj.id].image));
                break;
            case ManagerDailyBonus.INSTRUMENT:
                im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[obj.id].imageShop));
                break;
        }
        MCScaler.scale(im, 60, 60);
        im.x = -im.width/2;
        im.y = -im.height/2;
        im.filter = ManagerFilters.SHADOW;
        _source = new Sprite();
        _source.addChild(im);

        switch (index) {
            case 0:
                _source.x = 0;
                _source.y = -165;
                break;
            case 1:
                _source.x = 82;
                _source.y = -143;
                break;
            case 2:
                _source.x = 143;
                _source.y = -83;
                break;
            case 3:
                _source.x = 165;
                _source.y = 0;
                break;
            case 4:
                _source.x = 142;
                _source.y = 82;
                break;
            case 5:
                _source.x = 82;
                _source.y = 143;
                break;
            case 6:
                _source.x = 0;
                _source.y = 164;
                break;
            case 7:
                _source.x = -82;
                _source.y = 142;
                break;
            case 8:
                _source.x = -143;
                _source.y = 82;
                break;
            case 9:
                _source.x = -165;
                _source.y = 0;
                break;
            case 10:
                _source.x = -143;
                _source.y = -82;
                break;
            case 11:
                _source.x = -82;
                _source.y = -143;
                break;
        }

        _source.rotation = (Math.PI/6)*index;
        _parent.addChild(_source);
        if (obj.type == ManagerDailyBonus.HARD_MONEY || obj.type == ManagerDailyBonus.SOFT_MONEY) {
            var txt:CTextField = new CTextField(60, 40, '+'+String(obj.count));
            txt.setFormat(CTextField.MEDIUM24, 20, Color.WHITE, ManagerFilters.TEXT_BROWN_COLOR);
            txt.x = -20;
            txt.y = -5;
            _source.addChild(txt);
        }
    }

    public function deleteIt():void {
        im.filter = null;
        _parent.removeChild(_source);
        _source.dispose();
        _parent = null;
        _source = null;
    }
}
}
