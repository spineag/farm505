/**
 * Created by user on 6/24/15.
 */
package ui.bottomInterface {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.display.Bitmap;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;

import social.SocialNetworkSwitch;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import tutorial.miniScenes.ManagerMiniScenes;

import utils.CTextField;

import utils.SimpleArrow;
import tutorial.TutorialAction;
import tutorial.helpers.HelperReason;
import tutorial.managerCutScenes.ManagerCutScenes;

import user.NeighborBot;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.HorizontalPlawka;
import windows.WindowsManager;
import windows.ambar.WOAmbars;
import windows.serverError.WOServerError;
import windows.shop.WOShop;

public class MainBottomPanel {
    private var _source:Sprite;
    private var _friendBoard:Sprite;
    private var _friendBoardHelpInfo:Image;
    private var _shopBtn:CButton;
    private var _toolsBtn:CButton;
    private var _optionBtn:CSprite;
    private var _cancelBtn:CButton;
    private var _homeBtn:CButton;
    private var _orderBtn:CButton;
    private var _ambarBtn:CButton;
    private var _checkImage:Image;
    private var _checkSprite:Sprite;
    private var _person:Someone;
    private var _ava:Image;
    private var _tutorialCallback:Function;
    private var _arrow:SimpleArrow;
    private var _imNotification:Image;
    private var _txtNotification:CTextField;
    private var _txtHome:CTextField;
    public var _questBoolean:Boolean;
    public var _questBuilId:int = 0;
    private var _typeHelp:int = 0;

    private var g:Vars = Vars.getInstance();

    public function MainBottomPanel() {
        _questBoolean = false;
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
        _imNotification = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_m_big'));
        MCScaler.scale(_imNotification,25,25);
        _imNotification.x = 40;
        _imNotification.y = -5;
        _shopBtn.addChild(_imNotification);
        _txtNotification = new CTextField(30,20,'');
        _txtNotification.setFormat(CTextField.BOLD18, 14, Color.WHITE);
        _txtNotification.x = 38;
        _txtNotification.y = -4;
        _shopBtn.addChild(_txtNotification);
        _imNotification.visible = false;
        _txtNotification.visible = false;
        notification();
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
        _toolsBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[478])); };
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
        _shopBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[475])); };
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
        _ambarBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[132]) + "/" + String(g.managerLanguage.allTexts[133])); };
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
        _checkImage.x = -_checkImage.width/2;
        _checkImage.y = -_checkImage.height/2;
        _checkSprite = new Sprite();
        _checkSprite.addChild(_checkImage);
        _checkSprite.x = 18 + _checkImage.width/2;
        _checkSprite.y = 20 + _checkImage.height/2;
        _orderBtn.addChild(_checkSprite);
        _checkSprite.visible = false;
        _orderBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[476])); };
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
        _cancelBtn.hoverCallback = function():void {g.hint.showIt(String(g.managerLanguage.allTexts[477]));};
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
        _txtHome = new CTextField(100, 70, String(g.managerLanguage.allTexts[988]));
        _txtHome.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.ORANGE_COLOR);
        _txtHome.x = 105;
        _homeBtn.addChild(_txtHome);
        _homeBtn.x = 0 + _homeBtn.width/2;
        _homeBtn.y = 2 + _homeBtn.height/2;
        _source.addChild(_homeBtn);
        _homeBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[479])) };
        _homeBtn.outCallback = function():void { g.hint.hideIt() };
        _homeBtn.clickCallback = function():void {onClick('door')};
        _homeBtn.visible = false;

        _optionBtn = new CSprite();
        _optionBtn.nameIt = 'optionBtn';
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('op_bt_opt'));
        _optionBtn.addChild(im);
        _optionBtn.x = 214;
        _optionBtn.y = -70;
        _source.addChild(_optionBtn);
        _optionBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[480])); };
        _optionBtn.outCallback = function():void { g.hint.hideIt(); };
        _optionBtn.endClickCallback = function():void {onClick('option')};
    }

    private function onClick(reason:String):void {
        if (_arrow) _arrow.deleteIt();
        switch (reason) {
            case 'shop':
                if (g.managerTutorial.isTutorial) {
                    if (g.managerTutorial.currentAction == TutorialAction.BUY_ANIMAL || g.managerTutorial.currentAction == TutorialAction.BUY_FABRICA
                            || g.managerTutorial.currentAction == TutorialAction.BUY_FARM || g.managerTutorial.currentAction == TutorialAction.BUY_CAT) {

                    } else if (g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE && g.managerTutorial.subStep == 2) {  // wo za bred???
                        g.managerCutScenes.checkCutSceneCallback();
                    } else {
                        return;
                    }
                } else if (g.managerCutScenes.isCutScene) {
                    if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_BUY_DECOR)) {

                    } else return;
                }
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    if (g.managerCutScenes.isCutScene) return;
                    g.toolsModifier.cancelMove();
                    cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                if (g.managerMiniScenes.isMiniScene) deleteArrow();    
                g.toolsPanel.hideRepository();
                var shopTab:int = WOShop.VILLAGE;
                if (g.managerTutorial.isTutorial) {
                    g.user.decorShiftShop = 0;
                    g.user.decorShop = false;
                    if (g.managerTutorial.currentAction == TutorialAction.BUY_ANIMAL) shopTab = WOShop.ANIMAL;
                    else if (g.managerTutorial.currentAction == TutorialAction.BUY_FABRICA) shopTab = WOShop.FABRICA;
                    else if (g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE) shopTab = WOShop.VILLAGE;
                    else if (g.managerTutorial.currentAction == TutorialAction.BUY_CAT) shopTab = WOShop.VILLAGE;
                    else if (g.managerTutorial.currentAction == TutorialAction.BUY_FARM) shopTab = WOShop.VILLAGE;
                } else if (g.managerCutScenes.isCutScene) {
                    shopTab = WOShop.DECOR;
                    g.managerCutScenes.checkCutSceneCallback();
                } else if (g.managerMiniScenes.isReason(ManagerMiniScenes.BUY_BUILD)) {
                    shopTab = WOShop.FABRICA;
                } else if (g.managerHelpers && g.managerHelpers.isActiveHelper) {
                    g.user.decorShiftShop = 0;
                    g.user.decorShop = false;
                    if (g.managerHelpers.activeReason.reason == HelperReason.REASON_BUY_ANIMAL) shopTab = WOShop.ANIMAL;
                    else if (g.managerHelpers.activeReason.reason == HelperReason.REASON_BUY_FABRICA) shopTab = WOShop.FABRICA;
                    else if (g.managerHelpers.activeReason.reason == HelperReason.REASON_BUY_FARM) shopTab = WOShop.VILLAGE;
                    else if (g.managerHelpers.activeReason.reason == HelperReason.REASON_BUY_HERO) shopTab = WOShop.VILLAGE;
                    else if (g.managerHelpers.activeReason.reason == HelperReason.REASON_BUY_RIDGE) shopTab = WOShop.VILLAGE;
                } else {
                    if (g.user.buyShopTab == WOShop.VILLAGE)
                    shopTab = WOShop.ANIMAL;
                }
                if (g.managerTutorial.isTutorial) {
                    if (_tutorialCallback != null) {
                        _tutorialCallback.apply();
                    }
                }
                if (_questBoolean) {
                    if (_typeHelp == HelperReason.REASON_BUY_ANIMAL) shopTab = WOShop.ANIMAL;
                }
                g.windowsManager.openWindow(WindowsManager.WO_SHOP, null, shopTab);
                if (g.managerHelpers && g.managerHelpers.isActiveHelper) {
                    g.managerHelpers.onOpenShop();
                }
                if (_questBoolean) {
                    _questBoolean = false;
                    (g.windowsManager.currentWindow as WOShop).deleteArrow();
                    if (_typeHelp == HelperReason.REASON_BUY_FABRICA ) {
                        (g.windowsManager.currentWindow as WOShop).openOnResource(_questBuilId);
                        (g.windowsManager.currentWindow as WOShop).addArrow(_questBuilId);
                    } else if (_typeHelp == HelperReason.REASON_BUY_HERO) {
                        (g.windowsManager.currentWindow as WOShop).addArrowAtPos(0);
                    } else if (_typeHelp == HelperReason.REASON_BUY_ANIMAL ) {
                        (g.windowsManager.currentWindow as WOShop).openOnResource(_questBuilId);
                        (g.windowsManager.currentWindow as WOShop).addArrow(_questBuilId);
                    }
                }
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'cancel':
                if (g.managerCutScenes.isCutScene) return;
                if (g.managerTutorial.isTutorial) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.toolsModifier.cancelMove();
                    g.buyHint.hideIt();
                } else {
                    cancelBoolean(false);
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
                g.managerHelpers.onUserAction();
                if (g.managerCutScenes.isCutScene)  {
                    if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_TO_INVENTORY_DECOR)) {
                        if (g.toolsModifier.modifierType != ToolsModifier.NONE) return;
                    } else if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_FROM_INVENTORY_DECOR)) {

                    } else return;
                }
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
                g.managerHelpers.onUserAction();
                if (g.managerCutScenes.isCutScene) return;
                if (g.managerTutorial.isTutorial) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    cancelBoolean(false);
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
                if (g.managerCutScenes.isCutScene) return;
                if (g.managerTutorial.isTutorial) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                g.windowsManager.openWindow(WindowsManager.WO_ORDERS, null);
                g.toolsPanel.hideRepository();
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'ambar':
                if (g.managerCutScenes.isCutScene) return;
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
                if (g.managerCutScenes.isCutScene) return;
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
        if (!_source) return;
        _source.x = g.managerResize.stageWidth - 271;
        _source.y = g.managerResize.stageHeight - 83;
    }

    public function onResizePanelFriend():void {
        if (_friendBoard) _friendBoard.x = g.managerResize.stageWidth/2 - 121;
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
        removeHelpIcon();
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

    public function onFullOrder(v:Boolean):void {
        if (v) {
            _checkSprite.visible = true;
            animateCheckSprite1();
        } else {
            _checkSprite.visible = false;
            TweenMax.killTweensOf(_checkSprite);
        }
    }

    private function friendBoard():void {
        var im:Image;
        var txt:CTextField;
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
        txt = new CTextField(150,40,_person.name);
        txt.setFormat(CTextField.BOLD18, 18, ManagerFilters.BROWN_COLOR);
        txt.x = 90;
        txt.y = 20;
        _friendBoard.addChild(txt);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        im.x = 60;
        im.y = 50;
        MCScaler.scale(im,45,45);
        _friendBoard.addChild(im);
        txt = new CTextField(50,50,String(_person.level));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        if (_person is NeighborBot) txt.text = '10';
        txt.x = 55;
        txt.y = 49;
        _friendBoard.addChild(txt);
    }

    public function addHelpIcon():void {
        // _person === g.visitedUser
        var sp:CSprite = new CSprite();
        if (_person && _person.needHelpCount > 0) {
            _friendBoardHelpInfo = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
            _friendBoardHelpInfo.x = 65;
            _friendBoardHelpInfo.y = 5;
            sp.addChild(_friendBoardHelpInfo);
            sp.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[481])); };
            sp.outCallback = function():void { g.hint.hideIt(); };
            _friendBoard.addChild(sp);
        }
    }

    public function removeHelpIcon():void {
        if (_friendBoardHelpInfo) {
            if (_friendBoard.contains(_friendBoardHelpInfo)) _friendBoard.removeChild(_friendBoardHelpInfo);
            _friendBoardHelpInfo.dispose();
            _friendBoardHelpInfo = null;
        }
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
        if (!tex) return;
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
    
    public function activateShopButtonHoverAnimation(v:Boolean):void {
        if (v) _shopBtn.releaseHoverAnimation();
            else _shopBtn.finishHoverAnimation();
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

    public function addArrow(btnName:String, t:Number = 0, resourceId:int = 0, typeId:int = 0):void {
        switch (btnName) {
            case 'shop':
                _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
                _arrow.animateAtPosition(_shopBtn.x, _shopBtn.y - _shopBtn.height/2 - 10);
                if (resourceId >= 1) {
                    _questBoolean = true;
                    _questBuilId = resourceId;
                    _typeHelp = typeId;
                }

                break;
            case 'home':
                _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
                _arrow.animateAtPosition(_homeBtn.x, _homeBtn.y - _homeBtn.height/2 - 10);
                break;
        }
        if (g.managerTutorial.isTutorial) {
            if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) _arrow.scaleIt(1.2);
                else _arrow.scaleIt(1.4);
        } else _arrow.scaleIt(.7);
        if (t) _arrow.activateTimer(t, deleteArrow);
    }

    public function deleteArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _questBoolean = false;
    }

    public function hideMainPanel():void { // for tutorial
        _source.x = g.managerResize.stageWidth - 271;
        _source.y = g.managerResize.stageHeight + 83;
        _source.visible = false;
    }

    public function animateShowingMainPanel():void { // for tutorial
        _source.visible = true;
        new TweenMax(_source, 1, {y:g.managerResize.stageHeight - 83, ease:Back.easeOut});
    }

    public function notification():void {
        if (g.user.allNotification == 0 && g.user.plantNotification + g.user.fabricaNotification + g.user.decorNotification + g.user.villageNotification > 0) {
            _imNotification.visible = true;
            _txtNotification.visible = true;
            g.user.allNotification = g.user.plantNotification + g.user.fabricaNotification + g.user.decorNotification + g.user.villageNotification;
            _txtNotification.text = String(g.user.allNotification);

        } else if (g.user.allNotification > 0 && g.user.plantNotification + g.user.fabricaNotification + g.user.decorNotification + g.user.villageNotification <= 0) {
            _imNotification.visible = true;
            _txtNotification.visible = true;
            _txtNotification.text = String(g.user.allNotification);
            createNotificateionItem();
        } else {
            _imNotification.visible = false;
            _txtNotification.visible = false;
        }
    }

    public function updateTextNotification():void {
        _txtNotification.text = String(g.user.plantNotification + g.user.fabricaNotification + g.user.decorNotification + g.user.villageNotification);
        if (g.user.plantNotification + g.user.fabricaNotification + g.user.decorNotification + g.user.villageNotification <= 0) {
            _imNotification.visible = false;
            _txtNotification.visible = false;
            g.user.allNotification = 0;
            g.directServer.updateUserNotification(null);
        }
    }

    private function createNotificateionItem():void {
        if (g.user.level < 5) return;
        var i:int;
        var arR:Array = g.allData.building;
        for (i = 0; i < arR.length; i++) {
            if (arR[i].buildType != BuildType.CHEST) {
                if (arR.buildType == BuildType.TREE || arR.buildType == BuildType.FARM || arR[i].buildType == BuildType.FABRICA) {
                    for (var k:int = 0; k < arR[i].blockByLevel.length; k++) {
                        if (g.user.level == arR[i].blockByLevel[k]) {
                            if (arR[i].buildType == BuildType.TREE) g.user.plantNotification++;
                            if (arR[i].buildType == BuildType.FARM) g.user.villageNotification++;
                            if (arR[i].buildType == BuildType.FABRICA) g.user.fabricaNotification++;
                        }
                    }
                } else if (g.user.level == arR[i].blockByLevel) {
                    if (arR[i].buildType != BuildType.CAVE && arR[i].buildType != BuildType.TRAIN && arR[i].buildType != BuildType.PAPER && arR[i].buildType != BuildType.DAILY_BONUS
                            && arR[i].buildType != BuildType.ORDER && arR[i].buildType != BuildType.MARKET) {
                        g.user.decorNotification++;
                    }
                }
            }
        }

        if (g.dataLevel.objectLevels[g.user.level].catCount > 0) {
            g.user.villageNotification++
        }
        if (g.dataLevel.objectLevels[g.user.level].ridgeCount > 0) {
            g.user.villageNotification++
        }
    }

    private function animateCheckSprite1():void {
        TweenMax.to(_checkSprite, .2, {scaleX:1.2, scaleY:1.2, onComplete: animateCheckSprite2, delay:3});
    }

    private function animateCheckSprite2():void {
        TweenMax.to(_checkSprite, .2, {scaleX:.95, scaleY:.95, onComplete: animateCheckSprite3});
    }

    private function animateCheckSprite3():void {
        TweenMax.to(_checkSprite, .2, {scaleX:1.2, scaleY:1.2, onComplete: animateCheckSprite4});
    }

    private function animateCheckSprite4():void {
        TweenMax.to(_checkSprite, .2, {scaleX:.95, scaleY:.95, onComplete: animateCheckSprite5});
    }

    private function animateCheckSprite5():void {
        TweenMax.to(_checkSprite, .1, {scaleX:1, scaleY:1, onComplete: animateCheckSprite1});
    }
}
}
