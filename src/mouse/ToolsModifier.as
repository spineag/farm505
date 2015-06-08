/**
 * Created by user on 5/20/15.
 */
package mouse {
import flash.geom.Point;

import manager.Vars;

import map.MatrixGrid;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.Color;

import temp.MapEditorInterface;

import utils.MCScaler;

public class ToolsModifier {
    public static var NONE:int = 0;
    public static var MOVE:int = 1;
    public static var FLIP:int = 2;
    public static var DELETE:int = 3;
    public static var INVENTORY:int = 4;
    public static var PLANT_SEED:int = 5;
    public static var PLANT_TREES:int = 6;
    public static var GRID_DEACTIVATED:int = 6;

    private var _activeBuildingData:Object;
    private var _spriteForMove:Sprite;
    private var _cont:Sprite;
    private var _callbackAfterMove:Function;
    private var _mouse:OwnMouse;
    private var _townMatrix:Array;
    private var _modifierType:int;
    private var _mouseIcon:Sprite;
    private var _mouseCont:Sprite;

    private var g:Vars = Vars.getInstance();

    public function ToolsModifier() {
        _mouseCont = g.cont.mouseCont;
        _cont = g.cont.animationsContTop;
        _mouse = g.ownMouse;
        _callbackAfterMove = null;
        _modifierType = NONE;
        _mouseIcon = new Sprite();
    }

    public function setTownArray():void {
        _townMatrix = g.townArea.townMatrix;
    }

    public function set modifierType(a:int):void {
        _modifierType = a;
        checkMouseIcon();
    }

    public function get modifierType():int {
        return _modifierType;
    }

    public function checkMouseIcon():void {
        var im:Image;
        switch (g.toolsModifier.modifierType){
             case ToolsModifier.NONE:
                 clearCont();
                 if(_mouseCont.contains(_mouseIcon)) _mouseCont.removeChild(_mouseIcon);
                 g.gameDispatcher.removeEnterFrame(moveMouseIcon);
                 return;
             case ToolsModifier.MOVE:
                clearCont();
                 im = new Image(g.mapAtlas.getTexture("Move"));
                 _mouseIcon.addChild(im);
                 break;
             case ToolsModifier.FLIP:
                clearCont();
                 im = new Image(g.mapAtlas.getTexture("Rotate"));
                 _mouseIcon.addChild(im);
                break;
             case ToolsModifier.DELETE:
                clearCont();
                 im = new Image(g.mapAtlas.getTexture("Cancel"));
                 _mouseIcon.addChild(im);
                break;
             case ToolsModifier.GRID_DEACTIVATED:
                 clearCont();
                 var q:Quad = new Quad(100, 100, Color.RED);
                 q.rotation = Math.PI/4;
                     var _iconEditor:Sprite = new Sprite();
                 _iconEditor.addChild(q);
                 _iconEditor.scaleY /= 2;
                 _iconEditor.x = _iconEditor.width/2;
                 _mouseIcon.addChild(_iconEditor);
                break;
        }
        if(!_mouseCont.contains(_mouseIcon)) _mouseCont.addChild(_mouseIcon);
        MCScaler.scale(_mouseIcon, 30, 30);
        g.gameDispatcher.addEnterFrame(moveMouseIcon);
     }

    [Inline]
    private function clearCont():void{
        while (_mouseIcon.numChildren) {
            _mouseIcon.removeChildAt(0);
        }
    }
    private function moveMouseIcon():void{
        _mouseCont.x = g.ownMouse.mouseX + 20;
        _mouseCont.y = g.ownMouse.mouseY + 10;
    }

    public function startMove(buildingData:Object, callback:Function = null):void {
        var im:Image;

        _spriteForMove = new Sprite();
        _callbackAfterMove = callback;
        _activeBuildingData = buildingData;
        if (_activeBuildingData.url == "buildAtlas") {
            im  = new Image(g.tempBuildAtlas.getTexture(_activeBuildingData.image));
            im.x = _activeBuildingData.innerX;
            im.y = _activeBuildingData.innerY;
        } else {
            im  = new Image(g.mapAtlas.getTexture(_activeBuildingData.image));
            im.x = -im.width/2;
        }

        if (_activeBuildingData.isFlip) _spriteForMove.scaleX *= -1;
        _spriteForMove.addChild(im);
        _spriteForMove.flatten();
        _spriteForMove.x = _mouse.mouseX - _cont.x;
        _spriteForMove.y = _mouse.mouseY - _cont.y - MatrixGrid.FACTOR/2;
        _cont.addChild(_spriteForMove);

        _cont.x = g.cont.gameCont.x;
        _cont.y = g.cont.gameCont.y;

        _cont.addEventListener(TouchEvent.TOUCH, onTouch);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function onTouch(te:TouchEvent):void {
        if (te.getTouch(_cont, TouchPhase.ENDED)) {
            onTouchEnded();
        }
    }

    public function onTouchEnded():void {
        if (!_spriteForMove) return;
        if (_callbackAfterMove != null) {
            _callbackAfterMove.apply(null, [_spriteForMove.x, _spriteForMove.y])
        }
        _cont.removeEventListener(TouchEvent.TOUCH, onTouch);
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        _cont.removeChild(_spriteForMove);
        _spriteForMove.unflatten();
        while (_spriteForMove.numChildren) {
            _spriteForMove.removeChildAt(0);
        }
        _spriteForMove = null;
    }

    private function moveIt():void {
        _spriteForMove.x = _mouse.mouseX - _cont.x;
        _spriteForMove.y = _mouse.mouseY - _cont.y - MatrixGrid.FACTOR/2;
        var point:Point = g.matrixGrid.getIndexFromXY(new Point(_spriteForMove.x, _spriteForMove.y));
        g.matrixGrid.setSpriteFromIndex(_spriteForMove, point);

        checkFreeGrids(point.x, point.y, _activeBuildingData.width, _activeBuildingData.height) ? _spriteForMove.alpha = 1 : _spriteForMove.alpha = .4;
    }

    private function onEnterFrame():void {
        moveIt();
    }

    private var i:int;
    private var j:int;
    private var obj:Object;
    public function checkFreeGrids(posX:int, posY:int, width:int, height:int):Boolean {
        for (i = posY; i < posY + height; i++) {
            for (j = posX; j < posX + width; j++) {
                obj = _townMatrix[i][j];
                if (!obj.inGame) return false;
                if (obj.isFull) return false;
                if (obj.isBlocked) return false;
                if (obj.isFence) return false;
            }
        }

        return true;
    }
}
}
