/**
 * Created by user on 10/27/15.
 */
package ui.catPanel {

import flash.filters.GlowFilter;

import manager.Vars;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import windows.WOComponents.HorizontalPlawka;

public class CatPanel {
    private var _source:Sprite;
    private var _txtCount:TextField;

    private var g:Vars = Vars.getInstance();
    public function CatPanel() {
        _source = new Sprite();
        var pl:HorizontalPlawka = new HorizontalPlawka(null, g.allData.atlas['interfaceAtlas'].getTexture('xp_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('xp_back_left'), 105);
        _source.addChild(pl);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('circle'));
        im.x = -im.width/2;
        im.y = -10;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_icon'));
        im.x = -19;
        im.y = -5;
        _source.addChild(im);
        _txtCount = new TextField(77, 40, '55', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtCount.nativeFilters = [new GlowFilter(0x4d3800, 1, 4, 4, 5)];
        _txtCount.x = 26;
        _source.addChild(_txtCount);
        onResize();
        g.cont.interfaceCont.addChild(_source);
        checkCat();
    }

    public function checkCat():void {
        _txtCount.text = String(g.managerCats.countFreeCats + " / " + g.managerCats.curCountCats);
    }

    public function onResize():void {
        _source.y = 77;
        _source.x = Starling.current.nativeStage.stageWidth - 112;
    }
}
}
