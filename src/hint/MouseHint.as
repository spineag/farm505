/**
 * Created by user on 6/25/15.
 */
package hint {

import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

import utils.MCScaler;

public class MouseHint {
    public static const SERP:String = "cursor_sickle";
    public static const CLOCK:String = "cursor_clock";
    public static const VEDRO:String = "cursor_basket";
    public static const SCICCORS:String = "cursor_basket";
    public static const KOWOLKA:String = "cursor_basket";
    public static const KORZINA:String = "cursor_basket";
    public static const HELP:String = "help_icon";
    public static const ANIMAL:String = "animal";
    private var _curType:String;

    private var _source:Sprite;
    private var _imageBg:Image;
    private var _image:Image;
//    private var _imageCircle:Image;
    private var _txtCount:CTextField;
    private var _imageCont:Sprite;
    private var _isShowed:Boolean;

    private var g:Vars = Vars.getInstance();

    public function MouseHint() {
        _source = new Sprite();
        _isShowed = false;
//        _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture("cursor_circle"));
//        _source.addChild(_imageBg);
        _imageCont = new Sprite();
        _source.addChild(_imageCont);
//        _imageCircle = new Image(g.allData.atlas['interfaceAtlas'].getTexture("cursor_number_circle"));
//        _imageCircle.x = _source.width - 27;
//        _imageCircle.y = _source.height - 23;
//        _source.addChild(_imageCircle);
        _txtCount = new CTextField(30,30,"");
        _txtCount.setFormat(CTextField.BOLD14, 14, Color.WHITE, ManagerFilters.TEXT_BLUE_COLOR);
        _txtCount.x = 29;
        _txtCount.y = 39;
        _source.addChild(_txtCount);
    }

    public function hideIt():void {
        while(_imageCont.numChildren) _imageCont.removeChildAt(0);
        _isShowed = false;
        if (_image) {
            _image.dispose();
            _image = null;
        }
        if (_imageBg) {
            _imageBg.dispose();
            _imageBg = null;
        }
        _txtCount.text = '';
        if (g.cont.hintContUnder.contains(_source)) g.cont.hintContUnder.removeChild(_source);
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
    }

    private function onEnterFrame():void {
        _source.x = g.ownMouse.mouseX + 15;
        _source.y = g.ownMouse.mouseY + 5;
    }

    public function get isShowedAnimalFeed():Boolean {
        return _isShowed && _curType == ANIMAL;
    }

    public function showMouseHint(s:String, dat:Object = null):void {
        if (_isShowed) return;
        _curType = s;
        _isShowed = true;
//        _imageCircle.visible = false;
        _txtCount.text = '';
        g.cont.hintContUnder.addChild(_source);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
        onEnterFrame();
        switch (s) {
            case SERP:
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(SERP));
                _image.x = 7;
                _image.y = 8;
                _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_circle_2'));
                break;
            case CLOCK:
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(CLOCK));
                    MCScaler.scale(_image,_image.height-2,_image.width-2);
                _image.x = 7;
                _image.y = 12;
                _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_circle_3'));

                break;
            case VEDRO:
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(VEDRO));
                _image.x = 7;
                _image.y = 10;
                _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_circle_2'));

                break;
            case KORZINA:
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(KORZINA));
                _image.x = 7;
                _image.y = 7;
                _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_circle_2'));

                break;
            case ANIMAL:
//                _imageCircle.visible = true;
                _txtCount.text = String(g.userInventory.getCountResourceById(dat.idResourceRaw));
                if (g.dataResource.objectResources[dat.idResourceRaw].buildType == BuildType.PLANT)
                    _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[dat.idResourceRaw].imageShop + '_icon'));
                else
                    _image = new Image(g.allData.atlas[g.dataResource.objectResources[dat.idResourceRaw].url].getTexture(g.dataResource.objectResources[dat.idResourceRaw].imageShop));
                MCScaler.scale(_image, 40, 40);
                _image.x = 6;
                _image.y = 10;
                _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_circle_1'));
                break;
        }

        if (!_image) {
            Cc.error('MouseHint checkMouseHint:: no image for type: ' + s);
            return;
        }
        if (!_imageBg) {
            Cc.error('MouseHint checkMouseHint:: no _imageBg for type: ' + s);
            return;
        }
        _imageCont.addChild(_imageBg);
        _imageCont.addChild(_image);
    }
}
}
