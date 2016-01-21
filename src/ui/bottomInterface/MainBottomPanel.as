/**
 * Created by user on 6/24/15.
 */
package ui.bottomInterface {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.ManagerFilters;
import manager.Vars;

import mouse.ToolsModifier;

import mouse.ToolsModifier;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import user.NeighborBot;

import user.Someone;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.HorizontalPlawka;
import windows.ambar.WOAmbars;

public class MainBottomPanel {
    private var _source:Sprite;
    private var _friendBoard:Sprite;
    private var _shopBtn:CButton;
    private var _toolsBtn:CButton;
    private var _optionBtn:CSprite;
    private var _cancelBtn:CButton;
    private var _doorBtn:CButton;
    private var _orderBtn:CButton;
    private var _ambarBtn:CButton;
    private var _checkImage:Image;
    private var _person:Someone;
    private var _ava:Image;
    private var g:Vars = Vars.getInstance();

    public function MainBottomPanel() {
        _source = new Sprite();
        onResize();
        _friendBoard = new Sprite();
        g.cont.interfaceCont.addChild(_friendBoard);
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
        _checkImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _checkImage.touchable = false;
        _checkImage.x = 18;
        _checkImage.y = 20;
        _orderBtn.addChild(_checkImage);
        _checkImage.visible = false;
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
        _doorBtn.hoverCallback = function():void { g.hint.showIt("Вернутся домой") };
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
                    g.toolsPanel.hideRepository();
                g.woShop.showIt();
                break;
            case 'cancel':
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    _toolsBtn.visible = true;
                    _cancelBtn.visible = false;
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.toolsModifier.cancelMove();
                }
                if (g.toolsPanel.isShowed) {
                    if (g.toolsPanel.repositoryBoxVisible) {
                        _toolsBtn.visible = false;
                        _cancelBtn.visible = true;
                        g.toolsPanel.hideRepository();
                    } else {
                        _toolsBtn.visible = true;
                        _cancelBtn.visible = false;
                        g.friendPanel.showIt();
                        g.toolsPanel.hideIt();
                    }
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
                g.toolsPanel.hideRepository();
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
                g.toolsPanel.hideRepository();
                break;
            case 'order':
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                g.woOrder.showIt();
                g.toolsPanel.hideRepository();
                break;
            case 'ambar':
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                g.woAmbars.showItWithParams(WOAmbars.AMBAR);
                g.toolsPanel.hideRepository();

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

    public function doorBoolean(b:Boolean,person:Someone = null):void {
        _person = person;
        _doorBtn.visible = b;
        _shopBtn.visible = !b;
        _ambarBtn.visible = !b;
        _orderBtn.visible = !b;
        _toolsBtn.visible = !b;
        _cancelBtn.visible = false;
        if(b) {
            while (_friendBoard.numChildren) {
                _friendBoard.removeChildAt(0);
            }
            friendBoard();
        } else {
            while (_friendBoard.numChildren) {
                _friendBoard.removeChildAt(0);
            }
        }
    }

    public function checkIsFullOrder():void {
        _checkImage.visible = g.managerOrder.chekIsAnyFullOrder();
    }

    private function friendBoard():void {
        var im:Image;
        var txt:TextField;
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 71, 71);
        _ava.x = 9;
        _ava.y = 8;
        _friendBoard.addChild(_ava);
        if (_person is NeighborBot) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (_person.photo) {
                g.load.loadImage(_person.photo, onLoadPhoto);
            }
    }
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_board'));
        _friendBoard.x = Starling.current.nativeStage.stageWidth/2 - im.width/2;
        _friendBoard.addChild(im);
        txt = new TextField(150,40,_person.name,g.allData.fonts['BloggerBold'],18,ManagerFilters.TEXT_BROWN);
        txt.x = 90;
        txt.y = 20;
        _friendBoard.addChild(txt);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        im.x = 60;
        im.y = 50;
        MCScaler.scale(im,45,45);
        _friendBoard.addChild(im);
        txt = new TextField(50,50,String(_person.level),g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 57;
        txt.y = 49;
        _friendBoard.addChild(txt);
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            bitmap = g.pBitmaps[_person.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('FriendItem:: no photo for userId: ' + _person.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        _ava = new Image(tex);
        MCScaler.scale(_ava,71,71);
        _ava.x = 9;
        _ava.y = 8;
        _friendBoard.addChild(_ava);
    }
}
}
