/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import flash.filters.GlowFilter;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.filters.BlurFilter;

import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.WOComponents.CartonBackground;

public class ShopTabBtn {
    public static const VILLAGE:int=1;
    public static const ANIMAL:int=2;
    public static const FABRICA:int=3;
    public static const PLANT:int=4;
    public static const DECOR:int=5;

    public var source:CSprite;
    public var cloneSource:CSprite;

    private var g:Vars = Vars.getInstance();

    public function ShopTabBtn(type:int, f:Function) {
        source = new CSprite();
        cloneSource = new CSprite();
        create(type, source, null);
        create(type, cloneSource, f);
        cloneSource.filter = ManagerFilters.SHADOW;
        cloneSource.hoverCallback = onHover;
        cloneSource.outCallback = onOut;
    }

    private function create(type:int, parent:CSprite, callback:Function):void {
        var bg:CartonBackground = new CartonBackground(123, 100);
        parent.addChild(bg);
        var _txt:TextField = new TextField(123, 100, '', g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        _txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txt.y = 10;
        parent.endClickCallback = callback;

        var im:Image;
        switch (type) {
            case VILLAGE:
                _txt.text = 'Двор';
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_court'));
                break;
            case ANIMAL:
                _txt.text = 'Животные';
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_animals'));
                break;
            case FABRICA:
                _txt.text = 'Фабрики';
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_fabric'));
                break;
            case PLANT:
                _txt.text = 'Растения';
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_plants'));
                break;
            case DECOR:
                _txt.text = 'Декор';
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_decor'));
                break;
        }
        im.x = 62 - im.width/2;
        im.y = 38 - im.height/2;
        parent.addChild(im);
        parent.addChild(_txt);
        parent.flatten();
    }

    public function activateIt(value:Boolean):void {
        source.visible = value;
        cloneSource.visible = !value;
    }

    public function setPosition(x:int, y:int, dX:int, dY:int):void {
        source.x = x;
        source.y = y;
        cloneSource.x = dX + x;
        cloneSource.y = dY + y + 7;
    }

    private function onHover():void {
        cloneSource.filter = ManagerFilters.BUTTON_HOVER_FILTER;
    }

    private function onOut():void {
        cloneSource.filter = null;
        cloneSource.filter = ManagerFilters.SHADOW;
    }
}
}
