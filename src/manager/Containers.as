/**
 * Created by user on 5/14/15.
 */
package manager {
import flash.geom.Point;

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
    public var interfaceCont:Sprite;
    public var animationsContTop:Sprite;
    public var windowsCont:Sprite;
    public var popupCont:Sprite;
    public var mouseCont:Sprite;
    public var gameCont:Sprite;

    public var isDragged:Boolean = false;
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
        windowsCont = new Sprite();
        popupCont = new Sprite();
        mouseCont = new Sprite();

        mainCont.addChild(gameCont);
        gameCont.addChild(backgroundCont);
        gameCont.addChild(gridDebugCont);
        gameCont.addChild(contentCont);
        gameCont.addChild(animationsCont);
        gameCont.addChild(cloudsCont);
        mainCont.addChild(interfaceCont);
        mainCont.addChild(animationsContTop);
        mainCont.addChild(windowsCont);
        mainCont.addChild(popupCont);
        mainCont.addChild(mouseCont);

        g.mainStage.addChild(mainCont);

        gameCont.addEventListener(TouchEvent.TOUCH, onGameContTouch);
    }

    private function onGameContTouch(te:TouchEvent):void {
        if (te.getTouch(gameCont, TouchPhase.MOVED)) {
            dragGameCont(te.touches[0].getLocation(g.mainStage));  // потрібно переписати
        }

        if (te.getTouch(gameCont, TouchPhase.BEGAN)) {
//            isDragged = true;
//            g.gameDispatcher.addEnterFrame(dragGameCont);
            _startDragPoint = te.touches[0].getLocation(g.mainStage); //te.touches[0].globalX;
            _startDragPointCont = new Point(gameCont.x, gameCont.y);
        }
//        } else if (te.getTouch(gameCont, TouchPhase.ENDED)) {
//            g.gameDispatcher.removeEnterFrame(dragGameCont);
//            isDragged = false;
//        }
    }

    private function dragGameCont(mouseP:Point):void {
        gameCont.x = _startDragPointCont.x + mouseP.x - _startDragPoint.x;
        gameCont.y = _startDragPointCont.y + mouseP.y - _startDragPoint.y;
    }

    public function moveCenterToXY(_x:int, _y:int, needQuick:Boolean = false):void {  // (_x, _y) - координати в системі (realGameWidth, realGameHeight)
        //переміщаємо ігрову область так, щоб вказана точка була по центру екрана
        var newX:int;
        var newY:int;

        newX = 0   + g.stageWidth/2;
        newY = -g.matrixGrid.offsetY - g.realGameHeight/2    + g.stageHeight/2;

        //потрібно переробити
//        newX = _x - g.stageWidth/2;
//        newY = _y  - g.matrixGrid.offsetY;
//
////        newY = _y - g.stageHeight/2;
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
