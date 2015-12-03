/**
 * Created by user on 6/24/15.
 */
package ui.bottomInterface {
import manager.Vars;

import mouse.ToolsModifier;

import mouse.ToolsModifier;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.CSprite;

import windows.WOComponents.HorizontalPlawka;
import windows.ambar.WOAmbars;

public class MainBottomPanel {
    private var _source:Sprite;
    private var _shopBtn:CSprite;
    private var _toolsBtn:CSprite;
    private var _optionBtn:CSprite;
    private var _cancelBtn:CSprite;
    private var _doorBtn:CSprite;
    private var _orderBtn:CSprite;
    private var _ambarBtn:CSprite;
    private var g:Vars = Vars.getInstance();

    public function MainBottomPanel() {
        _source = new Sprite();
        onResize();
        g.cont.interfaceCont.addChild(_source);
        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_l'), g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_r'), 260);
        _source.addChild(pl);
        createBtns();
    }

    private function createBtns():void {
        var im:Image;

        _toolsBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _toolsBtn.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_tools'));
        im.x = 6;
        im.y = 6;
        _toolsBtn.addChild(im);
        _toolsBtn.flatten();
        _toolsBtn.x = 3;
        _toolsBtn.y = 8;
        _source.addChild(_toolsBtn);
        _toolsBtn.hoverCallback = function():void { g.hint.showIt("Редактирование карты", "0"); };
        _toolsBtn.outCallback = function():void { g.hint.hideIt(); };
        _toolsBtn.endClickCallback = function():void {onClick('tools')};

        _shopBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _shopBtn.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_shop'));
        im.x = 5;
        im.y = 4;
        _shopBtn.addChild(im);
        _shopBtn.flatten();
        _shopBtn.x = 66;
        _shopBtn.y = 8;
        _source.addChild(_shopBtn);
        _shopBtn.hoverCallback = function():void { g.hint.showIt("Магазин","0"); };
        _shopBtn.outCallback = function():void { g.hint.hideIt(); };
        _shopBtn.endClickCallback = function():void {onClick('shop')};

        _ambarBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _ambarBtn.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_stor'));
        im.x = 5;
        im.y = 3;
        _ambarBtn.addChild(im);
        _ambarBtn.flatten();
        _ambarBtn.x = 129;
        _ambarBtn.y = 8;
        _source.addChild(_ambarBtn);
        _ambarBtn.hoverCallback = function():void { g.hint.showIt("Амбар/Склад", "0"); };
        _ambarBtn.outCallback = function():void { g.hint.hideIt(); };
        _ambarBtn.endClickCallback = function():void {onClick('ambar')};

        _orderBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _orderBtn.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_order'));
        im.x = 4;
        im.y = 0;
        _orderBtn.addChild(im);
        _orderBtn.flatten();
        _orderBtn.x = 192;
        _orderBtn.y = 8;
        _source.addChild(_orderBtn);
        _orderBtn.hoverCallback = function():void { g.hint.showIt("Заказы", "0"); };
        _orderBtn.outCallback = function():void { g.hint.hideIt(); };
        _orderBtn.endClickCallback = function():void {onClick('order')};

        _cancelBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _cancelBtn.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_canc'));
        im.x = 4;
        im.y = 3;
        _cancelBtn.addChild(im);
        _cancelBtn.flatten();
        _cancelBtn.x = 3;
        _cancelBtn.y = 8;
        _source.addChild(_cancelBtn);
        _cancelBtn.hoverCallback = function():void {g.hint.showIt("Отменить","0");};
        _cancelBtn.outCallback = function():void { g.hint.hideIt(); };
        _cancelBtn.endClickCallback = function():void {onClick('cancel')};
        _cancelBtn.visible = false;

        _doorBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_home'));
        _doorBtn.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_home'));
        im.x = 71;
        im.y = 16;
        _doorBtn.addChild(im);
        _doorBtn.flatten();
        _doorBtn.x = 2;
        _doorBtn.y = 9;
        _source.addChild(_doorBtn);
        _doorBtn.hoverCallback = function():void { g.hint.showIt("Домой","0") };
        _doorBtn.outCallback = function():void { g.hint.hideIt() };
        _doorBtn.endClickCallback = function():void {onClick('door')};
        _doorBtn.visible = false;

        _optionBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('op_bt_opt'));
        _optionBtn.addChild(im);
        _optionBtn.x = 214;
        _optionBtn.y = -70;
        _source.addChild(_optionBtn);
        _optionBtn.hoverCallback = function():void { g.hint.showIt("Настройки","0"); };
        _optionBtn.outCallback = function():void { g.hint.hideIt(); };
        _optionBtn.endClickCallback = function():void {onClick('option')};
    }

    private function onClick(reason:String):void {
        switch (reason) {
            case 'shop':
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.woShop.showIt();
                break;
            case 'cancel':
                if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
                    _toolsBtn.visible = true;
                    _cancelBtn.visible = false;
                    g.friendPanel.showIt();
                    g.toolsPanel.hideIt();
                } else {
                    g.toolsModifier.cancelMove();
                    g.cont.contentCont.alpha = 1;
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                break;
            case 'tools':
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.friendPanel.hideIt();
                g.toolsPanel.showIt();
                _toolsBtn.visible = false;
                _cancelBtn.visible = true;
                break;
            case 'option':
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                if (g.optionPanel.isShowed) {
                     g.optionPanel.hideIt();
                 } else {
                     g.optionPanel.showIt();
                 }
                break;
            case 'order':
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.woOrder.showIt();
                break;
            case 'ambar':
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.woAmbars.showItWithParams(WOAmbars.AMBAR);
                break;
            case 'door':
                if (g.isAway) g.townArea.backHome();
                break;
        }
    }

    public function onResize():void {
        _source.x = Starling.current.nativeStage.stageWidth - 271;
        _source.y = Starling.current.nativeStage.stageHeight - 83;
    }

//    public function cancelBoolean(b:Boolean):void {
//        _cancelBtn.visible = b;
//        _shopBtn.visible = !b;
//    }

    public function doorBoolean(b:Boolean):void {
        _doorBtn.visible = b;
        _shopBtn.visible = !b;
        _ambarBtn.visible = !b;
        _orderBtn.visible = !b;
        _toolsBtn.visible = !b;
    }
}
}
