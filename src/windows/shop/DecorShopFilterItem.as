/**
 * Created by andy on 7/24/16.
 */
package windows.shop {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.HorizontalPlawka;

public class DecorShopFilterItem {
    private var _source:CSprite;
    private var _bg:HorizontalPlawka;
    private var _typeFilter:int;
    private var g:Vars = Vars.getInstance();
    private var _width:int = 150;
    private var _txt:CTextField;
    private var _callback:Function;
    private var _parent:Sprite;
    private var _btn:CButton;

    public function DecorShopFilterItem(typeFilter:int, pos:int, f:Function, p:Sprite) {
        _typeFilter = typeFilter;
        _parent = p;
        _callback = f;
        _source = new CSprite();
        _bg = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), _width);
        _txt = new CTextField(_width, 35, '');
        _txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _source.addChild(_bg);
        _source.addChild(_txt);
        _source.y = pos * 33;
        _parent.addChild(_source);
        switch (_typeFilter) {
            case DecorShopFilter.FILTER_ALL: _txt.text = 'Все'; break;
            case DecorShopFilter.FILTER_OTHER: _txt.text = 'Другое'; break;
            case DecorShopFilter.FILTER_FENCE: _txt.text = 'Заборчики'; break;
            case DecorShopFilter.FILTER_TAIL: _txt.text = 'Плитки'; break;
            case DecorShopFilter.FILTER_TREES: _txt.text = 'Деревья'; break;
            case DecorShopFilter.FILTER_SPECIAL: _txt.text = 'Особое'; break;
            case DecorShopFilter.FILTER_HOLIDAY: _txt.text = 'Праздничные'; break;
        }
        _source.endClickCallback = onClick;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
    }

    public function get source():CSprite {
        return _source;
    }

    private function onClick():void {
        if (_callback != null) {
            _callback.apply(null, [_typeFilter]);
        }
    }

    private function onHover():void {
        _bg.filter = ManagerFilters.BUILDING_HOVER_FILTER;
    }

    private function onOut():void {
        _bg.filter = null;
    }
    
    public function addButton():void {
        _btn = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 46, 46);
        _btn.addDisplayObject(im);
        _btn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_tr'));
        im.x = 16;
        im.y = 9;
        _btn.addChild(im);
        _btn.y = 17;
        _source.addChild(_btn);
        _btn.clickCallback = onClick;
    }

    public function deleteIt():void {
        if (_btn) {
            _source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        _parent.removeChild(_source);
        _source.removeChild(_bg);
        _bg.filter = null;
        _bg.deleteIt();
        _source.removeChild(_txt);
        _txt.dispose();
        _parent = null;
        _callback = null;
        _source.deleteIt();
    }

}
}
