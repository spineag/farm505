/**
 * Created by user on 5/20/15.
 */
package mouse {
import build.WorldObject;
import build.decor.DecorTail;
import build.ridge.Ridge;
import build.tree.Tree;
import build.wild.Wild;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import manager.Vars;

import map.MatrixGrid;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

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

    private var _activeBuildingData:Object;
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
    private var filter:ColorMatrixFilter;

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
        _txtCount = new TextField(50, 40,"","Arial",16,Color.RED);
        _txtCount.x = 5;
        _txtCount.y = 5;

        filter = new ColorMatrixFilter();
        filter.tint(Color.RED, 1);
    }

    public function setTownArray():void {
        _townMatrix = g.townArea.townMatrix;
    }

    public function set modifierType(a:int):void {
        if (_modifierType == PLANT_SEED || _modifierType == PLANT_SEED_ACTIVE) {
            g.managerPlantRidge.lockAllFillRidge(false); // unlock all not empty ridges
        }
        _modifierType = a;
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
                 im = new Image(g.allData.atlas['mapAtlas'].getTexture('Move'));
                 if (im) _mouseIcon.addChild(im);
                 break;
             case ToolsModifier.FLIP:
                 im = new Image(g.allData.atlas['mapAtlas'].getTexture('Rotate'));
                 if (im) _mouseIcon.addChild(im);
                break;
             case ToolsModifier.DELETE:
                 im = new Image(g.allData.atlas['mapAtlas'].getTexture('Cancel'));
                 if (im) _mouseIcon.addChild(im);
                break;
             case ToolsModifier.INVENTORY:
                 im = new Image(g.allData.atlas['mapAtlas'].getTexture('Storage'));;
                 if (im) _mouseIcon.addChild(im);
                break;
             case ToolsModifier.GRID_DEACTIVATED:
                 var q:Quad = new Quad(100, 100, Color.RED);
                 q.rotation = Math.PI/4;
                 var _iconEditor:Sprite = new Sprite();
                 _iconEditor.addChild(q);
                 _iconEditor.scaleY /= 2;
                 _iconEditor.x = _iconEditor.width/2;
                 _mouseIcon.addChild(_iconEditor);
                break;
            case ToolsModifier.PLANT_SEED:
                if (_plantId <= 0) return;
                im = new Image(g.allData.atlas['plantAtlas'].getTexture(g.dataResource.objectResources[_plantId].imageShop));
                if (im) _mouseIcon.addChild(im);
                updateCountTxt();
                if (!_mouseCont.contains(_txtCount)) _mouseCont.addChild(_txtCount);
                break;
            case ToolsModifier.ADD_NEW_RIDGE:
//                _modifierType = NONE;
                break;
        }
        if (im) {
            if (!_mouseCont.contains(_mouseIcon)) _mouseCont.addChild(_mouseIcon);
            MCScaler.scale(_mouseIcon, 30, 30);
            g.gameDispatcher.addEnterFrame(moveMouseIcon);
        } else {
            if (g.toolsModifier.modifierType != ToolsModifier.ADD_NEW_RIDGE) {
                Cc.error('ToolsModifier:: no image for modifierType: ' + g.toolsModifier.modifierType);
                g.woGameError.showIt();
            }
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
        if (_mouseCont.contains(_txtCount)) {
            _mouseCont.removeChild(_txtCount);
        }
    }

    private function moveMouseIcon():void{
        _mouseCont.x = g.ownMouse.mouseX + 20;
        _mouseCont.y = g.ownMouse.mouseY + 10;
    }

    private var imForMove:Image;
    public function  startMove(buildingData:Object, callback:Function = null, treeState:int = 1, ridgeState:int = 1, isFromShop:Boolean = false):void {
        if (!buildingData) {
            Cc.error('ToolsModifier startMove:: empty buildingData');
            g.woGameError.showIt();
            return;
        }
        _spriteForMove = new Sprite();
        _callbackAfterMove = callback;
        _activeBuildingData = buildingData;

        if (_activeBuildingData.url == "treeAtlas"){
            switch (treeState) {
                case Tree.GROW1:
                case Tree.GROW_FLOWER1:
                case Tree.GROWED1:
                    imForMove = new Image(g.allData.atlas[_activeBuildingData.url].getTexture(_activeBuildingData.imageGrowSmall));
                    if (imForMove) {
                        imForMove.x = _activeBuildingData.innerPositionsGrow1[0];
                        imForMove.y = _activeBuildingData.innerPositionsGrow1[1];
                    }
                    break;
                case Tree.GROW2:
                case Tree.GROW_FLOWER2:
                case Tree.GROWED2:
                    imForMove = new Image(g.allData.atlas['treeAtlas'].getTexture(_activeBuildingData.imageGrowMiddle));
                    if (imForMove) {
                        imForMove.x = _activeBuildingData.innerPositionsGrow2[0];
                        imForMove.y = _activeBuildingData.innerPositionsGrow2[1];
                    }
                    break;
                case Tree.GROW3:
                case Tree.GROW_FLOWER3:
                case Tree.GROWED3:
                case Tree.GROW_FIXED:
                case Tree.GROWED_FIXED:
                case Tree.GROW_FIXED_FLOWER:
                    imForMove = new Image(g.allData.atlas['treeAtlas'].getTexture(_activeBuildingData.imageGrowBig));
                    if (imForMove) {
                        imForMove.x = _activeBuildingData.innerPositionsGrow3[0];
                        imForMove.y = _activeBuildingData.innerPositionsGrow3[1];
                    }
                    break;
                case Tree.DEAD:
                case Tree.ASK_FIX:
                case Tree.FIXED:
                case Tree.FULL_DEAD:
                    imForMove = new Image(g.allData.atlas['treeAtlas'].getTexture(_activeBuildingData.imageDead));
                    if (imForMove) {
                        imForMove.x = _activeBuildingData.innerPositionsDead[0];
                        imForMove.y = _activeBuildingData.innerPositionsDead[1];
                    }
                    break;
            }
            if (imForMove) {
                _spriteForMove.addChild(imForMove);
            } else {
                Cc.error('ToolsModifier startMove:: no image for tree type: ' + treeState);
                g.woGameError.showIt();
                return;
            }
        } else if (_activeBuildingData.buildType == BuildType.RIDGE) {
            imForMove = new Image(g.allData.atlas[_activeBuildingData.url].getTexture(_activeBuildingData.image));
            if (imForMove) {
                imForMove.x = _activeBuildingData.innerX;
                imForMove.y = _activeBuildingData.innerY;
                _spriteForMove.addChild(imForMove);
            } else {
                Cc.error('ToolsModifier startMove:: no image for BuildType: ' + _activeBuildingData.image);
                g.woGameError.showIt();
                return;
            }
            if (ridgeState == Ridge.GROW1 || ridgeState == Ridge.GROW2 || ridgeState == Ridge.GROW3 || ridgeState == Ridge.GROWED ) {
                switch (ridgeState) {
                    case Ridge.GROW1:
                        imForMove = new Image(g.allData.atlas['plantAtlas'].getTexture(g.dataResource.objectResources[_ridgeId].image1));
                        if (imForMove) {
                            imForMove.x = g.dataResource.objectResources[_ridgeId].innerPositions[0];
                            imForMove.y = g.dataResource.objectResources[_ridgeId].innerPositions[1];
                        }
                        break;
                    case Ridge.GROW2:
                        imForMove = new Image(g.allData.atlas['plantAtlas'].getTexture(g.dataResource.objectResources[_ridgeId].image2));
                        if (imForMove) {
                            imForMove.x = g.dataResource.objectResources[_ridgeId].innerPositions[2];
                            imForMove.y = g.dataResource.objectResources[_ridgeId].innerPositions[3];
                        }
                        break;
                    case Ridge.GROW3:
                        imForMove = new Image(g.allData.atlas['plantAtlas'].getTexture(g.dataResource.objectResources[_ridgeId].image3));
                        if (imForMove) {
                            imForMove.x = g.dataResource.objectResources[_ridgeId].innerPositions[4];
                            imForMove.y = g.dataResource.objectResources[_ridgeId].innerPositions[5];
                        }
                        break;
                    case Ridge.GROWED:
                        imForMove = new Image(g.allData.atlas['plantAtlas'].getTexture(g.dataResource.objectResources[_ridgeId].image4));
                        if (imForMove) {
                            imForMove.x = g.dataResource.objectResources[_ridgeId].innerPositions[6];
                            imForMove.y = g.dataResource.objectResources[_ridgeId].innerPositions[7];
                        }
                        break;
                }
                if (imForMove) {
                    _spriteForMove.addChild(imForMove);
                } else {
                    Cc.error('ToolsModifier startMove:: no image for ridge type: ' + ridgeState);
                    g.woGameError.showIt();
                    return;
                }
            }
        } else if (_activeBuildingData.url == "buildAtlas" || _activeBuildingData.url == "farmAtlas" || _activeBuildingData.url == "decorAtlas") {
            imForMove = new Image(g.allData.atlas[_activeBuildingData.url].getTexture(_activeBuildingData.image));
            if (imForMove) {
                imForMove.x = _activeBuildingData.innerX;
                imForMove.y = _activeBuildingData.innerY;
                _spriteForMove.addChild(imForMove);
            } else {
                Cc.error('ToolsModifier startMove:: no image for url=buildAtlas and _activeBuildingData.image: ' + _activeBuildingData.image);
                g.woGameError.showIt();
                return;
            }
            if (!isFromShop && g.selectedBuild && g.selectedBuild.stateBuild == WorldObject.STATE_BUILD) {
                imForMove = new Image(g.allData.atlas['buildAtlas'].getTexture("foundation"));
                imForMove.x = -262;
                imForMove.y = -274;
                _spriteForMove.addChild(imForMove);
            }
        } else if (_activeBuildingData.url == 'wildAtlas') {
            imForMove = new Image(g.allData.atlas[_activeBuildingData.url].getTexture(_activeBuildingData.image));
            if (imForMove) {
                imForMove.x = _activeBuildingData.innerX;
                imForMove.y = _activeBuildingData.innerY;
                _spriteForMove.addChild(imForMove);
            } else {
                Cc.error('ToolsModifier startMove:: no image for url=wildAtlas and _activeBuildingData.image: ' + _activeBuildingData.image);
                g.woGameError.showIt();
                return;
            }
        } else if (_activeBuildingData.url == 'mapAtlas') {
            imForMove  = new Image(g.allData.atlas[_activeBuildingData.url].getTexture(_activeBuildingData.image));
            if (imForMove) {
                imForMove.x = -imForMove.width/2;
                _spriteForMove.addChild(imForMove);
            } else {
                Cc.error('ToolsModifier startMove:: no such image _activeBuildingData.image: ' + _activeBuildingData.image);
                g.woGameError.showIt();
                return;
            }
        } else {
            Cc.error('ToolsModifier startMove:: no such image _activeBuildingData.image: ' + _activeBuildingData.image + ' for url: ' + _activeBuildingData.url);
            g.woGameError.showIt();
            return;
        }

        if (_activeBuildingData.isFlip) imForMove.scaleX *= -1;

        _spriteForMove.x = _mouse.mouseX - _cont.x;
        _spriteForMove.y = _mouse.mouseY - _cont.y - MatrixGrid.FACTOR/2;
        _cont.addChild(_spriteForMove);

        _cont.x = g.cont.gameCont.x;
        _cont.y = g.cont.gameCont.y;
        _cont.scaleX = _cont.scaleY = g.cont.gameCont.scaleX;

        if (g.selectedBuild && g.selectedBuild.source && g.selectedBuild.isContDrag || isFromShop) {
            _needMoveGameCont = true;
        }
        _cont.addEventListener(TouchEvent.TOUCH, onTouch);
        _moveGrid = new BuildMoveGrid(_spriteForMove, _activeBuildingData.width, _activeBuildingData.height);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    public function startMoveTail(buildingData:Object, callback:Function = null, isFromShop:Boolean = false):void {
        if (!buildingData) {
            Cc.error('ToolsModifier startMoveTail:: empty buildingData');
            g.woGameError.showIt();
            return;
        }

        g.cont.contentCont.alpha = .5;
        g.cont.contentCont.touchable = false;

        _spriteForMove = new Sprite();
        _callbackAfterMove = callback;
        _activeBuildingData = buildingData;
        imForMove = new Image(g.allData.atlas[_activeBuildingData.url].getTexture(_activeBuildingData.image));
        if (imForMove) {
            imForMove.x = _activeBuildingData.innerX;
            imForMove.y = _activeBuildingData.innerY;
            _spriteForMove.addChild(imForMove);
        } else {
            Cc.error('ToolsModifier startMove:: no image for url=buildAtlas and _activeBuildingData.image: ' + _activeBuildingData.image);
            g.woGameError.showIt();
            return;
        }

        if (_activeBuildingData.isFlip) imForMove.scaleX *= -1;

        _spriteForMove.x = _mouse.mouseX - _cont.x;
        _spriteForMove.y = _mouse.mouseY - _cont.y - MatrixGrid.FACTOR/2;
        _cont.addChild(_spriteForMove);

        _cont.x = g.cont.gameCont.x;
        _cont.y = g.cont.gameCont.y;
        _cont.scaleX = _cont.scaleY = g.cont.gameCont.scaleX;

        if (g.selectedBuild && g.selectedBuild.source && g.selectedBuild.source.isContDrag || isFromShop) {
            _needMoveGameCont = true;
        }
        _cont.addEventListener(TouchEvent.TOUCH, onTouch);
        _moveGrid = null;
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    public function cancelMove():void {
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (_spriteForMove) {
            while (_spriteForMove.numChildren) {
                _spriteForMove.removeChildAt(0);
            }
        }
        if (_moveGrid) _moveGrid.clearIt();
        _moveGrid = null;
        if (imForMove) imForMove.dispose();
        imForMove = null;
        _spriteForMove = null;
        return;
    }

    private var _needMoveGameCont:Boolean = false;
    private var _startDragPoint:Point;
    private function onTouch(te:TouchEvent):void {
        if (_needMoveGameCont && te.getTouch(_cont, TouchPhase.BEGAN)) {
            g.gameDispatcher.removeEnterFrame(onEnterFrame);
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
                    g.gameDispatcher.addEnterFrame(onEnterFrame);
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

        if (_activeBuildingData.buildType == BuildType.DECOR_TAIL) {
            g.cont.contentCont.alpha = 1;
            g.cont.contentCont.touchable = true;
        }


        if (!_spriteForMove) return;
        if (g.selectedBuild && g.selectedBuild.useIsometricOnly) {
            point = g.matrixGrid.getIndexFromXY(new Point(_spriteForMove.x, _spriteForMove.y));
            g.matrixGrid.setSpriteFromIndex(_spriteForMove, point);
        }
        x = _spriteForMove.x;
        y = _spriteForMove.y;
        if (!g.isActiveMapEditor && g.selectedBuild && g.selectedBuild.useIsometricOnly && !(g.selectedBuild is DecorTail)) {
            if (!checkFreeGrids(point.x, point.y, _activeBuildingData.width, _activeBuildingData.height)) {
                g.gameDispatcher.addEnterFrame(onEnterFrame);
                return;
            }
        }

        spriteForMoveIndexX = 0;
        spriteForMoveIndexY = 0;
        _cont.removeEventListener(TouchEvent.TOUCH, onTouch);
        g.gameDispatcher.removeEnterFrame(onEnterFrame);

        _cont.removeChild(_spriteForMove);
//        _spriteForMove.unflatten();
        while (_spriteForMove.numChildren) {
            _spriteForMove.removeChildAt(0);
        }
        if (_moveGrid) {
            _moveGrid.clearIt();
            _moveGrid = null;
        }

        if (imForMove) imForMove.dispose();
        imForMove = null;
        _spriteForMove = null;

        if (_callbackAfterMove != null) {
            _callbackAfterMove.apply(null, [x, y])
        }
    }

    private var spriteForMoveIndexX:int = 0;
    private var spriteForMoveIndexY:int = 0;
    private function moveIt():void {
        _spriteForMove.x = (_mouse.mouseX - _cont.x)/g.cont.gameCont.scaleX;
        _spriteForMove.y = (_mouse.mouseY - _cont.y - MatrixGrid.FACTOR/2)/g.cont.gameCont.scaleX;
        if (_startDragPoint) return;
        if (g.selectedBuild && !g.selectedBuild.useIsometricOnly) return;

        var point:Point = g.matrixGrid.getIndexFromXY(new Point(_spriteForMove.x, _spriteForMove.y));
        g.matrixGrid.setSpriteFromIndex(_spriteForMove, point);
        if (spriteForMoveIndexX != point.x || spriteForMoveIndexY != point.y) {
            spriteForMoveIndexX = point.x;
            spriteForMoveIndexY = point.y;
            if (_activeBuildingData.buildType == BuildType.DECOR_TAIL) {
                if (g.townArea.townTailMatrix[spriteForMoveIndexY][spriteForMoveIndexX].build) {
                    imForMove.filter = filter;
                } else {
                    imForMove.filter = null;
                }
            } else {
                if (g.isActiveMapEditor && _activeBuildingData.buildType == BuildType.WILD) return;
                _moveGrid.checkIt(spriteForMoveIndexX, spriteForMoveIndexY);
                if (_moveGrid.isFree) {
                    imForMove.filter = null;
                } else {
                    imForMove.filter = filter;

                }
            }
        }
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
