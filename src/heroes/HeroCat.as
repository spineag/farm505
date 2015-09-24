/**
 * Created by user on 9/23/15.
 */
package heroes {

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
        _catImage.x = _catImage.width/2;
        _catImage.y = _catImage.height - 10;
        _source.addChild(_catImage);

        _source.endClickCallback = onClick;
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType != ToolsModifier.NONE) return;
        activateIt();
    }

    private function activateIt():void {
        _isActive = !_isActive;
        if (_isActive) {
            _source.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1);
            g.activeCat = this;
        } else {
            _source.filter = null;
            g.activeCat = null;
        }
    }

}
}
