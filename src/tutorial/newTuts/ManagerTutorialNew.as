/**
 * Created by user on 11/28/16.
 */
package tutorial.newTuts {
import build.farm.Animal;
import build.farm.Farm;
import build.ridge.Ridge;
import com.junkbyte.console.Cc;
import data.BuildType;
import flash.geom.Point;
import tutorial.CutScene;
import tutorial.IManagerTutorial;
import tutorial.TutorialAction;
import tutorial.pretuts.TutorialMultNew;
import windows.WindowsManager;

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

                default: Cc.error('unknown tuts step'); break;
            }
            if (curFunc != null) {
                curFunc.apply();
            }
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
            st.replace(' user_name ', ', ' + g.user.name + ',');
        } else {
            st.replace(' user_name', '');
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
        _subStep = 3;
        ch.removeArrow();
        ch.tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
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
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
        for (var i:int=0; i<arr.length; i++) {
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

    private function subStep8_1():void {
        g.user.tutorialStep = 101;
        updateTutorialStep();
        TUTORIAL_ON = false;
        if (g.managerOrder) g.managerOrder.showSmallHeroAtOrder(true);
        super.clearAll();
    }

}
}
