/**
 * Created by user on 2/29/16.
 */
package tutorial {
import build.WorldObject;
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
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import windows.WindowsManager;
import windows.orderWindow.WOOrder;
import windows.shop.WOShop;

public class ManagerTutorial {
    private const TUTORIAL_ON:Boolean = true;

    private const MAX_STEPS:uint = 100;
    private var g:Vars = Vars.getInstance();
    private var cat:TutorialCat;
    private var cutScene:CutScene;
    private var subStep:int;
    private var texts:Object;
    private var black:Sprite;
    private var _tutorialObjects:Array;
    private var _currentAction:int;
    private var _tutorialResourceIDs:Array;
    private var _dustRectangle:DustRectangle;
    private var _tutorialCallback:Function;
    private var _airBubble:AirTextBubble;
    private var _counter:int;
    private var _tutorialPlaceBuilding:TutorialPlace;

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

    public function get currentAction():int {
        return _currentAction;
    }

    public function isTutorialResource(id:int):Boolean {
        return _tutorialResourceIDs.indexOf(id) > -1;
    }

    public function get isTutorial():Boolean {
        return g.user.tutorialStep < MAX_STEPS && TUTORIAL_ON;
    }

    private function updateTutorialStep():void {
        g.directServer.updateUserTutorialStep(null);
    }

    public function initScenes():void {
        var curFunc:Function;
//        trace('step: ' + g.user.tutorialStep);
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

            }
            if (curFunc != null) {
                curFunc.apply();
            }
//        } catch (err:Error) {
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'tutorial');
//            Cc.error("Tutorial crashed at step #" + String(g.user.tutorialStep) + " and subStep #" + String(subStep) + " with error message " + err.message);
//        }
    }

    private function  initScene_1():void {
        _currentAction = TutorialAction.NONE;
        if (!cat) cat = new TutorialCat();
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        subStep = 0;
        addCatToPos(30, 26);
        playCatIdle();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['next'], subStep1_1, 1);
        addBlack();
    }

    private function subStep1_1():void {
        subStep = 1;
        cutScene.reChangeBubble(texts[g.user.tutorialStep][subStep], texts['lookAround'], subStep1_2);
    }

    private function subStep1_2():void {
        subStep = 2;
        cutScene.hideIt(deleteCutScene);
        removeBlack();
//        g.optionPanel.makeFullScreen();
//        g.optionPanel.makeResizeForGame();
//        onResize();
        g.user.tutorialStep = 2;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_2():void {
        subStep = 0;
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
        g.managerCats.goCatToPoint(cat, p, subStep2_1);
    }

    private function subStep2_1():void {
        subStep = 1;
        g.optionPanel.makeScaling(1,false);
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        _currentAction = TutorialAction.CRAFT_RIDGE;
        for (var i:int=0; i<_tutorialObjects.length; i++) {
            if (!(_tutorialObjects[i] as Ridge).isFreeRidge) {
                _counter++;
                (_tutorialObjects[i] as WorldObject).showArrow();
                (_tutorialObjects[i] as WorldObject).tutorialCallback = subStep2_2;
            }
        }
    }

    private function subStep2_2(wo:WorldObject):void {
        subStep = 2;
        _counter--;
        wo.hideArrow();
        wo.tutorialCallback = null;
        if (_counter <= 0) {
            _currentAction = TutorialAction.NONE;
            subStep2_3();
        }
    }

    private function subStep2_3():void {
        cat.hideBubble();
        subStep = 3;
        _tutorialObjects = [];
        g.user.tutorialStep = 3;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_3():void {
        _currentAction = TutorialAction.NONE;
        subStep = 0;
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        }
        if (!cat) {
            addCatToPos((_tutorialObjects[0] as WorldObject).posX - 1, (_tutorialObjects[0] as WorldObject).posY + 2);
            g.cont.moveCenterToPos((_tutorialObjects[0] as WorldObject).posX, (_tutorialObjects[0] as WorldObject).posY, false, 2);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.playDirectLabel('idle3', true, playCatIdle);
//        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep3_1);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        subStep3_1();
    }

    private function subStep3_1():void {
        subStep = 1;
        _currentAction = TutorialAction.PLANT_RIDGE;
        _tutorialResourceIDs = [31];
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as WorldObject).tutorialCallback = subStep3_2;
    }

    private function subStep3_2(r:WorldObject):void {
        cat.hideBubble();
        subStep = 2;
        _tutorialResourceIDs = [];
        _tutorialObjects.splice(_tutorialObjects.indexOf(r), 1);
        r.hideArrow();
        r.tutorialCallback = null;
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as WorldObject).tutorialCallback = subStep3_3;
    }

    private function subStep3_3(r:WorldObject):void {
        subStep = 3;
        _tutorialObjects.splice(_tutorialObjects.indexOf(r), 1);
        r.hideArrow();
        r.tutorialCallback = null;
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as WorldObject).tutorialCallback = subStep3_4;
    }

    private function subStep3_4(r:WorldObject):void {
        _currentAction = TutorialAction.NONE;
        r.hideArrow();
        r.tutorialCallback = null;
        _tutorialObjects = [];
        subStep = 4;
        if (!cutScene) cutScene = new CutScene();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['next'], subStep3_5, 0);
        addBlack();
    }

    private function subStep3_5():void {
        removeBlack();
        subStep = 5;
        cutScene.hideIt(deleteCutScene);
        g.user.tutorialStep = 4;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_4():void {
        _currentAction = TutorialAction.NONE;
        subStep = 0;
        if (!texts) texts = (new TutorialTexts()).objText;
        _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.FARM);
        _tutorialObjects = (_tutorialObjects[0] as Farm).arrAnimals;
        if (!cat) {
            addCatToPos(30, 11);
            g.cont.moveCenterToPos(27, 14, true);
            subStep4_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(30, 11), subStep4_1);
            g.cont.moveCenterToPos(27, 14, false, 2);
        }
    }

    private function subStep4_1():void {
        subStep = 1;
        cat.flipIt(true);
        cat.playDirectLabel('idle3', true, playCatIdle);
//        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep4_2);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        subStep4_2();
    }

    private function subStep4_2():void {
        subStep = 2;
        _currentAction = TutorialAction.ANIMAL_FEED;
        (_tutorialObjects[0] as Animal).playDirectIdle();
        (_tutorialObjects[0] as Animal).addArrow();
        (_tutorialObjects[0] as Animal).tutorialCallback = subStep4_3;
    }

    private function subStep4_3(chick:Animal):void {
        cat.hideBubble();
        chick.removeArrow();
        chick.tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        subStep = 3;
        cat.playDirectLabel('idle3', true, playCatIdle);
//        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep4_4);
        cat.flipIt(true);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        subStep4_4();
    }

    private function subStep4_4():void {
        subStep = 4;
        _currentAction = TutorialAction.ANIMAL_SKIP;
        (_tutorialObjects[0] as Animal).playDirectIdle();
        (_tutorialObjects[0] as Animal).addArrow();
        (_tutorialObjects[0] as Animal).tutorialCallback = subStep4_5;
    }

    private function subStep4_5(chick:Animal):void {
        cat.hideBubble();
        chick.tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        subStep = 5;
        createDelay(1, subStep4_6);
    }

    private function subStep4_6():void {
        subStep = 6;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        _currentAction = TutorialAction.ANIMAL_CRAFT;
        (_tutorialObjects[0] as Animal).farm.addArrowToCraftItem(subStep4_7);
    }

    private function subStep4_7():void {
        cat.hideBubble();
        subStep = 7;
        _tutorialObjects = [];
        _currentAction = TutorialAction.LEVEL_UP;
        g.user.tutorialStep = 5;
        updateTutorialStep();
        _tutorialCallback = subStep4_8;
    }

    private function subStep4_8():void {
        initScenes();
    }

    private function initScene_5():void {
        _currentAction = TutorialAction.NONE;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(30, 11);
            playCatIdle();
            g.cont.moveCenterToPos(27, 14);
        }
        subStep = 0;
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['next'], subStep5_1, 0);
        addBlack();
    }

    private function subStep5_1():void {
        subStep = 1;
        cutScene.hideIt(deleteCutScene);
        removeBlack();
        g.user.tutorialStep = 6;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_6():void {
        _currentAction = TutorialAction.NONE;
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(30, 11);
            g.cont.moveCenterToPos(27, 14);
        }
        subStep = 0;
        cat.flipIt(true);
        cat.playDirectLabel('idle3', true, playCatIdle);
//        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep6_1);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        subStep6_1();
    }

    private function subStep6_1():void {
        subStep = 1;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _currentAction = TutorialAction.BUY_ANIMAL;
        _tutorialResourceIDs = [1];
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep6_2;
    }

    private function subStep6_2():void {
        g.bottomPanel.deleteArrow();
        cat.hideBubble();
        subStep = 2;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        createDelay(1, subStep6_3);
    }

    private function subStep6_3():void {
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _tutorialCallback = subStep6_4;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
    }

    private function subStep6_4():void {
        _tutorialCallback = subStep6_5;
    }

    private function subStep6_5():void {
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        g.windowsManager.hideWindow(WindowsManager.WO_SHOP);

        if (!cutScene) cutScene = new CutScene();
        subStep = 5;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep6_6, 0);
        g.user.tutorialStep = 7;
        updateTutorialStep();
    }

    private function subStep6_6():void {
        cutScene.hideIt(null);
        removeBlack();
        initScenes();
    }

    private function initScene_7():void {
        _currentAction = TutorialAction.NONE;
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(30, 11);
            g.cont.moveCenterToPos(27, 14);
        }
        subStep = 0;
        playCatIdle();
        if (!cutScene) {
            cutScene = new CutScene();
            cutScene.showIt(texts[g.user.tutorialStep][subStep]);
        } else {
            cutScene.reChangeBubble(texts[g.user.tutorialStep][subStep]);
        }
        _tutorialResourceIDs = [3];
        _currentAction = TutorialAction.BUY_FABRICA;
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep7_1;
    }

    private function subStep7_1():void {
        subStep = 1;
        cutScene.hideIt(deleteCutScene);
        g.bottomPanel.deleteArrow();
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        createDelay(1, subStep7_2);
    }

    private function subStep7_2():void {
        subStep = 2;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _tutorialCallback = subStep7_3;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
        var dataPlace:Object = {};
        dataPlace.dataBuild = -1;
        dataPlace.buildType = BuildType.TUTORIAL_PLACE;
        dataPlace.width = g.dataBuilding.objectBuilding[_tutorialResourceIDs[0]].width;
        dataPlace.height = g.dataBuilding.objectBuilding[_tutorialResourceIDs[0]].height;
        _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
        var p:Point = new Point(10, 25);
        p = g.matrixGrid.getXYFromIndex(p);
        g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
    }

    private function subStep7_3():void {
        g.cont.moveCenterToPos(_tutorialPlaceBuilding.posX, _tutorialPlaceBuilding.posY);
        _tutorialPlaceBuilding.activateIt(true);
        _currentAction = TutorialAction.PUT_FABRICA;
        subStep = 3;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _tutorialCallback = subStep7_4;
    }

    private function subStep7_4():void {
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        subStep = 4;
        _tutorialResourceIDs = [];
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.managerCats.goCatToPoint(cat, new Point(_tutorialObjects[0].posX - 1,  _tutorialObjects[0].posY + _tutorialObjects[0].sizeY + 1), subStep7_5);
    }

    private function subStep7_5():void {
        cat.flipIt(false);
        _currentAction = TutorialAction.PUT_FABRICA;
        subStep = 5;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        _tutorialCallback = subStep7_6;
        (_tutorialObjects[0] as Fabrica).showArrow();
    }

    private function subStep7_6():void {
        subStep = 6;
        g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY);
        cat.hideBubble();
        _currentAction = TutorialAction.NONE;
        (_tutorialObjects[0] as Fabrica).hideArrow();
        g.user.tutorialStep = 8;
        updateTutorialStep();
        createDelay(1, initScenes);
    }

    private function initScene_8():void {
        subStep = 0;
        _currentAction = TutorialAction.RAW_RECIPE;
        _tutorialResourceIDs = [1];
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.FABRICA);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX - 1, _tutorialObjects[0].posY + _tutorialObjects[0].sizeY + 1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
        }
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        (_tutorialObjects[0] as Fabrica).showArrow();
        _tutorialCallback = subStep8_1;
    }

    private function subStep8_1():void {
        subStep = 1;
        cat.hideBubble();
        cat.flipIt(false);
        (_tutorialObjects[0] as Fabrica).hideArrow();
        _tutorialCallback = subStep8_2;
    }

    private function subStep8_2():void {
        subStep = 2;
        _tutorialCallback = null;
        _tutorialObjects = [];
        _tutorialResourceIDs = [];
        _currentAction = TutorialAction.NONE;
        g.windowsManager.hideWindow(WindowsManager.WO_FABRICA);
        cat.playDirectLabel('idle2', true, subStep8_3);
    }

    private function subStep8_3():void {
        subStep = 3;
        cat.playDirectLabel('idle3', true, playCatIdle);
        g.user.tutorialStep = 9;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_9():void {
        subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(31, 26);
            g.cont.moveCenterToPos(31, 26, true);
            subStep9_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(31, 26), subStep9_1);
            g.cont.moveCenterToPos(31, 26,false, 1.5);
        }
    }

    private function subStep9_1():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        subStep = 1;
        cutScene.showIt(texts[g.user.tutorialStep][subStep]);
        subStep9_2();
    }

    private function subStep9_2():void {
        subStep = 2;
        _currentAction = TutorialAction.NEW_RIDGE;
        _tutorialResourceIDs = [11];
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep9_3;
    }

    private function subStep9_3():void {
        g.bottomPanel.deleteArrow();
        cutScene.hideIt(deleteCutScene);
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        subStep = 3;
        createDelay(1, subStep9_4);
    }

    private function subStep9_4():void {
        subStep = 4;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _tutorialCallback = subStep9_5;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
        var dataPlace:Object = {};
        dataPlace.dataBuild = -1;
        dataPlace.buildType = BuildType.TUTORIAL_PLACE;
        dataPlace.width = 2;
        dataPlace.height = 2;
        _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
        var p:Point = new Point(21, 35);
        p = g.matrixGrid.getXYFromIndex(p);
        g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
    }

    private function subStep9_5():void {
        subStep = 5;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        g.cont.moveCenterToPos(21, 35);
        _tutorialPlaceBuilding.activateIt(true);
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _tutorialCallback = subStep9_6;
    }

    private function subStep9_6():void {
        subStep = 6;
        cat.hideBubble();
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        var dataPlace:Object = {};
        dataPlace.dataBuild = -1;
        dataPlace.buildType = BuildType.TUTORIAL_PLACE;
        dataPlace.width = 2;
        dataPlace.height = 2;
        _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
        var p:Point = new Point(23, 35);
        p = g.matrixGrid.getXYFromIndex(p);
        g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
        _tutorialPlaceBuilding.activateIt(true);
        _tutorialCallback = subStep9_7;
    }

    private function subStep9_7():void {
        subStep = 7;
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        var dataPlace:Object = {};
        dataPlace.dataBuild = -1;
        dataPlace.buildType = BuildType.TUTORIAL_PLACE;
        dataPlace.width = 2;
        dataPlace.height = 2;
        _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
        var p:Point = new Point(25, 35);
        p = g.matrixGrid.getXYFromIndex(p);
        g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
        _tutorialPlaceBuilding.activateIt(true);
        _tutorialCallback = subStep9_8;
    }

    private function subStep9_8():void {
        _tutorialResourceIDs = [];
        _tutorialObjects = [];
        subStep = 8;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 10;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_10():void {
        subStep = 0;
        _currentAction = TutorialAction.NONE;
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int=0; i<arr.length; i++) {
            if (arr[i].posY == 35) {
                _tutorialObjects.push(arr[i]);
            }
        }
        _tutorialObjects.sortOn('dbBuildingId', Array.NUMERIC);
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX - 2, _tutorialObjects[0].posY + 1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
            subStep10_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(_tutorialObjects[0].posX - 2, _tutorialObjects[0].posY + 1), subStep10_1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, false, 1);
        }
    }

    private function subStep10_1():void {
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.flipIt(false);
        subStep = 1;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        _tutorialResourceIDs = [32];
        _currentAction = TutorialAction.PLANT_RIDGE;
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as Ridge).tutorialCallback = emptyFunction;
        _tutorialCallback = subStep10_2;
    }

    private function subStep10_2():void {
        subStep = 2;
        _tutorialCallback = null;
        cat.hideBubble();
        cat.flipIt(true);
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialObjects.shift();
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as Ridge).tutorialCallback = subStep10_3;
    }

    private function subStep10_3(r:Ridge=null):void {
        subStep = 3;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialObjects.shift();
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as Ridge).tutorialCallback = subStep10_4;
    }

    private function subStep10_4(r:Ridge=null):void {
        subStep = 4;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialObjects.length = 0;
        _tutorialResourceIDs.length = 0;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 11;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_11():void {
        subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(31, 26);
            g.cont.moveCenterToPos(31, 26, true);
            subStep11_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(31, 26), subStep11_1);
            g.cont.moveCenterToPos(31, 26);
        }
    }

    private function subStep11_1():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        _currentAction = TutorialAction.ORDER;
        subStep = 1;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep11_2, 1);
    }

    private function subStep11_2():void {
        cutScene.hideIt(deleteCutScene);
        removeBlack();
        cat.flipIt(true);
        subStep = 2;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        g.managerOrder.checkOrderForTutorial(subStep11_5);
        createDelay(3000, subStep11_3);
    }

    private function subStep11_3():void {
        subStep = 3;
        cat.hideBubble();
        g.cont.moveCenterToPos(40, 1, false, 2);
        createDelay(3000, subStep11_4);
    }

    private function subStep11_4():void {
        subStep = 4;
        g.cont.moveCenterToPos(31, 26, false, 2);
    }

    private function subStep11_5(rCat:OrderCat):void {
        subStep = 5;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        subStep11_6();
    }

    private function subStep11_6():void {
        subStep = 6;
        _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.ORDER);
        g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, false, 1);
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = subStep11_7;
    }

    private function subStep11_7():void {
        subStep = 7;
        cat.hideBubble();
        cat.flipIt(false);
        (_tutorialObjects[0] as WorldObject).hideArrow();
        createDelay(1, subStep11_8);
    }

    private function subStep11_8():void {
        subStep = 8;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_ORDERS) {
            (g.windowsManager.currentWindow as WOOrder).setTextForCustomer(texts[g.user.tutorialStep][subStep]);
            var ob:Object = (g.windowsManager.currentWindow as WOOrder).getSellBtnProperties();
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x + 55, ob.y);
            _tutorialCallback = subStep11_9;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
    }

    private function subStep11_9():void {
        _currentAction = TutorialAction.NONE;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        subStep = 9;
        (g.windowsManager.currentWindow as WOOrder).setTextForCustomer(texts[g.user.tutorialStep][subStep]);
        g.user.tutorialStep = 12;
        updateTutorialStep();
        createDelay(3, subStep11_10);
    }

    private function subStep11_10():void {
        subStep = 10;
        _currentAction = TutorialAction.LEVEL_UP;
        _tutorialCallback = subStep11_11;
    }

    private function subStep11_11():void {
        subStep = 11;
        _tutorialObjects.length = 0;
        _tutorialResourceIDs.length = 0;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        initScenes();
    }

    private function initScene_12():void {
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(31, 26);
            g.cont.moveCenterToPos(31, 26, true);
        }
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        addBlack();
        subStep = 0;
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep12_1, 1);
    }

    private function subStep12_1():void {
        subStep = 1;
        removeBlack();
        cutScene.hideIt(deleteCutScene);
        _currentAction = TutorialAction.BUY_FABRICA;
        _tutorialResourceIDs = [1];
//        g.woShop.activateTab(3);
//        g.woShop.showIt();
//        var ob:Object = g.woShop.getShopItemProperties(_tutorialResourceIDs[0]);
//        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _tutorialCallback = subStep12_2;
    }

    private function subStep12_2():void {
        subStep = 2;
        _currentAction = TutorialAction.PUT_FABRICA;
        _tutorialCallback = subStep12_3;
//        g.woShop.activateTab(1);
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
    }

    private function subStep12_3():void {
        subStep = 3;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 13;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_13():void {
        subStep = 0;
        _currentAction = TutorialAction.NONE;
        _tutorialResourceIDs = [1];
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(1);
        }
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX + _tutorialObjects[0].sizeX, _tutorialObjects[0].posY);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
            subStep13_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(_tutorialObjects[0].posX + _tutorialObjects[0].sizeX, _tutorialObjects[0].posY), subStep13_1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY);
        }
    }

    private function subStep13_1():void {
        _currentAction = TutorialAction.FABRICA_SKIP_FOUNDATION;
        cat.flipIt(true);
        if (!texts) texts = (new TutorialTexts()).objText;
        subStep = 1;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = subStep13_2;
    }

    private function subStep13_2():void {
        subStep = 2;
        cat.hideBubble();
        (_tutorialObjects[0] as WorldObject).hideArrow();
//        _tutorialCallback = subStep13_3;
        subStep13_3();
    }

    private function subStep13_3():void {
        subStep = 3;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 14;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_14():void {
        _currentAction = TutorialAction.PUT_FABRICA;
        _tutorialResourceIDs = [1];
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(1);
        }
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX + _tutorialObjects[0].sizeX, _tutorialObjects[0].posY);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.flipIt(true);
        subStep = 0;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = initScene14_1;
    }

    private function initScene14_1():void {
        subStep = 1;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        cat.hideBubble();
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 15;
        _tutorialObjects.length = 0;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_15():void {
        subStep = 0;
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

        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX  + _tutorialObjects[0].sizeX, _tutorialObjects[0].posY);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
            subStep15_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(_tutorialObjects[0].posX + _tutorialObjects[0].sizeX, _tutorialObjects[0].posY), subStep15_1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY);
        }
    }

    private function subStep15_1():void {
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.flipIt(false);
        subStep = 1;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        for (var i:int=0; i<_tutorialObjects.length; i++) {
            (_tutorialObjects[i] as WorldObject).showArrow();
            (_tutorialObjects[i] as Ridge).tutorialCallback = subScene15_2;
        }
    }

    private function subScene15_2(r:WorldObject):void {
        subStep = 2;
        cat.hideBubble();
        r.hideArrow();
        _tutorialObjects.splice(_tutorialObjects.indexOf(r), 1);
        if (!_tutorialObjects.length) {
            _tutorialCallback = null;
            _currentAction = TutorialAction.NONE;
            g.user.tutorialStep = 16;
            _tutorialResourceIDs.length = 0;
            updateTutorialStep();
            initScenes();
        }
    }

    private function initScene_16():void {
        subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!texts) texts = (new TutorialTexts()).objText;
        _tutorialObjects = g.townArea.getCityObjectsById(1);
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY + _tutorialObjects[0].sizeY);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
            subStep16_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(_tutorialObjects[0].posX, _tutorialObjects[0].posY + _tutorialObjects[0].sizeY), subStep16_1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY,false, 1.5);
        }
    }

    private function subStep16_1():void {
        _tutorialResourceIDs = [6]; // recipeId
        cat.flipIt(false);
        subStep = 1;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = subStep16_2;
        _currentAction = TutorialAction.RAW_RECIPE;
    }

    private function subStep16_2():void {
        subStep = 2;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        cat.hideBubble();
        cat.flipIt(true);
        _tutorialCallback = subStep16_3;
    }

    private function subStep16_3():void {
        subStep = 3;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 17;
        _tutorialResourceIDs.length = 0;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_17():void {  // need remake for new fabrica window
//        _currentAction = TutorialAction.NONE;
//        if (!_tutorialObjects.length) {
//            _tutorialObjects = g.townArea.getCityObjectsById(1);
//        }
//        if (!cat) {
//            addCatToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY + _tutorialObjects[0].sizeY);
//            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
//        }
//        if (g.currentOpenedWindow) {
//            if (g.currentOpenedWindow != g.woFabrica) {
//                g.currentOpenedWindow.hideIt();
//                (_tutorialObjects[0] as Fabrica).openFabricaWindow();
//            }
//        } else {
//            (_tutorialObjects[0] as Fabrica).openFabricaWindow();
//        }
//        addBlack();
//        if (!texts) texts = (new TutorialTexts()).objText;
//        if (!cutScene) cutScene = new CutScene();
//        subStep = 0;
//        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep17_1, 1);
    }

    private function subStep17_1():void {
        subStep = 1;
        _currentAction = TutorialAction.FABRICA_SKIP_RECIPE;
        cutScene.hideIt(deleteCutScene);
        removeBlack();
//        var ob:Object = g.woFabrica.getSkipBtnProperties();   need remake for new wo
//        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
//        _tutorialCallback = subStep17_2;
    }

    private function subStep17_2():void {
        subStep = 2;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
//        g.woFabrica.hideIt();     need remake for new wo
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
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY + _tutorialObjects[0].sizeY);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cutScene) cutScene = new CutScene();
        subStep = 0;
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep18_1, 1);
    }

    private function subStep18_1():void {
        subStep = 1;
        cutScene.hideIt(deleteCutScene);
        _currentAction = TutorialAction.FABRICA_CRAFT;
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = subStep18_2;
    }

    private function subStep18_2():void {
        subStep = 2;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _currentAction = TutorialAction.LEVEL_UP;
        _tutorialCallback = subStep18_3;
        g.user.tutorialStep = 19;
        _tutorialResourceIDs.length = 0;
        updateTutorialStep();
    }

    private function subStep18_3():void {
        subStep = 3;
        _currentAction = TutorialAction.NONE;
        _tutorialCallback = null;
        initScenes();
    }

    private function initScene_19():void {
        _currentAction = TutorialAction.NONE;
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(1);
        }
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY + _tutorialObjects[0].sizeY);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cutScene) cutScene = new CutScene();
        subStep = 0;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep19_1, 1);
    }

    private function subStep19_1():void {
        subStep = 1;
        cutScene.hideIt(deleteCutScene);
        removeBlack();
        _currentAction = TutorialAction.BUY_CAT;
//        g.woShop.activateTab(1);
//        g.woShop.showIt();
//        var ob:Object = g.woShop.getShopDirectItemProperties(1);
//        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _tutorialCallback = subStep19_2;
        g.cont.moveCenterToPos(31, 28);
    }

    private function subStep19_2():void {
        subStep = 2;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _currentAction = TutorialAction.NONE;
        _tutorialCallback = null;
//        g.woShop.hideIt();
        g.user.tutorialStep = 20;
        updateTutorialStep();
        createDelay(3000, subStep19_3);
    }

    private function subStep19_3():void {
        subStep = 3;
        initScenes();
    }

    private function initScene_20():void {
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(31, 26);
            g.cont.moveCenterToPos(31, 26, true);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.flipIt(false);
        subStep = 0;
//        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep20_1);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
    }

    private function subStep20_1():void {
        subStep = 1;
        cat.hideBubble();
        _currentAction = TutorialAction.BUY_FARM;
        _tutorialResourceIDs = [39];
//        g.woShop.activateTab(1);
//        g.woShop.showIt();
//        var ob:Object = g.woShop.getShopItemProperties(_tutorialResourceIDs[0]);
//        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _tutorialCallback = subStep20_2;
    }

    private function subStep20_2():void {
        subStep = 2;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _currentAction = TutorialAction.PUT_FARM;
        _tutorialCallback = subStep20_3;
//        g.woShop.activateTab(1);
    }

    private function subStep20_3():void {
        subStep = 3;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 21;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_21():void {
        subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(39);
        }
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY + _tutorialObjects[0].sizeY);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
            subStep21_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(_tutorialObjects[0].posX, _tutorialObjects[0].posY + _tutorialObjects[0].sizeY), subStep21_1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY);
        }
    }

    private function subStep21_1():void {
        subStep = 1;
        cat.flipIt(true);
        if (!texts) texts = (new TutorialTexts()).objText;
//        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep21_2);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
    }

    private function subStep21_2():void {
        subStep = 2;
        cat.hideBubble();
        _tutorialResourceIDs = [6];
        _currentAction = TutorialAction.BUY_ANIMAL;
//        g.woShop.activateTab(2);
//        g.woShop.showIt();
//        var ob:Object = g.woShop.getShopItemProperties(_tutorialResourceIDs[0]);
//        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _tutorialCallback = subStep21_3;
    }

    private function subStep21_3():void {
        subStep = 3;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
//        g.woShop.hideIt();
//        g.woShop.activateTab(1);
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 22;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_22():void {
        _currentAction = TutorialAction.NONE;
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsById(39);
        }
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY + _tutorialObjects[0].sizeY);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
        }
        subStep = 0;
        cat.flipIt(true);
        if (!texts) texts = (new TutorialTexts()).objText;
//        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep22_2);
        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok']);
    }

    private function subStep22_2():void {
        subStep = 2;
        cat.hideBubble();
        _currentAction = TutorialAction.ANIMAL_FEED;
        _tutorialObjects = (_tutorialObjects[0] as Farm).arrAnimals;
        (_tutorialObjects[0] as Animal).playDirectIdle();
        (_tutorialObjects[0] as Animal).addArrow();
        (_tutorialObjects[0] as Animal).tutorialCallback = subStep22_3;
    }

    private function subStep22_3(bee:Animal):void {
        subStep = 3;
        bee.removeArrow();
        bee.tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 23;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_23():void {
        subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(31, 28);
            g.cont.moveCenterToPos(31, 28, true);
        }
        subStep23_1();
    }

    private function subStep23_1():void {
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cutScene) cutScene = new CutScene();
        subStep = 1;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep23_2, 1);
    }

    private function subStep23_2():void {
        subStep = 2;
        cutScene.hideIt(deleteCutScene);
        removeBlack();
        _currentAction = TutorialAction.VISIT_NEIGHBOR;
        var ob:Object = g.friendPanel.getNeighborItemProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _tutorialCallback = subStep23_3;
    }

    private function subStep23_3():void {
        subStep = 3;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _tutorialCallback = subStep23_4;
    }

    private function subStep23_4():void {
        _tutorialCallback = null;
        subStep = 4;
        addBlack();
        cutScene = new CutScene();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep23_5, 1);
        g.cont.moveCenterToPos(30, 30,false, 1);
    }

    private function subStep23_5():void {
        subStep = 5;
        removeBlack();
        if (cutScene) cutScene.hideIt(deleteCutScene);
        _tutorialObjects = g.townArea.getAwayCityObjectsById(44);
        (_tutorialObjects[0] as WorldObject).showArrow();
        g.cont.moveCenterToXY((_tutorialObjects[0] as Market).source.x, (_tutorialObjects[0] as Market).source.y);
        _tutorialCallback = subStep23_6;
    }

    private function subStep23_6():void {
        subStep = 6;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialResourceIDs = [124, 1, 5, 6, 125];
        _airBubble = new AirTextBubble();
        _airBubble.showIt(texts[g.user.tutorialStep][subStep], g.cont.popupCont, 700, 200);
//        var ob:Object = g.woMarket.getItemProperties(1);   need remake for new wo
//        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
//        _tutorialCallback = subStep23_7;
    }

    private function subStep23_7():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        g.user.tutorialStep = 24;
        updateTutorialStep();
        _airBubble.hideIt();
        subStep = 7;
        g.user.tutorialStep = 23;
        _airBubble.showIt(texts[g.user.tutorialStep][subStep], g.cont.popupCont, 700, 200, subStep23_8);
    }

    private function subStep23_8():void {
        _airBubble.hideIt();
        _airBubble.deleteIt();
        _airBubble = null;
//        g.woMarket.hideIt();  need remake for new wo
        _currentAction = TutorialAction.GO_HOME;
        subStep = 8;
        if (!cutScene) cutScene = new CutScene();
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep23_9, 1);
    }

    private function subStep23_9():void {
        subStep = 9;
        removeBlack();
        if (cutScene) cutScene.hideIt(deleteCutScene);
        var ob:Object = g.bottomPanel.getBtnProperties('home');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _tutorialCallback = subStep23_10;
    }

    private function subStep23_10():void {
        subStep = 10;
        _tutorialCallback = null;
        g.user.tutorialStep = 24;
        _tutorialResourceIDs = [];
        initScenes();
    }

    private function initScene_24():void {
        subStep = 0;
        _currentAction = TutorialAction.NONE;
        if (!cat) {
            addCatToPos(31, 28);
            g.cont.moveCenterToPos(31, 28, true);
        }
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep24_1, 1);
    }

    private function subStep24_1():void {
        subStep = 1;
        removeBlack();
        cutScene.hideIt(deleteCutScene);
        g.user.tutorialStep = 101;
        updateTutorialStep();

        clearAll();
    }

    private function clearAll():void {
        if (cat) {
            cat.removeFromMap();
            cat.deleteIt();
            cat = null;
        }
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

    private function createDelay(delay:int, f:Function):void {
        var func:Function = function():void {
            timer.removeEventListener(TimerEvent.TIMER, func);
            timer = null;
            if (f != null) {
                f.apply();
            }
        };
        var timer:Timer = new Timer(delay, 1);
        timer.addEventListener(TimerEvent.TIMER, func);
        timer.start();
    }

    private function emptyFunction(...params):void {}
}
}

