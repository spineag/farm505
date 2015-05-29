/**
 * Created by user on 5/20/15.
 */
package mouse {
import flash.geom.Point;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import temp.MapEditorInterface;

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
    public var modifierType:int;

    private var g:Vars = Vars.getInstance();

    public function ToolsModifier() {
        _cont = g.cont.animationsContTop;
        _mouse = g.ownMouse;
        _callbackAfterMove = null;
        modifierType = NONE;
    }

    public function setTownArray():void {
        _townMatrix = g.townArea.townMatrix;
    }

    public function addMoveIcon(add:Boolean = true):void {
        // добавлення іконки пересування до мишки
    }

    public function startMove(buildingData:Object, callback:Function = null):void {
        // реалізація пересування, поки тільки  для будівль для режиму MapEditor
        var im:Image;

        addMoveIcon(false);
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

        _spriteForMove.addChild(im);
        _spriteForMove.flatten();
        _spriteForMove.x = _mouse.mouseX - _cont.x;
        _spriteForMove.y = _mouse.mouseY - _cont.y;
        _cont.addChild(_spriteForMove);

        _cont.x = g.cont.gameCont.x;
        _cont.y = g.cont.gameCont.y;

        _cont.addEventListener(TouchEvent.TOUCH, onTouch);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function onTouch(te:TouchEvent):void {
        if (te.getTouch(_cont, TouchPhase.ENDED)) {
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
    }

    private function moveIt():void {
        _spriteForMove.x = _mouse.mouseX - _cont.x;
        _spriteForMove.y = _mouse.mouseY - _cont.y;
        var point:Point = g.matrixGrid.getIndexFromXY(new Point(_spriteForMove.x, _spriteForMove.y));
        g.matrixGrid.setSpriteFromIndex(_spriteForMove, point);

        checkFreeGrids(point.x, point.y, _activeBuildingData.width, _activeBuildingData.height) ? _spriteForMove.alpha = 1 : _spriteForMove.alpha = .4;
    }

    private function onEnterFrame():void {
        moveIt();
    }

    private var i:int;
    private var j:int;
    var obj:Object;
    private function checkFreeGrids(posX:int, posY:int, width:int, height:int):Boolean {
        for (i = posY; i < posY + height; i++) {
            for (j = posX; j < posX + width; j++) {
                obj = _townMatrix[i][j];
                if (!obj.inGame) return false;
                if (obj.isFull) return false;
                if (obj.isBlocked) return false;
            }
        }

        return true;
    }
}
}
