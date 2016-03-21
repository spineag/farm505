/**
 * Created by user on 5/14/15.
 */
package manager {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import flash.geom.Point;

import map.MatrixGrid;

import mouse.ToolsModifier;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import tutorial.ManagerTutorial;
import tutorial.TutorialAction;

public class Containers {
    public var SHIFT_MAP_X:int;
    public var SHIFT_MAP_Y:int;

    public var mainCont:Sprite;
    public var backgroundCont:Sprite;
    public var gridDebugCont:Sprite;
    public var tailCont:Sprite;
    public var contentCont:Sprite;
    public var cloudsCont:Sprite;
    public var animationsCont:Sprite;
    public var interfaceContMapEditor:Sprite;
    public var interfaceCont:Sprite;
    public var animationsContTop:Sprite;
    public var animationsContBot:Sprite;
    public var animationsResourceCont:Sprite;
    public var windowsCont:Sprite;
    public var popupCont:Sprite;
    public var hintCont:Sprite;
    public var hintContUnder:Sprite;
    public var hintGameCont:Sprite;
    public var mouseCont:Sprite;
    public var gameCont:Sprite;

    private var _startDragPoint:Point;
    private var _startDragPointCont:Point;

    private var g:Vars = Vars.getInstance();

    public function Containers() {
        SHIFT_MAP_X = 185 * g.scaleFactor;
        SHIFT_MAP_Y = 590 * g.scaleFactor;

        mainCont = new Sprite();
        gameCont = new Sprite();
        backgroundCont = new Sprite();
        gridDebugCont = new Sprite();
        contentCont = new Sprite();
        tailCont = new Sprite();
        animationsCont = new Sprite();
        cloudsCont = new Sprite();
        interfaceCont = new Sprite();
        animationsContBot = new Sprite();
        animationsContTop = new Sprite();
        animationsResourceCont = new Sprite();
        windowsCont = new Sprite();
        popupCont = new Sprite();
        hintCont = new Sprite();
        hintContUnder = new Sprite();
        hintGameCont = new Sprite();
        mouseCont = new Sprite();
        interfaceContMapEditor = new Sprite();

        mainCont.addChild(gameCont);
        gameCont.addChild(backgroundCont);
        gameCont.addChild(gridDebugCont);
        gameCont.addChild(tailCont);
        gameCont.addChild(contentCont);
        gameCont.addChild(animationsCont);
        gameCont.addChild(cloudsCont);
        mainCont.addChild(hintGameCont);
        mainCont.addChild(animationsContBot);
        mainCont.addChild(interfaceCont);
        mainCont.addChild(interfaceContMapEditor);
        mainCont.addChild(animationsContTop);
        mainCont.addChild(hintContUnder);
        mainCont.addChild(windowsCont);
        mainCont.addChild(animationsResourceCont);
        mainCont.addChild(hintCont);
        mainCont.addChild(popupCont);
        mainCont.addChild(mouseCont);

        g.mainStage.addChild(mainCont);

        addGameContListener(true);
    }

    public function addGameContListener(value:Boolean):void {
        if (value) {
            if (gameCont.hasEventListener(TouchEvent.TOUCH)) return;
            gameCont.addEventListener(TouchEvent.TOUCH, onGameContTouch);

        } else {
            if (!gameCont.hasEventListener(TouchEvent.TOUCH)) return;
            gameCont.removeEventListener(TouchEvent.TOUCH, onGameContTouch);
        }
    }

    private var _isDragged:Boolean = false;
    private function onGameContTouch(te:TouchEvent):void {
        var p:Point;
        if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED && te.getTouch(gameCont, TouchPhase.ENDED)) {
            p = te.touches[0].getLocation(g.mainStage);
            p.x -= gameCont.x;
            p.y -= gameCont.y;
            p = g.matrixGrid.getStrongIndexFromXY(p);
            g.deactivatedAreaManager.deactivateArea(p.x, p.y);
            return;
        }

        if (te.getTouch(gameCont, TouchPhase.ENDED)) {
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE && !_isDragged && g.selectedBuild) {
                g.toolsModifier.onTouchEnded();
                _isDragged = false;
                return;
            }
            if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
                if (!_isDragged) {
                    g.bottomPanel.cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                _isDragged = false;
                return;
            }
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
                if (!_isDragged) {
                    g.bottomPanel.cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                _isDragged = false;
                return;
            }
            _isDragged = false;
        }

        if (te.getTouch(gameCont, TouchPhase.MOVED)) {
            _isDragged = true;
            dragGameCont(te.touches[0].getLocation(g.mainStage));  // потрібно переписати перевірки на спосіб тачу
        } else if (te.getTouch(gameCont, TouchPhase.BEGAN)) {
            _startDragPoint = te.touches[0].getLocation(g.mainStage); //te.touches[0].globalX;
            _startDragPointCont = new Point(gameCont.x, gameCont.y);
            if (g.currentOpenedWindow) {
                g.currentOpenedWindow.hideIt();
            }
        }
    }

    public function setDragPoints(p:Point):void {
        _startDragPoint = p;
        _startDragPointCont = new Point(gameCont.x, gameCont.y);
    }

    public function dragGameCont(mouseP:Point):void {
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction == TutorialAction.PUT_FABRICA || g.managerTutorial.currentAction == TutorialAction.PUT_FARM) {

            } else {
                return;
            }
        }
        g.hideAllHints(); // ??? not optimise
        var s:Number = gameCont.scaleX;
        if (_startDragPointCont == null || _startDragPoint == null) return;
        gameCont.x = _startDragPointCont.x + mouseP.x - _startDragPoint.x;
        gameCont.y = _startDragPointCont.y + mouseP.y - _startDragPoint.y;
        var oY:Number = g.matrixGrid.offsetY*s;
        if (gameCont.y > oY + SHIFT_MAP_Y*s) gameCont.y = oY + SHIFT_MAP_Y*s;
        if (gameCont.y < -g.realGameTilesHeight*s - oY + Starling.current.nativeStage.stageHeight + SHIFT_MAP_Y*s)
            gameCont.y = -g.realGameTilesHeight*s - oY + Starling.current.nativeStage.stageHeight + SHIFT_MAP_Y*s;
        if (gameCont.x > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s)
            gameCont.x =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s;
        if (gameCont.x < -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth + SHIFT_MAP_X*s)
            gameCont.x = -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth + SHIFT_MAP_X*s;
    }

    public function moveCenterToXY(_x:int, _y:int, needQuick:Boolean = false, time:Number = .5):void {  // (_x, _y) - координати в загальній системі gameCont
        //переміщаємо ігрову область так, щоб вказана точка була по центру екрана
        var newX:int;
        var newY:int;
        var s:Number = gameCont.scaleX;
        var oY:Number = g.matrixGrid.offsetY*s;
        newX = -(_x*s - Starling.current.nativeStage.stageWidth/2);
        newY = -(_y*s - Starling.current.nativeStage.stageHeight/2);
        if (newY > oY + SHIFT_MAP_Y*s) gameCont.y = oY + SHIFT_MAP_Y*s;
        if (newY < -g.realGameTilesHeight*s - oY + Starling.current.nativeStage.stageHeight + SHIFT_MAP_Y*s)
            newY = -g.realGameTilesHeight*s - oY + Starling.current.nativeStage.stageHeight + SHIFT_MAP_Y*s;
        if (newX > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s)
            newX =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s;
        if (newX < -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth - SHIFT_MAP_X*s)
            newX = -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth - SHIFT_MAP_X*s;

        if (needQuick) {
            gameCont.x = newX;
            gameCont.y = newY;
        } else {
            new TweenMax(gameCont, time, {x:newX, y:newY, ease:Linear.easeOut});
//            var tween:Tween = new Tween(gameCont, .5);
//            tween.moveTo(newX, newY);
//            tween.onComplete = function ():void {
//                g.starling.juggler.remove(tween);
//            };
//            g.starling.juggler.add(tween);
        }
    }

    public function moveCenterToPos(posX:int, posY:int, needQuick:Boolean = false, time:Number = .5):void {
        var p:Point = new Point(posX, posY);
        p = g.matrixGrid.getXYFromIndex(p);
        moveCenterToXY(p.x, p.y, needQuick, time);
    }

    public function deltaMoveGameCont(deltaX:int, deltaY:int, time:Number = .5):void {
        var oY:Number = g.matrixGrid.offsetY*g.cont.gameCont.scaleX;
        var nX:int = gameCont.x + deltaX;
        var nY:int = gameCont.y + deltaY;
        if (nY > oY + SHIFT_MAP_Y*g.cont.gameCont.scaleX) nY = oY + SHIFT_MAP_Y*g.cont.gameCont.scaleX;
        if (nY < -g.realGameTilesHeight*g.cont.gameCont.scaleX - oY + Starling.current.nativeStage.stageHeight + SHIFT_MAP_Y*g.cont.gameCont.scaleX)
            nY = -g.realGameTilesHeight*g.cont.gameCont.scaleX - oY + Starling.current.nativeStage.stageHeight + SHIFT_MAP_Y*g.cont.gameCont.scaleX;
        if (nX > g.cont.gameCont.scaleX*g.realGameWidth/2 - g.cont.gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*g.cont.gameCont.scaleX)
            nX =  g.cont.gameCont.scaleX*g.realGameWidth/2 - g.cont.gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*g.cont.gameCont.scaleX;
        if (nX < -g.cont.gameCont.scaleX*g.realGameWidth/2 + g.cont.gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth - SHIFT_MAP_X*g.cont.gameCont.scaleX)
            nX = -g.cont.gameCont.scaleX*g.realGameWidth/2 + g.cont.gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth - SHIFT_MAP_X*g.cont.gameCont.scaleX;
        new TweenMax(gameCont, time, {x:nX, y:nY, ease:Linear.easeOut});
    }
}
}
