/**
 * Created by user on 11/28/16.
 */
package tutorial.newTuts {
import build.WorldObject;
import build.chestBonus.Chest;
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.farm.Farm;
import build.ridge.Ridge;
import build.tutorialPlace.TutorialPlace;
import build.wild.Wild;

import com.junkbyte.console.Cc;
import data.BuildType;
import flash.geom.Point;
import mouse.ToolsModifier;
import particle.tuts.DustRectangle;

import tutorial.AfterTutorialWindow;
import tutorial.CutScene;
import tutorial.IManagerTutorial;
import tutorial.TutorialAction;
import tutorial.pretuts.TutorialMultNew;
import utils.SimpleArrow;
import utils.Utils;
import windows.WindowsManager;
import windows.fabricaWindow.WOFabrica;
import windows.shop.WOShop;

public class ManagerTutorialNew extends IManagerTutorial{

    public function ManagerTutorialNew() {
        super();
        _useNewTuts = true;
    }

    override protected function initScenes():void {
        var curFunc:Function;
        _subStep = 0;
        _currentAction = TutorialAction.NONE;
        try {
            Cc.info('init tutorial scene for step: ' + g.user.tutorialStep);
            switch (g.user.tutorialStep) {
                case 1: curFunc = initScene_1; break;
                case 2: curFunc = initScene_2; break;
                case 3: curFunc = initScene_3; break;
                case 4: curFunc = initScene_4; break;
                case 5: curFunc = initScene_5; break;
                case 6: curFunc = initScene_6; break;
                case 7: curFunc = initScene_7; break;
                case 8: curFunc = initScene_8; break;
                case 9: curFunc = initScene_9; break;
                case 10: curFunc = initScene_10; break;
                case 11: curFunc = initScene_11; break;
                case 12: curFunc = initScene_12; break;
                case 13: curFunc = initScene_13; break;
                case 14: curFunc = initScene_14; break;
                case 15: curFunc = initScene_15; break;
                case 16: curFunc = initScene_16; break;
//                case 17: curFunc = initScene_17; break;

                default: Cc.error('unknown tuts step');
                    subStep16_4();
                    break;
            }
            if (curFunc != null) {
                curFunc.apply();
            }
            g.friendPanel.hideIt(true);
        } catch (err:Error) {
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'tutorial');
            Cc.error("Tutorial crashed at step #" + String(g.user.tutorialStep) + " and subStep #" + String(_subStep) + " with error message " + err.message);
        }
    }

    private function initScene_1():void {
        _mult = new TutorialMultNew();
        _mult.showMult(subStep1_1, subStep1_2);
    }

    private function subStep1_1():void {
        _subStep = 1;
        g.startPreloader.hideIt();
        g.startPreloader = null;
    }

    private function subStep1_2():void {
        _subStep = 2;
        _mult.deleteIt();
        _mult = null;
        g.user.tutorialStep = 2;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_2():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTextsNew()).objText;
        var st:String = texts[g.user.tutorialStep][_subStep];
        if (g.user.name) {
            st = st.replace(' user_name ', ' ' + g.user.name + '. ');
        } else {
            st = st.replace(' user_name', '');
        }
        cutScene.showIt(st, texts['next'], subStep2_1, .5);
        addBlack();
    }

    private function subStep2_1():void {
        _subStep = 2;
        cutScene.hideIt(deleteCutScene, initScenes);
        removeBlack();
        g.user.tutorialStep = 3;
        updateTutorialStep();
    }

    private function initScene_3(r:Ridge = null):void {
        _subStep = 0;
        if (r) r.hideArrow();
        _tutorialObjects = [];
        var ar:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int=0; i<ar.length; i++) {
            if ((ar[i] as Ridge).isFreeRidge) continue;
            if ((ar[i] as Ridge).plant.dataPlant.id == 31) {
                _tutorialObjects.push(ar[i]);
                break;
            }
        }
        if (_tutorialObjects.length) {
            subStep3_1();
        } else {
            subStep3_2();
        }
    }

    private function subStep3_1():void {
        _subStep = 1;
        _currentAction = TutorialAction.CRAFT_RIDGE;
        var p:Point = new Point();
        var r:Ridge = _tutorialObjects[0] as Ridge;
        p.x = r.posX;
        p.y = r.posY;
        g.cont.moveCenterToPos(p.x, p.y, false, .5);
        r.showArrow();
        r.tutorialCallback = initScene_3;
    }

    private function subStep3_2():void {
        _subStep = 2;
        _tutorialObjects = [];
        g.user.tutorialStep = 4;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_4():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTextsNew()).objText;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['next'], subStep4_1, 0, 'tutorial_nyam');
        addBlack();
    }

    private function subStep4_1():void {
        removeBlack();
        _subStep = 1;
        cutScene.hideIt(deleteCutScene, initScenes);
        g.user.tutorialStep = 5;
        updateTutorialStep();
    }

    private function initScene_5():void {
        _tutorialResourceIDs = [31];
        _tutorialCallback = null;
        _tutorialObjects = [];
        var ar:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int=0; i<ar.length; i++) {
            if ((ar[i] as Ridge).isFreeRidge) {
                _tutorialObjects.push(ar[i]);
                break;
            }
        }
        if (_tutorialObjects.length) {
            _currentAction = TutorialAction.PLANT_RIDGE;
            var p:Point = new Point();
            var r:Ridge = _tutorialObjects[0] as Ridge;
            p.x = r.posX;
            p.y = r.posY;
            g.cont.moveCenterToPos(p.x, p.y, false, .5);
            r.showArrow();
            r.tutorialCallback = subStep5_1;
        } else {
            subStep5_10();
        }
    }

    private function subStep5_1(r:Ridge=null):void {
        r.hideArrow();
        initScene_5();
    }

    private function subStep5_10():void {
        _subStep = 10;
        g.user.tutorialStep = 6;
        _tutorialResourceIDs = [];
        updateTutorialStep();
        initScenes();
    }

    private function initScene_6():void {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
        if (!arr.length) {
            Cc.error('ManagerTutorialNew substep6_2: no farm');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'tuts 6_2');
            return;
        }
        if ((arr[0] as Farm).isAnyCrafted) {
            subStep6_4();
        } else {
            arr = (arr[0] as Farm).arrAnimals;
            for (var i:int = 0; i<arr.length; i++) {
                if ((arr[i] as Animal).state == Animal.WORK) {
                    subStep6_4();
                    return;
                }
            }
            _currentAction = TutorialAction.ANIMAL_FEED;
            _tutorialObjects.push(arr[0]);
            if (!cutScene) cutScene = new CutScene();
            if (!texts) texts = (new TutorialTextsNew()).objText;
            cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['next'], subStep6_1, 0);
            addBlack();
        }
    }

    private function subStep6_1():void {
        _subStep=1;
        removeBlack();
        cutScene.hideIt(deleteCutScene, subStep6_2);
    }

    private function subStep6_2():void {
        _subStep=2;
        g.cont.moveCenterToPos(28, 11, false, 1);
        (_tutorialObjects[0] as Animal).playDirectIdle();
        (_tutorialObjects[0] as Animal).addArrow();
        (_tutorialObjects[0] as Animal).tutorialCallback = subStep6_3;
    }

    private function subStep6_3(chick:Animal):void {
        chick.removeArrow();
        chick.tutorialCallback = null;
        subStep6_4();
    }

    private function subStep6_4():void {
        _subStep = 4;
        g.user.tutorialStep = 7;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_7():void {
        if (!_tutorialObjects.length) {
            var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
            if (!arr.length) {
                Cc.error('ManagerTutorialNew substep7_2: no farm');
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'tuts 7_2');
                return;
            }
            if ((arr[0] as Farm).isAnyCrafted) {
                subStep7_4();
            } else {
                g.cont.moveCenterToPos(28, 11, false, 1);
                arr = (arr[0] as Farm).arrAnimals;
                for (var i:int = 0; i<arr.length; i++) {
                    if ((arr[i] as Animal).state == Animal.WORK) {
                        _tutorialObjects.push(arr[i]);
                        break;
                    }
                }
                if (!_tutorialObjects.length) {
                    subStep7_4();
                    return;
                }
            }
        }
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTextsNew()).objText;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['next'], subStep7_1, 0);
        addBlack();
    }

    private function subStep7_1():void {
        _subStep=1;
        removeBlack();
        cutScene.hideIt(deleteCutScene, subStep7_2);
    }

    private function subStep7_2():void {
        _subStep = 2;
        _currentAction = TutorialAction.ANIMAL_SKIP;
        (_tutorialObjects[0] as Animal).playDirectIdle();
        (_tutorialObjects[0] as Animal).addArrow();
        (_tutorialObjects[0] as Animal).tutorialCallback = subStep7_3;
    }

    private function subStep7_3(ch:Animal):void {
        _currentAction = TutorialAction.NONE;
        if (g.timerHint) g.timerHint.managerHide();
        _subStep = 3;
        ch.removeArrow();
        ch.tutorialCallback = null;
        subStep7_4();
    }

    private function subStep7_4():void {
        _tutorialObjects = [];
        _subStep = 4;
        g.user.tutorialStep = 8;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_8():void {
        if (g.user.level > 1) {
            subStep8_2();
        } else {
            var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
            for (var i:int = 0; i < arr.length; i++) {
                if ((arr[i] as Farm).isAnyCrafted) {
                    _tutorialObjects.push(arr[i]);
                    break;
                }
            }
            if (_tutorialObjects.length) {
                g.cont.moveCenterToPos(28, 11, false, 1);
                _currentAction = TutorialAction.ANIMAL_CRAFT;
                (_tutorialObjects[0] as Farm).addArrowToCraftItem(subStep8_1);
            } else {
                subStep8_1();
            }
        }
    }

    private function subStep8_1():void {
        _tutorialObjects = [];
        _subStep = 1;
        _currentAction = TutorialAction.LEVEL_UP;
        _tutorialCallback = subStep8_2;
    }

    private function subStep8_2():void {
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 9;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_9():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTextsNew()).objText;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], String(g.managerLanguage.allTexts[532]), subStep9_2);
        addBlackUnderInterface();
    }

    private function subStep9_2():void {
        _subStep = 2; //  need for shop == 2
        cutScene.hideIt(deleteCutScene);
        _currentAction = TutorialAction.NEW_RIDGE;
        _tutorialResourceIDs = [11];
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep9_2a;
        g.bottomPanel.activateShopButtonHoverAnimation(true);
    }

    private function subStep9_2a():void {
        _subStep = 2;
        removeBlack();
        g.bottomPanel.deleteArrow();
        g.bottomPanel.activateShopButtonHoverAnimation(false);
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _onShowWindowCallback = subStep9_3;
    }

    private function subStep9_3():void {
        _subStep = 3;
        _onShowWindowCallback = null;
        _tutorialObjects.length = 0;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height - 15);

            var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
            for (var i:int=0; i<arr.length; i++) {
                if (arr[i].posY == 35) {
                    _tutorialObjects.push(arr[i]);
                }
            }
            if (!_tutorialObjects.length) {
                _tutorialCallback = subStep9_4;
            } else if (_tutorialObjects.length == 1) {
                _tutorialCallback = subStep9_7;
            } else {
                _tutorialCallback = subStep9_9;
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

    private function subStep9_4():void {
        _subStep = 4;
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
        subStep9_5();
    }

    private function subStep9_5():void {
        _subStep = 5;
        g.cont.moveCenterToPos(21, 35);
        _tutorialCallback = subStep9_6;
    }

    private function subStep9_6():void {
        _subStep = 6;
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        subStep9_7();
    }

    private function subStep9_7():void {
        _subStep = 7;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _tutorialPlaceBuilding = _tutorialObjects[1];
        g.cont.moveCenterToPos(23, 35);
        _tutorialPlaceBuilding.activateIt(true);
        _tutorialCallback = subStep9_8;
    }

    private function subStep9_8():void {
        _subStep = 8;
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        subStep9_9();
    }

    private function subStep9_9():void {
        _subStep = 9;
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
        _tutorialCallback = subStep9_10;
    }

    private function subStep9_10():void {
        _subStep = 10;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _tutorialPlaceBuilding.activateIt(false);
        _tutorialPlaceBuilding = null;
        _tutorialResourceIDs = [];
        _tutorialObjects = [];
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 10;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_10():void {
        _subStep = 0;
        _currentAction = TutorialAction.NONE;
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int=0; i<arr.length; i++) {
            if (arr[i].posY == 35 && (arr[i] as Ridge).isFreeRidge) {
                _tutorialObjects.push(arr[i]);
            }
        }
        if (!_tutorialObjects.length) {
            subStep10_4();
            return;
        }
        _tutorialObjects.sortOn('posX', Array.NUMERIC);
        subStep10_1();
    }

    private function subStep10_1():void {
        _subStep = 1;
        _tutorialResourceIDs = [32];
        _currentAction = TutorialAction.PLANT_RIDGE;
        (_tutorialObjects[0] as WorldObject).showArrow();
        (_tutorialObjects[0] as Ridge).tutorialCallback = subStep10_2;
    }

    private function subStep10_2(r:Ridge=null):void {
        _subStep = 2;
        _tutorialCallback = null;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialObjects.shift();
        if (!_tutorialObjects.length) {
            subStep10_4();
        } else {
            (_tutorialObjects[0] as WorldObject).showArrow();
            (_tutorialObjects[0] as Ridge).tutorialCallback = subStep10_3;
        }
    }

    private function subStep10_3(r:Ridge=null):void {
        _subStep = 3;
        (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialObjects.shift();
        if (!_tutorialObjects.length) {
            subStep10_4();
        } else {
            (_tutorialObjects[0] as WorldObject).showArrow();
            (_tutorialObjects[0] as Ridge).tutorialCallback = subStep10_4;
        }
    }

    private function subStep10_4(r:Ridge=null):void {
        _subStep = 4;
        if (_tutorialObjects.length) (_tutorialObjects[0] as WorldObject).hideArrow();
        _tutorialObjects.length = 0;
        _tutorialResourceIDs.length = 0;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        g.user.tutorialStep = 11;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_11():void {
        _currentAction = TutorialAction.NONE;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTextsNew()).objText;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], String(g.managerLanguage.allTexts[532]), subStep11_1);
//        g.bottomPanel.animateShowingMainPanel();
//        Utils.createDelay(1.1, subStep7_1);
        _tutorialCallback = null;
        addBlackUnderInterface();
    }

    private function subStep11_1():void {
        _subStep = 1;
        cutScene.hideIt(deleteCutScene);
        _currentAction = TutorialAction.BUY_ANIMAL;
        _tutorialResourceIDs = [1];
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep11_2;
        g.bottomPanel.activateShopButtonHoverAnimation(true);
    }

    private function subStep11_2():void {
        removeBlack();
        g.bottomPanel.deleteArrow();
        g.bottomPanel.activateShopButtonHoverAnimation(false);
        _subStep = 2;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _onShowWindowCallback = subStep11_3;
    }

    private function subStep11_3():void {
        _subStep = 3;
        _onShowWindowCallback = null;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height - 15);
            _tutorialCallback = subStep11_4;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
    }

    private function subStep11_4():void {
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
        Utils.createDelay(3, subStep11_5);
    }

    private function subStep11_5():void {
        _subStep = 5;
        g.user.tutorialStep = 12;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_12():void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _currentAction = TutorialAction.NONE;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTextsNew()).objText;
        _subStep = 0;
        _tutorialResourceIDs = [3];
        _tutorialObjects = g.townArea.getCityObjectsById(_tutorialResourceIDs[0]);
        if (_tutorialObjects.length) {
            g.cont.moveCenterToPos(30, 11, false, 2);
            subStep12_4();
        } else {
            addBlackUnderInterface();
            cutScene.showIt(texts[g.user.tutorialStep][_subStep], String(g.managerLanguage.allTexts[532]), subStep12_1a);
        }
    }

    private function subStep12_1a():void {
        cutScene.hideIt(deleteCutScene);
        _currentAction = TutorialAction.BUY_FABRICA;
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep12_1;
        g.bottomPanel.activateShopButtonHoverAnimation(true);
    }

    private function subStep12_1():void {
        removeBlack();
        _subStep = 1;
        g.bottomPanel.deleteArrow();
        g.bottomPanel.activateShopButtonHoverAnimation(false);
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _onShowWindowCallback = subStep12_2;
    }

    private function subStep12_2():void {
        _subStep = 2;
        _onShowWindowCallback = null;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height - 15);
            _tutorialCallback = subStep12_3;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
        var dataPlace:Object = {};
        dataPlace.dataBuild = -1;
        dataPlace.buildType = BuildType.TUTORIAL_PLACE;
        dataPlace.width = g.allData.getBuildingById(_tutorialResourceIDs[0]).width;
        dataPlace.height = g.allData.getBuildingById(_tutorialResourceIDs[0]).height;
        _tutorialPlaceBuilding = g.townArea.createNewBuild(dataPlace) as TutorialPlace;
        var p:Point = new Point(10, 7);
        p = g.matrixGrid.getXYFromIndex(p);
        g.townArea.pasteBuild(_tutorialPlaceBuilding, p.x, p.y, false, false);
    }

    private function subStep12_3():void {
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
        _tutorialCallback = subStep12_4;
    }

    private function subStep12_4():void {
        if (_tutorialPlaceBuilding) {
            _tutorialPlaceBuilding.activateIt(false);
            _tutorialPlaceBuilding = null;
        }
        _subStep = 4;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        g.cont.moveCenterToPos(8, 9);
        Utils.createDelay(.5, subStep12_5);
    }

    private function subStep12_5():void {
        _subStep = 5;
        if ((_tutorialObjects[0] as Fabrica).stateBuild == WorldObject.STATE_ACTIVE) {
            subStep12_7();
        } else {
            _currentAction = TutorialAction.PUT_FABRICA;
            _tutorialCallback = subStep12_6;
            (_tutorialObjects[0] as Fabrica).showArrow();
        }
    }

    private function subStep12_6():void {
        _subStep = 6;
        _tutorialResourceIDs = [];
        _currentAction = TutorialAction.NONE;
        (_tutorialObjects[0] as Fabrica).hideArrow();
        subStep12_7();
    }

    private function subStep12_7():void {
        _subStep = 7;
        g.user.tutorialStep = 13;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_13():void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _subStep = 0;
        _currentAction = TutorialAction.RAW_RECIPE;
        _tutorialResourceIDs = [1]; // recipeId
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.FABRICA);
        }
        if ((_tutorialObjects[0] as Fabrica).isAnyCrafted) {
            subStep13_3();
        } else {
            g.cont.moveCenterToPos(8, 9, true);
            (_tutorialObjects[0] as Fabrica).showArrow();
            _tutorialCallback = subStep13_1;
        }
    }

    private function subStep13_1():void {
        _subStep = 1;
        (_tutorialObjects[0] as Fabrica).hideArrow();
        _tutorialCallback = subStep13_2;
    }

    private function subStep13_2():void {
        _subStep = 2;
        _currentAction = TutorialAction.FABRICA_SKIP_RECIPE;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_FABRICA) {
            var ob:Object = (g.windowsManager.currentWindow as WOFabrica).getSkipBtnProperties();
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_LEFT, g.cont.popupCont);
            _arrow.scaleIt(.8);
            _arrow.animateAtPosition(ob.x, ob.y + ob.height/2);
            _tutorialCallback = subStep13_3;
        } else {
            Cc.error('tuts:: WO_fabrica is not opened');
        }
    }

    private function subStep13_3():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _tutorialCallback = null;
        _tutorialObjects = [];
        _tutorialResourceIDs = [];
        _currentAction = TutorialAction.NONE;
        g.windowsManager.hideWindow(WindowsManager.WO_FABRICA);
        g.user.tutorialStep = 14;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_14():void {
        if (!_tutorialObjects.length) {
            _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.FABRICA);
        }
        if ((_tutorialObjects[0] as Fabrica).isAnyCrafted) {
            g.cont.moveCenterToPos(8, 9);
            subStep14_1();
        } else {
            subStep14_2();
        }
    }

    private function subStep14_1():void {
        _subStep = 1;
        _currentAction = TutorialAction.FABRICA_CRAFT;
        (_tutorialObjects[0] as Fabrica).addArrowToCraftItem(subStep14_2);
        _tutorialCallback = subStep14_2;
    }

    private function subStep14_2():void {
        _subStep = 2;
        _tutorialObjects = [];
        _tutorialResourceIDs = [];
        _currentAction = TutorialAction.NONE;
        g.user.tutorialStep = 15;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_15():void {
        var ar:Array = g.townArea.getCityObjectsById(57);
        for (var i:int=0; i<ar.length; i++) {
            if ((ar[i] as Wild).posX == 10 && (ar[i] as Wild).posY == 31) {
                _tutorialObjects.push(ar[i]);
                break;
            }
        }
        if (!_tutorialObjects.length) {
            subStep15_10();
            return;
        }
        if (g.userInventory.getCountResourceById((_tutorialObjects[0] as Wild).dataBuild.removeByResourceId) <= 0) { // add it at new user start in php, not here
            g.userInventory.addResource((_tutorialObjects[0] as Wild).dataBuild.removeByResourceId, 1);
        }
        g.cont.moveCenterToPos(9, 30, false, 1);
        Utils.createDelay(1.5, subStep15_1);
    }

    private function subStep15_1():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTextsNew()).objText;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][_subStep],texts['next'], subStep15_2);
    }

    private function subStep15_2():void {
        _subStep = 1;
        cutScene.hideIt(deleteCutScene);
        removeBlack();
        _currentAction = TutorialAction.REMOVE_WILD;
        _tutorialCallback = subStep15_3;
        (_tutorialObjects[0] as Wild).showArrow();
    }

    private function subStep15_3():void {
        (_tutorialObjects[0] as Wild).hideArrow();
        _tutorialCallback = subStep15_4;
    }

    private function subStep15_4():void {
        _currentAction = TutorialAction.NONE;
        _tutorialCallback = null;
        if (g.wildHint) g.wildHint.managerHide();
        Utils.createDelay(3, subStep15_10);
    }

    private function subStep15_10():void {
        _subStep = 10;
        g.user.tutorialStep = 16;
        updateTutorialStep();
        _tutorialCallback = null;
        _tutorialObjects = [];
        Utils.createDelay(1, initScenes);
    }


    private function initScene_16():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TutorialTextsNew()).objText;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep],texts['next'], subStep16_1);
        addBlack();
    }

    private function subStep16_1():void {
        removeBlack();
        _subStep = 1;
        cutScene.hideIt(deleteCutScene);
        _tutorialObjects = [];
        var chest:WorldObject = g.managerChest.makeTutorialChest();
        _tutorialObjects.push(chest);
        g.cont.moveCenterToPos(31, 31, false, 1);
        Utils.createDelay(1, subStep16_2);
    }

    private function subStep16_2():void {
        _subStep = 2;
        (_tutorialObjects[0] as Chest).showArrow();
        _currentAction = TutorialAction.TAKE_CHEST;
        _tutorialCallback = subStep16_3;
    }

    private function subStep16_3():void {
        _subStep = 3;
        (_tutorialObjects[0] as Chest).hideArrow();
        _tutorialCallback = subStep16_4;
    }

    private function subStep16_4():void {
        _subStep = 4;
        _tutorialCallback = null;
        _tutorialObjects = [];
        _currentAction = TutorialAction.NONE;
//        g.user.tutorialStep = 17;
//        updateTutorialStep();
//        initScenes();
//    }
//
//    private function initScene_17():void {
//        _afterTutorialWindow = new AfterTutorialWindow();
//        Utils.createDelay(1.5, subStep17_1);
//    }
//
//    private function subStep17_1():void {
//        _subStep = 1;
//        _afterTutorialWindow.showIt(subStep17_2);
//    }
//
//    private function subStep17_2():void {
//        _subStep = 2;
        g.user.tutorialStep = 101;
        updateTutorialStep();
        TUTORIAL_ON = false;
        if (g.managerOrder) g.managerOrder.showSmallHeroAtOrder(true);
        if (g.managerHelpers) g.managerHelpers.checkIt();
        super.clearAll();
    }




//    private function subStep8_1():void {
//        g.user.tutorialStep = 101;
//        updateTutorialStep();
//        TUTORIAL_ON = false;
//        if (g.managerOrder) g.managerOrder.showSmallHeroAtOrder(true);
//        super.clearAll();
//    }

}
}
