/**
 * Created by user on 4/28/16.
 */
package tutorial.managerCutScenes {
import build.WorldObject;
import build.market.Market;

import data.BuildType;

import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import manager.Vars;
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import tutorial.AirTextBubble;
import tutorial.CutScene;
import tutorial.DustRectangle;
import tutorial.SimpleArrow;
import tutorial.TutorialCat;

public class ManagerCutScenes {
    public static const CAT_BIG:String = 'big';         // use class CatScene
    public static const CAT_SMALL:String = 'small';     // use class TutorialCat
    public static const CAT_AIR:String = 'air';         // use class AirTextBubble

    public static const REASON_NEW_LEVEL:int = 1;  // use after getting new level
    public static const REASON_STUPID_USER:int = 2;  // use if user do nothing at 4-9 levels during 30 seconds

    public static const ID_ACTION_SHOW_ORDER:int=0;
    public static const ID_ACTION_SHOW_PAPPER:int=1;
    private var countActions:int = 2;

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

    public function checkAvailableCutScenes():void { // use this function only once at game start
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
                    if (_properties[i].reason == REASON_NEW_LEVEL && g.user.level == _properties[i].level) {
                        _curCutScenePropertie = _properties[i];
                        checkTypeFunctions();
                        return;
                    }
                }
                break;
        }
    }

    public function isType(id:int):Boolean {
        return isCutScene && id == _curCutScenePropertie.id_action;
    }

    private function checkTypeFunctions():void {
        switch (_curCutScenePropertie.id_action) {
            case ID_ACTION_SHOW_ORDER: releaseOrderAndPapper(); break;
        }
    }

    public function releaseOrderAndPapper():void {
        isCutScene = true;
        _cutSceneBuildings = g.townArea.getCityObjectsByType(BuildType.MARKET);
        addCatToPos(20, 22);
        g.managerCats.goCatToPoint(_cat, new Point(46, 0), order_1);
        g.cont.moveCenterToPos(_cutSceneBuildings[0].source.x - 100, _cutSceneBuildings[0].source.y + 300, false, 2);
    }

    private function order_1():void {
        _cat.flipIt(true);
        _cat.showBubble(_curCutScenePropertie.text);
        (_cutSceneBuildings as Market).showArrow();

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

    private function createDelay(delay:int, f:Function):void {
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
