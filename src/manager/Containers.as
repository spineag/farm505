/**
 * Created by user on 5/14/15.
 */
package manager {
import flash.geom.Point;

import map.MatrixGrid;

import mouse.ToolsModifier;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Containers {
    public static const SHIFT_MAP_X:int = 70;
    public static const SHIFT_MAP_Y:int = 227;

    public var mainCont:Sprite;
    public var backgroundCont:Sprite;
    public var gridDebugCont:Sprite;
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
        mainCont = new Sprite();
        gameCont = new Sprite();
        backgroundCont = new Sprite();
        gridDebugCont = new Sprite();
        contentCont = new Sprite();
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

//        gridDebugCont.x = SHIFT_MAP_X;
//        gridDebugCont.y = SHIFT_MAP_Y;
//        contentCont.x = SHIFT_MAP_X;
//        contentCont.y = SHIFT_MAP_Y;
//        animationsCont.x = SHIFT_MAP_X;
//        animationsCont.y = SHIFT_MAP_Y;
//        hintGameCont.x = SHIFT_MAP_X;
//        hintGameCont.y = SHIFT_MAP_Y;

        mainCont.addChild(gameCont);
        gameCont.addChild(backgroundCont);
        gameCont.addChild(gridDebugCont);
        gameCont.addChild(contentCont);
        gameCont.addChild(animationsCont);
        gameCont.addChild(cloudsCont);
        gameCont.addChild(hintGameCont);
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
//        addCancelTouch(true);
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
        if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED && te.getTouch(gameCont, TouchPhase.ENDED)) {
            var p:Point = te.touches[0].getLocation(g.mainStage);
            p.x -= gameCont.x;
            p.y -= gameCont.y;
            p = g.matrixGrid.getStrongIndexFromXY(p);
            g.deactivatedAreaManager.deactivatedTheArea(p.x, p.y);
            return;
        }

        if (te.getTouch(gameCont, TouchPhase.ENDED)) {
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE && !_isDragged) {
                g.toolsModifier.onTouchEnded();
                _isDragged = false;
                return;
            }
            if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
                if (!_isDragged) g.toolsModifier.modifierType = ToolsModifier.NONE;
                _isDragged = false;
                return;
            }
            if (g.activeCat) {
                var p:Point = te.touches[0].getLocation(g.mainStage);
                p = gameCont.globalToLocal(p);
                p = g.matrixGrid.getIndexFromXY(p);
                g.managerCats.goCatToPoint(g.activeCat, p);
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
        var s:Number = g.cont.gameCont.scaleX;
        if (_startDragPointCont == null || _startDragPoint == null) return;
        gameCont.x = _startDragPointCont.x + mouseP.x - _startDragPoint.x;
        gameCont.y = _startDragPointCont.y + mouseP.y - _startDragPoint.y;
//        trace(gameCont.x + ' + ' + gameCont.y + ' | ' + mouseP.x + ' + ' + mouseP.y + '');
        var oY:Number = g.matrixGrid.offsetY*s;
        if (gameCont.y > oY + SHIFT_MAP_Y*s) gameCont.y = oY + SHIFT_MAP_Y*s;
        if (gameCont.y < -g.realGameTilesHeight*s - oY + Starling.current.nativeStage.stageHeight + SHIFT_MAP_Y*s)
            gameCont.y = -g.realGameTilesHeight*s - oY + Starling.current.nativeStage.stageHeight + SHIFT_MAP_Y*s;
        if (gameCont.x > s*g.realGameWidth/2 - s*MatrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s)
            gameCont.x =  s*g.realGameWidth/2 - s*MatrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s;
        if (gameCont.x < -s*g.realGameWidth/2 + s*MatrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth - SHIFT_MAP_X*s)
            gameCont.x = -s*g.realGameWidth/2 + s*MatrixGrid.DIAGONAL/2 + Starling.current.nativeStage.stageWidth - SHIFT_MAP_X*s;
    }

    public function moveCenterToXY(_x:int, _y:int, needQuick:Boolean = false):void {  // (_x, _y) - координати в загальній системі gameCont
        //переміщаємо ігрову область так, щоб вказана точка була по центру екрана
        var newX:int;
        var newY:int;

        newX = -(_x - Starling.current.nativeStage.stageWidth/2); // - g.realGameWidth/2;
        newY = -(_y - Starling.current.nativeStage.stageHeight/2);// - g.matrixGrid.offsetY;
//
        if (needQuick) {
            gameCont.x = newX;
            gameCont.y = newY;
        } else {
            var tween:Tween = new Tween(gameCont, 1);
            tween.moveTo(newX, newY);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
            };
            g.starling.juggler.add(tween);
        }
    }
}
}
