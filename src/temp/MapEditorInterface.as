/**
 * Created by user on 5/20/15.
 */
package temp {
import data.BuildType;

import flash.display.BitmapData;
import flash.display.Shape;

import manager.Vars;
import mouse.ToolsModifier;

import starling.animation.Tween;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CButton;
import utils.CSprite;

public class MapEditorInterface {
    private var _allTable:Sprite;
    private var _contBuildings:Sprite;
    private var _leftArrow:CSprite;
    private var _rightArrow:CSprite;
    private var _moveBtn:EditorButtonInterface;
    private var _rotateBtn:EditorButtonInterface;
    private var _cancelBtn:EditorButtonInterface;
    private var _activeBtn:EditorButtonInterface;
    private var _mouseCoordinates:IsometricMouseCoordinates;
    private var _arrWilds:Array;

    private var g:Vars = Vars.getInstance();

    public function MapEditorInterface() {
        _allTable = new Sprite();
        _allTable.y = g.stageHeight - 100;
        g.cont.interfaceContMapEditor.addChild(_allTable);

        _mouseCoordinates = new IsometricMouseCoordinates();
        g.cont.interfaceContMapEditor.addChild(_mouseCoordinates.source);

        setEditorButtons();

        _contBuildings = new Sprite();
        _allTable.addChild(_contBuildings);

        var bg:Quad = new Quad(g.stageWidth, 80, Color.GRAY);
        bg.y = 20;
        _allTable.addChild(bg);

        bg = new Quad(50, 20, Color.BLUE);
        bg.x = g.stageWidth - 50;
        bg.y = 0;
        _allTable.addChild(bg);

        var shape:Shape = new Shape();
        shape.graphics.beginFill(0xffffff);
        shape.graphics.moveTo(0,10);
        shape.graphics.lineTo(10,2);
        shape.graphics.lineTo(10,18);
        shape.graphics.lineTo(0,10);
        shape.graphics.endFill();
        var BMP:BitmapData = new BitmapData(10, 20, true, 0x00000000);
        BMP.draw(shape);
        var Txr:Texture = Texture.fromBitmapData(BMP,false, false);
        _leftArrow = new CSprite();
        _leftArrow.addChild(new Image(Txr));
        _leftArrow.x = g.stageWidth - 45;
        _leftArrow.y = 0;
        _allTable.addChild(_leftArrow);

        shape.graphics.clear();
        shape.graphics.beginFill(0xffffff);
        shape.graphics.moveTo(0,2);
        shape.graphics.lineTo(0,18);
        shape.graphics.lineTo(10,10);
        shape.graphics.lineTo(0,2);
        shape.graphics.endFill();
        var BM:BitmapData = new BitmapData(10, 20, true, 0x00000000);
        BM.draw(shape);
        var Tx:Texture = Texture.fromBitmapData(BM,false, false);
        _rightArrow = new CSprite();
        _rightArrow.addChild(new Image(Tx));
        _rightArrow.x = g.stageWidth - 15;
        _rightArrow.y = 0;
        _allTable.addChild(_rightArrow);

        _contBuildings = new Sprite();
        _allTable.addChild(_contBuildings);
        _leftArrow.addEventListener(Event.TRIGGERED,onTriggered);
        _rightArrow.addEventListener(Event.TRIGGERED,onTriggered);

        fillWilds();

        _mouseCoordinates.startIt();
    }

    private function onTriggered(e:Event):void{
        switch (e.target) {
            case _leftArrow:
                scroleType(-500);
                break;
            case _rightArrow:
                scroleType(500);
                break;
        }
    }

    private function fillWilds():void{
        var obj:Object = g.dataBuilding.objectBuilding;
        var item:MapEditorInterfaceItem;
        var i:int = 0;

        _arrWilds = [];
        for(var id:String in obj) {
            if (obj[id].buildType == BuildType.WILD) {
                item = new MapEditorInterfaceItem(obj[id]);
                item.source.y = 20;
                item.source.x = i * 80;
                _contBuildings.addChild(item.source);
                _arrWilds.push(item);
                i++;
            }
        }
    }

    private function scroleType(delta:int):void{
        var endX:int = -_contBuildings.width + g.stageWidth;
        var newX:int = _contBuildings.x + delta;

        if(newX > 0) newX = 0;
        if(newX < endX) newX = endX - 20;

        var tween:Tween = new Tween(_contBuildings, 1);
        tween.moveTo(newX, _contBuildings.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);
    }

    private function setEditorButtons():void{
        _moveBtn = new EditorButtonInterface();
        _moveBtn.setIconButton("tools_panel_bt_move");
        _moveBtn.source.x = 700;
        _allTable.addChild(_moveBtn.source);

        _rotateBtn = new EditorButtonInterface();
        _rotateBtn.setIconButton("tools_panel_bt_rotate");
        _rotateBtn.source.x = 740;
        _allTable.addChild(_rotateBtn.source);

        _cancelBtn = new EditorButtonInterface();
        _cancelBtn.setIconButton("tools_panel_bt_canc");
        _cancelBtn.source.x = 780;
        _allTable.addChild(_cancelBtn.source);

        _activeBtn = new EditorButtonInterface();
        _activeBtn.setIconButton("red_tile");
        _activeBtn.source.x = 840;
        _allTable.addChild(_activeBtn.source);

        g.toolsModifier.modifierType = ToolsModifier.NONE;

        checkTypeEditor();

        var f1:Function = function ():void {
            if(g.toolsModifier.modifierType != ToolsModifier.GRID_DEACTIVATED){
                g.toolsModifier.modifierType == ToolsModifier.MOVE
                        ? g.toolsModifier.modifierType = ToolsModifier.NONE : g.toolsModifier.modifierType = ToolsModifier.MOVE;
                checkTypeEditor();
            }
        };
        _moveBtn.source.endClickCallback = f1;

        var f2:Function = function ():void {
            if(g.toolsModifier.modifierType != ToolsModifier.GRID_DEACTIVATED){
                g.toolsModifier.modifierType == ToolsModifier.FLIP
                        ? g.toolsModifier.modifierType = ToolsModifier.NONE : g.toolsModifier.modifierType = ToolsModifier.FLIP;
                checkTypeEditor();
            }

        };
        _rotateBtn.source.endClickCallback = f2;

        var f3:Function = function ():void {
            if(g.toolsModifier.modifierType != ToolsModifier.GRID_DEACTIVATED){
                g.toolsModifier.modifierType == ToolsModifier.DELETE
                        ? g.toolsModifier.modifierType = ToolsModifier.NONE : g.toolsModifier.modifierType= ToolsModifier.DELETE;
                checkTypeEditor();
            }

        };
        _cancelBtn.source.endClickCallback = f3;

        var f4:Function = function ():void {
            if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else{
                g.toolsModifier.modifierType = ToolsModifier.GRID_DEACTIVATED;
            }
            checkTypeEditor();

        };
        _activeBtn.source.endClickCallback = f4;
    }

    private function checkTypeEditor():void {
        _moveBtn.source.y = -10;
        _rotateBtn.source.y = -10;
        _cancelBtn.source.y = -10;
        _activeBtn.source.y = -10;

        switch (g.toolsModifier.modifierType) {
            case ToolsModifier.MOVE:
                _moveBtn.source.y = -20;
                break;
            case ToolsModifier.FLIP:
                _rotateBtn.source.y = -20;
                break;
            case ToolsModifier.DELETE:
                _cancelBtn.source.y = -20;
                break;
            case ToolsModifier.GRID_DEACTIVATED:
                _activeBtn.source.y = -20;
                break;
        }
    }

    public function deleteIt():void {
        g.cont.interfaceContMapEditor.removeChild(_allTable);
        g.cont.interfaceContMapEditor.removeChild(_mouseCoordinates.source);
        while (_contBuildings.numChildren) _contBuildings.removeChildAt(0);
        while (_allTable.numChildren) _allTable.removeChildAt(0);
        for (var i:int=0; i<_arrWilds.length; i++) {
            _arrWilds[i].deleteIt();
        }
        _arrWilds.length = 0;
        _arrWilds = null;
        _mouseCoordinates.stopIt();
        _mouseCoordinates.deleteIt();
        _leftArrow.deleteIt();
        _rightArrow.deleteIt();
        _activeBtn.deleteIt();
        _cancelBtn.deleteIt();
        _moveBtn.deleteIt();
        _rotateBtn.deleteIt();
    }
}
}
