/**
 * Created by user on 10/27/15.
 */
package ui.catPanel {

import flash.filters.GlowFilter;
import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.WOComponents.HorizontalPlawka;

public class CatPanel {
    private var _source:CSprite;
    private var _txtCount:TextField;
    private var _txtZero:TextField;

    private var g:Vars = Vars.getInstance();
    public function CatPanel() {
        _source = new CSprite();
        var pl:HorizontalPlawka = new HorizontalPlawka(null, g.allData.atlas['interfaceAtlas'].getTexture('xp_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('xp_back_left'), 100);
        _source.addChild(pl);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('circle'));
        im.x = -im.width/2;
        im.y = -10;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_icon'));
        im.x = -19;
        im.y = -5;
        _source.addChild(im);
        _txtCount = new TextField(77, 40, '55', g.allData.fonts['BloggerBold'], 22, ManagerFilters.TEXT_BROWN);
        _txtZero = new TextField(30, 40, '', g.allData.fonts['BloggerBold'], 22, ManagerFilters.TEXT_ORANGE);
        _source.addChild(_txtCount);
        _source.addChild(_txtZero);

        onResize();
        g.cont.interfaceCont.addChild(_source);
        checkCat();
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
//        _source.endClickCallback = onClick;
    }

    public function checkCat():void {
        if (g.managerCats.countFreeCats <= 0) {
            _txtZero.text = '0';
            _txtCount.text = String("/" + g.managerCats.curCountCats);
            _txtCount.x = 28;
            _txtZero.x = 57 - _txtCount.textBounds.width;
            _txtZero.visible = true;
        } else {
            _txtCount.text = String(g.managerCats.countFreeCats + "/" + g.managerCats.curCountCats);
            _txtZero.visible = false;
            _txtCount.x = 20;

        }

    }

    public function onResize():void {
        _source.y = 77;
        _source.x = Starling.current.nativeStage.stageWidth - 108;

    }

    private function onHover():void {
        g.hint.showIt('Готовы поработать: ' + g.managerCats.countFreeCats + '  Всего котов: ' + g.managerCats.curCountCats, true,_source.x);
    }

    private function onOut():void {
        g.hint.hideIt();
    }

    public function visibleCatPanel(b:Boolean):void {
        if (b) _source.visible = true;
        else _source.visible = false;
    }

//    private function onClick():void {
//        g.user.level ++;
//        g.woLevelUp.showLevelUp();
//    }
}
}
