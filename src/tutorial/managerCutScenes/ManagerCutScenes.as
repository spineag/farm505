/**
 * Created by user on 4/28/16.
 */
package tutorial.managerCutScenes {
import build.WorldObject;
import build.decor.Decor;
import build.market.Market;
import build.paper.Paper;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import manager.Vars;

import mouse.ToolsModifier;

import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import tutorial.AirTextBubble;
import tutorial.CutScene;
import tutorial.DustRectangle;
import tutorial.SimpleArrow;
import tutorial.TutorialCat;

import windows.WindowsManager;
import windows.shop.WOShop;

public class ManagerCutScenes {
    public static const CAT_BIG:String = 'big';         // use class CatScene
    public static const CAT_SMALL:String = 'small';     // use class TutorialCat
    public static const CAT_AIR:String = 'air';         // use class AirTextBubble

    public static const REASON_NEW_LEVEL:int = 1;  // use after getting new level
    public static const REASON_STUPID_USER:int = 2;  // use if user do nothing at 4-9 levels during 30 seconds

    public static const ID_ACTION_SHOW_MARKET:int = 0;
    public static const ID_ACTION_SHOW_PAPPER:int = 1;
    public static const ID_ACTION_BUY_DECOR:int = 2;
    public static const ID_ACTION_TO_INVENTORY_DECOR:int = 3;
    public static const ID_ACTION_FROM_INVENTORY_DECOR:int = 4;

    private var g:Vars = Vars.getInstance();
    private var _properties:Array;
    private var _curCutScenePropertie:Object;
    private var _cat:TutorialCat;
    private var _cutScene:CutScene;
    private var _airBubble:AirTextBubble;
    private var _arrow:SimpleArrow;
    private var _dustRectangle:DustRectangle;
    private var _black:Sprite;
    private var _cutSceneResourceIDs:Array;
    private var _cutSceneBuildings:Array;
    private var _cutSceneCallback:Function;
    public var isCutScene:Boolean = false;

    public function ManagerCutScenes() {
        _properties = (new CutSceneProperties(this)).properties;
    }

    private function saveUserCutScenesData():void {
        g.directServer.updateUserCutScenesData();
    }

    public function checkAvailableCutScenes():void { // use this function only once at game start
        var countActions:int = _properties.length;
        if (g.user.cutScenes.length < countActions) {
            var l:int = countActions - g.user.cutScenes.length;
            while (l>0) {
                g.user.cutScenes.push(0);
                l--;
            }
        }
        for (l=0; l<countActions; l++) {
            if (g.user.cutScenes[l] == 0) { // if == 1 - its mean, that cutScene was showed
                if (_properties[l].level) {
                    if (_properties[l].level == g.user.level) {
                        _curCutScenePropertie = _properties[l];
                        checkTypeFunctions();
                        return;
                    } else {
                        continue;
                    }
                } else {
                    // ?? as example, maybe check by getting new building
                }
            }
        }
    }

    public function checkCutScene(reason:int):void {
        if (g.user.level < 5) return;
        var i:int;
        switch (reason) {
            case REASON_NEW_LEVEL:
                for (i=0; i<_properties.length; i++) {
                    if (_properties[i].reason == REASON_NEW_LEVEL && g.user.level == _properties[i].level && g.user.cutScenes[_properties[i].id_action] == 0) {
                        _curCutScenePropertie = _properties[i];
                        checkTypeFunctions();
                        return;
                    }
                }
                break;
        }
    }

    public function isType(id:int):Boolean {
        return id == _curCutScenePropertie.id_action;
    }

    private function checkTypeFunctions():void {
        switch (_curCutScenePropertie.id_action) {
            case ID_ACTION_SHOW_MARKET: releaseMarket(); break;
            case ID_ACTION_SHOW_PAPPER: releasePapper(); break;
            case ID_ACTION_BUY_DECOR: releaseDecor(); break;
            case ID_ACTION_TO_INVENTORY_DECOR: releaseToInventoryDecor(); break;
            case ID_ACTION_FROM_INVENTORY_DECOR: releaseFromInventoryDecor(); break;
        }
    }

    public function releaseMarket():void {
        isCutScene = true;
        _cutSceneBuildings = g.townArea.getCityObjectsByType(BuildType.MARKET);
        addCatToPos(20, 22);
        g.managerCats.goCatToPoint(_cat, new Point(44, 0), market_1);
        g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 50, _cutSceneBuildings[0].source.y + 50, false, 3);
    }

    private function market_1():void {
        _cat.flipIt(false);
        _cat.showBubble(_curCutScenePropertie.text);
        (_cutSceneBuildings[0] as Market).showArrow();
        _airBubble = new AirTextBubble();
        _cutSceneCallback = market_2;
    }

    private function market_2():void {
        _cutSceneCallback = null;
        _cat.hideBubble();
        (_cutSceneBuildings[0] as Market).hideArrow();
        _airBubble.showIt(_curCutScenePropertie.text2, g.cont.popupCont, Starling.current.nativeStage.stageWidth/2 - 150, Starling.current.nativeStage.stageHeight/2, market_3);
        _airBubble.showBtnParticles();
        _airBubble.showBtnArrow();
    }

    private function market_3():void {
        _airBubble.hideIt();
        _airBubble.deleteIt();
        _airBubble = null;
        g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
        g.user.cutScenes[0] = 1;
        saveUserCutScenesData();
        checkCutScene(REASON_NEW_LEVEL);
    }

    private function releasePapper():void {
        isCutScene = true;
        _cutSceneBuildings = g.townArea.getCityObjectsByType(BuildType.PAPER);
        if (_cat) {
            g.managerCats.goCatToPoint(_cat, new Point(41, 0), papper_1);
            g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 50, _cutSceneBuildings[0].source.y + 50, false, 1);
        } else {
            addCatToPos(20, 22);
            g.managerCats.goCatToPoint(_cat, new Point(41, 0), papper_1);
            g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 50, _cutSceneBuildings[0].source.y + 50, false, 3);
        }
    }

    private function papper_1():void {
        _cat.flipIt(false);
        _cat.showBubble(_curCutScenePropertie.text);
        (_cutSceneBuildings[0] as Paper).showArrow();
        _cutSceneCallback = papper_2;
    }

    private function papper_2():void {
        _cat.hideBubble();
        (_cutSceneBuildings[0] as Paper).hideArrow();
        papper_3();
    }

    private function papper_3():void {
        _cutSceneCallback = null;
        g.user.cutScenes[1] = 1;
        saveUserCutScenesData();
        if (_cat) {
            _cat.removeFromMap();
            _cat.deleteIt();
            _cat = null;
        }
        isCutScene = false;
    }

    private function releaseDecor():void {
        isCutScene = true;
        _cutScene = new CutScene();
        _cutScene.showIt(_curCutScenePropertie.text);
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _cutSceneCallback = decor_1;
    }

    private function decor_1():void {
        g.bottomPanel.deleteArrow();
        _cutScene.hideIt(deleteCutScene);
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _cutSceneCallback = decor_2;
    }

    private function decor_2():void {
        _cutSceneResourceIDs = [28];
        var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_cutSceneResourceIDs[0], true);
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        _cutSceneCallback = decor_3;
    }

    private function decor_3():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _cutSceneCallback = decor_4;
    }

    private function decor_4():void {
        _cutSceneCallback = null;
        g.user.cutScenes[2] = 1;
        saveUserCutScenesData();
        checkCutScene(REASON_NEW_LEVEL);
    }

    private function releaseToInventoryDecor():void {
        isCutScene = true;
        _cutSceneResourceIDs = [28];
        _cutSceneBuildings = g.townArea.getCityObjectsById(_cutSceneResourceIDs[0]);
        if (!_cutSceneBuildings.length) {
            Cc.error('no decor for CutScene');
            return;
        }
        g.bottomPanel.showToolsForCutScene();
        createDelay(.7, toInventory_1);
    }

    private function toInventory_1():void {
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curCutScenePropertie.text);
        var ob:Object = g.toolsPanel.getRepositoryBoxProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        g.toolsPanel.cutSceneCallback = toInventory_2;
    }

    private function toInventory_2():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        var pX:int = _cutSceneBuildings[0].posX - 2;
        var pY:int = _cutSceneBuildings[0].posY - 2;
        if (pX < 0 || pY < 0) {
            pX += 2;
            pY += 2;
        }
        g.cont.moveCenterToPos(pX, pY, false, .5);
        (_cutSceneBuildings[0] as Decor).showArrow();
        _cutSceneCallback = toInventory_3;
    }

    private function toInventory_3():void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        (_cutSceneBuildings[0] as Decor).hideArrow();
        _cutSceneBuildings = [];
        g.toolsPanel.hideRepository();
        _cutSceneCallback = null;
        g.user.cutScenes[3] = 1;
        saveUserCutScenesData();
        createDelay(.7, toInventory_4);
    }

    private function toInventory_4():void {
        checkCutScene(REASON_NEW_LEVEL);
    }

    private function releaseFromInventoryDecor():void {
        isCutScene = true;
        if (g.toolsPanel.isShowed) {
            fromInventory_1();
        } else {
            g.bottomPanel.showToolsForCutScene();
            createDelay(.7, fromInventory_1);
        }
    }

    private function fromInventory_1():void {
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curCutScenePropertie.text);
        var ob:Object = g.toolsPanel.getRepositoryBoxProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        g.toolsPanel.cutSceneCallback = fromInventory_2;
    }

    private function fromInventory_2():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _cutScene.hideIt(deleteCutScene);
        createDelay(.5, fromInventory_3);
    }

    private function fromInventory_3():void {
        var ob:Object = g.toolsPanel.getRepositoryBoxFirstItemProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        _cutSceneCallback = fromInventory_4;
    }

    private function fromInventory_4():void {
        g.toolsPanel.hideRepository();
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _cutSceneCallback = fromInventory_5;
    }

    private function fromInventory_5():void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _cutSceneBuildings = [];
        _cutSceneResourceIDs = [];
        _cutSceneCallback = null;
        g.user.cutScenes[4] = 1;
        saveUserCutScenesData();
        isCutScene = false;
    }



    public function isCutSceneResource(id:int):Boolean {
        return _cutSceneResourceIDs.indexOf(id) > -1;
    }

    public function checkCutSceneCallback():void {
        if (_cutSceneCallback != null) {
            _cutSceneCallback.apply();
        }
    }

    private function addCatToPos(_x:int, _y:int):void {
        if (!_cat) _cat = new TutorialCat();
        _cat.setPosition(new Point(_x, _y));
        _cat.addToMap();
    }

    private function playCatIdle():void {
        if (_cat) _cat.playDirectLabel('idle', false, null);
    }

    private function addBlack():void {
        if (!_black) {
            var q:Quad = new Quad(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, Color.BLACK);
            _black = new Sprite();
            _black.addChild(q);
            _black.alpha = .3;
            g.cont.popupCont.addChildAt(_black, 0);
        }
    }

    private function removeBlack():void {
        if (_black) {
            if (g.cont.popupCont.contains(_black)) g.cont.popupCont.removeChild(_black);
            _black.dispose();
            _black = null;
        }
    }

    private function deleteCutScene():void {
        if (_cutScene) {
            _cutScene.deleteIt();
            _cutScene = null;
        }
    }

    public function isCutSceneBuilding(wo:WorldObject):Boolean {
        return _cutSceneBuildings.indexOf(wo) > -1;
    }

    private function createDelay(delay:Number, f:Function):void {
        var func:Function = function():void {
            timer.removeEventListener(TimerEvent.TIMER, func);
            timer = null;
            if (f != null) {
                f.apply();
            }
        };
        var timer:Timer = new Timer(delay*1000, 1);
        timer.addEventListener(TimerEvent.TIMER, func);
        timer.start();
    }
}
}
