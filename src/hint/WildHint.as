/**
 * Created by user on 6/11/15.
 */
package hint {
import manager.Vars;

import starling.display.Image;
import starling.text.TextField;

import utils.CSprite;

public class WildHint {
    private var _source:CSprite;
    private var _isOnHover:Boolean;
    private var _circle:Image;
    private var _bg:Image;
    private var _countTxt:TextField;

    private var g:Vars = Vars.getInstance();

    public function WildHint() {
        _source = new CSprite();
        _bg = new Image(g.interfaceAtlas.getTexture('hint_wild'));
        _source.addChild(_bg);
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height;
        _circle = new Image(g.interfaceAtlas.getTexture('hint_circle'));
        _circle.x = 70;
        _circle.y = 30;
        _source.addChild(_circle);
    }
}
}
