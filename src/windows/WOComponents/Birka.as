/**
 * Created by user on 11/9/15.
 */
package windows.WOComponents {
import flash.geom.Rectangle;
import manager.ManagerFilters;
import manager.Vars;

import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;
import utils.CTextField;

public class Birka extends Sprite{
    private var _source:Sprite;
    private var _txt:CTextField;
    private var g:Vars = Vars.getInstance();
    private var _curH:int;
    private var _bg:Sprite;
    private var _parent:Sprite;

    public function Birka(text:String, parent:Sprite, w:int, h:int) {
        _parent = parent;
        _source = new Sprite();
        _txt = new CTextField(300, 70, text);
        _txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.LIGHT_BLUE_COLOR);
        _txt.alignH = Align.LEFT;
        _bg = new Sprite();

        createAll();

        _source.touchable = false;
        _source.y = int(-h/2 + _curH/2 + 180);
        _source.x = int(-w/2 + 14);
        _parent.addChild(_source);
    }

    private function createAll():void {
        var tW:int = int(_txt.textBounds.width);
        var catIm:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_cat'));
        _curH = int(catIm.height) + tW + 50;
        if (_curH%2) _curH++;
        _source.addChild(_bg);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_d'));
        im.y = -im.height;
        im.x = -im.width;
        _bg.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_t'));
        im.y = -_curH;
        im.x = -im.width;
        _bg.addChild(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_c'));
        im.tileGrid = new Rectangle();
        im.x = -im.width;
        im.y = -_curH + 34;
        im.height = _curH - 76;
        _bg.addChildAt(im, 0);

        if (g.socialNetworkID != SocialNetworkSwitch.SN_VK_ID) {
            // double image to fix artifacts
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_c'));
            im.tileGrid = new Rectangle();
            im.x = -im.width;
            im.y = -_curH + 34 - 5;
            im.height = _curH - 76 + 10;
            _bg.addChildAt(im, 0);
        }

//        var cCount:int = Math.ceil((_curH - 80)/43) + 1;
//        for (var i:int=0; i < cCount; i++) {
//            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_c'));
//            im.x = -im.width;
//            if (i == cCount-1) {
//                im.y = -_curH + 30;
//            } else {
//                im.y = -75 - i * (im.height - 2);
//            }
//            _bg.addChildAt(im, 0);
//        }

        catIm.x = -58;
        catIm.y = -60;
        _source.addChild(catIm);
        _txt.rotation = -Math.PI/2;
        _txt.y = -65;
        _txt.x = -73;
        _source.addChild(_txt);
    }

    public function get source():Sprite {
        return _source;
    }

    public function get bg():Sprite {
        return _bg;
    }

    public function get curH():int {
        return _curH;
    }

    public function updateText(st:String):void {
        _txt.text = st;
        while (_bg.numChildren) _bg.removeChildAt(0);
        while (_source.numChildren) _source.removeChildAt(0);
        createAll();
    }
    
    public function updateTextField():void {
        _txt.updateIt();
    }

    public function flipIt():void {
        _bg.scaleX = -1;
        _bg.x = -_bg.width;
    }

    public function deleteIt():void {
        if (_parent.contains(_source)) _parent.removeChild(_source);
        _source.dispose();
        _source = null;
        _txt = null;
        _bg = null;
        g = null;
    }
}
}
