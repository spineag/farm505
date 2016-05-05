/**
 * Created by user on 6/24/15.
 */
package ui.bottomInterface {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.junkbyte.console.Cc;

import flash.display.Bitmap;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import tutorial.SimpleArrow;
import tutorial.TutorialAction;
import tutorial.managerCutScenes.ManagerCutScenes;

import user.NeighborBot;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.HorizontalPlawka;
import windows.WindowsManager;
import windows.ambar.WOAmbars;
import windows.shop.WOShop;

public class MainBottomPanel {
    private var _source:Sprite;
    private var _friendBoard:Sprite;
    private var _shopBtn:CButton;
    private var _toolsBtn:CButton;
    private var _optionBtn:CSprite;
    private var _cancelBtn:CButton;
    private var _homeBtn:CButton;
    private var _orderBtn:CButton;
    private var _ambarBtn:CButton;
    private var _checkImage:Image;
    private var _person:Someone;
    private var _ava:Image;
    private var _tutorialCallback:Function;
    private var _arrow:SimpleArrow;
    private var g:Vars = Vars.getInstance();

    public function MainBottomPanel() {
        _source = new Sprite();
        onResize();
        _friendBoard = new Sprite();
        onResizePanelFriend();
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

        _homeBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_home'));
        im.width = 260;
        _homeBtn.addDisplayObject(im);
        _homeBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_home'));
        im.x = 60;
        im.y = 6;
        _homeBtn.addDisplayObject(im);
        var txt:TextField = new TextField(100, 70, "Домой", g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_ORANGE;
        txt.x = 105;
        _homeBtn.addChild(txt);
        _homeBtn.flatten();
        _homeBtn.x = 0 + _homeBtn.width/2;
        _homeBtn.y = 2 + _homeBtn.height/2;
        _source.addChild(_homeBtn);
        _homeBtn.hoverCallback = function():void { g.hint.showIt("Вернутся домой") };
        _homeBtn.outCallback = function():void { g.hint.hideIt() };
        _homeBtn.clickCallback = function():void {onClick('door')};
        _homeBtn.visible = false;

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
                if (g.managerTutorial.isTutorial) {
                    if (g.managerTutorial.currentAction == TutorialAction.BUY_ANIMAL || g.managerTutorial.currentAction == TutorialAction.BUY_FABRICA
                            || g.managerTutorial.currentAction == TutorialAction.BUY_FARM || g.managerTutorial.currentAction == TutorialAction.BUY_CAT) {

                    } else if (g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE && g.managerTutorial.subStep == 2) {
                        g.managerCutScenes.checkCutSceneCallback();
                    } else {
                        return;
                    }
                } else if (g.managerCutScenes.isCutScene) {
                    if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_BUY_DECOR)) {

                    } else return;
                }
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                g.toolsPanel.hideRepository();
                var shopTab:int = WOShop.VILLAGE;
                if (g.managerTutorial.isTutorial) {
                    if (g.managerTutorial.currentAction == TutorialAction.BUY_ANIMAL) shopTab = WOShop.ANIMAL;
                    else if (g.managerTutorial.currentAction == TutorialAction.BUY_FABRICA) shopTab = WOShop.FABRICA;
                    else if (g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE) shopTab = WOShop.VILLAGE;
                    else if (g.managerTutorial.currentAction == TutorialAction.BUY_CAT) shopTab = WOShop.VILLAGE;
                    else if (g.managerTutorial.currentAction == TutorialAction.BUY_FARM) shopTab = WOShop.VILLAGE;
                } else if (g.managerCutScenes.isCutScene) {
                    shopTab = WOShop.DECOR;
                    g.managerCutScenes.checkCutSceneCallback();
                }

                g.windowsManager.openWindow(WindowsManager.WO_SHOP, null, shopTab);
                if (g.managerTutorial.isTutorial) {
                    if (_tutorialCallback != null) {
                        _tutorialCallback.apply();
                    }
                }
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'cancel':
                if (g.managerTutorial.isTutorial) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    _toolsBtn.visible = true;
                    _cancelBtn.visible = false;
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.toolsModifier.cancelMove();
                    g.buyHint.hideIt();
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
                if (g.managerTutorial.isTutorial) return;
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
                if (g.managerTutorial.isTutorial) return;
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
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'order':
                if (g.managerTutorial.isTutorial) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                g.windowsManager.openWindow(WindowsManager.WO_ORDERS, null);
                g.toolsPanel.hideRepository();
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'ambar':
                if (g.managerTutorial.isTutorial) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                if (g.user.lastVisitAmbar) g.windowsManager.openWindow(WindowsManager.WO_AMBAR, null, WOAmbars.AMBAR);
                else g.windowsManager.openWindow(WindowsManager.WO_AMBAR, null, WOAmbars.SKLAD);
                g.toolsPanel.hideRepository();
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'door':
                if (g.managerTutorial.isTutorial) {
                    if (g.managerTutorial.currentAction == TutorialAction.GO_HOME) {
                        g.managerTutorial.checkTutorialCallback();
                    } else return;
                }
                if (g.isAway) g.townArea.backHome();
                g.catPanel.visibleCatPanel(true);
                break;
        }
    }

    public function showToolsForCutScene():void {
        onClick('tools');
    }

    public function onResize():void {
        _source.x = Starling.current.nativeStage.stageWidth - 271;
        _source.y = Starling.current.nativeStage.stageHeight - 83;
    }

    public function onResizePanelFriend():void {
        _friendBoard.x = Starling.current.nativeStage.stageWidth/2 - 121;
    }

    public function cancelBoolean(b:Boolean):void {
        _cancelBtn.visible = b;
        _toolsBtn.visible = !b;
    }

    public function doorBoolean(b:Boolean,person:Someone = null):void {
        _person = person;
        _homeBtn.visible = b;
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

    public function getShopButtonProperties():Object {
        var obj:Object = {};
        obj.x = _shopBtn.x - _shopBtn.width/2;
        obj.y = _shopBtn.y - _shopBtn.height/2;
        var p:Point = new Point(obj.x, obj.y);
        p = _source.localToGlobal(p);
        obj.x = p.x;
        obj.y = p.y;
        obj.width = _shopBtn.width;
        obj.height = _shopBtn.height;
        return obj;
    }

    public function set tutorialCallback(f:Function):void {
        _tutorialCallback = f;
    }

    public function getBtnProperties(type:String):Object {
        var ob:Object = {};
        var p:Point = new Point();
        switch (type) {
            case 'home':
                p.x = 0;
                p.y = 0;
                p = _homeBtn.localToGlobal(p);
                ob.x = p.x;
                ob.y = p.y;
                ob.width = _homeBtn.width;
                ob.height = _homeBtn.height;
                return ob;
                break;
        }

        return ob;
    }

    public function addArrow(btnName:String):void {
        switch (btnName) {
            case 'shop':
                _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
                _arrow.animateAtPosition(_shopBtn.x, _shopBtn.y - _shopBtn.height/2 - 10);
                _arrow.scaleIt(.7);
                break;
            case 'home':
                _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
                _arrow.animateAtPosition(_homeBtn.x, _homeBtn.y - _homeBtn.height/2 - 10);
                _arrow.scaleIt(.7);
        }
    }

    public function deleteArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function hideMainPanel():void { // for tutorial
        _source.x = Starling.current.nativeStage.stageWidth - 271;
        _source.y = Starling.current.nativeStage.stageHeight + 83;
        _source.visible = false;
    }

    public function animateShowingMainPanel():void { // for tutorial
        _source.visible = true;
        new TweenMax(_source, 1, {y:Starling.current.nativeStage.stageHeight - 83, ease:Back.easeOut});
    }

}
}
