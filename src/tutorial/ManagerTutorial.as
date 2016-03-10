/**
 * Created by user on 2/29/16.
 */
package tutorial {
import build.WorldObject;

import com.junkbyte.console.Cc;
import flash.geom.Point;
import manager.Vars;
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

public class ManagerTutorial {
    private const TUTORIAL_ON:Boolean = false;

    private const MAX_STEPS:uint = 100;
    private var g:Vars = Vars.getInstance();
    private var cat:TutorialCat;
    private var cutScene:CutScene;
    private var subStep:int;
    private var texts:Object;
    private var black:Sprite;
    private var tutorialObjects:Array;

    public function ManagerTutorial() {
        tutorialObjects = [];
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
//                case 2:
//                    curFunc = initScene2;
//                    break;
//                case 3:
//                    curFunc = initScene3;
//                    break;
//                case 4:
//                    curFunc = initScene4;
//                    break;
//                case 5:
//                    curFunc = initScene5;
//                    break;
//                case 6:
//                    curFunc = initScene6;
//                    break;
//                case 7:
//                    curFunc = initScene7;
//                    break;
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
        subStep = 1;
        if (!cat) {
            addCatToPos(30, 26);
        }
        if (!texts) texts = (new TutorialTexts()).objText;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.flipIt(true);
        cat.showBubble(texts[g.user.tutorialStep][subStep]);
        g.optionPanel.makeScaling(1,false);
        g.cont.moveCenterToPos(30, 30);
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
        return tutorialObjects.indexOf(wo) > -1;
    }
}
}

