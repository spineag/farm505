/**
 * Created by user on 4/28/16.
 */
package tutorial.managerCutScenes {
import build.WorldObject;

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
    public static const REASON_STUPID_USER:int = 2;  // use if user do nothing at 4-9 levels 30 seconds

    public static const TYPE_ACTION_SHOW_ORDER_AND_PAPPER:String = 'order_and_papper';

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

    public function checkCutScene(reason:int):void {
        if (g.user.level < 5) return;
        var i:int;
        switch (reason) {
            case REASON_NEW_LEVEL:
                for (i=0; i<_properties.length; i++) {
                    if (_properties[i].raeson == REASON_NEW_LEVEL && g.user.level == _properties[i].level) {
                        _curCutScenePropertie = _properties[i];
                        checkTypeFunctions();
                        return;
                    }
                }
                break;
        }
    }

    public function isType(type:String):Boolean {
        return isCutScene && type == _curCutScenePropertie.type;
    }

    private function checkTypeFunctions():void {
        switch (_curCutScenePropertie.type) {
            case TYPE_ACTION_SHOW_ORDER_AND_PAPPER: releaseOrderAndPapper(); break;
        }
    }

    public function releaseOrderAndPapper():void {
        isCutScene = true;

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
