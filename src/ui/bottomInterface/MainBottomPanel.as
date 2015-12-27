/**
 * Created by user on 6/24/15.
 */
package ui.bottomInterface {
import manager.ManagerFilters;
import manager.Vars;

import mouse.ToolsModifier;

import mouse.ToolsModifier;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;

import windows.WOComponents.HorizontalPlawka;
import windows.ambar.WOAmbars;

public class MainBottomPanel {
    private var _source:Sprite;
    private var _shopBtn:CButton;
    private var _toolsBtn:CButton;
    private var _optionBtn:CSprite;
    private var _cancelBtn:CButton;
    private var _doorBtn:CButton;
    private var _orderBtn:CButton;
    private var _ambarBtn:CButton;
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

        _toolsBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _toolsBtn.addDisplayObject(im);
        _toolsBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_tools'));
        im.x = 6;
        im.y = 6;
        _toolsBtn.addDisplayObject(im);
        _toolsBtn.x = 3 + _toolsBtn.width/2;
        _toolsBtn.y = 8 + _toolsBtn.height/2;
        _source.addChild(_toolsBtn);
        _toolsBtn.hoverCallback = function():void { g.hint.showIt("Редактирование карты"); };
        _toolsBtn.outCallback = function():void { g.hint.hideIt(); };
        _toolsBtn.clickCallback = function():void {onClick('tools')};

        _shopBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _shopBtn.addDisplayObject(im);
        _shopBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_shop'));
        im.x = 5;
        im.y = 4;
        _shopBtn.addDisplayObject(im);
        _shopBtn.x = 66 + _shopBtn.width/2;
        _shopBtn.y = 8 + _shopBtn.height/2;
        _source.addChild(_shopBtn);
        _shopBtn.hoverCallback = function():void { g.hint.showIt("Магазин"); };
        _shopBtn.outCallback = function():void { g.hint.hideIt(); };
        _shopBtn.clickCallback = function():void {onClick('shop')};

        _ambarBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _ambarBtn.addDisplayObject(im);
        _ambarBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_stor'));
        im.x = 5;
        im.y = 3;
        _ambarBtn.addDisplayObject(im);
        _ambarBtn.x = 129 + _ambarBtn.width/2;
        _ambarBtn.y = 8 + _ambarBtn.height/2;
        _source.addChild(_ambarBtn);
        _ambarBtn.hoverCallback = function():void { g.hint.showIt("Амбар/Склад"); };
        _ambarBtn.outCallback = function():void { g.hint.hideIt(); };
        _ambarBtn.clickCallback = function():void {onClick('ambar')};

        _orderBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _orderBtn.addDisplayObject(im);
        _orderBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_order'));
        im.x = 4;
        im.y = 0;
        _orderBtn.addDisplayObject(im);
        _orderBtn.x = 192 + _orderBtn.width/2;
        _orderBtn.y = 8 + _orderBtn.height/2;
        _source.addChild(_orderBtn);
        _orderBtn.hoverCallback = function():void { g.hint.showIt("Заказы"); };
        _orderBtn.outCallback = function():void { g.hint.hideIt(); };
        _orderBtn.clickCallback = function():void {onClick('order')};

        _cancelBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _cancelBtn.addDisplayObject(im);
        _cancelBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_canc'));
        im.x = 4;
        im.y = 3;
        _cancelBtn.addDisplayObject(im);
        _cancelBtn.x = 3 + _cancelBtn.width/2;
        _cancelBtn.y = 8 + _cancelBtn.height/2;
        _source.addChild(_cancelBtn);
        _cancelBtn.hoverCallback = function():void {g.hint.showIt("Отменить");};
        _cancelBtn.outCallback = function():void { g.hint.hideIt(); };
        _cancelBtn.clickCallback = function():void {onClick('cancel')};
        _cancelBtn.visible = false;

        _doorBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_home'));
        im.width = 260;
        _doorBtn.addDisplayObject(im);
        _doorBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_home'));
        im.x = 60;
        im.y = 6;
        _doorBtn.addDisplayObject(im);
        var txt:TextField = new TextField(100, 70, "Домой", g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_ORANGE;
        txt.x = 105;
        _doorBtn.addChild(txt);
        _doorBtn.flatten();
        _doorBtn.x = 0 + _doorBtn.width/2;
        _doorBtn.y = 2 + _doorBtn.height/2;
        _source.addChild(_doorBtn);
        _doorBtn.hoverCallback = function():void { g.hint.showIt("Домой") };
        _doorBtn.outCallback = function():void { g.hint.hideIt() };
        _doorBtn.clickCallback = function():void {onClick('door')};
        _doorBtn.visible = false;

        _optionBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('op_bt_opt'));
        _optionBtn.addChild(im);
        _optionBtn.x = 214;
        _optionBtn.y = -70;
        _source.addChild(_optionBtn);
        _optionBtn.hoverCallback = function():void { g.hint.showIt("Настройки"); };
        _optionBtn.outCallback = function():void { g.hint.hideIt(); };
        _optionBtn.endClickCallback = function():void {onClick('option')};
    }

    private function onClick(reason:String):void {
        switch (reason) {
            case 'shop':
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                g.woShop.showIt();
                break;
            case 'cancel':
                if (g.toolsPanel.isShowed) {
                    if (g.toolsPanel.repositoryBoxVisible) {
                        g.toolsPanel.hideRepository();
                    } else {
                        _toolsBtn.visible = true;
                        _cancelBtn.visible = false;
                        g.friendPanel.showIt();
                        g.toolsPanel.hideIt();
                    }
                }
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    _toolsBtn.visible = true;
                    _cancelBtn.visible = false;
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.toolsModifier.cancelMove();
                }
                break;
            case 'tools':
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                g.friendPanel.hideIt();
                g.toolsPanel.showIt();
                _toolsBtn.visible = false;
                _cancelBtn.visible = true;
                break;
            case 'option':
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                if (g.optionPanel.isShowed) {
                     g.optionPanel.hideIt();
                 } else {
                     g.optionPanel.showIt();
                 }
                break;
            case 'order':
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                g.woOrder.showIt();
                break;
            case 'ambar':
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
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

    public function cancelBoolean(b:Boolean):void {
        _cancelBtn.visible = b;
        _toolsBtn.visible = !b;
    }

    public function doorBoolean(b:Boolean):void {
        _doorBtn.visible = b;
        _shopBtn.visible = !b;
        _ambarBtn.visible = !b;
        _orderBtn.visible = !b;
        _toolsBtn.visible = !b;
        _cancelBtn.visible = false;
    }
}
}
