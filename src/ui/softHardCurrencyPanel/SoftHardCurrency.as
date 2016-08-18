/**
 * Created by user on 7/6/15.
 */
package ui.softHardCurrencyPanel {
import flash.filters.GlowFilter;
import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import mouse.ToolsModifier;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;

import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.HorizontalPlawka;
import windows.WindowsManager;

public class SoftHardCurrency {
    private var _source:Sprite;
    private var _contSoft:CSprite;
    private var _contHard:CSprite;
    private var _txtSoft:TextField;
    private var _txtHard:TextField;
    private var _imCoin:Image;
    private var _imHard:Image;
    private var _count:int;
    private var _animation:Boolean;
    private var g:Vars = Vars.getInstance();

    public function SoftHardCurrency() {
        _source = new Sprite();
        _contSoft = new CSprite();
        _contSoft.nameIt = 'panel_contSoft';
        _contHard = new CSprite();
        _contHard.nameIt = 'panel_contHard';
        _contSoft.endClickCallback = onClickSoft;
        _contSoft.hoverCallback = function ():void {
            g.hint.showIt("Монеты",'none',1);
        };
        _contSoft.outCallback = function ():void {
            g.hint.hideIt();
        };
        _contHard.endClickCallback = onClickHard;
        _contHard.hoverCallback = function ():void {
            g.hint.showIt("Рубины",'none',1);
        };
        _contHard.outCallback = function ():void {
            g.hint.hideIt();
        };
        createPanel(true, _contSoft, onClickSoft);
        createPanel(false, _contHard, onClickHard);
        _txtSoft =  new TextField(122, 38, '88888', g.allData.bFonts['BloggerBold18'], 18, Color.WHITE);
        _txtSoft.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _contSoft.addChild(_txtSoft);
        _txtHard =  new TextField(122, 38, '88888', g.allData.bFonts['BloggerBold18'], 18, Color.WHITE);
        _txtHard.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _contHard.addChild(_txtHard);

        _source.addChild(_contSoft);
        _contHard.y = 56;
        _source.addChild(_contHard);
        _source.x = 35;
        _source.y = 15;
        g.cont.interfaceCont.addChild(_source);
    }

    private function createPanel(isSoft:Boolean, p:CSprite, f:Function):void {
        var im:Image;
        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), 122);
        p.addChild(pl);
        pl.touchable = true;
        if (isSoft) {
            _imCoin = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
            MCScaler.scale(_imCoin, 50, 50);
            _imCoin.x = -_imCoin.width/2 + 15;
            _imCoin.y = 5;
            _imCoin.pivotX = 25;
            _imCoin.pivotY = 25;
            p.addChild(_imCoin);
        } else {
            _imHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            MCScaler.scale(_imHard, 50, 50);
            _imHard.x = -_imHard.width/2 + 15;
            _imHard.y = 5;
            _imHard.pivotX = 25;
            _imHard.pivotY = 25;
            p.addChild(_imHard);
        }
        var btn:CButton = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 46, 46);
        btn.addDisplayObject(im);
        btn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 24, 24);
        im.x = im.y = 11;
        btn.addChild(im);
        btn.x = 145 - btn.width/2;
        btn.y = 20;
        p.addChild(btn);
        btn.clickCallback = f;
    }

    public function checkSoft():void {
       _txtSoft.text =  String(g.user.softCurrencyCount);
    }

    public function checkHard():void {
        _txtHard.text =  String(g.user.hardCurrency);
    }

    public function getHardCurrencyPoint():Point {
        return _contHard.localToGlobal(new Point(14, 30));
    }

    public function getSoftCurrencyPoint():Point {
        return _contSoft.localToGlobal(new Point(14, 30));
    }

    private function onClickSoft():void {
        if (g.managerTutorial.isTutorial) return;
        if (g.managerCutScenes.isCutScene) return;
        if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
            g.toolsModifier.cancelMove();
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
        g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, false);
    }

    private function onClickHard():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
            g.toolsModifier.cancelMove();
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
        g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
    }

    public function animationBuy(hard:Boolean):void {
        var tween:Tween;
        if (hard) {
            tween = new Tween(_imHard, 0.3);
        } else {
            tween = new Tween(_imCoin, 0.3);
        }
        tween.scaleTo(1.5);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(0.5);
        g.starling.juggler.add(tween);

    }

}
}
