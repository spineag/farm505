/**
 * Created by user on 9/23/15.
 */
package heroes {

import com.junkbyte.console.Cc;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.CSprite;

public class HeroCat extends BasicCat{
    private var _catImage:Image;
    private var _isFree:Boolean;
    private var _isActive:Boolean;

    public function HeroCat(type:int) {
        super();

        _isFree = true;
        _isActive = false;
        _source = new CSprite();
        switch (type) {
            case MAN:
                _catImage = new Image(g.catAtlas.getTexture('cat_man'));
                break;
            case WOMAN:
                _catImage = new Image(g.catAtlas.getTexture('cat_woman'));
                break;
        }
        if (!_catImage) {
            Cc.error('HeroCat no such image: for type: ' + type);
            g.woGameError.showIt();
            return;
        }
        _catImage.x = -_catImage.width/2;
        _catImage.y = -_catImage.height + 2;
        _source.addChild(_catImage);

        _source.endClickCallback = onClick;
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType != ToolsModifier.NONE) return;
        activateIt();
    }

    public function activateIt():void {
        _isActive = !_isActive;
        if (_isActive) {
            if (g.activeCat) g.activeCat.activateIt();
            _source.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1);
            g.activeCat = this;
        } else {
            _source.filter = null;
            g.activeCat = null;
        }
    }

    public function get isFree():Boolean {
        return _isFree;
    }

    public function set isFree(value:Boolean):void {
        _isFree = value;
    }

}
}
