/**
 * Created by user on 5/14/15.
 */
package manager {
import flash.geom.Point;

import map.MatrixGrid;

import mouse.ToolsModifier;

import starling.animation.Tween;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Containers {
    public var mainCont:Sprite;
    public var backgroundCont:Sprite;
    public var gridDebugCont:Sprite;
    public var contentCont:Sprite;
    public var cloudsCont:Sprite;
    public var animationsCont:Sprite;
    public var interfaceContMapEditor:Sprite;
    public var interfaceCont:Sprite;
    public var animationsContTop:Sprite;
    public var animationsResourceCont:Sprite;
    public var windowsCont:Sprite;
    public var popupCont:Sprite;
    public var hintCont:Sprite;
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
        animationsContTop = new Sprite();
        animationsResourceCont = new Sprite();
        windowsCont = new Sprite();
        popupCont = new Sprite();
        hintCont = new Sprite();
        hintGameCont = new Sprite();
        mouseCont = new Sprite();
        interfaceContMapEditor = new Sprite();

        mainCont.addChild(gameCont);
        gameCont.addChild(backgroundCont);
        gameCont.addChild(gridDebugCont);
        gameCont.addChild(contentCont);
        gameCont.addChild(animationsCont);
        gameCont.addChild(cloudsCont);
        gameCont.addChild(hintGameCont);
        mainCont.addChild(interfaceCont);
        mainCont.addChild(interfaceContMapEditor);
        mainCont.addChild(animationsContTop);
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

    private function onGameContTouch(te:TouchEvent):void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE && te.getTouch(gameCont, TouchPhase.ENDED)) {
            // нужно еще проверять не драгается ли поляна, если да - то не заходить в этот if
            g.toolsModifier.onTouchEnded();
            return;
        }

        if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED && te.getTouch(gameCont, TouchPhase.ENDED)) {
            var p:Point = te.touches[0].getLocation(g.mainStage);
            p.x -= gameCont.x;
            p.y -= gameCont.y;
            p = g.matrixGrid.getStrongIndexFromXY(p);
            g.deactivatedAreaManager.deactivatedTheArea(p.x, p.y);
            return;
        }

        if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
            // если садяться растение - то скинуть
            // если деревья-то посадить его
            // если передвижение - то поставить
            return;
        }

        if (te.getTouch(gameCont, TouchPhase.MOVED)) {
            dragGameCont(te.touches[0].getLocation(g.mainStage));  // потрібно переписати перевірки на спосіб тачу
        } else if (te.getTouch(gameCont, TouchPhase.BEGAN)) {
            _startDragPoint = te.touches[0].getLocation(g.mainStage); //te.touches[0].globalX;
            _startDragPointCont = new Point(gameCont.x, gameCont.y);
        }
    }

    private function dragGameCont(mouseP:Point):void {
        if (_startDragPointCont == null || _startDragPoint == null) return;
        gameCont.x = _startDragPointCont.x + mouseP.x - _startDragPoint.x;
        gameCont.y = _startDragPointCont.y + mouseP.y - _startDragPoint.y;
        var oY:Number = g.matrixGrid.offsetY;
        if (gameCont.y > -oY) gameCont.y = -oY;
        if (gameCont.y < -oY - g.realGameHeight + g.stageHeight)
            gameCont.y = -oY - g.realGameHeight + g.stageHeight;
        if (gameCont.x > g.realGameWidth/2 - MatrixGrid.DIAGONAL/2)
            gameCont.x =  g.realGameWidth/2 - MatrixGrid.DIAGONAL/2;
        if (gameCont.x < -g.realGameWidth/2 - MatrixGrid.DIAGONAL/2 + g.stageWidth)
            gameCont.x =  -g.realGameWidth/2 - MatrixGrid.DIAGONAL/2 + g.stageWidth;

    }

    public function moveCenterToXY(_x:int, _y:int, needQuick:Boolean = false):void {  // (_x, _y) - координати в загальній системі gameCont
        //переміщаємо ігрову область так, щоб вказана точка була по центру екрана
        var newX:int;
        var newY:int;

        newX = -(_x - g.stageWidth/2); // - g.realGameWidth/2;
        newY = -(_y - g.stageHeight/2);// - g.matrixGrid.offsetY;
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
