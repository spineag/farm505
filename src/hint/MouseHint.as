/**
 * Created by user on 6/25/15.
 */
package hint {

import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class MouseHint {
    public static const SERP:String = "cursor_sickle";
    public static const CLOCK:String = "cursor_clock";
    public static const VEDRO:String = "cursor_basket";
    public static const SCICCORS:String = "cursor_basket";
    public static const KOWOLKA:String = "cursor_basket";
    public static const KORZINA:String = "cursor_basket";
    public static const HELP:String = "help_icon";

    private var _source:Sprite;
    private var _imageBg:Image;
    private var _image:Image;
    private var _imageCircle:Image;
    private var _txtCount:TextField;
    private var _imageCont:Sprite;

    private var g:Vars = Vars.getInstance();

    public function MouseHint() {
        _source = new Sprite();
        _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture("cursor_circle"));
        _source.addChild(_imageBg);
        _imageCont = new Sprite();
        _source.addChild(_imageCont);
        _imageCircle = new Image(g.allData.atlas['interfaceAtlas'].getTexture("cursor_number_circle"));
        _imageCircle.x = _source.width - 27;
        _imageCircle.y = _source.height - 23;
        _source.addChild(_imageCircle);
        _txtCount = new TextField(_imageCircle.width,_imageCircle.height,"",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtCount.x = _imageCircle.x;
        _txtCount.y = _imageCircle.y;
        _source.addChild(_txtCount);
    }

    public function hideIt():void {
        while(_imageCont.numChildren) _imageCont.removeChildAt(0);
        if (_image) {
            _image.dispose();
            _image = null;
        }
        if (g.cont.hintContUnder.contains(_source)) g.cont.hintContUnder.removeChild(_source);
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
    }

    private function onEnterFrame():void {
        _source.x = g.ownMouse.mouseX + 20;
        _source.y = g.ownMouse.mouseY + 20;
    }

    public function checkMouseHint(s:String, data:Object = null):void {
        if (g.currentOpenedWindow == true) return;
        _imageCircle.visible = false;
        _txtCount.text = '';
        g.cont.hintContUnder.addChild(_source);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
        onEnterFrame();
        switch (s) {
            case SERP:
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(SERP));
                _image.x = 7;
                _image.y = 7;
                break;
            case CLOCK:
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(CLOCK));
                _image.x = 7;
                _image.y = 7;

                break;
            case VEDRO:
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(VEDRO));
                _image.x = 7;
                _image.y = 7;
                break;
            case KORZINA:
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(KORZINA));
                _image.x = 7;
                _image.y = 7;

                break;
            case 'animal':
                _imageCircle.visible = true;
                _txtCount.text = String(g.userInventory.getCountResourceById(data.idResourceRaw));
                _image = new Image(g.allData.atlas[g.dataResource.objectResources[data.idResourceRaw].url].getTexture(g.dataResource.objectResources[data.idResourceRaw].imageShop));
                MCScaler.scale(_image, 40, 40);
                _image.x = 5;
                _image.y = 6;
                break;
        }

        if (!_image) {
            Cc.error('MouseHint checkMouseHint:: no image for type: ' + s);
        }
        _imageCont.addChild(_image);
    }
}
}
