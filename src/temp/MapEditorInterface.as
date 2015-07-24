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
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CButton;

public class MapEditorInterface {
    public static const TYPE_BUILDING:String = 'building';
    public static const TYPE_TREE:String = 'tree';
    public static const TYPE_DECOR:String = 'decor';

    private var _type:String;

    private var _allTable:Sprite;
    private var _contBuildings:Sprite;
    private var _contTrees:Sprite;
    private var _contDecors:Sprite;
    private var _bg:Quad;
    private var _arrowBg:Quad;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _houseBtn:CButton;
    private var _treeBtn:CButton;
    private var _decorBtn:CButton;
    private var _moveBtn:EditorButtonInterface;
    private var _rotateBtn:EditorButtonInterface;
    private var _cancelBtn:EditorButtonInterface;
    private var _activeBtn:EditorButtonInterface;
    private var _mouseCoordinates:IsometricMouseCoordinates;

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

        _bg = new Quad(g.stageWidth, 80, Color.GRAY);
        _bg.y = 20;
        _allTable.addChild(_bg);

        _arrowBg = new Quad(50, 20, Color.BLUE);
        _arrowBg.x = g.stageWidth - 50;
        _arrowBg.y = 0;
        _allTable.addChild(_arrowBg);

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
        _leftArrow = new CButton(Txr);
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
        _rightArrow = new CButton(Tx);
        _rightArrow.x = g.stageWidth - 15;
        _rightArrow.y = 0;
        _allTable.addChild(_rightArrow);

        //button1
        shape.graphics.clear();
        shape.graphics.beginFill(0xffffff);
        shape.graphics.moveTo(0,0);
        shape.graphics.lineTo(50,0);
        shape.graphics.lineTo(50,20);
        shape.graphics.lineTo(0,20);
        shape.graphics.lineTo(0,0);
        shape.graphics.endFill();
        var BM1:BitmapData = new BitmapData(50, 20, true, 0x00000000);
        BM1.draw(shape);
        var Tx1:Texture = Texture.fromBitmapData(BM1,false, false);
        _houseBtn = new CButton(Tx1,"Building");
        _allTable.addChild(_houseBtn);

        //Button2
        shape.graphics.clear();
        shape.graphics.beginFill(0xDC143C);
        shape.graphics.moveTo(0,0);
        shape.graphics.lineTo(50,0);
        shape.graphics.lineTo(50,20);
        shape.graphics.lineTo(0,20);
        shape.graphics.lineTo(0,0);
        shape.graphics.endFill();
        var BM2:BitmapData = new BitmapData(50, 20, true, 0x00000000);
        BM2.draw(shape);
        var Tx2:Texture = Texture.fromBitmapData(BM2,false, false);
        _treeBtn = new CButton(Tx2,"Tree");
        _treeBtn.x = 50;
        _allTable.addChild(_treeBtn);

        //Button3
        shape.graphics.clear();
        shape.graphics.beginFill(0xFFFF00);
        shape.graphics.moveTo(0,0);
        shape.graphics.lineTo(50,0);
        shape.graphics.lineTo(50,20);
        shape.graphics.lineTo(0,20);
        shape.graphics.lineTo(0,0);
        shape.graphics.endFill();
        var BM3:BitmapData = new BitmapData(50, 20, true, 0x00000000);
        BM3.draw(shape);
        var Tx3:Texture = Texture.fromBitmapData(BM3,false, false);
        _decorBtn = new CButton(Tx3,"Decor");
        _decorBtn.x = 100;
        _allTable.addChild(_decorBtn);

        fillIt();
        fillHouses();
        fillTrees();
        fillDecors();
    }

    private function fillIt():void {
        _contBuildings = new Sprite();
        _contTrees = new Sprite();
        _contDecors = new Sprite();
        _allTable.addChild(_contBuildings);
        _allTable.addChild(_contTrees);
        _allTable.addChild(_contDecors);

        _type = TYPE_BUILDING;

        checkType();

        _houseBtn.addEventListener(Event.TRIGGERED,onTriggered);
        _treeBtn.addEventListener(Event.TRIGGERED,onTriggered);
        _decorBtn.addEventListener(Event.TRIGGERED,onTriggered);
        _leftArrow.addEventListener(Event.TRIGGERED,onTriggered);
        _rightArrow.addEventListener(Event.TRIGGERED,onTriggered);
    }

    private function checkType():void {
        _houseBtn.y = 0;
        _treeBtn.y = 0;
        _decorBtn.y = 0;
        _contBuildings.visible = false;
        _contTrees.visible = false;
        _contDecors.visible = false;

        switch (_type) {
            case TYPE_BUILDING:
                _houseBtn.y = -7;
                _contBuildings.visible = true;
                break;
            case TYPE_TREE:
                _treeBtn.y = -7;
                _contTrees.visible = true;
                break;
            case TYPE_DECOR:
                _decorBtn.y = -7;
                _contDecors.visible = true;
                break;
        }
    }

    private function onTriggered(e:Event):void{
        switch (e.target) {
            case _houseBtn:
                _type = TYPE_BUILDING;
                break;
            case _treeBtn:
                _type = TYPE_TREE;
                break;
            case _decorBtn:
                _type = TYPE_DECOR;
                break;
            case _leftArrow:
                scroleType(-500);
                break;
            case _rightArrow:
                scroleType(500);
                break;
        }
        checkType();
    }

    private function fillHouses():void{
        var obj:Object = g.dataBuilding.objectBuilding;
        var item:MapEditorInterfaceItem;
        var i:int = 0;

        for(var id:String in obj) {
            if (obj[id].buildType == BuildType.FABRICA || obj[id].buildType == BuildType.TEST || obj[id].buildType == BuildType.FARM
                    || obj[id].buildType == BuildType.RIDGE || obj[id].buildType == BuildType.AMBAR || obj[id].buildType == BuildType.SKLAD
                    || obj[id].buildType == BuildType.ORDER || obj[id].buildType == BuildType.MARKET || obj[id].buildType == BuildType.CAVE) {
                    || obj[id].buildType == BuildType.ORDER || obj[id].buildType == BuildType.MARKET || obj[id].buildType == BuildType.DAILY_BONUS) {
                item = new MapEditorInterfaceItem(obj[id], TYPE_BUILDING);
                item.source.y = 20;
                item.source.x = i * 80;
                _contBuildings.addChild(item.source);
                i++;
            }
        }
    }

    private function fillTrees():void {
        var obj:Object = g.dataBuilding.objectBuilding;
        var item:MapEditorInterfaceItem;
        var i:int = 0;

        for (var id:String in obj) {
            if (obj[id].buildType == BuildType.TREE || obj[id].buildType == BuildType.WILD) {
                item = new MapEditorInterfaceItem(obj[id], TYPE_TREE);
                item.source.y = 20;
                item.source.x = i * 80;
                _contTrees.addChild(item.source);
                i++;
            }
        }
    }

    private function fillDecors():void {
        var obj:Object = g.dataBuilding.objectBuilding;
        var item:MapEditorInterfaceItem;
        var i:int = 0;

        for (var id:String in obj) {
            if (obj[id].buildType == BuildType.DECOR || obj[id].buildType == BuildType.DECOR_FULL_FENСE
                    || obj[id].buildType == BuildType.DECOR_POST_FENCE) {
                item = new MapEditorInterfaceItem(obj[id], TYPE_DECOR);
                item.source.y = 20;
                item.source.x = i * 80;
                _contDecors.addChild(item.source);
                i++;
            }
        }
    }

    private function scroleType(delta:int):void{
        var cont:Sprite;
        var endX:int;

        switch (_type){
            case TYPE_BUILDING:
                cont = _contBuildings;
                    endX = -_contBuildings.width + g.stageWidth;
                break;
            case TYPE_TREE:
                cont = _contTrees;
                endX = -_contTrees.width + g.stageWidth;
                break;
            case TYPE_DECOR:
                cont = _contDecors;
                endX = -_contDecors.width + g.stageWidth;
                break;
        }
        var newX:int = cont.x + delta;
        if(newX > 0) newX = 0;
        if(newX < endX) newX = endX - 20;

        var tween:Tween = new Tween(cont, 1);
        tween.moveTo(newX, cont.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);
    }

    private function setEditorButtons():void{
        _moveBtn = new EditorButtonInterface();
        _moveBtn.setIconButton("Move");
        _moveBtn.source.x = 700;
        _allTable.addChild(_moveBtn.source);

        _rotateBtn = new EditorButtonInterface();
        _rotateBtn.setIconButton("Rotate");
        _rotateBtn.source.x = 740;
        _allTable.addChild(_rotateBtn.source);

        _cancelBtn = new EditorButtonInterface();
        _cancelBtn.setIconButton("Cancel");
        _cancelBtn.source.x = 780;
        _allTable.addChild(_cancelBtn.source);

        _activeBtn = new EditorButtonInterface();
        _activeBtn.setIconButton("Active");
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
}
}
