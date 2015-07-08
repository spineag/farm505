/**
 * Created by user on 6/25/15.
 */
package hint {

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

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

    private var g:Vars = Vars.getInstance();

    public function MouseHint() {
        _source = new Sprite();
        g.cont.hintCont.addChild(_source);
    }

    public function hideHintMouse():void {
        while (_source.numChildren) {
            _source.removeChildAt(0);
        }
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
    }
    private function onEnterFrame():void {
        _source.x = g.ownMouse.mouseX + 20;
        _source.y = g.ownMouse.mouseY + 20;
    }

    public function checkMouseHint(s:String):void {
        g.gameDispatcher.addEnterFrame(onEnterFrame);
        onEnterFrame();
        switch (s) {
            case SERP:
                _image = new Image(g.interfaceAtlas.getTexture(SERP));
                _imageBg = new Image(g.interfaceAtlas.getTexture("mouse_circle"));
                break;
            case CLOCK:
                _image = new Image(g.interfaceAtlas.getTexture(CLOCK));
                _imageBg = new Image(g.interfaceAtlas.getTexture("mouse_circle"));
                break;
            case VEDRO:
                _image = new Image(g.interfaceAtlas.getTexture(VEDRO));
                _imageBg = new Image(g.interfaceAtlas.getTexture("mouse_circle"));
                break;
            case KORZINA:
                _image = new Image(g.interfaceAtlas.getTexture(KORZINA));
                _imageBg = new Image(g.interfaceAtlas.getTexture("mouse_circle"));
                break;
        }
        _source.addChild(_imageBg);
        _source.addChild(_image);
        _image.x = 10;
        _image.y = 15;
    }
}
}
