/**
 * Created by andy on 11/13/15.
 */
package windows.orderWindow {
import data.BuildType;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;

public class WOOrderResourceItem {
    public var source:CSprite;
    private var _bg:CartonBackgroundIn;
    private var _check:Image;
    private var _countTxt:CTextField;
    private var _countRed:CTextField;
    private var _image:Image;
    private var _id:int;
    private var _onHover:Boolean;
    private var g:Vars = Vars.getInstance();

    public function WOOrderResourceItem() {
        source = new CSprite();
        _bg = new CartonBackgroundIn(93, 93);
        source.addChild(_bg);
        _onHover = false;
        _check = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _check.x = 69;
        _check.y = -5;
        _check.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_check);
        _check.visible = false;

        _countTxt = new CTextField(80, 40, "10/10");
        _countTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _countTxt.alignH = Align.RIGHT;
        _countTxt.y = 60;
        _countTxt.x = -3;
        source.addChild(_countTxt);
        _countRed = new CTextField(50, 30, "");
        _countRed.setFormat(CTextField.BOLD18, 18, ManagerFilters.ORANGE_COLOR, ManagerFilters.BROWN_COLOR);
        _countRed.alignH = Align.RIGHT;
        _countRed.y = 65;
        _countRed.x = -23;
        source.addChild(_countRed);
        source.hoverCallback = onHover;
        source.outCallback = outCallback;
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
        _countRed.text = '';
    }

    public function fillIt(id:int, count:int):void {
        var obj:Object = g.allData.resource[id];
        _id = id;
        if (obj.buildType == BuildType.PLANT)
            _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(obj.imageShop + '_icon'));
        else
            _image = new Image(g.allData.atlas[obj.url].getTexture(obj.imageShop));
        MCScaler.scale(_image, 85, 85);
        _image.x = 47 - _image.width/2;
        _image.y = 47 - _image.height/2;
        source.addChildAt(_image, 1);
        var curCount:int = g.userInventory.getCountResourceById(id);
        _countRed.text = String(curCount);
        _countTxt.text = '/' + String(count);
        _countTxt.x = 12;
        _countRed.x = 44 -_countTxt.textBounds.width;
        if (curCount >= count) {
            _check.visible = true;
//            _countTxt.text = String(curCount) + '/' + String(count);
//            _countTxt.x = 12;
            _countRed.changeTextColor = ManagerFilters.LIGHT_GREEN_COLOR;
        } else {
            _countRed.changeTextColor = ManagerFilters.ORANGE_COLOR;
        }

        source.visible = true;
    }

    public function isChecked():Boolean {
        return _check.visible;
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        g.resourceHint.showIt(_id,source.x,source.y,source);
    }

    private function outCallback():void {
        _onHover = false;
        g.resourceHint.hideIt();
    }

    public function deleteIt():void {
        source.removeChild(_bg);
        _bg.deleteIt();
        _bg = null;
        if (_countRed) {
            source.removeChild(_countRed);
            _countRed.deleteIt();
            _countRed = null;
        }
        if (_countTxt) {
            source.removeChild(_countTxt);
            _countTxt.deleteIt();
            _countTxt = null;
        }
        source.deleteIt();
        _image = null;
        _check = null;
        source = null;
    }
}
}