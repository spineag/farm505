/**
 * Created by user on 7/6/15.
 */
package ui.softHardCurrencyPanel {
import flash.filters.GlowFilter;
import flash.geom.Point;

import manager.Vars;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.display.Sprite;

import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.HorizontalPlawka;

public class SoftHardCurrency {
    private var _source:Sprite;
    private var _contSoft:CSprite;
    private var _contHard:CSprite;
    private var _txtSoft:TextField;
    private var _txtHard:TextField;
    private var g:Vars = Vars.getInstance();

    public function SoftHardCurrency() {
        _source = new Sprite();
        _contSoft = new CSprite();
        _contHard = new CSprite();
        _contSoft.endClickCallback = onClickSoft;
        _contSoft.hoverCallback = function ():void {
            g.hint.showIt("Монеты","0");
        };
        _contSoft.outCallback = function ():void {
            g.hint.hideIt();
        };
        _contHard.endClickCallback = onClickHard;
        _contHard.hoverCallback = function ():void {
            g.hint.showIt("Изумруды","0");
        };
        _contHard.outCallback = function ():void {
            g.hint.hideIt();
        };
        createPanel(true, _contSoft);
        createPanel(false, _contHard);
        _txtSoft =  new TextField(122, 38, '88888', g.allData.fonts['BloggerMedium'], 18, Color.WHITE);
        _txtSoft.nativeFilters = [new GlowFilter(0x4d3800, 1, 4, 4, 5)];
        _contSoft.addChild(_txtSoft);
        _txtHard =  new TextField(122, 38, '88888', g.allData.fonts['BloggerMedium'], 18, Color.WHITE);
        _txtHard.nativeFilters = [new GlowFilter(0x4d3800, 1, 4, 4, 5)];
        _contHard.addChild(_txtHard);

        _source.addChild(_contSoft);
        _contHard.y = 56;
        _source.addChild(_contHard);
        _source.x = 35;
        _source.y = 15;
        g.cont.interfaceCont.addChild(_source);
    }

    private function createPanel(isSoft:Boolean, p:CSprite):void {
        var im:Image;
        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), 122);
        p.addChild(pl);
        if (isSoft) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        } else {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        }
        MCScaler.scale(im, 50, 50);
        im.x = -im.width/2;
        im.y = -6;
        p.addChild(im);
        var btn:Sprite = new Sprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 46, 46);
        btn.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 24, 24);
        im.x = im.y = 11;
        btn.addChild(im);
        btn.x = 122 - btn.width/2;
        btn.y = -3;
        p.addChild(btn);
    }

    public function checkSoft():void {
       _txtSoft.text =  String(g.user.softCurrencyCount);
    }

    public function checkHard():void {
        _txtHard.text =  String(g.user.hardCurrency);
    }

    public function getHardCurrencyPoint():Point {
        return _contHard.localToGlobal(new Point(5, 5));
    }

    public function getSoftCurrencyPoint():Point {
        return _contSoft.localToGlobal(new Point(5, 5));
    }

    private function onClickSoft():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
        g.woBuyCurrency.showItMenu(false);
    }

    private function onClickHard():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
        g.woBuyCurrency.showItMenu(true);
    }
}
}
