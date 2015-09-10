/**
 * Created by user on 5/20/15.
 */
package mouse {
import build.tree.Tree;

import flash.geom.Point;

import manager.Vars;

import map.MatrixGrid;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.ColorMatrixFilter;
import starling.utils.Color;

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

    private var g:Vars = Vars.getInstance();

    public function ToolsModifier() {
        _mouseCont = g.cont.mouseCont;
        _cont = g.cont.animationsContTop;
        _mouse = g.ownMouse;
        _callbackAfterMove = null;
        _modifierType = NONE;
        _mouseIcon = new Sprite();
        contImage = new Sprite();
        _plantId = -1;
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

    public function set plantId(a:int):void {
        _plantId = a;
    }

    public function get plantId():int {
        return _plantId;
    }

    public function checkMouseIcon():void {
        var im:Image;

        clearCont();
        switch (g.toolsModifier.modifierType){
             case ToolsModifier.NONE:
                 _plantId = -1;
                 if(_mouseCont.contains(_mouseIcon)) _mouseCont.removeChild(_mouseIcon);
                 g.gameDispatcher.removeEnterFrame(moveMouseIcon);
                 return;
             case ToolsModifier.MOVE:
                 im = new Image(g.mapAtlas.getTexture("Move"));
                 _mouseIcon.addChild(im);
                 break;
             case ToolsModifier.FLIP:
                 im = new Image(g.mapAtlas.getTexture("Rotate"));
                 _mouseIcon.addChild(im);
                break;
             case ToolsModifier.DELETE:
                 im = new Image(g.mapAtlas.getTexture("Cancel"));
                 _mouseIcon.addChild(im);
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
                im = new Image(g.plantAtlas.getTexture(g.dataResource.objectResources[_plantId].imageShop));
                _mouseIcon.addChild(im);
                break;
        }
        if (im) {
            if (!_mouseCont.contains(_mouseIcon)) _mouseCont.addChild(_mouseIcon);
            MCScaler.scale(_mouseIcon, 30, 30);
            g.gameDispatcher.addEnterFrame(moveMouseIcon);
        }
     }

    private function clearCont():void{
        while (_mouseIcon.numChildren) {
            _mouseIcon.removeChildAt(0);
        }
    }

    private function moveMouseIcon():void{
        _mouseCont.x = g.ownMouse.mouseX + 20;
        _mouseCont.y = g.ownMouse.mouseY + 10;
    }

    private var imForMove:Image;
    public function startMove(buildingData:Object, callback:Function = null, treeState:int = 1):void {
        _spriteForMove = new Sprite();
        _callbackAfterMove = callback;
        _activeBuildingData = buildingData;
        if (_activeBuildingData.url == "treeAtlas"){
            switch (treeState) {
                case Tree.GROW1:
                case Tree.GROW_FLOWER1:
                case Tree.GROWED1:
                    imForMove = new Image(g.treeAtlas.getTexture(_activeBuildingData.imageGrowSmall));
                    imForMove.x = _activeBuildingData.innerPositionsGrow1[0];
                    imForMove.y = _activeBuildingData.innerPositionsGrow1[1];
                    break;
                case Tree.GROW2:
                case Tree.GROW_FLOWER2:
                case Tree.GROWED2:
                    imForMove = new Image(g.treeAtlas.getTexture(_activeBuildingData.imageGrowMiddle));
                    imForMove.x = _activeBuildingData.innerPositionsGrow2[0];
                    imForMove.y = _activeBuildingData.innerPositionsGrow2[1];
                    break;
                case Tree.GROW3:
                case Tree.GROW_FLOWER3:
                case Tree.GROWED3:
                case Tree.GROW_FIXED:
                case Tree.GROWED_FIXED:
                case Tree.GROW_FIXED_FLOWER:
                    imForMove = new Image(g.treeAtlas.getTexture(_activeBuildingData.imageGrowBig));
                    imForMove.x = _activeBuildingData.innerPositionsGrow3[0];
                    imForMove.y = _activeBuildingData.innerPositionsGrow3[1];
                    break;
                case Tree.DEAD:
                case Tree.ASK_FIX:
                case Tree.FIXED:
                case Tree.FULL_DEAD:
                    imForMove = new Image(g.treeAtlas.getTexture(_activeBuildingData.imageDead));
                    imForMove.x = _activeBuildingData.innerPositionsGrowDead[0];
                    imForMove.y = _activeBuildingData.innerPositionsGrowDead[1];
                    break;
            }
            _spriteForMove.addChild(imForMove);
//            _spriteForMove.addChild(contImage);
        } else if (_activeBuildingData.url == "buildAtlas") {
            imForMove = new Image(g.tempBuildAtlas.getTexture(_activeBuildingData.image));
            imForMove.x = _activeBuildingData.innerX;
            imForMove.y = _activeBuildingData.innerY;
            _spriteForMove.addChild(imForMove);
        } else {
            imForMove  = new Image(g.mapAtlas.getTexture(_activeBuildingData.image));
            imForMove.x = -imForMove.width/2;
        }

//        if (_activeBuildingData.isFlip) _spriteForMove.scaleX *= -1;
        if (_activeBuildingData.isFlip) imForMove.scaleX *= -1;

//        _spriteForMove.flatten();
        _spriteForMove.x = _mouse.mouseX - _cont.x;
        _spriteForMove.y = _mouse.mouseY - _cont.y - MatrixGrid.FACTOR/2;
        _cont.addChild(_spriteForMove);

        _cont.x = g.cont.gameCont.x;
        _cont.y = g.cont.gameCont.y;

        _cont.addEventListener(TouchEvent.TOUCH, onTouch);
        _moveGrid = new BuildMoveGrid(_spriteForMove, _activeBuildingData.width, _activeBuildingData.height);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function onTouch(te:TouchEvent):void {
        if (te.getTouch(_cont, TouchPhase.ENDED)) {
            onTouchEnded();
        }
    }

    public function onTouchEnded():void {
        if (!_spriteForMove) return;
        var point:Point = g.matrixGrid.getIndexFromXY(new Point(_spriteForMove.x, _spriteForMove.y));
        if (!checkFreeGrids(point.x, point.y, _activeBuildingData.width, _activeBuildingData.height)) return;

        spriteForMoveIndexX = 0;
        spriteForMoveIndexY = 0;
        if (_callbackAfterMove != null) {
            _callbackAfterMove.apply(null, [_spriteForMove.x, _spriteForMove.y])
        }
        _cont.removeEventListener(TouchEvent.TOUCH, onTouch);
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        _cont.removeChild(_spriteForMove);
//        _spriteForMove.unflatten();
        while (_spriteForMove.numChildren) {
            _spriteForMove.removeChildAt(0);
        }
        _moveGrid.clearIt();
        _moveGrid = null;
        if (imForMove) imForMove.dispose();
        imForMove = null;
        _spriteForMove = null;
    }

    private var spriteForMoveIndexX:int = 0;
    private var spriteForMoveIndexY:int = 0;
    private function moveIt():void {
        _spriteForMove.x = _mouse.mouseX - _cont.x;
        _spriteForMove.y = _mouse.mouseY - _cont.y - MatrixGrid.FACTOR/2;
        var point:Point = g.matrixGrid.getIndexFromXY(new Point(_spriteForMove.x, _spriteForMove.y));
        g.matrixGrid.setSpriteFromIndex(_spriteForMove, point);
        if (spriteForMoveIndexX != point.x || spriteForMoveIndexY != point.y) {  // ��������� ���������� �� ������� � ����� ��������
            spriteForMoveIndexX = point.x;
            spriteForMoveIndexY = point.y;
            _moveGrid.checkIt(spriteForMoveIndexX, spriteForMoveIndexY);
            if (_moveGrid.isFree) {
                if (imForMove) imForMove.filter = null;
            } else {
                var filter:ColorMatrixFilter = new ColorMatrixFilter();
                filter.tint(Color.RED, 1);
                imForMove.filter = filter;
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
