/**
 * Created by user on 11/28/16.
 */
package tutorial.newTuts {
import build.WorldObject;
import build.ridge.Ridge;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import tutorial.CutScene;
import tutorial.IManagerTutorial;
import tutorial.TutorialAction;
import tutorial.pretuts.TutorialMultNew;

import utils.Utils;

import windows.WindowsManager;

public class ManagerTutorialNew extends IManagerTutorial{

    public function ManagerTutorialNew() {
        super();
        _needBlockForTutorial = false;
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
        _needBlockForTutorial = true;
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
        _needBlockForTutorial = true;
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
        g.cont.moveCenterToPos(p.x, p.y, false, 2);
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
            g.cont.moveCenterToPos(p.x, p.y, false, 2);
            r.showArrow();
            r.tutorialCallback = subStep5_1;
        } else {
            subStep5_10();
        }
    }

    private function subStep5_1(r:Ridge=null):void {
        r.hideArrow();

    }

    private function subStep5_10():void {
        _subStep = 10;
        g.user.tutorialStep = 6;
        updateTutorialStep();
        initScenes();
    }


}
}
