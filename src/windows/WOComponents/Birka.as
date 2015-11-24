/**
 * Created by user on 11/9/15.
 */
package windows.WOComponents {
import flash.filters.GlowFilter;

import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;

public class Birka extends Sprite{
    private var _source:Sprite;
    private var _txt:TextField;
    private var g:Vars = Vars.getInstance();
    private var _curH:int;
    private var _bg:Sprite;

    public function Birka(text:String, woSource:Sprite, w:int, h:int) {
        _source = new Sprite();
        _txt = new TextField(300, 70, text, g.allData.fonts['BloggerBold'], 24, 0x009eff);
        _txt.hAlign =  HAlign.LEFT;
        _txt.nativeFilters = [new GlowFilter(Color.WHITE, 1, 6, 6, 9.0)];
        _bg = new Sprite();

        createAll();

        _source.touchable = false;
        _source.flatten();
        _source.y = -h/2 + _curH/2 + 180;
        _source.x = -w/2 + 14;
        woSource.addChild(_source);
    }

    private function createAll():void {
        var tW:int = int(_txt.textBounds.width);
        var catIm:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_cat'));
        _curH = int(catIm.height) + tW + 50;
        _source.addChild(_bg);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_d'));
        im.y = -im.height;
        im.x = -im.width;
        _bg.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_t'));
        im.y = -_curH;
        im.x = -im.width;
        _bg.addChild(im);

        var cCount:int = Math.ceil((_curH - 80)/43) + 1;
        for (var i:int=0; i < cCount; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_c'));
            im.x = -im.width;
            if (i == cCount-1) {
                im.y = -_curH + 30;
            } else {
                im.y = -75 - i * (im.height - 2);
            }
            _bg.addChildAt(im, 0);
        }

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

    public function updateText(st:String):void {
        _txt.text = st;
        _source.unflatten();
        while (_bg.numChildren) _bg.removeChildAt(0);
        while (_source.numChildren) _source.removeChildAt(0);
        createAll();
        _source.flatten();
    }

    public function flipIt():void {
        _bg.scaleX = -1;
        _bg.x = -_bg.width;
    }
}
}
