/**
 * Created by user on 5/14/15.
 */
package map {
import data.BuildType;
import manager.*;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import flash.geom.Point;
import mouse.ToolsModifier;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import tutorial.TutorialAction;
import tutorial.managerCutScenes.ManagerCutScenes;
import utils.CSprite;

public class Containers {
    public var SHIFT_MAP_X:int;
    public var SHIFT_MAP_Y:int;

    private var _mainCont:Sprite;
    public var backgroundCont:Sprite;
    public var gridDebugCont:Sprite;
    public var tailCont:CSprite;
    public var contentCont:CSprite;
    public var cloudsCont:Sprite;
    public var animationsCont:Sprite;
    public var craftCont:Sprite;
    public var craftAwayCont:Sprite;
    public var interfaceContMapEditor:Sprite;
    public var interfaceCont:Sprite;
    public var animationsContTop:Sprite;
    public var animationsContBottom:Sprite;
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

        _mainCont = new Sprite();
        gameCont = new Sprite();
        backgroundCont = new Sprite();
        gridDebugCont = new Sprite();
        contentCont = new CSprite();
        craftCont = new Sprite();
        craftAwayCont = new Sprite();
        tailCont = new CSprite();
        animationsCont = new Sprite();
        cloudsCont = new Sprite();
        interfaceCont = new Sprite();
        animationsContBottom = new Sprite();
        animationsContTop = new Sprite();
        animationsResourceCont = new Sprite();
        windowsCont = new Sprite();
        popupCont = new Sprite();
        hintCont = new Sprite();
        hintContUnder = new Sprite();
        hintGameCont = new Sprite();
        mouseCont = new Sprite();
        interfaceContMapEditor = new Sprite();

        _mainCont.addChild(gameCont);
        gameCont.addChild(backgroundCont);
        gameCont.addChild(gridDebugCont);
        gameCont.addChild(tailCont);
        gameCont.addChild(contentCont);
        gameCont.addChild(craftCont);
        gameCont.addChild(craftAwayCont);
        gameCont.addChild(animationsCont);
        gameCont.addChild(cloudsCont);
        _mainCont.addChild(hintGameCont);
        _mainCont.addChild(animationsContBottom);
        _mainCont.addChild(interfaceCont);
        _mainCont.addChild(interfaceContMapEditor);
        _mainCont.addChild(animationsContTop);
        _mainCont.addChild(hintContUnder);
        _mainCont.addChild(windowsCont);
        _mainCont.addChild(animationsResourceCont);
        _mainCont.addChild(hintCont);
        _mainCont.addChild(popupCont);
        _mainCont.addChild(mouseCont);

        g.mainStage.addChild(_mainCont);

        addGameContListener(true);
        contentCont.nameIt = 'contentCont_csprite';
        tailCont.nameIt = 'tailCont_csprite';
        
        craftAwayCont.touchable = false;
        craftAwayCont.visible = false;
    }
    
    public function onLoadAll():void {
        hideAll(false);
        _mainCont.addChildAt(gameCont, 0);
    }
    
    public function hideAll(v:Boolean):void {
        hintGameCont.visible = !v;
        animationsContBottom.visible = !v;
        interfaceCont.visible = !v;
        interfaceContMapEditor.visible = !v;
        animationsContTop.visible = !v;
        hintContUnder.visible = !v;
        windowsCont.visible = !v;
        animationsResourceCont.visible = !v;
        hintCont.visible = !v;
        mouseCont.visible = !v;
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
            g.ownMouse.showUsualCursor();
            return;
        }

        if (te.getTouch(gameCont, TouchPhase.ENDED)) {
            onEnded();
        } else if (te.getTouch(gameCont, TouchPhase.MOVED)) {
            if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE || g.toolsModifier.modifierType == ToolsModifier.CRAFT_PLANT) return;
            dragGameCont(te.touches[0].getLocation(g.mainStage));  // потрібно переписати перевірки на спосіб тачу
        } else if (te.getTouch(gameCont, TouchPhase.BEGAN)) {
            if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED;
            _startDragPoint = te.touches[0].getLocation(g.mainStage); //te.touches[0].globalX;
            _startDragPointCont = new Point(gameCont.x, gameCont.y);
            if (g.ownMouse) g.ownMouse.showClickCursor();
            if (g.mouseHint) g.mouseHint.hideIt();
        } else if (te.getTouch(gameCont, TouchPhase.HOVER)) {}
    }

    public function onEnded():void {
        checkOnDragEnd();
        g.ownMouse.showUsualCursor();
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE && !_isDragged && g.selectedBuild) {
            g.toolsModifier.onTouchEnded();
            return;
        }
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE || g.toolsModifier.modifierType == ToolsModifier.CRAFT_PLANT) {
            if (!_isDragged && !g.managerTutorial.isTutorial) {
                if (g.toolsModifier.modifierType != ToolsModifier.PLANT_SEED_ACTIVE) {
                    g.bottomPanel.cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
                    for (var i:int = 0; i < arr.length; i++) {
                        arr[i].lastBuyResource = false;
                    }
                } else {
                    g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED;
                }
            }
            _isDragged = false;
        }
        g.hideAllHints();
    }

    public function setDragPoints(p:Point):void {
        _startDragPoint = p;
        _startDragPointCont = new Point(gameCont.x, gameCont.y);
    }

    public function deleteDragPoint():void {
        _startDragPoint = null;
        _startDragPointCont = null;
    }

    public function dragGameCont(mouseP:Point):void {
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE || g.toolsModifier.modifierType == ToolsModifier.CRAFT_PLANT) return;
        if (g.managerTutorial.isTutorial) { // no for new tuts
            if (g.managerTutorial.currentAction == TutorialAction.PUT_FABRICA || g.managerTutorial.currentAction == TutorialAction.PUT_FARM) {

            } else {
                return;
            }
        }
        if (g.managerCutScenes.isCutScene && !g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_BUY_DECOR) && !g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_FROM_INVENTORY_DECOR)) return;
        g.hideAllHints(); // ??? not optimise
        if (_startDragPointCont == null || _startDragPoint == null) return;
        if (!_isDragged) if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(true);
        _isDragged = true;
        var s:Number = gameCont.scaleX;
        gameCont.x = _startDragPointCont.x + mouseP.x - _startDragPoint.x;
        gameCont.y = _startDragPointCont.y + mouseP.y - _startDragPoint.y;
        var oY:Number = g.matrixGrid.offsetY*s;
        if (gameCont.y > oY + SHIFT_MAP_Y*s) gameCont.y = oY + SHIFT_MAP_Y*s;
        if (gameCont.y < -g.realGameTilesHeight*s - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*s)
            gameCont.y = -g.realGameTilesHeight*s - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*s;
        if (gameCont.x > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s)
            gameCont.x =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s;
        if (gameCont.x < -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + SHIFT_MAP_X*s)
            gameCont.x = -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + SHIFT_MAP_X*s;
    }
    
    public function checkOnDragEnd():void {
        if (_isDragged) {
            _isDragged = false;
            if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(false);
        }
    }

    public function moveCenterToXY(_x:int, _y:int, needQuick:Boolean = false, time:Number = .5, callback:Function = null):void {  // (_x, _y) - координати в загальній системі gameCont
        //переміщаємо ігрову область так, щоб вказана точка була по центру екрана
        var newX:int;
        var newY:int;
        var s:Number = gameCont.scaleX;
        var oY:Number = g.matrixGrid.offsetY*s;
        newX = -(_x*s - g.managerResize.stageWidth/2);
        newY = -(_y*s - g.managerResize.stageHeight/2);
        if (newY > oY + SHIFT_MAP_Y*s) newY = oY + SHIFT_MAP_Y*s;
        if (newY < -g.realGameTilesHeight*s - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*s)
            newY = -g.realGameTilesHeight*s - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*s;
        if (newX > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s)
            newX =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s;
        if (newX < -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + SHIFT_MAP_X*s)
            newX = -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + SHIFT_MAP_X*s;
        var f1:Function = function():void {
            if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(false);
            if (callback != null) {
                callback.apply();
            }
        };
        if (needQuick) {
            gameCont.x = newX;
            gameCont.y = newY;
            if (g.managerVisibleObjects) g.managerVisibleObjects.checkInStaticPosition();
        } else {
            if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(true);
            new TweenMax(gameCont, time, {x:newX, y:newY, ease:Linear.easeOut,onComplete: f1});
        }

    }

    public function killMoveCenterToPoint():void {
        TweenMax.killTweensOf(gameCont);
    }

    public function moveCenterToPos(posX:int, posY:int, needQuick:Boolean = false, time:Number = .5, callback:Function = null):void {
        var p:Point = new Point(posX, posY);
        p = g.matrixGrid.getXYFromIndex(p);
        moveCenterToXY(p.x, p.y, needQuick, time, callback);
    }

    public function deltaMoveGameCont(deltaX:int, deltaY:int, time:Number = .5):void {
        var oY:Number = g.matrixGrid.offsetY*g.cont.gameCont.scaleX;
        var nX:int = gameCont.x + deltaX;
        var nY:int = gameCont.y + deltaY;
        if (nY > oY + SHIFT_MAP_Y*g.cont.gameCont.scaleX) nY = oY + SHIFT_MAP_Y*g.cont.gameCont.scaleX;
        if (nY < -g.realGameTilesHeight*g.cont.gameCont.scaleX - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*g.cont.gameCont.scaleX)
            nY = -g.realGameTilesHeight*g.cont.gameCont.scaleX - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*g.cont.gameCont.scaleX;
        if (nX > g.cont.gameCont.scaleX*g.realGameWidth/2 - g.cont.gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*g.cont.gameCont.scaleX)
            nX =  g.cont.gameCont.scaleX*g.realGameWidth/2 - g.cont.gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*g.cont.gameCont.scaleX;
        if (nX < -g.cont.gameCont.scaleX*g.realGameWidth/2 + g.cont.gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth - SHIFT_MAP_X*g.cont.gameCont.scaleX)
            nX = -g.cont.gameCont.scaleX*g.realGameWidth/2 + g.cont.gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth - SHIFT_MAP_X*g.cont.gameCont.scaleX;
        new TweenMax(gameCont, time, {x:nX, y:nY, ease:Linear.easeOut});
    }

    public function onResize():void {
        var s:Number = gameCont.scaleX;
        var oY:Number = g.matrixGrid.offsetY*s;
        if (gameCont.y > oY + g.cont.SHIFT_MAP_Y*s) gameCont.y = oY + g.cont.SHIFT_MAP_Y*s;
        if (gameCont.y < -oY - g.realGameTilesHeight*s + g.managerResize.stageHeight + g.cont.SHIFT_MAP_Y*s)
            gameCont.y = -oY - g.realGameTilesHeight*s + g.managerResize.stageHeight + g.cont.SHIFT_MAP_Y*s;
        if (gameCont.x > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s)
            gameCont.x =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s;
        if (gameCont.x < -s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + g.cont.SHIFT_MAP_X*s)
            gameCont.x =  -s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + g.cont.SHIFT_MAP_Y*s;
    }
}
}
