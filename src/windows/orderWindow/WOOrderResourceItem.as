/**
 * Created by andy on 11/13/15.
 */
package windows.orderWindow {
import flash.filters.GlowFilter;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;

import utils.MCScaler;

import windows.WOComponents.CartonBackgroundIn;

public class WOOrderResourceItem {
    public var source:Sprite;
    private var _check:Image;
    private var _countTxt:TextField;
    private var _image:Image;
    private var g:Vars = Vars.getInstance();

    public function WOOrderResourceItem() {
        source = new Sprite();
        var bg:CartonBackgroundIn = new CartonBackgroundIn(93, 93);
        source.addChild(bg);
        source.touchable = false;

        _check = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _check.x = 69;
        _check.y = -5;
        source.addChild(_check);
        _check.visible = false;

        _countTxt = new TextField(80, 40, "10/10", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _countTxt.hAlign = HAlign.RIGHT;
        _countTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _countTxt.x = 12;
        _countTxt.y = 60;
        source.addChild(_countTxt);

        source.visible = false;
    }

    public function clearIt():void {
        _check.visible = false;
        source.visible = false;
        if (_image && source.contains(_image)) {
            source.removeChild(_image);
            _image.dispose();
            _image = null;
        }
        _countTxt.text = '';
    }

    public function fillIt(id:int, count:int):void {
        var obj:Object = g.dataResource.objectResources[id];
        _image = new Image(g.allData.atlas[obj.url].getTexture(obj.imageShop));
        MCScaler.scale(_image, 85, 85);
        _image.x = 47 - _image.width/2;
        _image.y = 47 - _image.height/2;
        source.addChildAt(_image, 1);
        var curCount:int = g.userInventory.getCountResourceById(id);
        if (curCount >= count) {
            _check.visible = true;
        }
        _countTxt.text = String(curCount) + '/' + String(count);
        source.visible = true;
    }

    public function isChecked():Boolean {
        return _check.visible;
    }
}
}
