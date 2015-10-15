/**
 * Created by user on 7/6/15.
 */
package ui.softHardCurrencyPanel {
import flash.geom.Point;

import manager.Vars;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.display.Sprite;

import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

public class SoftHardCurrency {
    private var _source:Sprite;
    private var _contSoft:CSprite;
    private var _contHard:CSprite;
    private var _txtSoft:TextField;
    private var _txtHard:TextField;
    private var _imageSoft:Image;
    private var _imageHard:Image;
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
        g.cont.interfaceCont.addChild(_source);
        _imageSoft = new Image(g.interfaceAtlas.getTexture("soft_board"));
        _imageSoft.x = 5;
        _imageHard = new Image(g.interfaceAtlas.getTexture("hard_board"));
        _imageHard.x = 5;
        _imageHard.y = 60;
        _txtSoft = new TextField(100,100,"","Arial",18,Color.WHITE);
        _txtSoft.x = 90 - _txtSoft.width/2;
        _txtSoft.y = -17;
        _txtHard = new TextField(100,100,"","Arial",18,Color.WHITE);
        _txtHard.x = 85 - _txtHard.width/2;
        _txtHard.y = 35;
        _contSoft.addChild(_imageSoft);
        _contHard.addChild(_imageHard);
        _txtSoft.text = String(g.user.softCurrencyCount);
        _txtHard.text = String(g.user.hardCurrency);
        _contSoft.addChild(_txtSoft);
        _contHard.addChild(_txtHard);
        _source.addChild(_contHard);
        _source.addChild(_contSoft);
    }

    public function checkSoft():void {
       _txtSoft.text =  String(g.user.softCurrencyCount);
    }
//
//    public function addHard():void {
//
//    }
//
//    public function deleteHard():void {
//
//    }

    public function getHardCurrencyPoint():Point {
        var p:Point = new Point();
        p.x = _imageHard.x + 20;
        p.y = _imageHard.y + 10;
        p = _source.localToGlobal(p);
        return p;
    }

    public function getSoftCurrencyPoint():Point {
        var p:Point = new Point();
        p.x = _imageSoft.x + 20;
        p.y = _imageSoft.y + 10;
        p = _source.localToGlobal(p);
        return p;
    }

    public function checkHard():void {
        _txtHard.text =  String(g.user.hardCurrency);
    }

    private function onClickSoft():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
        g.woBuyCurrency.showItMenu();
        g.woBuyCurrency._contSoft.visible = true;
        g.woBuyCurrency._contHard.visible = false;
    }

    private function onClickHard():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
        g.woBuyCurrency.showItMenu();
        g.woBuyCurrency._contHard.visible = true;
        g.woBuyCurrency._contSoft.visible = false;
    }
}
}
