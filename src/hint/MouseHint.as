/**
 * Created by user on 6/25/15.
 */
package hint {

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class MouseHint {
    public static const SERP:String = "serp_icon";
    public static const CLOCK:String = "clock_icon";
    public static const VEDRO:String = "vedro_icon";
    public static const SCICCORS:String = "sciccors_icon";
    public static const KOWOLKA:String = "kowolka_icon";
    public static const KORZINA:String = "korzina_icon";
    public static const HELP:String = "help_icon";

    private var _source:Sprite;
    private var _imageBg:Image;
    private var _image:Image;
    private var _imageCircle:Image;
    private var _txtCount:TextField;

    private var g:Vars = Vars.getInstance();

    public function MouseHint() {
        _source = new Sprite();
        _imageBg = new Image(g.interfaceAtlas.getTexture("mouse_circle"));
        _source.addChild(_imageBg);
        _imageCircle = new Image(g.interfaceAtlas.getTexture("hint_circle"));
        _imageCircle.x = _source.width - 27;
        _imageCircle.y = _source.height - 23;
        _source.addChild(_imageCircle);
        _txtCount = new TextField(_imageCircle.width,_imageCircle.height,"","Arial",14,Color.BLACK);
        _txtCount.x = _imageCircle.x;
        _txtCount.y = _imageCircle.y;
        _source.addChild(_txtCount);
    }

    public function hideHintMouse():void {
        if (_image && _source.contains(_image)) {
            _source.removeChild(_image);
            _image.dispose();
            _image = null;
        }
        if (g.cont.hintCont.contains(_source)) g.cont.hintCont.removeChild(_source);
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
    }
    private function onEnterFrame():void {
        _source.x = g.ownMouse.mouseX + 20;
        _source.y = g.ownMouse.mouseY + 20;
    }

    public function checkMouseHint(s:String, data:Object = null):void {
        _imageCircle.visible = false;
        _txtCount.text = '';
        g.cont.hintCont.addChild(_source);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
        onEnterFrame();
        switch (s) {
            case SERP:
                _image = new Image(g.interfaceAtlas.getTexture(SERP));
                _image.x = 10;
                _image.y = 15;
                break;
            case CLOCK:
                _image = new Image(g.interfaceAtlas.getTexture(CLOCK));
                _image.x = 10;
                _image.y = 15;
                break;
            case VEDRO:
                _image = new Image(g.interfaceAtlas.getTexture(VEDRO));
                _image.x = 10;
                _image.y = 15;
                break;
            case KORZINA:
                _image = new Image(g.interfaceAtlas.getTexture(KORZINA));
                _image.x = 10;
                _image.y = 15;
                break;
            case 'animal':
                _imageCircle.visible = true;
                _txtCount.text = String(g.userInventory.getCountResourceById(data.idResourceRaw));
                _image = new Image(g.resourceAtlas.getTexture(g.dataResource.objectResources[data.idResourceRaw].imageShop));
                MCScaler.scale(_image, 50, 50);
                _image.x = 4;
                _image.y = 2;
                break;
        }

        _source.addChild(_image);
    }
}
}
