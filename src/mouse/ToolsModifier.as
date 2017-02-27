/**
 * Created by user on 5/20/15.
 */
package mouse {
import build.WorldObject;
import build.chestYellow.ChestYellow;
import build.decor.Decor;
import build.decor.DecorAnimation;
import build.decor.DecorFence;
import build.decor.DecorTail;
import build.wild.Wild;
import com.junkbyte.console.Cc;
import flash.geom.Point;

import hint.MouseHint;

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;
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
    public static var CRAFT_PLANT:int = 11;
    public static var FEED_ANIMAL_ACTIVE:int = 12;

    private var _activeBuilding:WorldObject;
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
    private var _plantId:int;
    private var _ridgeId:int;
    private var _txtCount:CTextField;

    private var g:Vars = Vars.getInstance();

    public function ToolsModifier() {
        _mouseCont = g.cont.mouseCont;
        _cont = g.cont.animationsContBottom;
        _mouse = g.ownMouse;
        _callbackAfterMove = null;
        _modifierType = NONE;
        _mouseIcon = new Sprite();
        _plantId = -1;
        _txtCount = new CTextField(50,40,"");
        _txtCount.setFormat(CTextField.BOLD18, 16, Color.WHITE);
        _txtCount.x = 21;
        _txtCount.y = 27;
    }

    public function setTownArray():void {
        _townMatrix = g.townArea.townMatrix;
    }

    public function set modifierType(a:int):void {
        Cc.info('set modifierType ==' + a);
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (_modifierType == a) return;
        if (_modifierType == PLANT_SEED) {
//            g.managerPlantRidge.lockAllFillRidge(false); // unlock all not empty ridges
        } else if (_modifierType == PLANT_SEED_ACTIVE) {
//            g.managerPlantRidge.lockAllFillRidge(false);
            g.managerPlantRidge.onStartActivePlanting(false);
        } else if (_modifierType == CRAFT_PLANT) {
            g.mouseHint.hideIt();
            g.managerPlantRidge.onStartCraftPlanting(false);
        } else if (_modifierType == FEED_ANIMAL_ACTIVE) {
            g.managerAnimal.onStartFeedAnimal(false);
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
        } else if (_modifierType == PLANT_SEED_ACTIVE) {
            if (g.managerPendingRequest && !g.managerPendingRequest.isActive) g.managerPendingRequest.activateIt();
            g.managerPlantRidge.onStartActivePlanting(true);
//            g.managerPlantRidge.lockAllFillRidge(true);
        } else if (_modifierType == PLANT_SEED) {
            if (g.managerPendingRequest && !g.managerPendingRequest.isActive) g.managerPendingRequest.activateIt();
//            g.managerPlantRidge.lockAllFillRidge(true);
        } else if (_modifierType == CRAFT_PLANT) {
            if (g.managerPendingRequest && !g.managerPendingRequest.isActive) g.managerPendingRequest.activateIt();
            g.mouseHint.showMouseHint(MouseHint.SERP);
            g.managerPlantRidge.onStartCraftPlanting(true);
        } else if (_modifierType == FEED_ANIMAL_ACTIVE) {
            if (g.managerPendingRequest && !g.managerPendingRequest.isActive) g.managerPendingRequest.activateIt();
            g.managerAnimal.onStartFeedAnimal(true);
        } else if (_modifierType == NONE) {
            if (g.managerPendingRequest && g.managerPendingRequest.isActive) g.managerPendingRequest.disActivateIt();
        }
        checkMouseIcon();
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

    public function checkMouseIcon():void {
        var im:Image;

        clearCont();
        switch (_modifierType){
             case NONE:
                 _plantId = -1;
                 if(_mouseCont.contains(_mouseIcon)) _mouseCont.removeChild(_mouseIcon);
                 while (_mouseIcon.numChildren) _mouseIcon.removeChildAt(0);
                 g.gameDispatcher.removeEnterFrame(moveMouseIcon);
                 _mouseIcon.scaleX = _mouseIcon.scaleY = 1;
                 return;
             case MOVE:
                 im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_move'));
                 if (im) _mouseIcon.addChild(im);
                 break;
             case FLIP:
                 im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_rotate'));
                 if (im) _mouseIcon.addChild(im);
                break;
             case DELETE:
                 im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_canc'));
                 if (im) _mouseIcon.addChild(im);
                break;
             case INVENTORY:
                 im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_inv'));
                 if (im) _mouseIcon.addChild(im);
                break;
             case GRID_DEACTIVATED:
                 im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_tile'));
                 if (im) {
                     im.x = -im.width/2 - 15;
                     im.y = - 5 - 2;
                     _mouseIcon.addChild(im);
                 }
                break;
            case PLANT_SEED_ACTIVE:
            case PLANT_SEED:
                if (_plantId <= 0) return;
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_circle'));
                _mouseIcon.addChild(im);
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.resource[_plantId].imageShop + '_icon'));
                if (im) {
                    MCScaler.scale(im, 40, 40);
                    im.x = 27 - im.width/2;
                    im.y = 27 - im.height/2;
                    _mouseIcon.addChild(im);
                }
                if (!_mouseCont.contains(_mouseIcon)) _mouseCont.addChild(_mouseIcon);
                var im2:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("cursor_number_circle"));
                im2.x = _mouseIcon.width - 27;
                im2.y = _mouseIcon.height - 23;
                _mouseIcon.addChild(im2);
                if (_txtCount && !_mouseIcon.contains(_txtCount)) _mouseIcon.addChild(_txtCount);
                updateCountTxt();
                break;
            case ADD_NEW_RIDGE:
//                _modifierType = NONE;
                break;
            case CRAFT_PLANT:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_sickle'));
                break;
        }
        if (im) {
            if (!_mouseCont.contains(_mouseIcon)) _mouseCont.addChild(_mouseIcon);
//            MCScaler.scale(_mouseIcon, 40, 40);
            g.gameDispatcher.addEnterFrame(moveMouseIcon);
        }
     }

    public function updateCountTxt():void {
        if (_txtCount) {
            if (_plantId > 0) {
                _txtCount.text = String(g.userInventory.getCountResourceById(_plantId));
            } else {
                _txtCount.text = '';
            }
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


    // --------------------------------------------- MOVE SECTION -----------------------------------------------


    private function moveMouseIcon():void{
        _mouseIcon.x = g.ownMouse.mouseX + 15;
        _mouseIcon.y = g.ownMouse.mouseY + 5;
    }

    public function  startMove(selectedBuild:WorldObject, callback:Function=null, isFromShop:Boolean = false):void {
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

    public function startMoveTail(selectedBuild:WorldObject, callback:Function = null, isFromShop:Boolean = false):void {
        if (!selectedBuild) {
            Cc.error('ToolsModifier startMoveTail:: empty buildingData');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'toolsModifier');
            return;
        }

        g.townArea.onActivateMoveModifier(false);
        g.cont.contentCont.alpha = .5;
        g.cont.contentCont.touchable = false;

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
        _moveGrid = new BuildMoveGrid(_spriteForMove, _activeBuilding.dataBuild.width, _activeBuilding.dataBuild.height);
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
        if (_txtCount) {
            if (_mouseIcon.contains(_txtCount)) _mouseIcon.removeChild(_txtCount);
//            _txtCount.deleteIt();
//            _txtCount = null;
        }
        _moveGrid = null;
        _spriteForMove.removeChild(_activeBuilding.source);
        _spriteForMove = null;
        if (_activeBuilding is DecorTail) {
            if (_startMoveX == -1 && _startMoveY == -1) {
                _activeBuilding.clearIt();
                _activeBuilding = null;
            } else {
                g.townArea.pasteTailBuild((_activeBuilding as DecorTail), _startMoveX, _startMoveY, false, false);
            }
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
            g.cont.checkOnDragEnd();
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
            if (_modifierType == MOVE) {
                g.townArea.onActivateMoveModifier(true);
                g.cont.contentCont.alpha = 1;
            }
        } else g.cont.contentCont.alpha = 1;
        if (_activeBuilding is DecorTail) {
            if (!checkFreeTailGrids(point.x, point.y, _activeBuilding.dataBuild.width, _activeBuilding.dataBuild.height)) {
                g.gameDispatcher.addEnterFrame(moveIt);
                return;
            } else {
                g.cont.contentCont.alpha = 1;
                g.cont.contentCont.touchable = true;
            }
        }
        if (!g.isActiveMapEditor && _activeBuilding.useIsometricOnly && !(_activeBuilding is DecorTail)) {
            if (_activeBuilding.dataBuild.isFlip) {
                if (!checkFreeGrids(point.x, point.y, _activeBuilding.dataBuild.height, _activeBuilding.dataBuild.width)) {
                    g.gameDispatcher.addEnterFrame(moveIt);
                    return;
                }
            } else {
                if (!checkFreeGrids(point.x, point.y, _activeBuilding.dataBuild.width, _activeBuilding.dataBuild.height)) {
                    g.gameDispatcher.addEnterFrame(moveIt);
                    return;
                }
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

        var pointPos:Point = g.matrixGrid.getIndexFromXY(new Point(_spriteForMove.x, _spriteForMove.y));
        g.matrixGrid.setSpriteFromIndex(_spriteForMove, pointPos);
        if (spriteForMoveIndexX != pointPos.x || spriteForMoveIndexY != pointPos.y) {
            spriteForMoveIndexX = pointPos.x;
            spriteForMoveIndexY = pointPos.y;
            if (_activeBuilding is DecorTail) {
                if (!g.townArea.townTailMatrix[spriteForMoveIndexY] || !g.townArea.townTailMatrix[spriteForMoveIndexY][spriteForMoveIndexX]) return;
                if (!checkFreeTailGrids(pointPos.x, pointPos.y, _activeBuilding.dataBuild.width, _activeBuilding.dataBuild.height)) {
                    _spriteForMove.filter = ManagerFilters.RED_TINT_FILTER;
                } else {
                    _spriteForMove.filter = null;
                }
                _moveGrid.checkIt(spriteForMoveIndexX, spriteForMoveIndexY);
            } else {
                if (g.isActiveMapEditor && _activeBuilding is Wild) return;
                if (g.isActiveMapEditor && _activeBuilding is Decor) return;
                if (g.isActiveMapEditor && _activeBuilding is ChestYellow) return;
                if (g.isActiveMapEditor && _activeBuilding is DecorAnimation) return;
                _moveGrid.checkIt(spriteForMoveIndexX, spriteForMoveIndexY);
                if (_moveGrid.isFree) {
                    _activeBuilding.source.filter = null;
                } else {
//                    if (_startMoveX == int(_spriteForMove.x) && _startMoveY == int(_spriteForMove.y))  _activeBuilding.source.filter = null;
                    _activeBuilding.source.filter = ManagerFilters.RED_TINT_FILTER;
                }
                if (_activeBuilding is DecorFence) {
                    try {
                        checkDecorFenceForFlip(pointPos);
                    } catch (e:Error) {
                        Cc.error('Error with DecorFence at checkDecorFenceForFlip');
                    }
                }
            }
        }
    }

    private function checkDecorFenceForFlip(pos:Point):void {
        var fence:DecorFence;
        //check right top
        if (_townMatrix[pos.y-1] && _townMatrix[pos.y-1][pos.x] && _townMatrix[pos.y-1][pos.x].build && _townMatrix[pos.y-1][pos.x].build is DecorFence) {
            fence = _townMatrix[pos.y-1][pos.x].build as DecorFence;
            if (_townMatrix[pos.y-1][pos.x+1] && _townMatrix[pos.y-1][pos.x+1].build && _townMatrix[pos.y-1][pos.x+1].build is DecorFence) {
                if (fence == _townMatrix[pos.y-1][pos.x+1].build && fence.dataBuild.id == _activeBuilding.dataBuild.id) {
                    // user have the sane fence at right top
                    if (_activeBuilding.flip) (_activeBuilding as DecorFence).makeFlipAtMoving();
                    return;
                }
            }
        }
        // check left bottom
        if (_townMatrix[pos.y+2] && _townMatrix[pos.y+2][pos.x] && _townMatrix[pos.y+2][pos.x].build && _townMatrix[pos.y+2][pos.x].build is DecorFence) {
            fence = _townMatrix[pos.y+2][pos.x].build as DecorFence;
            if (_townMatrix[pos.y+2][pos.x+1] && _townMatrix[pos.y+2][pos.x+1].build && _townMatrix[pos.y+2][pos.x+1].build is DecorFence) {
                if (fence == _townMatrix[pos.y+2][pos.x+1].build && fence.dataBuild.id == _activeBuilding.dataBuild.id) {
                    // user have the sane fence at left bottom
                    if (_activeBuilding.flip) (_activeBuilding as DecorFence).makeFlipAtMoving();
                    return;
                }
            }
        }
        //check left top
        if (_townMatrix[pos.y][pos.x-1] && _townMatrix[pos.y][pos.x-1].build && _townMatrix[pos.y][pos.x-1].build is DecorFence) {
            fence = _townMatrix[pos.y][pos.x-1].build as DecorFence;
            if (_townMatrix[pos.y+1] && _townMatrix[pos.y+1][pos.x-1] && _townMatrix[pos.y+1][pos.x-1].build && _townMatrix[pos.y+1][pos.x-1].build is DecorFence) {
                if (fence == _townMatrix[pos.y+1][pos.x-1].build && fence.dataBuild.id == _activeBuilding.dataBuild.id) {
                    // user have the sane fence at left top
                    if (!_activeBuilding.flip) (_activeBuilding as DecorFence).makeFlipAtMoving();
                    return;
                }
            }
        }
        //check right bottom
        if (_townMatrix[pos.y][pos.x+2] && _townMatrix[pos.y][pos.x+2].build && _townMatrix[pos.y][pos.x+2].build is DecorFence) {
            fence = _townMatrix[pos.y][pos.x+2].build as DecorFence;
            if (_townMatrix[pos.y+1] && _townMatrix[pos.y+1][pos.x+2] && _townMatrix[pos.y+1][pos.x+2].build && _townMatrix[pos.y+1][pos.x+2].build is DecorFence) {
                if (fence == _townMatrix[pos.y+1][pos.x+2].build && fence.dataBuild.id == _activeBuilding.dataBuild.id) {
                    // user have the sane fence at right bottom
                    if (!_activeBuilding.flip) (_activeBuilding as DecorFence).makeFlipAtMoving();
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
                if (i < 0 || j < 0 || i >= 80 || j >= 80) return false;
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
    public function checkFreeTailGrids(posX:int, posY:int, width:int, height:int):Boolean {
        var ob:Object;
        for (i = posY; i < posY + height; i++) {
            for (j = posX; j < posX + width; j++) {
                if (i < 0 || j < 0 || i > 80 || j > 80) return false;
                obj = g.townArea.townTailMatrix[i][j];
                ob = _townMatrix[i][j];
                if (obj.inTile) return false;
                if (!obj.inGame) return false;
                if (obj.isBlocked) return false;
                if (ob.isLockedLand) return false;
            }
        }

        return true;
    }
}
}
