package tutorial {
import analytic.AnalyticManager;
import build.WorldObject;
import com.junkbyte.console.Cc;
import manager.Vars;
import particle.tuts.DustRectangle;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import tutorial.pretuts.TutorialMultNew;
import utils.SimpleArrow;

public class IManagerTutorial {
    protected var TUTORIAL_ON:Boolean = true;
    protected const MAX_STEPS:uint = 100;
    protected var g:Vars = Vars.getInstance();
    protected var cutScene:CutScene;
    protected var _subStep:int;
    protected var texts:Object;
    protected var black:Sprite;
    protected var _tutorialObjects:Array;
    protected var _currentAction:int;
    protected var _tutorialResourceIDs:Array;
    protected var _dustRectangle:DustRectangle;
    protected var _tutorialCallback:Function;
    protected var _onShowWindowCallback:Function;
    protected var _airBubble:AirTextBubble;
    protected var _counter:int;
    protected var _arrow:SimpleArrow;
    protected var _mult:TutorialMultNew;
    protected var _afterTutorialWindow:AfterTutorialWindow;
    protected var _useNewTuts:Boolean;

    public function IManagerTutorial() {
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

    public function onGameStart():void { initScenes(); }
    public function useNewTuts():Boolean { return _useNewTuts; }
    protected function initScenes():void {}
    public function get currentAction():int { return _currentAction; }
    public function get subStep():int { return _subStep; }
    public function isTutorialResource(id:int):Boolean { return _tutorialResourceIDs.indexOf(id) > -1; }
    public function get isTutorial():Boolean { return TUTORIAL_ON && g.user.tutorialStep < MAX_STEPS; }
    public function checkDefaults():void {}
    public function onResize():void {}
    public function isTutorialBuilding(wo:WorldObject):Boolean { return _tutorialObjects.indexOf(wo) > -1; }
    public function addTutorialWorldObject(w:WorldObject):void {_tutorialObjects.push(w); }
    protected function emptyFunction(...params):void {}

    protected function clearAll():void {
    }

    protected function deleteCutScene():void {
        if (cutScene) {
            cutScene.deleteIt();
            cutScene = null;
        }
    }

    protected function addBlack():void {
        if (!black) {
            var q:Quad = new Quad(g.managerResize.stageWidth, g.managerResize.stageHeight, Color.BLACK);
            black = new Sprite();
            black.addChild(q);
            black.alpha = .3;
            g.cont.popupCont.addChildAt(black, 0);
        }
    }

    protected function removeBlack():void {
        if (black) {
            if (g.cont.popupCont.contains(black)) g.cont.popupCont.removeChild(black);
            black.dispose();
            black = null;
        }
    }

    protected function updateTutorialStep():void {
        Cc.info('update tutorial step: ' + g.user.tutorialStep);
        g.directServer.updateUserTutorialStep(null);
        if (g.analyticManager)
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.ACTION_TUTORIAL, {id:g.user.tutorialStep});
    }
}
}
