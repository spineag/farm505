/**
 * Created by user on 2/29/16.
 */
package tutorial {
import build.WorldObject;
import build.farm.Animal;
import build.farm.Farm;
import com.junkbyte.console.Cc;
import data.BuildType;
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
    private var _currentAction:int;
    private var _tutorialResourceIDs:Array;

    public function ManagerTutorial() {
        tutorialObjects = [];
        _currentAction = TutorialAction.NONE;
        _tutorialResourceIDs = [];
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
        tutorialObjects = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        var count:int = 0;
        var f:Function = function (wo:WorldObject):void {
            count++;
            wo.hideArrow();
            wo.tutorialCallback = null;
            if (count >= tutorialObjects.length) {
                _currentAction = TutorialAction.NONE;
                subStep2_2();
            }
        };
        _currentAction = TutorialAction.CRAFT_RIDGE;
        for (var i:int=0; i<tutorialObjects.length; i++) {
            (tutorialObjects[i] as WorldObject).showArrow();
            (tutorialObjects[i] as WorldObject).tutorialCallback = f;
        }
    }

    private function subStep2_2():void {
        tutorialObjects = [];
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
        tutorialObjects = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        _currentAction = TutorialAction.PLANT_RIDGE;
        _tutorialResourceIDs = [31];
        (tutorialObjects[0] as WorldObject).showArrow();
        (tutorialObjects[0] as WorldObject).tutorialCallback = subStep3_2;
    }

    private function subStep3_2(r:WorldObject):void {
        _tutorialResourceIDs = [];
        tutorialObjects.splice(tutorialObjects.indexOf(r), 1);
        r.hideArrow();
        r.tutorialCallback = null;
        (tutorialObjects[0] as WorldObject).showArrow();
        (tutorialObjects[0] as WorldObject).tutorialCallback = subStep3_3;
    }

    private function subStep3_3(r:WorldObject):void {
        tutorialObjects.splice(tutorialObjects.indexOf(r), 1);
        r.hideArrow();
        r.tutorialCallback = null;
        (tutorialObjects[0] as WorldObject).showArrow();
        (tutorialObjects[0] as WorldObject).tutorialCallback = subStep3_4;
    }

    private function subStep3_4(r:WorldObject):void {
        _currentAction = TutorialAction.NONE;
        r.hideArrow();
        r.tutorialCallback = null;
        tutorialObjects = [];
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
    }

    private function subStep4_1():void {
        subStep = 1;
        cat.playDirectLabel('idle3', true, playCatIdle);
        cat.showBubble(texts[g.user.tutorialStep][subStep], texts['ok'], subStep4_2);
    }

    private function subStep4_2():void {
        cat.hideBubble();
        tutorialObjects = g.townArea.getCityObjectsByType(BuildType.FARM);
        tutorialObjects = (tutorialObjects[0] as Farm).arrAnimals;
        (tutorialObjects[0] as Animal).playDirectIdle();
        (tutorialObjects[0] as Animal).addArrow();
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

