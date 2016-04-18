/**
 * Created by user on 5/20/15.
 */
package mouse {
import build.AreaObject;
import build.decor.DecorTail;
import build.wild.Wild;

import com.junkbyte.console.Cc;

import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import map.MatrixGrid;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

import windows.WindowsManager;

public class ToolsModifier {
    public static var NONE:int = 0;
    public static var MOVE:int = 1;
    public static var FLIP:int = 2;
    public static var DELETE:int = 3;
    public static var INVENTORY:int = 4;
    public static var PLANT_SEED:int = 5;
    public static var PLANT_SEED_ACTIVE:int = 6;
    public static var PLANT_TREES:int = 7;
    public static var GRID_DEACTIVATED:int = 8;
    public static var ADD_NEW_RIDGE:int = 9;
    public static var ADD_NEW_DECOR:int = 10;

    private var _activeBuilding:AreaObject;
    private var _startMoveX:int;
    private var _startMoveY:int;
    private var _spriteForMove:Sprite;
    private var _moveGrid:BuildMoveGrid;
    private var _cont:Sprite;
    private var _callbackAfterMove:Function;
    private var _mouse:OwnMouse;
    private var _townMatrix:Array;
    private var _modifierType:int;
    private var _mouseIcon:Sprite;
    private var _mouseCont:Sprite;
    public var contImage:Sprite;
    private var _plantId:int;
    private var _ridgeId:int;
    private var _txtCount:TextField;

    private var g:Vars = Vars.getInstance();

    public function ToolsModifier() {
        _mouseCont = g.cont.mouseCont;
        _cont = g.cont.animationsContBot;
        _mouse = g.ownMouse;
        _callbackAfterMove = null;
        _modifierType = NONE;
        _mouseIcon = new Sprite();
        contImage = new Sprite();
        _plantId = -1;
        _txtCount = new TextField(50,40,"",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        _txtCount.x = 18;
        _txtCount.y = 29;
    }

    public function setTownArray():void {
        _townMatrix = g.townArea.townMatrix;
    }

    public function set modifierType(a:int):void {
        if (_modifierType == PLANT_SEED || _modifierType == PLANT_SEED_ACTIVE) {
            g.managerPlantRidge.lockAllFillRidge(false); // unlock all not empty ridges
        }
        if (_modifierType == MOVE) {
            g.townArea.onActivateMoveModifier(false);
        } else if (_modifierType == FLIP) {
            g.townArea.onActivateRotateModifier(false);
        } else if (_modifierType == INVENTORY) {
            g.townArea.onActivateInventoryModifier(false);
        }

        _modifierType = a;
        if (_modifierType == MOVE) {
            g.townArea.onActivateMoveModifier(true);
        } else if (_modifierType == FLIP) {
            g.townArea.onActivateRotateModifier(true);
        } else if (_modifierType == INVENTORY) {
            g.townArea.onActivateInventoryModifier(true);
        }
        checkMouseIcon();
        if (_modifierType == PLANT_SEED || _modifierType == PLANT_SEED_ACTIVE) {
            g.managerPlantRidge.lockAllFillRidge(true);  // lock all not empty ridges
        }
    }

    public function get modifierType():int {
        return _modifierType;
    }

    public function set plantId(a:int):void {
        _plantId = a;
    }

    public function get plantId():int {
        return _plantId;
    }

    public function set ridgeId(a:int):void {
        _ridgeId = a;
    }

    public function set activatePlantState(value:Boolean):void {
        if (value) {
            _modifierType = PLANT_SEED_ACTIVE;
        } else {
            _modifierType = PLANT_SEED;
        }
    }

    public function checkMouseIcon():void {
        var im:Image;

        clearCont();
        switch (g.toolsModifier.modifierType){
             case ToolsModifier.NONE:
                 _plantId = -1;
                 if(_mouseCont.contains(_mouseIcon)) _mouseCont.removeChild(_mouseIcon);
                 g.gameDispatcher.removeEnterFrame(moveMouseIcon);
                 _mouseIcon.scaleX = _mouseIcon.scaleY = 1;
                 return;
             case ToolsModifier.MOVE:
                 im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_move'));
                 if (im) _mouseIcon.addChild(im);
                 break;
             case ToolsModifier.FLIP:
                 im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_rotate'));
                 if (im) _mouseIcon.addChild(im);
                break;
             case ToolsModifier.DELETE:
                 im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_canc'));
                 if (im) _mouseIcon.addChild(im);
                break;
             case ToolsModifier.INVENTORY:
                 im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_inv'));
                 if (im) _mouseIcon.addChild(im);
                break;
             case ToolsModifier.GRID_DEACTIVATED:
                 im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_tile'));
                 if (im) {
                     im.x = -im.width/2 - 15;
                     im.y = - 5 - 2;
                     _mouseIcon.addChild(im);
                 }
                break;
            case ToolsModifier.PLANT_SEED:
                if (_plantId <= 0) return;
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_circle'));
                _mouseCont.addChild(im);
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_plantId].imageShop + '_icon'));
                if (im) {
                    MCScaler.scale(im, 40, 40);
                    im.x = 27 - im.width/2;
                    im.y = 27 - im.height/2;
                    _mouseIcon.addChild(im);
                }
                if (!_mouseCont.contains(_mouseIcon)) _mouseCont.addChild(_mouseIcon);
                var im2:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("cursor_number_circle"));
                im2.x = _mouseCont.width - 27;
                im2.y = _mouseCont.height - 23;
                _mouseCont.addChild(im2);
                if (!_mouseCont.contains(_txtCount)) _mouseCont.addChild(_txtCount);
                updateCountTxt();
                break;
            case ToolsModifier.ADD_NEW_RIDGE:
//                _modifierType = NONE;
                break;
        }
        if (im) {
            if (!_mouseCont.contains(_mouseIcon)) _mouseCont.addChild(_mouseIcon);
            MCScaler.scale(_mouseIcon, 40, 40);
            g.gameDispatcher.addEnterFrame(moveMouseIcon);
        }
     }

    public function updateCountTxt():void {
        if (_plantId > 0) {
            _txtCount.text = String(g.userInventory.getCountResourceById(plantId));
        } else {
            _txtCount.text = '';
        }
    }

    private function clearCont():void{
        while (_mouseIcon.numChildren) {
            _mouseIcon.removeChildAt(0);
        }
        while (_mouseCont.numChildren) {
            _mouseCont.removeChildAt(0);
        }
    }

    private function moveMouseIcon():void{
        _mouseCont.x = g.ownMouse.mouseX + 15;
        _mouseCont.y = g.ownMouse.mouseY + 5;
    }

    public function  startMove(selectedBuild:AreaObject, callback:Function=null, isFromShop:Boolean = false):void {
        if (!selectedBuild) {
            Cc.error('ToolsModifier startMove:: empty selectedBuild');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'toolsModifier');
            return;
        }
        _spriteForMove = new Sprite();
        _callbackAfterMove = callback;
        _activeBuilding = selectedBuild;
        _activeBuilding.source.filter = null;

        if (!isFromShop) {
            _startMoveX = _activeBuilding.source.x;
            _startMoveY = _activeBuilding.source.y;
        } else {
            _startMoveX = -1;
            _startMoveY = -1;
        }
        _activeBuilding.source.x = 0;
        _activeBuilding.source.y = 0;
        _spriteForMove.addChild(_activeBuilding.source);

        _spriteForMove.x = _mouse.mouseX - _cont.x;
        _spriteForMove.y = _mouse.mouseY - _cont.y - g.matrixGrid.FACTOR/2;
        _cont.addChild(_spriteForMove);

        _cont.x = g.cont.gameCont.x;
        _cont.y = g.cont.gameCont.y;
        _cont.scaleX = _cont.scaleY = g.cont.gameCont.scaleX;

        if (_activeBuilding.isContDrag() || isFromShop) {
            _needMoveGameCont = true;
        }
        _cont.addEventListener(TouchEvent.TOUCH, onTouch);
        if (_activeBuilding.flip) {
            _moveGrid = new BuildMoveGrid(_spriteForMove, _activeBuilding.dataBuild.height, _activeBuilding.dataBuild.width);
        } else {
            _moveGrid = new BuildMoveGrid(_spriteForMove, _activeBuilding.dataBuild.width, _activeBuilding.dataBuild.height);
        }
        g.gameDispatcher.addEnterFrame(moveIt);
    }

    public function startMoveTail(selectedBuild:AreaObject, callback:Function = null, isFromShop:Boolean = false):void {
        if (!selectedBuild) {
            Cc.error('ToolsModifier startMoveTail:: empty buildingData');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'toolsModifier');
            return;
        }

        g.cont.contentCont.alpha = .5;
        g.cont.contentCont.touchable = false;

        _spriteForMove = new Sprite();
        _callbackAfterMove = callback;
        _activeBuilding = selectedBuild;
        _activeBuilding.source.filter = null;

        _startMoveX = _activeBuilding.source.x;
        _startMoveY = _activeBuilding.source.y;
        _activeBuilding.source.x = 0;
        _activeBuilding.source.y = 0;
        _spriteForMove.addChild(_activeBuilding.source);

        _spriteForMove.x = _mouse.mouseX - _cont.x;
        _spriteForMove.y = _mouse.mouseY - _cont.y - g.matrixGrid.FACTOR/2;
        _cont.addChild(_spriteForMove);

        _cont.x = g.cont.gameCont.x;
        _cont.y = g.cont.gameCont.y;
        _cont.scaleX = _cont.scaleY = g.cont.gameCont.scaleX;

        if (_activeBuilding.isContDrag() || isFromShop) {
            _needMoveGameCont = true;
        }
        _cont.addEventListener(TouchEvent.TOUCH, onTouch);
        _moveGrid = null;
        g.gameDispatcher.addEnterFrame(moveIt);
    }

    public function cancelMove():void {
        if (!_spriteForMove) return;
        g.cont.contentCont.alpha = 1;
        g.gameDispatcher.removeEnterFrame(moveIt);
        while (_spriteForMove.numChildren) {
             _spriteForMove.removeChildAt(0);
        }
        if (_moveGrid) _moveGrid.clearIt();
        _moveGrid = null;
        _spriteForMove.removeChild(_activeBuilding.source);
        _spriteForMove = null;
        if (_activeBuilding is DecorTail) {
            g.cont.contentCont.touchable = true;
        }
        if (_activeBuilding) {
            if (_activeBuilding.source) _activeBuilding.source.filter = null;
            if (_startMoveX == -1 && _startMoveY == -1) {
                _activeBuilding.clearIt();
                _activeBuilding = null;
            } else {
                g.townArea.pasteBuild(_activeBuilding, _startMoveX, _startMoveY, false, false);
            }
        }
        g.selectedBuild = null;
    }

    private var _needMoveGameCont:Boolean = false;
    private var _startDragPoint:Point;
    private function onTouch(te:TouchEvent):void {
        if (_needMoveGameCont && te.getTouch(_cont, TouchPhase.BEGAN)) {
            g.gameDispatcher.removeEnterFrame(moveIt);
            _startDragPoint = new Point();
            _startDragPoint.x = g.cont.gameCont.x;
            _startDragPoint.y = g.cont.gameCont.y;
            g.cont.setDragPoints(te.touches[0].getLocation(g.mainStage));
        }

        if (_needMoveGameCont && te.getTouches(_cont, TouchPhase.MOVED)) {
            if (!_startDragPoint) return;
            _cont.x = g.cont.gameCont.x;
            _cont.y = g.cont.gameCont.y;
            g.cont.dragGameCont(te.touches[0].getLocation(g.mainStage));
        }

        if (te.getTouch(_cont, TouchPhase.ENDED)) {
            if (_startDragPoint) {
                var distance:int = Math.abs(g.cont.gameCont.x - _startDragPoint.x) + Math.abs(g.cont.gameCont.y - _startDragPoint.y);
                if (distance > 5) {
                    g.gameDispatcher.addEnterFrame(moveIt);
                } else {
                    _needMoveGameCont = false;
                    onTouchEnded();
                }
                _startDragPoint = null;
            } else {
                onTouchEnded();
            }
        }
    }

    public function onTouchEnded():void {
        var x:Number;
        var y:Number;
        var point:Point;

        if (!_spriteForMove) return;
        if (_activeBuilding.useIsometricOnly) {
            point = g.matrixGrid.getIndexFromXY(new Point(_spriteForMove.x, _spriteForMove.y));
            g.matrixGrid.setSpriteFromIndex(_spriteForMove, point);
        }
        x = _spriteForMove.x;
        y = _spriteForMove.y;
        if (_activeBuilding is DecorTail) {
            if (g.townArea.townTailMatrix[point.y][point.x].build) {
                g.gameDispatcher.addEnterFrame(moveIt);
                return;
            } else {
                g.cont.contentCont.alpha = 1;
                g.cont.contentCont.touchable = true;
            }
        }
        if (!g.isActiveMapEditor && _activeBuilding.useIsometricOnly && !(_activeBuilding is DecorTail)) {
            if (!checkFreeGrids(point.x, point.y, _activeBuilding.dataBuild.width, _activeBuilding.dataBuild.height)) {
                g.gameDispatcher.addEnterFrame(moveIt);
                return;
            }
        }

        spriteForMoveIndexX = 0;
        spriteForMoveIndexY = 0;
        _cont.removeEventListener(TouchEvent.TOUCH, onTouch);
        g.gameDispatcher.removeEnterFrame(moveIt);

        _cont.removeChild(_spriteForMove);
        while (_spriteForMove.numChildren) {
            _spriteForMove.removeChildAt(0);
        }
        if (_moveGrid) {
            _moveGrid.clearIt();
            _moveGrid = null;
        }
        _spriteForMove = null;

        if (_callbackAfterMove != null) {
            _callbackAfterMove.apply(null, [_activeBuilding, int(x), int(y)]);
        }
    }

    private var spriteForMoveIndexX:int = 0;
    private var spriteForMoveIndexY:int = 0;
    private function moveIt():void {
        _cont.x = g.cont.gameCont.x;
        _cont.y = g.cont.gameCont.y;
        _spriteForMove.x = (_mouse.mouseX - _cont.x)/g.cont.gameCont.scaleX;
        _spriteForMove.y = (_mouse.mouseY - _cont.y - g.matrixGrid.FACTOR/2)/g.cont.gameCont.scaleX;
        if (_startDragPoint) return;  // using for dragging gameCont
        if (!_activeBuilding.useIsometricOnly) return;

        var point:Point = g.matrixGrid.getIndexFromXY(new Point(_spriteForMove.x, _spriteForMove.y));
        g.matrixGrid.setSpriteFromIndex(_spriteForMove, point);
        if (spriteForMoveIndexX != point.x || spriteForMoveIndexY != point.y) {
            spriteForMoveIndexX = point.x;
            spriteForMoveIndexY = point.y;
            if (_activeBuilding is DecorTail) {
                if (!g.townArea.townTailMatrix[spriteForMoveIndexY] || !g.townArea.townTailMatrix[spriteForMoveIndexY][spriteForMoveIndexX]) return;
                if (g.townArea.townTailMatrix[spriteForMoveIndexY][spriteForMoveIndexX].build) {
                    _spriteForMove.filter = ManagerFilters.RED_TINT_FILTER;
                } else {
                    _spriteForMove.filter = null;
                }
            } else {
                if (g.isActiveMapEditor && _activeBuilding is Wild) return;
                _moveGrid.checkIt(spriteForMoveIndexX, spriteForMoveIndexY);
                if (_moveGrid.isFree) {
//                    _spriteForMove.filter = null;
                    _activeBuilding.source.filter = null;
                } else {
//                    _spriteForMove.filter = ManagerFilters.RED_TINT_FILTER;
                    _activeBuilding.source.filter = ManagerFilters.RED_TINT_FILTER;
                }
            }
        }
    }

    private var i:int;
    private var j:int;
    private var obj:Object;
    public function checkFreeGrids(posX:int, posY:int, width:int, height:int):Boolean {
        for (i = posY; i < posY + height; i++) {
            for (j = posX; j < posX + width; j++) {
                if (i < 0 || j < 0 || i > 80 || j > 80) return false;
                obj = _townMatrix[i][j];
                if (g.managerTutorial.isTutorial) {
                    if (!obj.isTutorialBuilding) {
                        return false;
                    }
                }
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
