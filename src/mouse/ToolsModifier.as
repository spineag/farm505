/**
 * Created by user on 5/20/15.
 */
package mouse {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class ToolsModifier {
    public static var NONE:int = 0;
    public static var MOVE:int = 1;
    public static var FLIP:int = 2;
    public static var DELETE:int = 3;
    public static var INVENTORY:int = 4;
    public static var PLANT_SEED:int = 5;
    public static var PLANT_TREES:int = 6;

    private var _activeBuildingId:int;
    private var _imageForMove:Image;
    private var _cont:Sprite;
    private var _callbackAfterMove:Function;
    private var _mouse:OwnMouse;

    private var g:Vars = Vars.getInstance();

    public function ToolsModifier() {
        _cont = g.cont.animationsContTop;
        _mouse = g.ownMouse;
        _callbackAfterMove = null;
    }

    public function addMoveIcon(add:Boolean = true):void {
        // добавлення іконки пересування до мишки
    }

    public function startMove(buildingID:int, callback:Function = null):void {
        // реалізація пересування, поки тільки  для будівль для режиму MapEditor
        addMoveIcon(false);
        _callbackAfterMove = callback;
        _activeBuildingId = buildingID;
        _imageForMove = new Image(g.mapAtlas.getTexture(String(g.dataBuilding.objectBuilding[buildingID].image)));

        //_imageForMove.touchable = false;
        _imageForMove.pivotX = _imageForMove.width/2;
        _imageForMove.pivotY = _imageForMove.height/2;
        _imageForMove.x = _mouse.mouseX - _cont.x;
        _imageForMove.y = _mouse.mouseY - _cont.y;
        _cont.addChild(_imageForMove);

        _cont.x = g.cont.gameCont.x;
        _cont.y = g.cont.gameCont.y;

        _cont.addEventListener(TouchEvent.TOUCH, onTouch);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function onTouch(te:TouchEvent):void {
        if (te.getTouch(_cont, TouchPhase.ENDED)) {
            if (_callbackAfterMove != null) {
                _callbackAfterMove.apply(null, [te.touches[0].getLocation(g.mainStage)])
            }
            _cont.removeEventListener(TouchEvent.TOUCH, onTouch);
            g.gameDispatcher.removeEnterFrame(onEnterFrame);
        }
    }

    private function moveIt():void {
        _imageForMove.x = _mouse.mouseX - _cont.x;
        _imageForMove.y = _mouse.mouseY - _cont.y;
    }

    private function onEnterFrame():void {
        moveIt();
    }
}
}
