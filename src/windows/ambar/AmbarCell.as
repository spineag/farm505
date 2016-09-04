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
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.CartonBackgroundIn;
import windows.WindowsManager;

public class AmbarCell {
    public var source:CSprite;

    private var _info:Object; // id & count
    private var _data:Object;
    private var _image:Image;
    private var _countTxt:CTextField;
    private var g:Vars = Vars.getInstance();
    private var _clickCallback:Function;
    private var _onHover:Boolean;

    public function AmbarCell(info:Object) {
        _clickCallback = null;
        _onHover = false;
        source = new CSprite();
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        source.endClickCallback = onClick;
        var s:CartonBackgroundIn = new CartonBackgroundIn(100, 100);
        source.addChild(s);

        _info = info;
        if (!_info) {
            Cc.error('AmbarCell:: _info == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ambarCell');
            return;
        }
        _data = g.dataResource.objectResources[_info.id];
        if (!_data) {
            Cc.error('AmbarCell:: _data == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ambarCell');
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
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ambarCell');
                return;
            }
            MCScaler.scale(_image, 90, 90);
            _image.x = 50 - _image.width/2;
            _image.y = 50 - _image.height/2;
            source.addChild(_image);
        }

        _countTxt = new CTextField(60,20,String(g.userInventory.getCountResourceById(_data.id)));
        _countTxt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.TEXT_BROWN_COLOR);
        _countTxt.x = 50;
        _countTxt.y = 77;
        source.addChild(_countTxt);
    }

    public function deleteIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
        source = null;
        _image = null;
        _countTxt = null;
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        count = 0;
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        count = 0;
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function onOut():void {
        _onHover = false;
        g.resourceHint.hideIt();
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
    }

    private var count:int;
    private function onEnterFrame():void {
        count++;
        if (count >= 10) {
            if (!g.resourceHint.isShowed && _onHover)
                g.resourceHint.showIt(_data.id,source.x,source.y,source);
            g.gameDispatcher.removeEnterFrame(onEnterFrame);
            count = 0;
        }
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
