/**
 * Created by user on 8/26/15.
 */
package windows.market {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class MarketCheckBox {
    public var source:Sprite;
    private var _txt:TextField;
    private var _bg:CSprite;
    private var _galo4ka:Image;
    private var _stateChecked:Boolean;

    private var g:Vars = Vars.getInstance();

    public function MarketCheckBox() {
        source = new Sprite();
        _stateChecked = true;
        _txt = new TextField(250, 40, 'Добавить объявление в газету:', "Arial", 16, Color.BLACK);
        source.addChild(_txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka7'));
        im.scaleY = .8;
        im.width = im.height;
        _bg = new CSprite();
        _bg.addChild(im);
        _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('galo4ka'));
        MCScaler.scale(_galo4ka, im.width + 3, im.width + 3);
        _galo4ka.x = 3;
        _galo4ka.y = -3;
        _bg.addChild(_galo4ka);
        _bg.endClickCallback = changeState;
        _bg.x = 250;
        _bg.y = 5;
        source.addChild(_bg);
    }

    private function changeState():void {
        _stateChecked = !_stateChecked;
        _stateChecked ? _galo4ka.visible = true : _galo4ka.visible = false;
    }

    public function get isChecked():Boolean {
        return _stateChecked;
    }
}
}
