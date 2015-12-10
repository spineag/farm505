/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import data.DataMoney;

import flash.filters.GlowFilter;

import manager.ManagerFilters;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.Birka;

import windows.WOComponents.CartonBackground;

import windows.Window;
import windows.WOComponents.WindowBackground;

public class WOBuyCurrency extends Window{
    private var _tabSoft:Sprite;
    private var _cloneTabSoft:CSprite;
    private var _tabHard:Sprite;
    private var _cloneTabHard:CSprite;
    private var _contSoft:Sprite;
    private var _contHard:Sprite;
    private var _woBG:WindowBackground;
    private var _cartonBG:CartonBackground;
    private var _contCarton:Sprite;

    public function WOBuyCurrency() {
        _woWidth = 700;
        _woHeight = 560;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _contCarton = new Sprite();
        createExitButton(onClickExit);

        createTabs();
        _cartonBG = new CartonBackground(618, 398);
        _cartonBG.x = -350 + 42;
        _cartonBG.y = -280 + 114;
        _contCarton.addChild(_cartonBG);
        _contCarton.filter = ManagerFilters.SHADOW;
        _source.addChild(_contCarton);
        createLists();

        new Birka('ОБМЕННИК', _source, 700, 560);
    }

    private function createTabs():void {
        _tabHard = new Sprite();
        var carton:CartonBackground = new CartonBackground(255, 80);
        _tabHard.addChild(carton);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        MCScaler.scale(im, 55, 55);
        im.x = 27;
        im.y = 9;
        _tabHard.addChild(im);
        var txt:TextField = new TextField(160, 67, "Рубины", g.allData.fonts['BloggerBold'], 24, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 85;
        _tabHard.addChild(txt);
        _tabHard.x = -350 + 61;
        _tabHard.y = -280 + 46;
        _tabHard.flatten();
        _contCarton.addChild(_tabHard);

        _cloneTabHard = new CSprite();
        carton = new CartonBackground(255, 80);
        _cloneTabHard.addChild(carton);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        MCScaler.scale(im, 55, 55);
        im.x = 27;
        im.y = 9;
        _cloneTabHard.addChild(im);
        txt = new TextField(160, 67, "Рубины", g.allData.fonts['BloggerBold'], 24, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 85;
        _cloneTabHard.addChild(txt);
        _cloneTabHard.x = -350 + 61;
        _cloneTabHard.y = -280 + 49;
        _cloneTabHard.flatten();
        _cloneTabHard.endClickCallback = onClickHard;
        _source.addChild(_cloneTabHard);

        _tabSoft = new Sprite();
        carton = new CartonBackground(255, 80);
        _tabSoft.addChild(carton);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins"));
        MCScaler.scale(im, 55, 55);
        im.x = 27;
        im.y = 9;
        _tabSoft.addChild(im);
        txt = new TextField(160, 67, "Монеты", g.allData.fonts['BloggerBold'], 24, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 85;
        _tabSoft.addChild(txt);
        _tabSoft.x = -350 + 341;
        _tabSoft.y = -280 + 46;
        _tabSoft.flatten();
        _contCarton.addChild(_tabSoft);

        _cloneTabSoft = new CSprite();
        carton = new CartonBackground(255, 80);
        _cloneTabSoft.addChild(carton);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins"));
        MCScaler.scale(im, 55, 55);
        im.x = 27;
        im.y = 9;
        _cloneTabSoft.addChild(im);
        txt = new TextField(160, 67, "Монеты", g.allData.fonts['BloggerBold'], 24, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 85;
        _cloneTabSoft.addChild(txt);
        _cloneTabSoft.x = -350 + 341;
        _cloneTabSoft.y = -280 + 49;
        _cloneTabSoft.flatten();
        _cloneTabSoft.endClickCallback = onClickSoft;
        _source.addChild(_cloneTabSoft);
    }

    private function onClickHard():void {
        _contHard.visible = true;
        _contSoft.visible = false;
        _tabHard.visible = true;
        _cloneTabHard.visible = false;
        _cloneTabHard.filter = null;
        _tabSoft.visible = false;
        _cloneTabSoft.visible = true;
        _cloneTabSoft.filter = ManagerFilters.SHADOW;
    }

    private function onClickSoft():void {
        _contHard.visible = false;
        _contSoft.visible = true;
        _tabHard.visible = false;
        _cloneTabHard.visible = true;
        _cloneTabHard.filter = ManagerFilters.SHADOW;
        _tabSoft.visible = true;
        _cloneTabSoft.visible = false;
        _cloneTabSoft.filter = null;
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    public function showItMenu(showHard:Boolean):void {
        if (showHard) {
            onClickHard();
        } else {
            onClickSoft();
        }
        showIt();
    }

    private function createLists():void {
        var item:WOBuyCurrencyItem;
        var arrAdd:Array;
        var arrCost:Array;

        _contSoft = new Sprite();
        _contSoft.x = -350 + 45;
        _contSoft.y = -280 + 113;
        _source.addChild(_contSoft);
        _contHard = new Sprite();
        _contHard.x = -350 + 45;
        _contHard.y = -280 + 113;
        _source.addChild(_contHard);

        arrAdd = [220, 1100, 2500, 7000, 22000, 50000];
        arrCost = [1, 4, 9, 24, 69, 149];
        for (var i:int=0; i< arrAdd.length; i++) {
            item = new WOBuyCurrencyItem(DataMoney.SOFT_CURRENCY,arrAdd[i],"",arrCost[i]);
            item.source.x = 13;
            item.source.y = 12 + i*64;
            _contSoft.addChild(item.source);
        }

        arrAdd = [15, 45, 95, 185, 515, 1115];
        arrCost = [2, 5, 10, 19, 49, 99];
        for (i=0; i< arrAdd.length; i++) {
            item = new WOBuyCurrencyItem(DataMoney.HARD_CURRENCY,arrAdd[i],"",arrCost[i]);
            item.source.x = 13;
            item.source.y = 12 + i*64;
            _contHard.addChild(item.source);
        }
    }

}
}
