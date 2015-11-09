/**
 * Created by user on 11/9/15.
 */
package windows {
import flash.filters.GlowFilter;

import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;

public class Birka extends Sprite{
    private var _source:Sprite;
    private var g:Vars = Vars.getInstance();

    public function Birka(text:String, woSource:Sprite, w:int, h:int) {
        _source = new Sprite();
        var txt:TextField = new TextField(300, 70, text, "Arial", 24, 0x009eff);
        txt.hAlign =  HAlign.LEFT;
        txt.nativeFilters = [new GlowFilter(Color.WHITE, 1, 6, 6, 9.0)];
        txt.bold = true;
        var tW:int = int(txt.textBounds.width);
        var catIm:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_cat'));
        var curH:int = int(catIm.height) + tW + 50;

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_d'));
        im.y = -im.height;
        im.x = -im.width;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_t'));
        im.y = -curH;
        im.x = -im.width;
        _source.addChild(im);

        var cCount:int = Math.ceil((curH - 80)/43);
        for (var i:int=0; i < cCount; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_c'));
            im.x = -im.width;
            im.y = -75 - i*(im.height - 2);
            _source.addChildAt(im, 0);
        }

        catIm.x = -55;
        catIm.y = -60;
        _source.addChild(catIm);
        txt.rotation = -Math.PI/2;
        txt.y = -65;
        txt.x = -70;
        _source.addChild(txt);

        _source.touchable = false;
        _source.flatten();
        _source.y = -h/2 + curH/2 + 180;
        _source.x = -w/2 + 14;
        woSource.addChild(_source);
    }
}
}
