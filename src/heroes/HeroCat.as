/**
 * Created by user on 9/23/15.
 */
package heroes {
import starling.display.Image;

import utils.CSprite;

public class HeroCat extends BasicCat{
    private var _catImage:Image;

    public function HeroCat(type:int) {
        _source = new CSprite();
        switch (type) {
            case MAN:
                _catImage = new Image(g.catAtlas.getTexture('cat_man'));
                break;
            case WOMAN:
                _catImage = new Image(g.catAtlas.getTexture('cat_woman'));
                break;
        }
        _source.addChild(_catImage);
        setToFreeCell();
    }
}
}
