/**
 * Created by user on 2/29/16.
 */
package tutorial {
import analytic.AnalyticManager;

import build.WorldObject;
import build.chestBonus.Chest;
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.farm.Farm;
import build.market.Market;
import build.ridge.Ridge;
import build.tutorialPlace.TutorialPlace;
import com.junkbyte.console.Cc;
import data.BuildType;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import heroes.OrderCat;
import manager.Vars;
import mouse.ToolsModifier;
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import tutorial.pretuts.TutorialCloud;

import tutorial.pretuts.TutorialMult;

import windows.WindowsManager;
import windows.fabricaWindow.WOFabrica;
import windows.market.WOMarket;
import windows.orderWindow.WOOrder;
import windows.shop.WOShop;

public class ManagerTutorial {
    private var TUTORIAL_ON:Boolean = true;

    private const MAX_STEPS:uint = 100;
    private var g:Vars = Vars.getInstance();
    private var cat:TutorialCat;
    private var cutScene:CutScene;
    private var _subStep:int;
    private var texts:Object;
    private var black:Sprite;
    private var _tutorialObjects:Array;
    private var _currentAction:int;
    private var _tutorialResourceIDs:Array;
    private var _dustRectangle:DustRectangle;
    private var _tutorialCallback:Function;
    private var _onShowWindowCallback:Function;
    private var _airBubble:AirTextBubble;
    private var _counter:int;
    private var _tutorialPlaceBuilding:TutorialPlace;
    private var _arrow:SimpleArrow;
    private var _cloud:TutorialCloud;
    private var _mult:TutorialMult;

    public function ManagerTutorial() {
        _tutorialObjects = [];
        _currentAction = TutorialAction.NONE;
        _tutorialResourceIDs = [];
    }

    public function checkTutorialCallback():void {
        if (_tutorialCallback != null) {
            _tutorialCallback.apply();
        }
    }

    public function checkTutorialCallbackOnShowWindow():void {
        if (_onShowWindowCallback != null) {
            _onShowWindowCallback.apply();
        }
    }

    public function get currentAction():int {
        return _currentAction;
    }

    public function get subStep():int {
        return _subStep;
    }

    public function isTutorialResource(id:int):Boolean {
        return _tutorialResourceIDs.indexOf(id) > -1;
    }

    public function get isTutorial():Boolean {
        return TUTORIAL_ON && g.user.tutorialStep < MAX_STEPS;
    }

    private function updateTutorialStep():void {
        g.directServer.updateUserTutorialStep(null);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.ACTION_TUTORIAL, {id:g.user.tutorialStep});
    }

    public function initScenes():void {
        var curFunc:Function;
//        try {
            switch (g.user.tutorialStep) {
                case 1:
                    curFunc = initScene_1;
                    break;
                case 2:
                    curFunc = initScene_2;
                    break;
                case 3:
                    curFunc = initScene_3;
                    break;
                case 4:
                    curFunc = initScene_4;
                    break;
                case 5:
                    curFunc = initScene_5;
                    break;
                case 6:
                    curFunc = initScene_6;
                    break;
                case 7:
                    curFunc = initScene_7;
                    break;
                case 8:
                    curFunc = initScene_8;
                    break;
                case 9:
                    curFunc = initScene_9;
                    break;
                case 10:
                    curFunc = initScene_10;
                    break;
                case 11:
                    curFunc = initScene_11;
                    break;
                case 12:
                    curFunc = initScene_12;
                    break;
                case 13:
                    curFunc = initScene_13;
                    break;
                case 14:
                    curFunc = initScene_14;
                    break;
                case 15:
                    curFunc = initScene_15;
                    break;
                case 16:
                    curFunc = initScene_16;
                    break;
                case 17:
                    curFunc = initScene_17;
                    break;
                case 18:
                    curFunc = initScene_18;
                    break;
                case 19:
                    curFunc = initScene_19;
                    break;
                case 20:
                    curFunc = initScene_20;
                    break;
                case 21:
                    curFunc = initScene_21;
                    break;
                case 22:
                    curFunc = initScene_22;
                    break;
                case 23:
                    curFunc = initScene_23;
                    break;
                case 24:
                    curFunc = initScene_24;
                    break;
                case 25:
                    curFunc = initScene_25;
                    break;
                case 26:
                    curFunc = initScene_26;
                    break;

            }
            if (curFunc != null) {
                curFunc.apply();
            }
//        } catch (err:Error) {
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'tutorial');
//            Cc.error("Tutorial crashed at step #" + String(g.user.tutorialStep) + " and subStep #" + String(_subStep) + " with error message " + err.message);
//        }
    }

    private function initScene_1():void {
        _cloud = new TutorialCloud(subStep1_1);
        _mult = new TutorialMult();
    }

    private function subStep1_1():void {
        g.startPreloader.hideIt();
        g.startPreloader = null;
        _subStep = 1;
        if (!texts) texts = (new TutorialTexts()).objText;
        _cloud.showText(texts[g.user.tutorialStep][_subStep], subStep1_2, 1);
    }

    private function subStep1_2():void {
        _subStep = 2;
        _cloud.showText(texts[g.user.tutorialStep][_subStep], subStep1_3, 2);
    }

    private function subStep1_3():void {
        _subStep = 3;
        _cloud.showText(texts[g.user.tutorialStep][_subStep], subStep1_4, 3);
    }

    private function subStep1_4():void {
        _subStep = 4;
        _cloud.showText(texts[g.user.tutorialStep][_subStep], subStep1_5, 4);
    }

    private function subStep1_5():void {
        _mult.showMult(subStep1_6, subStep1_7);
    }

    private function subStep1_6():void {
        _cloud.deleteIt();
        _cloud = null;
    }

    private function subStep1_7():void {
        _mult.deleteIt();
        _mult = null;
        g.user.tutorialStep = 2;
        updateTutorialStep();
        initScenes();
    }

    private function  initScene_2():void {
        _currentAction = TutorialAction.NONE;
        if (!cat) cat = new TutorialCat();
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        _subStep = 0;
        addCatToPos(30, 26);
        playCatIdle();
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['next'], subStep2_1, .5);
        addBlack();
    }

    private function subStep2_1():void {
        _subStep = 1;
        cutScene.reChangeBubble(texts[g.user.tutorialStep][_subStep], texts['lookAround'], emptyFunction, subStep2_2a, subStep2_2);
    }

    private function subStep2_2():void {
        if (g.isDebug) {
            g.optionPanel.makeFullScreen();
            g.optionPanel.makeResizeForGame();
            onResize();
            subStep2_2a();
        } else {
            try {
                var func:Function = function (e:flash.events.Event):void {
                    Starling.current.nativeStage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, func);
                    g.optionPanel.makeFullScreen();
                    g.optionPanel.makeResizeForGame();
                    onResize();
                    subStep2_2a();
                };
                Starling.current.nativeStage.addEventListener(flash.events.MouseEvent.MOUSE_UP, func);
            } catch (e:Error) {
                Cc.ch('tutorial', 'Error:: Trouble with fullscreen: ' + e.message);
                subStep2_2a();
            }
        }
    }

    private function subStep2_2a():void {
        _subStep = 2;
        cutScene.hideIt(deleteCutScene, initScenes);
        removeBlack();
        g.user.tutorialStep = 3;
        updateTutorialStep();
    }

    private function initScene_3():void {
        _subStep = 0;
        _counter = 0;
        if (!cat) {
            addCatToPos(30, 26);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        var p:Point = new Point();
        p.x = (_tutorialObjects[0] as WorldObject).posX;
        p.y = (_tutorialObjects[0] as WorldObject).posY;
        g.cont.moveCenterToPos(p.x, p.y, false, 2);
        p.x -= 1;
        p.y += 2;
        g.managerCats.goCatToPoint(cat, p, subStep3_1);
    }

    private function subStep3_1():void {
        _subStep = 1;
        g.optionPanel.makeScaling(1);
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        _currentAction = TutorialAction.CRAFT_RIDGE;
        for (var i:int=0; i<_tutorialObjects.length; i++) {
            if (!(_tutorialObjects[i] as Ridge).isFreeRidge) {
                _counter++;
                (_tutorialObjects[i] as WorldObject).showArrow();
                (_tutorialObjects[i] as WorldObject).tutorialCallback = subStep3_2;
            }
        }
    }

    private function subStep3_2(wo:WorldObject):void {
        _subStep = 2;
        _counter--;
        wo.hideArrow();
        wo.tutorialCallback = null;
        cat.hideBubble();
        if (_counter <= 0) {
            _currentAction = TutorialAction.NONE;
            subStep3_3();
        }
    }

    private function subStep3_3():void {
        _subStep = 3;
        _tutorialObjects = [];
        cat.playDirectLabel('idle4', true, subStep3_4);
    }

    private function subStep3_4():void {
        _subStep = 4;
        g.user.tutorialStep = 4;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_4():void {
        _currentAction = TutorialAction.NONE;
        _subStep = 0;
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int=0; i<arr.length; i++) {
            if ((arr[i] as Ridge).isFreeRidge) _tutorialObjects.push(arr[i]);
        }
        if (!_tutorialObjects.length) {
            g.user.tutorialStep = 5;
            updateTutorialStep();
            initScenes();
            return;
        }
        _tutorialObjects.sortOn('posX', Array.NUMERIC);
        if (!cat) {
            addCatToPos((_tutorialObjects[0] as WorldObject).posX - 1, (_tutorialObjects[0] as WorldObject).posY + 2);
            g.cont.moveCenterToPos((_tutorialObjects[0] as WorldObject).posX, (_tutorialObjects[0] as WorldObject).posY, false, 1);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        subStep4_1();
    }

    private function subStep4_1():void {
        _subStep = 1;
        _currentAction = TutorialAction.PLANT_RIDGE;
        _tutorialResourceIDs = [31];
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as WorldObject).tutorialCallback = subStep4_2;
        _tutorialCallback = subStep4_1a;
    }

    private function subStep4_1a():void {
        cat.hideBubble();
        _tutorialCallback = null;
    }

    private function subStep4_2(r:WorldObject):void {
        _subStep = 2;
        _tutorialResourceIDs = [];
        r.hideArrow();
        r.tutorialCallback = null;
        _tutorialObjects.splice(_tutorialObjects.indexOf(r), 1);
        if (!_tutorialObjects.length) {
            subStep4_5();
        } else {
            (_tutorialObjects[0] as WorldObject).showArrow();
            (_tutorialObjects[0] as WorldObject).tutorialCallback = subStep4_3;
        }
    }

    private function subStep4_3(r:WorldObject):void {
        _subStep = 3;
        r.hideArrow();
        r.tutorialCallback = null;
        _tutorialObjects.splice(_tutorialObjects.indexOf(r), 1);
        if (!_tutorialObjects.length) {
            subStep4_5();
        } else {
            (_tutorialObjects[0] as WorldObject).showArrow();
            (_tutorialObjects[0] as WorldObject).tutorialCallback = subStep4_4;
        }
    }

    private function subStep4_4(r:WorldObject):void {
        r.hideArrow();
        r.tutorialCallback = null;
        _tutorialObjects = [];
        _subStep = 4;
        subStep4_5();
    }

    private function subStep4_5():void {
        _subStep = 5;
        _currentAction = TutorialAction.NONE;
        if (!cutScene) cutScene = new CutScene();
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['next'], subStep4_6, 0, 'tutorial_nyam');
        g.user.tutorialStep = 5;
        updateTutorialStep();
        addBlack();
    }

    private function subStep4_6():void {
        removeBlack();
        _subStep = 6;
        cutScene.hideIt(deleteCutScene, initScenes);
        g.toolsModifier.modifierType = ToolsModifier.NONE;
    }

    private function initScene_5():void {
        _currentAction = TutorialAction.NONE;
        _subStep = 0;
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(30, 11);
            g.cont.moveCenterToPos(28, 11, true);
            subStep5_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(30, 11), subStep5_1);
            g.cont.moveCenterToPos(28, 11, false, 2);
        }
    }

    private function subStep5_1():void {
        var i:int;
        _subStep = 1;
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
        if ((arr[0] as Farm).isAnyCrafted) {
            arr = (arr[0] as Farm).arrAnimals;
            for (i = 0; i<arr.length; i++) {
                if ((arr[i] as Animal).state == Animal.CRAFT) {
                    _tutorialObjects.push(arr[i]);
                    subStep5_6();
                    return;
                }
            }
        } else {
            arr = (arr[0] as Farm).arrAnimals;
            for (i = 0; i<arr.length; i++) {
                if ((arr[i] as Animal).state == Animal.WORK) {
                    _tutorialObjects.push(arr[i]);
                    subStep5_3a();
                    return;
                }
            }

            _tutorialObjects.push(arr[0]);
            cat.flipIt(true);
            cat.playDirectLabel('idle3', true, playCatIdle);
            cat.showBubble(texts[g.user.tutorialStep][_subStep]);
            subStep5_2();
        }
    }

    private function subStep5_2():void {
        _subStep = 2;
        _currentAction = TutorialAction.ANIMAL_FEED;
        (_tutorialObjects[0] as Animal).playDirectIdle();
        (_tutorialObjects[0] as Animal).addArrow();
        (_tutorialObjects[0] as Animal).tutorialCallback = subStep5_3;
    }

    private function subStep5_3(chick:Animal):void {
        cat.hideBubble();
        chick.removeArrow();
        chick.tutorialCallback = null;
        subStep5_3a();
    }

    private function subStep5_3a():void {
        _currentAction = TutorialAction.NONE;
        _subStep = 3;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.flipIt(true);
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        subStep5_4();
    }

    private function subStep5_4():void {
        _subStep = 4;
        _currentAction = TutorialAction.ANIMAL_SKIP;
        (_tutorialObjects[0] as Animal).playDirectIdle();
        (_tutorialObjects[0] as Animal).addArrow();
        (_tutorialObjects[0] as Animal).tutorialCallback = subStep5_5;
    }

    private function subStep5_5(chick:Animal):void {
        cat.hideBubble();
        chick.tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        _subStep = 5;
        createDelay(.3, subStep5_6);
    }

    private function subStep5_6():void {
        _subStep = 6;
        cat.flipIt(true);
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        _currentAction = TutorialAction.ANIMAL_CRAFT;
        (_tutorialObjects[0] as Animal).farm.addArrowToCraftItem(subStep5_7);
    }

    private function subStep5_7():void {
        cat.hideBubble();
        _subStep = 7;
        _tutorialObjects = [];
        _currentAction = TutorialAction.LEVEL_UP;
        g.user.tutorialStep = 6;
        updateTutorialStep();
        _tutorialCallback = subStep5_8;
    }

    private function subStep5_8():void {
        initScenes();
    }

    private function initScene_6():void {
        _currentAction = TutorialAction.NONE;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(30, 11);
            playCatIdle();
            g.cont.moveCenterToPos(28, 11);
        }
        _subStep = 0;
        cat.playDirectLabel('aplouse', true, null);
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['next'], subStep6_1, 0);
        addBlack();
    }

    private function subStep6_1():void {
        _subStep = 1;
        cutScene.hideIt(deleteCutScene, initScenes);
        removeBlack();
        g.user.tutorialStep = 7;
        updateTutorialStep();
    }

    private function initScene_7():void {
        _currentAction = TutorialAction.NONE;
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(30, 11);
            g.cont.moveCenterToPos(28, 11);
        }
        _subStep = 0;
        cat.flipIt(true);
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        g.bottomPanel.animateShowingMainPanel();
        createDelay(1.1, subStep7_1);
    }

    private function subStep7_1():void {
        _subStep = 1;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _currentAction = TutorialAction.BUY_ANIMAL;
        _tutorialResourceIDs = [1];
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep7_2;
    }

    private function subStep7_2():void {
        g.bottomPanel.deleteArrow();
        cat.hideBubble();
        _subStep = 2;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _onShowWindowCallback = subStep7_3;
    }

    private function subStep7_3():void {
        _onShowWindowCallback = null;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
            _tutorialCallback = subStep7_4;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
    }

    private function subStep7_4():void {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
        if ((arr[0] as Farm).arrAnimals.length >= 4) {
            _tutorialCallback = null;
            subStep7_5();
        } else {
            _tutorialCallback = subStep7_5; // now we don't use this and buy only one chicken
        }
    }

    private function subStep7_5():void {
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        g.windowsManager.hideWindow(WindowsManager.WO_SHOP);

        if (!cutScene) cutScene = new CutScene();
        _subStep = 5;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['ok'], subStep7_6, 0, 'tutorial_ko');
        g.user.tutorialStep = 8;
        updateTutorialStep();
    }

    private function subStep7_6():void {
        cutScene.hideIt(deleteCutScene, initScenes);
        removeBlack();
    }

    private function initScene_8():void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _currentAction = TutorialAction.NONE;
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(30, 11);
            g.cont.moveCenterToPos(30, 11);
        }
        _subStep = 0;
        _tutorialResourceIDs = [3];
        _tutorialObjects = g.townArea.getCityObjectsById(_tutorialResourceIDs[0]);
        if (_tutorialObjects.length) {
            g.cont.moveCenterToPos(30, 11, false, 2);
            subStep8_4();
        } else {
            playCatIdle();
            if (!cutScene) {
                cutScene = new CutScene();
            }
            cutScene.showIt(texts[g.user.tutorialStep][_subStep]);
            _currentAction = TutorialAction.BUY_FABRICA;
            var ob:Object = g.bottomPanel.getShopButtonProperties();
            g.bottomPanel.addArrow('shop');
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            g.bottomPanel.tutorialCallback = subStep8_1;
        }
    }

    private function subStep8_1():void {
        _subStep = 1;
        cutScene.hideIt(deleteCutScene);
        g.bottomPanel.deleteArrow();
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _onShowWindowCallback = subStep8_2;
    }

    private function subStep8_2():void {
        _subStep = 2;
        _onShowWindowCallback = null;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
            _tutorialCallback = subStep8_3;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
        var dataPlace:Object = {};
        dataPlace.dataBuild = -1;
        dataPlace.buildType = BuildType.TUTORIAL_PLACE;
        dataPlace.width = g.dataBuilding.objectBuilding[_tutorialResourceIDs[0]].width;
        dataPlace.height = g.dataBuilding.objectBuilding[_tutorialResourceIDs[0]].height;
        _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
        var p:Point = new Point(10, 7);
        p = g.matrixGrid.getXYFromIndex(p);
        g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
    }

    private function subStep8_3():void {
        g.cont.moveCenterToPos(8, 9);
        _tutorialPlaceBuilding.activateIt(true);
        _currentAction = TutorialAction.PUT_FABRICA;
        _subStep = 3;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _tutorialCallback = subStep8_4;
    }

    private function subStep8_4():void {
        if (_tutorialPlaceBuilding) {
            _tutorialPlaceBuilding.activateIt(false);
            _tutorialPlaceBuilding = null;
        }
        _subStep = 4;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.cont.moveCenterToPos(9, 13);
        g.managerCats.goCatToPoint(cat, new Point(9,  13), subStep8_5);
    }

    private function subStep8_5():void {
        cat.flipIt(false);
        _currentAction = TutorialAction.PUT_FABRICA;
        _subStep = 5;
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        _tutorialCallback = subStep8_6;
        (_tutorialObjects[0] as Fabrica).showArrow();
    }

    private function subStep8_6():void {
        _subStep = 6;
        _tutorialResourceIDs = [];
        _currentAction = TutorialAction.NONE;
        (_tutorialObjects[0] as Fabrica).hideArrow();
        cat.hideBubble();
        cat.playDirectLabel('idle4', true, subStep8_7);
    }

    private function subStep8_7():void {
        _subStep = 7;
        g.user.tutorialStep = 9;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_9():void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _subStep = 0;
        _currentAction = TutorialAction.RAW_RECIPE;
        _tutorialResourceIDs = [1];
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.FABRICA);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(9, 13);
            g.cont.moveCenterToPos(9, 13, true);
        }
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        (_tutorialObjects[0] as Fabrica).showArrow();
        _tutorialCallback = subStep9_1;
    }

    private function subStep9_1():void {
        _subStep = 1;
        cat.hideBubble();
        cat.flipIt(false);
        (_tutorialObjects[0] as Fabrica).hideArrow();
        _tutorialCallback = subStep9_2;
    }

    private function subStep9_2():void {
        _subStep = 2;
        _tutorialCallback = null;
        _tutorialObjects = [];
        _tutorialResourceIDs = [];
        _currentAction = TutorialAction.NONE;
        g.windowsManager.hideWindow(WindowsManager.WO_FABRICA);
//        cat.playDirectLabel('idle2', true, subStep8_3);
        subStep9_3();
    }

    private function subStep9_3():void {
        _subStep = 3;
        cat.playDirectLabel('idle3', true, playCatIdle);
        g.user.tutorialStep = 10;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_10():void {
        _subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(19, 37);
            g.cont.moveCenterToPos(19, 37, true);
            subStep10_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(19, 37), subStep10_1);
            g.cont.moveCenterToPos(19, 37, false, 1.5);
        }
    }

    private function subStep10_1():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        _subStep = 1;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep]);
        subStep10_2();
    }

    private function subStep10_2():void {
        _subStep = 2;
        _currentAction = TutorialAction.NEW_RIDGE;
        _tutorialResourceIDs = [11];
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep10_3;
    }

    private function subStep10_3():void {
        g.bottomPanel.deleteArrow();
        cutScene.hideIt(deleteCutScene);
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _subStep = 3;
        _onShowWindowCallback = subStep10_4;
    }

    private function subStep10_4():void {
        _subStep = 4;
        _onShowWindowCallback = null;
        _tutorialObjects.length = 0;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
            var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
            for (var i:int=0; i<arr.length; i++) {
                if (arr[i].posY == 35) {
                    _tutorialObjects.push(arr[i]);
                }
            }
            if (!_tutorialObjects.length) {
                _tutorialCallback = subStep10_4a;
            } else if (_tutorialObjects.length == 1) {
                _tutorialCallback = subStep10_6a;
            } else {
                _tutorialCallback = subStep10_7a;
            }

            _tutorialObjects.length = 0;
            var dataPlace:Object = {};
            dataPlace.dataBuild = -1;
            dataPlace.buildType = BuildType.TUTORIAL_PLACE;
            dataPlace.width = 2;
            dataPlace.height = 2;
            _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
            var p:Point = new Point(21, 35);
            p = g.matrixGrid.getXYFromIndex(p);
            g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
            _tutorialObjects.push(_tutorialPlaceBuilding);

            _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
            p = new Point(23, 35);
            p = g.matrixGrid.getXYFromIndex(p);
            g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
            _tutorialObjects.push(_tutorialPlaceBuilding);

            _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
            p = new Point(25, 35);
            p = g.matrixGrid.getXYFromIndex(p);
            g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
            _tutorialObjects.push(_tutorialPlaceBuilding);
        } else {
            Cc.error('wo_SHOP is not opened');
        }
    }

    private function subStep10_4a():void {
        _tutorialPlaceBuilding = _tutorialObjects[0];
        g.cont.moveCenterToPos(21, 35);
        _tutorialPlaceBuilding.activateIt(true);
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        subStep10_5();
    }

    private function subStep10_5():void {
        _subStep = 5;
//        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        g.cont.moveCenterToPos(21, 35);
        _tutorialCallback = subStep10_6;
    }

    private function subStep10_6():void {
        _subStep = 6;
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        subStep10_6a();
    }

    private function subStep10_6a():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
//        if (!cat.isShowingBubble) cat.showBubble(texts[g.user.tutorialStep][5]);
        _tutorialPlaceBuilding = _tutorialObjects[1];
        g.cont.moveCenterToPos(23, 35);
        _tutorialPlaceBuilding.activateIt(true);
        _tutorialCallback = subStep10_7;
    }

    private function subStep10_7():void {
        _subStep = 7;
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        subStep10_7a();
    }

    private function subStep10_7a():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        g.cont.moveCenterToPos(25, 35);
        _tutorialPlaceBuilding = _tutorialObjects[2];
        _tutorialPlaceBuilding.activateIt(true);
        _tutorialCallback = subStep10_8;
    }

    private function subStep10_8():void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        _tutorialResourceIDs = [];
        _tutorialObjects = [];
        _subStep = 8;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 11;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_11():void {
        _subStep = 0;
        _currentAction = TutorialAction.NONE;
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int=0; i<arr.length; i++) {
            if (arr[i].posY == 35 && (arr[i] as Ridge).isFreeRidge) {
                _tutorialObjects.push(arr[i]);
            }
        }
        if (!_tutorialObjects.length) {
            subStep11_4();
            return;
        }
        _tutorialObjects.sortOn('posX', Array.NUMERIC);
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX - 2, _tutorialObjects[0].posY + 1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
            subStep11_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(_tutorialObjects[0].posX - 2, _tutorialObjects[0].posY + 1), subStep11_1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, false, 1);
        }
    }

    private function subStep11_1():void {
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.flipIt(false);
        _subStep = 1;
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        _tutorialResourceIDs = [32];
        _currentAction = TutorialAction.PLANT_RIDGE;
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as Ridge).tutorialCallback = subStep11_2;
        _tutorialCallback = subStep11_2a;
    }

    private function subStep11_2a():void {
        cat.hideBubble();
        cat.flipIt(true);
        _tutorialCallback = null;
    }

    private function subStep11_2(r:Ridge=null):void {
        _subStep = 2;
        _tutorialCallback = null;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialObjects.shift();
        if (!_tutorialObjects.length) {
            subStep11_4();
        } else {
            (_tutorialObjects[0] as WorldObject).showArrow();
            (_tutorialObjects[0] as Ridge).tutorialCallback = subStep11_3;
        }
    }

    private function subStep11_3(r:Ridge=null):void {
        _subStep = 3;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialObjects.shift();
        if (!_tutorialObjects.length) {
            subStep11_4();
        } else {
            (_tutorialObjects[0] as WorldObject).showArrow();
            (_tutorialObjects[0] as Ridge).tutorialCallback = subStep11_4;
        }
    }

    private function subStep11_4(r:Ridge=null):void {
        _subStep = 4;
        if (_tutorialObjects.length) (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialObjects.length = 0;
        _tutorialResourceIDs.length = 0;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        cat.playDirectLabel('idle4', true, subStep11_5);
    }

    private function subStep11_5():void {
        _subStep = 5;
        g.user.tutorialStep = 12;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_12():void {
        _subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(34, 28);
            g.cont.moveCenterToPos(31, 26, true);
            subStep12_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(34, 28), subStep12_1);
            g.cont.moveCenterToPos(31, 26, false, 2);
        }
    }

    private function subStep12_1():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        _currentAction = TutorialAction.ORDER;
        _subStep = 1;
        if (g.managerOrder.countOrders) {
            cat.flipIt(true);
            subStep12_5();
        } else {
            addBlack();
            cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['ok'], subStep12_2);
        }
    }

    private function subStep12_2():void {
        cutScene.hideIt(deleteCutScene);
        removeBlack();
        cat.flipIt(true);
        _subStep = 2;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        g.managerOrder.checkOrderForTutorial(subStep12_5);
        createDelay(3, subStep12_3);
    }

    private function subStep12_3():void {
        _subStep = 3;
        cat.hideBubble();
        g.cont.moveCenterToPos(40, 1, false, 2);
        createDelay(4, subStep12_4);
    }

    private function subStep12_4():void {
        _subStep = 4;
        g.cont.moveCenterToPos(31, 26, false, 3);
    }

    private function subStep12_5(rCat:OrderCat=null):void {
        _subStep = 5;
        subStep12_6();
    }

    private function subStep12_6():void {
        _subStep = 6;
        _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.ORDER);
        g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, false, 1);
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = subStep12_7;
    }

    private function subStep12_7():void {
        _subStep = 7;
        cat.flipIt(false);
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _onShowWindowCallback = subStep12_8;
    }

    private function subStep12_8():void {
        _subStep = 8;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_ORDERS) {
            (g.windowsManager.currentWindow as WOOrder).setTextForCustomer(texts[g.user.tutorialStep][_subStep]);
            var ob:Object = (g.windowsManager.currentWindow as WOOrder).getSellBtnProperties();
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height - 20, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_LEFT, g.cont.popupCont);
            _arrow.scaleIt(.5);
            _arrow.animateAtPosition(ob.x, ob.y + 25);
            _tutorialCallback = subStep12_9;
        } else {
            Cc.error('wo_order is not opened');
        }
    }

    private function subStep12_9():void {
        _currentAction = TutorialAction.NONE;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _subStep = 9;
        (g.windowsManager.currentWindow as WOOrder).setTextForCustomer(texts[g.user.tutorialStep][_subStep]);
        g.user.tutorialStep = 13;
        updateTutorialStep();
//        _tutorialCallback = subStep11_10;
//    }
//
//    private function subStep11_10():void {
//        _subStep = 10;
//        (g.windowsManager.currentWindow as WOOrder).hideIt();
        _currentAction = TutorialAction.LEVEL_UP;
        _tutorialCallback = subStep12_11;
    }

    private function subStep12_11():void {
        _subStep = 11;
        _tutorialObjects.length = 0;
        _tutorialResourceIDs.length = 0;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        initScenes();
    }

    private function initScene_13():void {
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(31, 26);
            g.cont.moveCenterToPos(31, 26, true);
        }
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        _subStep = 0;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep]);
        _tutorialResourceIDs = [1];
        _currentAction = TutorialAction.BUY_FABRICA;
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep13_1;
    }

    private function subStep13_1():void {
        _subStep = 1;
        g.bottomPanel.deleteArrow();
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        cutScene.hideIt(deleteCutScene);
        _onShowWindowCallback = subStep13_2;
    }

    private function subStep13_2():void {
        _subStep = 2;
        _onShowWindowCallback = null;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
            _tutorialCallback = subStep13_3;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
        var dataPlace:Object = {};
        dataPlace.dataBuild = -1;
        dataPlace.buildType = BuildType.TUTORIAL_PLACE;
        dataPlace.width = 5;
        dataPlace.height = 5;
        _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
        var p:Point = new Point(3, 7);
        p = g.matrixGrid.getXYFromIndex(p);
        g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
    }

    private function subStep13_3():void {
        _tutorialPlaceBuilding.activateIt(true);
        _subStep = 3;
        g.cont.moveCenterToPos(3, 7);
        _currentAction = TutorialAction.PUT_FABRICA;
        _tutorialCallback = subStep13_4;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    private function subStep13_4():void {
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        _subStep = 4;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 14;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_14():void {
        _subStep = 0;
        _currentAction = TutorialAction.NONE;
        _tutorialResourceIDs = [1];
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(1);
        }
        if ((_tutorialObjects[0] as Fabrica).stateBuild == WorldObject.STATE_WAIT_ACTIVATE) {
            subStep14_3();
            return;
        }
        if (!cat) {
            addCatToPos(2, 12);
            g.cont.moveCenterToPos(2, 12, true);
            subStep13_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(2, 12), subStep14_1);
            g.cont.moveCenterToPos(2, 12);
        }
    }

    private function subStep14_1():void {
        _currentAction = TutorialAction.FABRICA_SKIP_FOUNDATION;
        cat.flipIt(false);
        if (!texts) texts = (new TutorialTexts()).objText;
        _subStep = 1;
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = subStep14_2;
    }

    private function subStep14_2():void {
        _subStep = 2;
        cat.hideBubble();
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialCallback = subStep14_3;
    }

    private function subStep14_3():void {
        _subStep = 3;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 15;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_15():void {
        _currentAction = TutorialAction.PUT_FABRICA;
        _tutorialResourceIDs = [1];
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(1);
        }
        if (!cat) {
            addCatToPos(2, 12);
            g.cont.moveCenterToPos(2, 12, true);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.flipIt(false);
        _subStep = 0;
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = initScene15_1;
    }

    private function initScene15_1():void {
        _subStep = 1;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        cat.hideBubble();
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        cat.playDirectLabel('idle4', true, subStep15_2);
    }

    private function subStep15_2():void {
        g.user.tutorialStep = 16;
        _tutorialObjects.length = 0;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_16():void {
        _subStep = 0;
        _currentAction = TutorialAction.CRAFT_RIDGE;
        _tutorialResourceIDs = [31];
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int=0; i<arr.length; i++) {
            if ((arr[i] as Ridge).isFreeRidge) continue;
            if ((arr[i] as Ridge).plant.dataPlant.id == _tutorialResourceIDs[0]) {
                _tutorialObjects.push(arr[i]);
            }
        }
        _tutorialObjects.sortOn('depth', Array.NUMERIC);
        for (i=0; i<_tutorialObjects.length; i++) {
            (_tutorialObjects[i] as Ridge).forceGrowPlant();
        }

        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX - 2, _tutorialObjects[0].posY + 1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
            subStep16_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(_tutorialObjects[0].posX - 2, _tutorialObjects[0].posY + 1), subStep16_1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, false, 2);
        }
    }

    private function subStep16_1():void {
        if (!texts) texts = (new TutorialTexts()).objText;
        _subStep = 1;
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        for (var i:int=0; i<_tutorialObjects.length; i++) {
            (_tutorialObjects[i] as WorldObject).showArrow();
            (_tutorialObjects[i] as Ridge).tutorialCallback = subScene16_2;
        }
    }

    private function subScene16_2(r:WorldObject):void {
        _subStep = 2;
        cat.hideBubble();
        r.hideArrow();
        _tutorialObjects.splice(_tutorialObjects.indexOf(r), 1);
        if (!_tutorialObjects.length) {
            _tutorialCallback = null;
            _currentAction = TutorialAction.NONE;
            g.user.tutorialStep = 17;
            _tutorialResourceIDs.length = 0;
            updateTutorialStep();
            initScenes();
        }
    }

    private function initScene_17():void {
        _subStep = 0;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _currentAction = TutorialAction.NONE;
        if (!texts) texts = (new TutorialTexts()).objText;
        _tutorialObjects = g.townArea.getCityObjectsById(1);
        if (!cat) {
            addCatToPos(2, 11);
            g.cont.moveCenterToPos(2, 11, true);
            subStep16_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(2, 11), subStep17_1);
            g.cont.moveCenterToPos(2, 11, false, 1.5);
        }
    }

    private function subStep17_1():void {
        _tutorialResourceIDs = [6]; // recipeId
        _subStep = 1;
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = subStep17_2;
        _currentAction = TutorialAction.RAW_RECIPE;
    }

    private function subStep17_2():void {
        _subStep = 2;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        cat.hideBubble();
        cat.flipIt(true);
        _tutorialCallback = subStep17_3;
    }

    private function subStep17_3():void {
        subStep17_4();
    }

    private function subStep17_4():void {
        _subStep = 4;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 18;
        _tutorialResourceIDs.length = 0;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_18():void {
        _currentAction = TutorialAction.NONE;
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(1);
        }
        if ((_tutorialObjects[0] as Fabrica).isAnyCrafted) {
            subStep18_3();
        }
        if (!cat) {
            addCatToPos(2, 11);
            g.cont.moveCenterToPos(2, 11, true);
        }
        if (g.windowsManager.currentWindow) {
            if (g.windowsManager.currentWindow.windowType != WindowsManager.WO_FABRICA) {
                g.windowsManager.currentWindow.hideIt();
                (_tutorialObjects[0] as Fabrica).openFabricaWindow();
            }
        } else {
            (_tutorialObjects[0] as Fabrica).openFabricaWindow();
        }
        addBlack();
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cutScene) cutScene = new CutScene();
        _subStep = 0;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['ok'], subStep18_1, 0);
    }

    private function subStep18_1():void {
        _subStep = 1;
        _currentAction = TutorialAction.FABRICA_SKIP_RECIPE;
        cutScene.hideIt(deleteCutScene);
        removeBlack();
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_FABRICA) {
            var ob:Object = (g.windowsManager.currentWindow as WOFabrica).getSkipBtnProperties();
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_LEFT, g.cont.popupCont);
            _arrow.scaleIt(.5);
            _arrow.animateAtPosition(ob.x, ob.y + ob.height/2);
            _tutorialCallback = subStep18_2;
        } else {
            Cc.error('tuts:: WO_fabrica is not opened');
        }
    }

    private function subStep18_2():void {
        _subStep = 2;
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        (g.windowsManager.currentWindow as WOFabrica).hideIt();
        subStep18_3();
    }

    private function subStep18_3():void {
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 19;
        _tutorialResourceIDs.length = 0;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_19():void {
        _currentAction = TutorialAction.NONE;
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(1);
        }
        if (!cat) {
            addCatToPos(2, 11);
            g.cont.moveCenterToPos(2, 11, true);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cutScene) cutScene = new CutScene();
        _subStep = 0;
        cat.flipIt(false);
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        subStep19_1();
    }

    private function subStep19_1():void {
        _subStep = 1;
        _currentAction = TutorialAction.FABRICA_CRAFT;
        (_tutorialObjects[0] as Fabrica).addArrowToCraftItem(subStep19_2);
        _tutorialCallback = subStep19_2;
    }

    private function subStep19_2():void {
        _subStep = 2;
        cat.hideBubble();
        _tutorialObjects = [];
        _currentAction = TutorialAction.LEVEL_UP;
        _tutorialCallback = subStep19_3;
        g.user.tutorialStep = 20;
        _tutorialResourceIDs.length = 0;
        updateTutorialStep();
    }

    private function subStep19_3():void {
        _subStep = 3;
        _currentAction = TutorialAction.NONE;
        _tutorialCallback = null;
        cat.playDirectLabel('idle4', true, subStep19_4);
    }

    private function subStep19_4():void {
        initScenes();
    }

    private function initScene_20():void {
        _currentAction = TutorialAction.BUY_CAT;
        if (!cat) {
            addCatToPos(31, 28);
            g.cont.moveCenterToPos(31, 28, true);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cutScene) cutScene = new CutScene();
        _subStep = 0;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep]);
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep20_1;
    }

    private function subStep20_1():void {
        g.bottomPanel.deleteArrow();
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _subStep = 1;
        cutScene.hideIt(deleteCutScene);
        _onShowWindowCallback = subStep20_2;
    }

    private function subStep20_2():void {
        _subStep = 2;
        _onShowWindowCallback = null;
        var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopDirectItemProperties(1);
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        _tutorialCallback = subStep20_3;
    }

    private function subStep20_3():void {
        _subStep = 3;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _currentAction = TutorialAction.NONE;
        _tutorialCallback = null;
        g.user.tutorialStep = 21;
        updateTutorialStep();
        createDelay(2, subStep20_4);
    }

    private function subStep20_4():void {
        _subStep = 4;
        initScenes();
    }

    private function initScene_21():void {
        _subStep = 0;
        _currentAction = TutorialAction.BUY_FARM;
        if (!cat) {
            addCatToPos(31, 26);
            g.cont.moveCenterToPos(31, 26, true);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cutScene) cutScene = new CutScene();
        _subStep = 0;
        if (g.windowsManager.currentWindow) {
            if (g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
                addBlack();
                cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['ok'], subStep21_3);
            } else {
                g.windowsManager.currentWindow.hideIt();
                createDelay(.7, subStep21_1a);
            }
        } else {
            subStep21_1a();
        }
    }

    private function subStep21_1a():void {
        _subStep = 1;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep]);
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep21_2a;
    }

    private function subStep21_2a():void {
        _subStep = 2;
        cutScene.hideIt(deleteCutScene);
        g.bottomPanel.deleteArrow();
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _onShowWindowCallback = subStep21_4;
    }

    private function subStep21_3():void {
        _subStep = 3;
        removeBlack();
        cutScene.hideIt(deleteCutScene);
        subStep21_4();
    }

    private function subStep21_4():void {
        _subStep = 4;
        _tutorialResourceIDs = [39];
        _onShowWindowCallback = null;
        var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0], true);
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        _tutorialCallback = subStep21_5;
        var dataPlace:Object = {};
        dataPlace.dataBuild = -1;
        dataPlace.buildType = BuildType.TUTORIAL_PLACE;
        dataPlace.width = 8;
        dataPlace.height = 8;
        _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
        var p:Point = new Point(6, 19);
        p = g.matrixGrid.getXYFromIndex(p);
        g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
    }

    private function subStep21_5():void {
        _subStep = 5;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _currentAction = TutorialAction.PUT_FARM;
        _tutorialPlaceBuilding.activateIt(true);
        _tutorialCallback = subStep21_6;
        g.cont.moveCenterToPos(6, 19, false, 1);
    }

    private function subStep21_6():void {
        _subStep = 6;
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        _tutorialCallback = null;
        _tutorialObjects = [];
        _tutorialResourceIDs = [];
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 22;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_22():void {
        _subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(39);
        }
        if (!cat) {
            addCatToPos(8, 17);
            g.cont.moveCenterToPos(8, 17, true);
            subStep22_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(8, 17), subStep22_1);
            g.cont.moveCenterToPos(8, 17);
        }
    }

    private function subStep22_1():void {
        _subStep = 1;
        cat.flipIt(true);
        if (!texts) texts = (new TutorialTexts()).objText;
        _tutorialResourceIDs = [6];
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep22_2;
        _currentAction = TutorialAction.BUY_ANIMAL;
    }

    private function subStep22_2():void {
        g.bottomPanel.deleteArrow();
        cat.hideBubble();
        _subStep = 2;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _onShowWindowCallback = subStep22_3;
    }

    private function subStep22_3():void {
        _subStep = 3;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            (g.windowsManager.currentWindow as WOShop).openOnResource(_tutorialResourceIDs[0]);
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
            _tutorialCallback = subStep22_4;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
    }

    private function subStep22_4():void {
        _subStep = 4;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        createDelay(.7, subStep22_5);
    }

    private function subStep22_5():void {
        _subStep = 5;
        g.windowsManager.hideWindow(WindowsManager.WO_SHOP);
        g.user.tutorialStep = 23;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_23():void {
        _currentAction = TutorialAction.ANIMAL_FEED;
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(39);
        }
        if (!cat) {
            addCatToPos(8, 17);
            g.cont.moveCenterToPos(8, 17, true);
            cat.flipIt(true);
        }
        _subStep = 0;
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        subStep23_1();
    }

    private function subStep23_1():void {
        _subStep = 1;
        _tutorialObjects = (_tutorialObjects[0] as Farm).arrAnimals;
        (_tutorialObjects[0] as Animal).addArrow();
        (_tutorialObjects[0] as Animal).tutorialCallback = subStep23_2;
    }

    private function subStep23_2(bee:Animal):void {
        cat.hideBubble();
        _subStep = 2;
        bee.removeArrow();
        bee.tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        cat.playDirectLabel('idle4', true, subStep23_3);
    }

    private function subStep23_3():void {
        g.user.tutorialStep = 24;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_24():void {
        g.directServer.getUserNeighborMarket(null);
        _subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(31, 28);
            g.cont.moveCenterToPos(31, 28, true);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cutScene) cutScene = new CutScene();
        cutScene.showIt(texts[g.user.tutorialStep][_subStep]);
        _currentAction = TutorialAction.VISIT_NEIGHBOR;
        g.friendPanel.showIt();
        createDelay(1, subStep24_1);
    }

    private function subStep24_1():void {
        _subStep = 1;
        var ob:Object = g.friendPanel.getNeighborItemProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        _tutorialCallback = subStep24_2;
    }

    private function subStep24_2():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        cutScene.hideIt(deleteCutScene);
        _subStep = 2;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _tutorialCallback = subStep24_3;
    }

    private function subStep24_3():void {
        g.cont.moveCenterToPos(31, 28, true);
        _tutorialCallback = null;
        _subStep = 3;
        cutScene = new CutScene();
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['ok'], subStep24_4);
    }

    private function subStep24_4():void {
        _subStep = 4;
        if (cutScene) cutScene.hideIt(deleteCutScene);
        _tutorialObjects = g.townArea.getAwayCityObjectsById(44);
        (_tutorialObjects[0] as WorldObject).showArrow();
        g.cont.moveCenterToXY((_tutorialObjects[0] as Market).source.x-100, (_tutorialObjects[0] as Market).source.y, false, 1.5);
        _tutorialCallback = subStep24_5;
    }

    private function subStep24_5():void {
        _subStep = 5;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialResourceIDs = [124, 1, 5, 6, 125];
        createDelay(.7, subStep24_6);
    }

    private function subStep24_6():void {
        _subStep = 6;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_MARKET) {
            _airBubble = new AirTextBubble();
            _airBubble.showIt(texts[g.user.tutorialStep][_subStep], g.cont.popupCont, Starling.current.nativeStage.stageWidth/2 - 150, Starling.current.nativeStage.stageHeight/2);
            var ob:Object = (g.windowsManager.currentWindow as WOMarket).getItemProperties(1);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _tutorialCallback = subStep24_7;
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.5);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height);
        } else {
            Cc.error('wo_market is not opened');
        }
    }

    private function subStep24_7():void {
        _subStep = 7;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        g.user.tutorialStep = 25;
        updateTutorialStep();
        _airBubble.hideIt();
        g.user.tutorialStep = 24;
        _airBubble.showIt(texts[g.user.tutorialStep][_subStep], g.cont.popupCont, Starling.current.nativeStage.stageWidth/2 - 150, Starling.current.nativeStage.stageHeight/2, subStep24_8);
        _airBubble.showBtnParticles();
        _airBubble.showBtnArrow();
    }

    private function subStep24_8():void {
        _airBubble.hideIt();
        _airBubble.deleteIt();
        _airBubble = null;
        _currentAction = TutorialAction.GO_HOME;
        g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
        _subStep = 8;
        if (!cutScene) cutScene = new CutScene();
        cutScene.showIt(texts[g.user.tutorialStep][_subStep]);
        subStep24_9();
    }

    private function subStep24_9():void {
        _subStep = 9;
        var ob:Object = g.bottomPanel.getBtnProperties('home');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.addArrow('home');
        _tutorialCallback = subStep24_10;
    }

    private function subStep24_10():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        g.bottomPanel.deleteArrow();
        if (cutScene) cutScene.hideIt(deleteCutScene);
        _subStep = 10;
        _tutorialCallback = subStep24_11;
    }

    private function subStep24_11():void {
        _subStep = 11;
        _tutorialCallback = null;
        g.user.tutorialStep = 25;
        _tutorialResourceIDs = [];
        _tutorialObjects = [];
        createDelay(.5, initScenes);
    }

    private function initScene_25():void {
        _subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(31, 28);
        } else {
            cat.setPosition(new Point(31, 28));
            cat.updatePosition();
        }
        g.cont.moveCenterToPos(31, 28, true);
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['ok'], subStep25_1, 1);
    }

    private function subStep25_1():void {
        removeBlack();
        if (cutScene) cutScene.hideIt(deleteCutScene);
        g.user.tutorialStep = 26;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_26():void {
        _tutorialObjects = [];
        var chest:WorldObject = g.managerChest.makeTutorialChest();
        _tutorialObjects.push(chest);
        if (!cat) {
            addCatToPos(31, 35);
            g.cont.moveCenterToPos(31, 31, true);
            subStep25_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(31, 35), subStep26_1);
            g.cont.moveCenterToPos(31, 31, false, 1);
        }
    }

    private function subStep26_1():void {
        _subStep = 1;
        (_tutorialObjects[0] as Chest).showArrow();
        _currentAction = TutorialAction.TAKE_CHEST;
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.flipIt(false);
        cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        _tutorialCallback = subStep26_2;
    }

    private function subStep26_2():void {
        _subStep = 2;
        cat.hideBubble();
        (_tutorialObjects[0] as Chest).hideArrow();
        _tutorialCallback = subStep26_3;
    }

    private function subStep26_3():void {
        _subStep = 3;
        g.user.tutorialStep = 101;
        updateTutorialStep();

        clearAll();
    }


    public function checkDefaults():void {
        if (g.user.tutorialStep < 6) g.bottomPanel.hideMainPanel();
        if (g.user.tutorialStep < 23) g.friendPanel.hideIt(true);
    }

    private function clearAll():void {
        if (cat) {
            cat.removeFromMap();
            cat.deleteIt();
            cat = null;
        }
        TUTORIAL_ON = false;
    }

    private function addCatToPos(_x:int, _y:int):void {
        if (!cat) cat = new TutorialCat();
        cat.setPosition(new Point(_x, _y));
        cat.addToMap();
    }

    private function playCatIdle():void {
        if (cat) cat.playDirectLabel('idle', false, null);
    }

    private function addBlack():void {
        if (!black) {
            var q:Quad = new Quad(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, Color.BLACK);
            black = new Sprite();
            black.addChild(q);
            black.alpha = .3;
            g.cont.popupCont.addChildAt(black, 0);
        }
    }

    private function removeBlack():void {
        if (black) {
            if (g.cont.popupCont.contains(black)) g.cont.popupCont.removeChild(black);
            black.dispose();
            black = null;
        }
    }

    public function onResize():void {
        if (black) {
            removeBlack();
            addBlack();
        }
        if (cutScene) {
            cutScene.onResize();
        }

        checkDefaults();

        var p:Point = new Point();
        var ob:Object;
        switch (g.user.tutorialStep) {
            case 3:
            case 4:
                if (!_tutorialObjects[0]) return;
                p.x = (_tutorialObjects[0] as WorldObject).posX;
                p.y = (_tutorialObjects[0] as WorldObject).posY;
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(p.x, p.y, false, 1);
                break;
            case 5:
            case 6:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(28, 11, false, 1);
                break;
            case 7:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(28, 11);
                if (_subStep == 1) {
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    ob = g.bottomPanel.getShopButtonProperties();
                    _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                } else if (_subStep == 3) {
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
                        ob = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
                        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                        _arrow.scaleIt(.7);
                        _arrow.animateAtPosition(ob.x + ob.width / 2, ob.y);
                    } else {
                        Cc.error('Tuts:: WO_Shop is not opened on resize');
                    }
                }
                break;
            case 8:
                if (_subStep == 0) {
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(30, 11, false, 1);
                    ob = g.bottomPanel.getShopButtonProperties();
                    _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                } else if (_subStep == 1) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(30, 11, false, 1);
                } else if (_subStep == 2) {
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(30, 11, false, 1);
                    if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
                        ob = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
                        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                        _arrow.scaleIt(.7);
                        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
                    } else {
                        Cc.error('wo_SHOP is not opened on resize');
                    }
                } else if ( _subStep == 3) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(8, 9, false, 1);
                } else if (_subStep >= 4) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(9, 13, false, 1);
                }
                break;
            case 9:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(9, 13, false, 1);
                break;
            case 10:
                if (_subStep == 2) {
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(19, 37, false, 1);
                    ob = g.bottomPanel.getShopButtonProperties();
                    _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                } else if (_subStep < 4) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(19, 37, false, 1);
                } else if (_subStep == 4) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(21, 35, false, 1);
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
                        ob = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
                        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                        _arrow.scaleIt(.7);
                        _arrow.animateAtPosition(ob.x + ob.width / 2, ob.y);
                    } else {
                        Cc.error('wo_SHOP is not opened on resize');
                    }
                } else if (_subStep == 5) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(21, 35, false, 1);
                } else if (_subStep == 6) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(23, 35, false, 1);
                } else if (_subStep == 7) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(23, 35, false, 1);
                } else {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(23, 35, false, 1);
                }
                break;
            case 11:
                if (_tutorialObjects[0]) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, false, 1);
                }
                break;
            case 12:
                if (_subStep < 6) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(31, 26, false, 1);
                } else if (_subStep == 6 || _subStep == 7) {
                    if (_tutorialObjects[0]) {
                        g.cont.killMoveCenterToPoint();
                        g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, false, 1);
                    }
                } else if (_subStep == 8) {
                    if (_tutorialObjects[0]) {
                        g.cont.killMoveCenterToPoint();
                        g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, false, 1);
                    }
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_ORDERS) {
                        ob = (g.windowsManager.currentWindow as WOOrder).getSellBtnProperties();
                        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height - 20, ob.x, ob.y);
                        _arrow = new SimpleArrow(SimpleArrow.POSITION_LEFT, g.cont.popupCont);
                        _arrow.scaleIt(.5);
                        _arrow.animateAtPosition(ob.x, ob.y + 25);
                    } else {
                        Cc.error('wo_order is not opened on resize');
                    }
                } else {
                    if (_tutorialObjects[0]) {
                        g.cont.killMoveCenterToPoint();
                        g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, false, 1);
                    }
                }
                break;
            case 13:
                if (_subStep == 0){
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(31, 26, false, 1);
                    ob = g.bottomPanel.getShopButtonProperties();
                    _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                } else if (_subStep == 1) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(31, 26, false, 1);
                } else if (_subStep == 2) {
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(31, 26, false, 1);
                    if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
                        ob = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
                        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                        _arrow.scaleIt(.7);
                        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
                    } else {
                        Cc.error('wo_shop is not opened on resize');
                    }
                }
                break;
            case 14:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(2, 12, false, 1);
                break;
            case 15:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(2, 12, false, 1);
                break;
            case 16:
                g.cont.killMoveCenterToPoint();
                if (_tutorialObjects[0]) {
                    g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
                } else {
                    g.cont.moveCenterToPos(2, 12, false, 1);
                }
                break;
            case 17:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(2, 11, false, 1);
                break;
            case 18:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(2, 11, false, 1);
                if (_subStep == 1) {
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_FABRICA) {
                        ob = (g.windowsManager.currentWindow as WOFabrica).getSkipBtnProperties();
                        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                        _arrow = new SimpleArrow(SimpleArrow.POSITION_LEFT, g.cont.popupCont);
                        _arrow.scaleIt(.5);
                    } else {
                        Cc.error('wo_fabrica is not opened on resize');
                    }
                }
                break;
            case 19:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(2, 11, false, 1);
                break;
            case 20:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(31, 28, false, 1);
                if (_subStep == 2) {
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
                        ob = (g.windowsManager.currentWindow as WOShop).getShopDirectItemProperties(1);
                        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                        _arrow.scaleIt(.7);
                        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
                    } else {
                        Cc.error('wo_shop is not opened on resize');
                    }
                }
                break;
            case 21:
                if (_subStep == 1) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(31, 26, false, 1);
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    ob = g.bottomPanel.getShopButtonProperties();
                    _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                } else if (_subStep == 4) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(31, 26, false, 1);
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
                        ob = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0], true);
                        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                        _arrow.scaleIt(.7);
                        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
                    } else {
                        Cc.error('wo_shop is not opened on resize');
                    }
                } else if (_subStep < 4) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(31, 26, false, 1);
                } else {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(16, 9, false, 1);
                }
                break;
            case 22:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(8, 17, false, 1);
                if (_subStep == 1) {
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    ob = g.bottomPanel.getShopButtonProperties();
                    _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                } else if (_subStep == 3) {
                    if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
                        if (_dustRectangle) {
                            _dustRectangle.deleteIt();
                            _dustRectangle = null;
                        }
                        if (_arrow) {
                            _arrow.deleteIt();
                            _arrow = null;
                        }
                        ob = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
                        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                        _arrow.scaleIt(.7);
                        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
                    } else {
                        Cc.error('wo_SHOP is not opened on resize');
                    }
                }
                break;
            case 23:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(8, 17, false, 1);
                break;
            case 24:
                if (_subStep == 1) {
                    if (_dustRectangle) {
                        _dustRectangle.deleteIt();
                        _dustRectangle = null;
                    }
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(31, 28, false, 1);
                    ob = g.friendPanel.getNeighborItemProperties();
                    _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                    _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                    _arrow.scaleIt(.5);
                    _arrow.animateAtPosition(ob.x + ob.width / 2, ob.y);
                } else if (_subStep < 4) {
                    g.cont.killMoveCenterToPoint();
                    g.cont.moveCenterToPos(31, 28, false, 1);
                } else if (_subStep > 4) {
                    if (_tutorialObjects[0]) {
                        g.cont.moveCenterToXY((_tutorialObjects[0] as Market).source.x - 100, (_tutorialObjects[0] as Market).source.y, false, 1);
                    }
                    if (_subStep == 6) {
                        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_MARKET) {
                            if (_dustRectangle) {
                                _dustRectangle.deleteIt();
                                _dustRectangle = null;
                            }
                            if (_arrow) {
                                _arrow.deleteIt();
                                _arrow = null;
                            }
                            _airBubble.hideIt();
                            _airBubble = new AirTextBubble();
                            _airBubble.showIt(texts[g.user.tutorialStep][_subStep], g.cont.popupCont, Starling.current.nativeStage.stageWidth/2 - 150, Starling.current.nativeStage.stageHeight/2);
                            ob = (g.windowsManager.currentWindow as WOMarket).getItemProperties(1);
                            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
                            _arrow.scaleIt(.5);
                            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height);
                        } else {
                            Cc.error('wo_market is not opened on resize');
                        }
                    } else if (_subStep == 7) {
                        _airBubble.hideIt();
                        _airBubble.showIt(texts[g.user.tutorialStep][_subStep], g.cont.popupCont, Starling.current.nativeStage.stageWidth/2 - 150, Starling.current.nativeStage.stageHeight/2, subStep24_8);
                        _airBubble.showBtnParticles();
                        _airBubble.showBtnArrow();
                    } else if (_subStep == 9) {
                        if (_dustRectangle) {
                            _dustRectangle.deleteIt();
                            _dustRectangle = null;
                        }
                        ob = g.bottomPanel.getBtnProperties('home');
                        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                    }
                }
                break;
            case 25:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(31, 28, false, 1);
                break;
            case 26:
                g.cont.killMoveCenterToPoint();
                g.cont.moveCenterToPos(31, 31, false, 1);
                break;
        }

    }

    private function deleteCutScene():void {
        if (cutScene) {
            cutScene.deleteIt();
            cutScene = null;
        }
    }

    public function isTutorialBuilding(wo:WorldObject):Boolean {
        return _tutorialObjects.indexOf(wo) > -1;
    }

    public function addTutorialWorldObject(w:WorldObject):void {
        _tutorialObjects.push(w);
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

    private function emptyFunction(...params):void {}
}
}

