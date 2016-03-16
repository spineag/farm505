/**
 * Created by user on 2/29/16.
 */
package tutorial {
import build.WorldObject;
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.farm.Farm;
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
    private var _dustOval:DustOval;
    private var _dustRectangle:DustRectangle;
    private var _tutorialCallback:Function;

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

    public function isTutorialResoucre(id:int):Boolean {
        return _tutorialResourceIDs.indexOf(id) > -1;
    }

    public function get isTutorial():Boolean {
        return g.user.tutorialStep < MAX_STEPS && TUTORIAL_ON;
    }

    private static function updateTutorialStep():void {
//        g.directServer.updateUserTutorialStep(null);
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
//
//
//                case 50:
//                    curFunc = initScene0;
//                    break;
            }
            if (curFunc != null) {
                curFunc.apply();
            }
//        } catch (err:Error) {
//            Cc.error("Tutorial crashed at step #" + g.user.tutorialStep + " with error message #" + err.errorID);
//        }
    }

    private function initScene_1():void {
        if (!cat) cat = new TutorialCat();
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        subStep = 1;
        addCatToPos(30, 26);
        playCatIdle();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['next'], subStep1_1, 1);
        addBlack();
    }

    private function subStep1_1():void {
        subStep = 2;
        cutScene.reChangeBubble(texts[g.user.tutorialStep][subStep], texts['lookAround'], subStep1_2)
    }

    private function subStep1_2():void {
        cutScene.hideIt(deleteCutScene);
        removeBlack();
//        g.optionPanel.makeFullScreen();
//        g.optionPanel.makeResizeForGame();
        onResize();
        g.user.tutorialStep = 2;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_2():void {
        subStep = 0;
        if (!cat) {
            addCatToPos(30, 26);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.flipIt(true);
        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep2_1);
        g.optionPanel.makeScaling(1,false);
        g.cont.moveCenterToPos(30, 30);
    }

    private function subStep2_1():void {
        subStep = 1;
        cat.hideBubble();
        cat.flipIt(false);
        cat.playDirectLabel('idle3', true, playCatIdle);
        _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        var count:int = 0;
        var f:Function = function (wo:WorldObject):void {
            count++;
            wo.hideArrow();
            wo.tutorialCallback = null;
            if (count >= _tutorialObjects.length) {
                _currentAction = TutorialAction.NONE;
                subStep2_2();
            }
        };
        _currentAction = TutorialAction.CRAFT_RIDGE;
        for (var i:int=0; i<_tutorialObjects.length; i++) {
            (_tutorialObjects[i] as WorldObject).showArrow();
            (_tutorialObjects[i] as WorldObject).tutorialCallback = f;
        }
    }

    private function subStep2_2():void {
        _tutorialObjects = [];
        g.user.tutorialStep = 3;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_3():void {
        subStep = 0;
        if (!cat) {
            addCatToPos(30, 26);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.flipIt(true);
        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep3_1);
    }

    private function subStep3_1():void {
        subStep = 1;
        cat.hideBubble();
        _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        _currentAction = TutorialAction.PLANT_WHEAT;
        _tutorialResourceIDs = [31];
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as WorldObject).tutorialCallback = subStep3_2;
    }

    private function subStep3_2(r:WorldObject):void {
        _tutorialResourceIDs = [];
        _tutorialObjects.splice(_tutorialObjects.indexOf(r), 1);
        r.hideArrow();
        r.tutorialCallback = null;
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as WorldObject).tutorialCallback = subStep3_3;
    }

    private function subStep3_3(r:WorldObject):void {
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
        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep3_5);
    }

    private function subStep3_5():void {
        g.user.tutorialStep = 4;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_4():void {
        subStep = 0;
        if (!cat) {
            addCatToPos(30, 26);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.flipIt(false);
        g.managerCats.goCatToPoint(cat, new Point(30, 11), subStep4_1);
        g.cont.moveCenterToPos(27, 14);
    }

    private function subStep4_1():void {
        subStep = 1;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep4_2);
    }

    private function subStep4_2():void {
        cat.hideBubble();
        _currentAction = TutorialAction.CHICKEN_FEED;
        _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.FARM);
        _tutorialObjects = (_tutorialObjects[0] as Farm).arrAnimals;
        (_tutorialObjects[0] as Animal).playDirectIdle();
        (_tutorialObjects[0] as Animal).addArrow();
        (_tutorialObjects[0] as Animal).tutorialCallback = subStep4_3;
    }

    private function subStep4_3(chick:Animal):void {
        chick.removeArrow();
        chick.tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        subStep = 3;
        cat.flipIt(true);
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep4_4);
    }

    private function subStep4_4():void {
        cat.hideBubble();
        cat.flipIt(false);
        _currentAction = TutorialAction.CHICKEN_SKIP;
        (_tutorialObjects[0] as Animal).playDirectIdle();
        (_tutorialObjects[0] as Animal).addArrow();
        (_tutorialObjects[0] as Animal).tutorialCallback = subStep4_5;
    }

    private function subStep4_5(chick:Animal):void {
        chick.removeArrow();
        chick.tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        subStep = 5;
        cat.flipIt(true);
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep4_6);
    }

    private function subStep4_6():void {
        cat.hideBubble();
        cat.flipIt(false);
        _currentAction = TutorialAction.CHICKEN_CRAFT;
        (_tutorialObjects[0] as Animal).farm.addArrowToCraftItem(subStep4_7);
    }

    private function subStep4_7():void {
//        (_tutorialObjects[0] as Animal).farm.removeArrowFromCraftItem();
        _currentAction = TutorialAction.LEVEL_UP;
        g.user.tutorialStep = 5;
        updateTutorialStep();
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
        subStep = 1;
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['next'], subStep5_1, 1);
        addBlack();
    }

    private function subStep5_1():void {
        cutScene.hideIt(deleteCutScene);
        removeBlack();
        g.user.tutorialStep = 6;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_6():void {
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(30, 11);
            g.cont.moveCenterToPos(27, 14);
        }
        subStep = 0;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep6_1);
    }

    private function subStep6_1():void {
        cat.hideBubble();
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _currentAction = TutorialAction.BUY_CHICKENS;
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep6_2;
        g.woShop.activateTab(2);
    }

    private function subStep6_2():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        var ob:Object = g.woShop.getShopItemProperties(1);
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _tutorialCallback = subStep6_3;
        _tutorialResourceIDs = [1];
    }

    private function subStep6_3():void {
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        g.woShop.hideIt();
        g.woShop.activateTab(1);

        if (!cutScene) cutScene = new CutScene();
        subStep = 3;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep6_4, 1);
        g.user.tutorialStep = 7;
        updateTutorialStep();
    }

    private function subStep6_4():void {
        removeBlack();
        cutScene.hideIt(deleteCutScene);
        initScenes();
    }

    private function initScene_7():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(30, 11);
        }
        g.cont.moveCenterToPos(27, 14);
        subStep = 0;
        playCatIdle();
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep7_1, 1);
    }

    private function subStep7_1():void {
        removeBlack();
        cutScene.hideIt(deleteCutScene);
        _currentAction = TutorialAction.BUY_FABRICA;
        g.woShop.activateTab(3);
        g.woShop.showIt();
        var ob:Object = g.woShop.getShopItemProperties(1);
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _tutorialCallback = subStep7_2;
        _tutorialResourceIDs = [3];
    }

    private function subStep7_2():void {
        _tutorialCallback = subStep7_3;
        _currentAction = TutorialAction.PUT_FABRICA;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        g.woShop.activateTab(1);
    }

    private function subStep7_3():void {
        _tutorialResourceIDs = [];
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.FABRICA);
        cat.flipIt(false);
        g.managerCats.goCatToPoint(cat, new Point(_tutorialObjects[0].posX + _tutorialObjects[0].sizeX, _tutorialObjects[0].posY), subStep7_4);
    }

    private function subStep7_4():void {
        cat.flipIt(true);
        _currentAction = TutorialAction.PUT_FABRICA;
        subStep = 4;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        _tutorialCallback = subStep7_5;
        (_tutorialObjects[0] as Fabrica).showArrow();
    }

    private function subStep7_5():void {
        g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY);
        cat.hideBubble();
        _currentAction = TutorialAction.NONE;
        (_tutorialObjects[0] as Fabrica).hideArrow();
        g.user.tutorialStep = 8;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_8():void {
        subStep = 1;
        _currentAction = TutorialAction.RAW_RECIPE;
        _tutorialResourceIDs = [21];
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.FABRICA);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX + _tutorialObjects[0].sizeX, _tutorialObjects[0].posY);
        }
        g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY);
        cat.flipIt(true);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        (_tutorialObjects[0] as Fabrica).showArrow();
        _tutorialCallback = subStep8_1;
    }

    private function subStep8_1():void {
        cat.hideBubble();
        cat.flipIt(false);
        (_tutorialObjects[0] as Fabrica).hideArrow();
        _tutorialCallback = subStep8_2;
    }

    private function subStep8_2():void {
        _tutorialCallback = null;
        _tutorialObjects = [];
        _tutorialResourceIDs = [];
        _currentAction = TutorialAction.NONE;
        cat.playDirectLabel('idle2', true, subStep8_3);
    }

    private function subStep8_3():void {
        cat.playDirectLabel('idle3', true, playCatIdle);
        g.woFabrica.hideIt();
        g.user.tutorialStep = 9;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_9():void {
        if (!cat) {
            addCatToPos(31, 26);
            g.cont.moveCenterToPos(31, 26, true);
            subStep9_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(31, 26), subStep9_1);
            g.cont.moveCenterToPos(31, 26);
        }
    }

    private function subStep9_1():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTexts()).objText;
        subStep = 1;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep9_2, 1);
    }

    private function subStep9_2():void {
        removeBlack();
        cutScene.hideIt(deleteCutScene);
        _currentAction = TutorialAction.NEW_RIDGE;
        g.woShop.activateTab(1);
        g.woShop.showIt();
        var ob:Object = g.woShop.getShopItemProperties(2);
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _tutorialCallback = subStep9_3;

    }

    private function subStep9_3():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        subStep = 3;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        _tutorialCallback = subStep9_4;
    }

    private function subStep9_4():void {
        cat.hideBubble();
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 10;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_10():void {
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.RIDGE);
            _tutorialObjects.sortOn('dbBuildingId', Array.NUMERIC);
            _tutorialObjects = [_tutorialObjects[_tutorialObjects.length-1]];
        }
        if (!cat) {
            addCatToPos(_tutorialObjects[0].posX + 2, _tutorialObjects[0].posY);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, true);
            subStep10_1();
        } else {
            g.managerCats.goCatToPoint(cat, new Point(_tutorialObjects[0].posX + 2, _tutorialObjects[0].posY), subStep10_1);
            g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY);
        }
    }

    private function subStep10_1():void {
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.flipIt(true);
        subStep = 1;
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = subStep10_2;
        _currentAction = TutorialAction.PLANT_CORN;
    }

    private function subStep10_2():void {
        cat.hideBubble();
        cat.flipIt(false);
        _tutorialResourceIDs = [32];
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialCallback = subStep10_3;
    }

    private function subStep10_3():void {
        _tutorialObjects.length = 0;
        _tutorialResourceIDs.length = 0;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 11;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_11():void {
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
        cutScene.showIt(texts[g.user.tutorialStep][subStep], texts['ok'], subStep11_2, 1)
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
        cat.hideBubble();
        g.cont.moveCenterToPos(40, 1, false, 2);
        createDelay(1000, subStep11_4);
    }

    private function subStep11_4():void {
        g.cont.moveCenterToPos(31, 26, false, 2);
    }

    private function subStep11_5(rCat:OrderCat):void {
        subStep = 5;
        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep11_6);
    }

    private function subStep11_6():void {
        _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.ORDER);
        g.cont.moveCenterToPos(_tutorialObjects[0].posX, _tutorialObjects[0].posY, false, 1);
        (_tutorialObjects[0] as WorldObject).showArrow();
        _tutorialCallback = subStep11_7;
    }

    private function subStep11_7():void {
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialCallback = subStep11_8;
    }

    private function subStep11_8():void {
        subStep = 8;
        g.woOrder.setTextForCustomer(texts[g.user.tutorialStep][subStep]);
        _tutorialCallback = subStep11_9;
    }

    private function subStep11_9():void {

    }


//    if (!cat) cat = new TutorialCat();
//    if (!cutScene) cutScene = new CutScene();
//    if (!texts) texts = (new TutorialTexts()).objText;



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
}
}

