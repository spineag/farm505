/**
 * Created by user on 2/16/17.
 */
package windows.salePack {
import data.BuildType;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import starling.utils.Align;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

public class WOSalePackItem {
    public var source:Sprite;
    private var _txtCount:CTextField;
    private var _txtName:CTextField;
    private var _objectId:int = 0;
    private var _objectType:int = 0;
    private var _objectCount:int = 0;
    private var g:Vars = Vars.getInstance();

    public function WOSalePackItem(objectId:int = 0, objectType:int = 0, objectCount:int = 0) {
        _objectId = objectId;
        _objectType = objectType;
        _objectCount = objectCount;
        source = new Sprite();
        var im:Image;
        im = new Image(g.allData.atlas['saleAtlas'].getTexture('sp_cell'));
        source.addChild(im);
        _txtName = new CTextField(171, 40, '');
        _txtName.setFormat(CTextField.BOLD30, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCount = new CTextField(171, 40, '');
        _txtCount.setFormat(CTextField.BOLD30, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCount.y = 135;
        if (objectId == 1 && objectType  == 1) {
            _txtName.text = 'Монеты';
            _txtCount.text = String(_objectCount);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        } else if (objectId == 2 && objectType == 2) {
            _txtName.text = 'Рубины';
            _txtCount.text = String(_objectCount);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        }  else if (_objectType == BuildType.RESOURCE || _objectType == BuildType.INSTRUMENT || _objectType == BuildType.PLANT) {
            _txtName.text = g.allData.resource[_objectId].name;
            _txtCount.text = String(_objectCount);
            im = new Image(g.allData.atlas[g.allData.resource[_objectId].url].getTexture(g.allData.resource[_objectId].imageShop));
        } else if (_objectType == BuildType.DECOR_ANIMATION) {
            _txtName.text = g.allData.building[_objectId].name;
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.building[_objectId].url + '_icon'));
            MCScaler.scale(im,100,100);
        } else if (_objectType == BuildType.DECOR) {
            _txtName.text = g.allData.building[_objectId].name;
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.building[_objectId].image +'_icon'));
            MCScaler.scale(im,100,100);
        }
        im.x = 85 - im.width/2;
        im.y = 85 - im.height/2;
        source.addChild(im);
        source.addChild(_txtName);
        source.addChild(_txtCount);
    }
}
}
