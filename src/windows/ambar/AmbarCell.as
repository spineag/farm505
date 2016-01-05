/**
 * Created by user on 6/17/15.
 */
package windows.ambar {

import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.CartonBackgroundIn;

public class AmbarCell {
    public var source:CSprite;

    private var _info:Object; // id & count
    private var _data:Object;
    private var _image:Image;
    private var _countTxt:TextField;
    private var g:Vars = Vars.getInstance();
    private var _clickCallback:Function;

    public function AmbarCell(info:Object) {
        _clickCallback = null;
        source = new CSprite();
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        source.endClickCallback = onClick;
        var s:CartonBackgroundIn = new CartonBackgroundIn(100, 100);
        source.addChild(s);

        _info = info;
        if (!_info) {
            Cc.error('AmbarCell:: _info == null');
            g.woGameError.showIt();
            return;
        }
        _data = g.dataResource.objectResources[_info.id];
        if (!_data) {
            Cc.error('AmbarCell:: _data == null');
            g.woGameError.showIt();
            return;
        }
        if (_data) {
            if (_data.buildType == BuildType.PLANT) {
                _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
            } else {
                _image = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
            }
            if (!_image) {
                Cc.error('AmbarCell:: no such image: ' + _data.imageShop);
                g.woGameError.showIt();
                return;
            }
            MCScaler.scale(_image, 90, 90);
            _image.x = 50 - _image.width/2;
            _image.y = 50 - _image.height/2;
            source.addChild(_image);
        }

        _countTxt = new TextField(30,20,'',g.allData.fonts['BloggerBold'],16, Color.WHITE);
        _countTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _countTxt.text = String(g.userInventory.getCountResourceById(_data.id));
        _countTxt.x = 75;
        _countTxt.y = 77;
        source.addChild(_countTxt);
    }

    public function clearIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
        source = null;
        _image = null;
        _countTxt = null;
    }

    private function onHover():void {
        g.resourceHint.hideIt();
        g.resourceHint.showIt(_data.id,source.x,source.y,source);
    }

    private function onOut():void {
        g.resourceHint.hideIt();
    }

    public function set clickCallback(f:Function):void {
        _clickCallback = f;
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_info.id]);
        }
    }
}
}
