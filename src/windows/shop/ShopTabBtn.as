/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;
import utils.CSprite;
import windows.WOComponents.CartonBackground;

public class ShopTabBtn {
    private var _source:CSprite;
    private var _SHADOW:BlurFilter;
    private var _shopSprite:Sprite;
    private var _shopSource:Sprite;
    private var _defaultX:int;
    private var _defaultY:int;
    private var _bg:CartonBackground;
    private var g:Vars = Vars.getInstance();

    public function ShopTabBtn(type:int, f:Function, shopSprite:Sprite, shopSource:Sprite, shadow:BlurFilter) {
        _SHADOW = shadow;
        _shopSprite = shopSprite;
        _shopSource = shopSource;
        _source = new CSprite();

        _bg = new CartonBackground(123, 100);
        _source.addChild(_bg);
        var _txt:TextField = new TextField(123, 100, '', g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        _txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txt.y = 10;
        _source.endClickCallback = f;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;

        var im:Image;
        switch (type) {
            case WOShop.VILLAGE:
                _txt.text = 'Двор';
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_court'));
                break;
            case WOShop.ANIMAL:
                _txt.text = 'Животные';
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_animals'));
                break;
            case WOShop.FABRICA:
                _txt.text = 'Фабрики';
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_fabric'));
                break;
            case WOShop.PLANT:
                _txt.text = 'Растения';
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_plants'));
                break;
            case WOShop.DECOR:
                _txt.text = 'Декор';
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_decor'));
                break;
        }
        im.x = 62 - im.width/2;
        im.y = 38 - im.height/2;
        _source.addChild(im);
        _source.addChild(_txt);
        _source.flatten();
    }

    public function activateIt(value:Boolean):void {
        if (value) {
            _source.filter = null;
            if (_shopSource.contains(_source)) _shopSource.removeChild(_source);
            if (!_shopSprite.contains(_source)) _shopSprite.addChild(_source);
            _source.x = _defaultX;
            _source.y = _defaultY;
            _source.isTouchable = false;
        } else {
            if (_shopSprite.contains(_source)) _shopSprite.removeChild(_source);
            if (!_shopSource.contains(_source)) _shopSource.addChild(_source);
            _source.filter = _SHADOW;
            _shopSource.setChildIndex(_source, _shopSource.getChildIndex(_shopSprite));
            _source.x = _defaultX + _shopSprite.x;
            _source.y = _defaultY +_shopSprite.y + 10;
            _source.isTouchable = true;
        }
    }

    public function setPosition(x:int, y:int):void {
        _defaultX = x;
        _defaultY = y;
    }

    private function onOut():void {
        _source.y = _defaultY + _shopSprite.y + 10;
    }

    private function onHover():void {
        _source.y = _defaultY + _shopSprite.y + 3;
    }

    public function deleteIt():void {
        _SHADOW = null;
        if (_shopSource.contains(_source)) _shopSource.removeChild(_source);
        if (_shopSprite.contains(_source)) _shopSprite.removeChild(_source);
        _source.removeChild(_bg);
        _bg.deleteIt();
        _bg = null;
        _shopSource = null;
        _shopSprite = null;
        _source.deleteIt();
        _source = null;
    }
}
}
