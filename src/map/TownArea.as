﻿package map {

import com.junkbyte.console.Cc;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;

import manager.Vars;


public class TownArea extends Sprite {
    public static var idFind:int = 1;

    private var lastMouseX:Number = 0;
    private var lastMouseY:Number = 0;
    private var _needAllZsort:int = 0;

    private var _cityObjects:Array;
    private var _isDragged:Boolean = false;
    private var _dataPreloaders:Object;
    private var _dataObjects:Object;
    private var _enabled:Boolean = true;


//    private var _glowFilter:GlowFilter;
//    private var _contrastFilter:ColorMatrixFilter;
//    private var _brightnessFilter:ColorMatrixFilter;

    private var _rectanglesArray:Array = [];

    protected var g:Vars = Vars.getInstance();

    public function TownArea() {
        _cityObjects = [];
        _dataPreloaders = {};
        _dataObjects = {};
        //_glowFilter = new GlowFilter(0xFFFF00, 1, 8, 8, 5);
        //_contrastFilter = MatrixUtil.setContrast(30);
        //_brightnessFilter = MatrixUtil.setBrightness(20);

//        _finder = new V_Finder();
//        _hev = new V_HevristicToTarget();

//        addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
//        addEventListener(MouseEvent.MOUSE_UP, mouseUpStageHandler, true);
//        Main.stageS.addEventListener(MouseEvent.MOUSE_UP, mouseUpStageHandler, true);
//        Main.stageS.addEventListener(Event.MOUSE_LEAVE, mouseLeaveStageHandler);
//        Main.stageS.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownStageHandler, true);
    }


//    public function getIsNormTile(indexY:int, indexX:int):Boolean {
//        var contain:Boolean = false;
//        for (var i:int = indexY; i < (indexY + 1); i++) {
//            for (var j:int = indexX; j < (indexX + 1); j++) {
//                var point:Point = new Point(j, i);
//
//                point = getXYFromIndex(point);
//                for (var k:int = 0; k < _rectanglesArray.length; k++) {
//                    var rect:Rectangle = new Rectangle(_rectanglesArray[k].t_x, _rectanglesArray[k].t_y, _rectanglesArray[k].width, _rectanglesArray[k].height);
//                    if (rect.containsPoint(point)) {
//                        contain = true;
//                        return contain;
//                    }
//                }
//            }
//        }
//        return contain;
//    }


//    public function addMoveObject(source:WorldObject):void {
//        if (!contains(source.source)) {
//            addChild(source.source);
//        }
//    }
//
//    public function removeMoveObject(source:WorldObject):void {
//        if (contains(source.source)) {
//            removeChild(source.source);
//        }
//    }

//    public function addObject(source:WorldObject):void {
//        var key:String = '';
//        var currCont:DisplayObjectContainer = _containerElements;
//        var arr:Array = _cityObjects;
//
//        if (source is BuildingDecor) {
//            if ((source as BuildingDecor).decorType == 'track') {
//                currCont = _containerElementsBottom;
//                arr = _cityObjectsBottom;
//            }
//        } else if (source is BuildingWild) {
//            if ((source as BuildingWild).type == BuildingWild.TYPE_STATIC) {
//                currCont = _containerElementsBottom;
//                arr = _cityObjectsBottom;
//            }
//        } else if (source is BuildingArea) {
//            currCont = _containerElementsBottom;
//            arr = _cityObjectsBottom;
//        }
//
//        if (!currCont.contains(source.source)) {
//            currCont.addChild(source.source);
//            arr.push(source);
//            if (source is BuildingDecor) {
//                currCont.setChildIndex(source.source, 0);
//            }
//        }
//
//        if (source is AreaObject && !(source is BuildingTemple) && !(source is BuildingBridge) && !(source is BuildingFence)) {
//            key = String((source as AreaObject).userBuildingId);
//            if (source is BuildingPlant) {
//                key += '-0';
//            } else if (source is BuildingRidge) {
//                key += '-1';
//            } else {
//                key += '-2';
//            }
//            _dataObjects[key] = source;
//        }
//
//    }

//    public function removeObject(source:WorldObject):void {
//        var i:int = 0;
//        var key:String = '';
//
//        while (i < _cityObjects.length && _cityObjects[i] != source) {
//            i++;
//        }
//        if (source) {
//            if (source.source) {
//                if (source.source.parent) {
//                    source.source.parent.removeChild(source.source);
//                }
//            }
//        }
//
//        if (_cityObjects[i] == source) {
//            _cityObjects.splice(i, 1);
//            if (source is AreaObject && !(source is BuildingTemple) && !(source is BuildingBridge)) {
//                key = String((source as AreaObject).userBuildingId);
//                if (source is BuildingPlant) {
//                    key += '-0';
//                } else if (source is BuildingRidge) {
//                    key += '-1';
//                } else {
//                    key += '-2';
//                }
//                delete _dataObjects[key];
//            }
//        }
//    }


//    public function addPreloader(posX:int, posY:int, sizeX:int, sizeY:int, p:PreloaderBuilding, buildingType:uint = 0):void {
//        if (buildingType == BuildingType.BTI_DECOR) {
//            return;
//        }
//        var key:String = String(posX) + String(posY);
//        var pos:Point3D = new Point3D();
//        pos.x = posX * FACTOR + FACTOR * sizeX * 0.5;
//        pos.z = posY * FACTOR + FACTOR * sizeY * 0.5;
//        var isoPoint:Point = IsoUtils.isoToScreen(pos);
//        p.source.x = isoPoint.x - p.source.width / 2;
//        p.source.y = isoPoint.y - p.source.height / 2;
//
//        if (!_dataPreloaders[key]) {
//            _dataPreloaders[key] = [];
//        }
//
//        _dataPreloaders[key].push(p);
//        _containerElements.addChild(p.source);
//    }

    //FIXME нерациональная уборка прелоадера с объэкта
//    public function removePreloader(posX:int, posY:int, buildingType:uint = 0):void {
//        if (buildingType == BuildingType.BTI_DECOR) {
//            return;
//        }
//        var key:String = String(posX) + String(posY);
//        var p:PreloaderBuilding = _dataPreloaders[key].shift();
//
//        if (p) {
//            if (_containerElements.contains(p.source)) {
//                _containerElements.removeChild(p.source);
//            }
//            p.remove();
//        }
//    }

//    public function setObjectToTopLayer(object:DisplayObject):void {
//        if (object.parent && object.parent.contains(object)) {
//            object.parent.removeChild(object);
//        }
//        _containerElementsTop.addChild(object);
//    }
//
//    public function setObjectToNormalLayer(object:DisplayObject):void {
//        if (object.parent && object.parent.contains(object)) {
//            object.parent.removeChild(object);
//        }
//        _containerElements.addChild(object);
//    }

//    public function arrangeTop(object:DisplayObject, target:DisplayObject):void {
//        var index1:int = target.parent.getChildIndex(target);
//        var index2:int = target.parent.getChildIndex(object);
//
//        if (index2 < index1) {
//            target.parent.setChildIndex(object, index1);
//        }
//    }

//    public function updatePosition():void {
//        var normW:Number;
//        var normH:Number;
//
//        if (!fon) {
//            return;
//        }
//        normW = width / scaleX;
//        normH = height / scaleY;
//        layerTop.scaleX = scaleX;
//        layerTop.scaleY = scaleY;
//
//        x = Main.stageS.stageWidth / 2 - width / 2;
//        y = Main.stageS.stageHeight / 2 - height / 2;
//        if (Main.stageS.stageWidth >= width) {
//            _handler.areaRectMove.x = x;
//            _handler.areaRectMove.width = 0;
//            width = Math.min(normW, Main.stageS.stageWidth);
//            scaleY = scaleX;
//        } else {
//            _handler.areaRectMove.x = Main.stageS.stageWidth - width;
//            _handler.areaRectMove.width = width - Main.stageS.stageWidth;
//        }
//
//        if (Main.stageS.stageHeight >= height) {
//            _handler.areaRectMove.y = y;
//            _handler.areaRectMove.height = 0;
//            height = Math.min(normH, Main.stageS.stageHeight);
//            scaleX = scaleY;
//        } else {
//            _handler.areaRectMove.y = Main.stageS.stageHeight - height;
//            _handler.areaRectMove.height = height - Main.stageS.stageHeight;
//        }
//        layerTop.x = x;
//        layerTop.y = y;
//    }

//    public function fillMatrix(posX:int, posY:int, sizeX:int, sizeY:int, sourceId:int, source:AreaObject, pass:Boolean = true, id:int = 1):void {
//        var arr:Array;
////			drawGrid(posX, posY, sizeX, sizeY, 0xff00ff);
//        for (var i:int = posY + offsetY; i < (posY + offsetY + sizeY); i++) {
//            for (var j:int = posX; j < (posX + sizeX); j++) {
//                arr = matrix[i][j].sources;
//                matrix[i][j].id = sourceId;
//                if (source) {
//                    if (source is BuildingArea) {
//                        arr.push(source);
//                    } else {
//                        arr.unshift(source);
//                    }
//                }
//                if (pass) {
//                    if ((i == posY + offsetY) && (j == posX)) {
//                        matrix[i][j].findId = 0;
//                    } else {
//                        matrix[i][j].findId = id;
//                    }
//                } else {
//                    matrix[i][j].findId = id;
//                }
//            }
//        }
//    }

//    public function isPointFree(point:Point):Boolean {
//        var obj:Object = matrix[point.x][point.y + offsetY];
//        var answer:Boolean = !obj.id;
//        if (obj.sources[0] is BuildingZone) {
//            answer = true;
//        }
//        return answer;
//    }

//    public function unFillMatrix(posX:int, posY:int, sizeX:int, sizeY:int, source:AreaObject):void {
//        var arr:Array;
//        var obj:AreaObject;
//
//        for (var i:int = posY + offsetY; i < (posY + offsetY + sizeY); i++) {
//            for (var j:int = posX; j < (posX + sizeX); j++) {
//                matrix[i][j].id = 0;
//                matrix[i][j].findId = 0;
//                arr = matrix[i][j].sources;
//                for (var k:int = 0; k < arr.length; k++) {
//                    if (arr[k] == source) {
//                        arr.splice(k, 1);
//                        k--;
//                    }
//                }
//                if (arr[0]) {
//                    obj = arr[0];
//                    fillMatrix(obj.posX, obj.posY, obj.sizeX, obj.sizeY, obj.id, obj);
//                }
//            }
//        }
//    }

//    public function getElementMatrix(indexX:int, indexY:int):Object {
//        var tempObj:Object;
//
//        try {
//            tempObj= matrix[indexY + offsetY][indexX];
//        } catch (e:Error) {
//            return null;
//        }
//
//        return tempObj;
//    }

//    public function drawGrid(posX:int, posY:int, sizeX:int, sizeY:int, color:uint):void {
//        var i:int;
//        var point:Point;
//
//        _containerElementsTop.graphics.lineStyle(1, color);
//
//        for (i = posY; i <= (posY + sizeY); i++) {
//            point = getXYFromIndex(new Point(posX, i));
//            _containerElementsTop.graphics.moveTo(point.x, point.y);
//            point = getXYFromIndex(new Point(posX + sizeX, i));
//            _containerElementsTop.graphics.lineTo(point.x, point.y);
//        }
//        for (i = posX; i <= (posX + sizeX); i++) {
//            point = getXYFromIndex(new Point(i, posY));
//            _containerElementsTop.graphics.moveTo(point.x, point.y);
//            point = getXYFromIndex(new Point(i, posY + sizeY));
//            _containerElementsTop.graphics.lineTo(point.x, point.y);
//        }
//    }

//    public function clearGrid():void {
//        _containerElementsTop.graphics.clear();
//    }

//    public function allZsort(cityObject:WorldObject = null):void {
//        _needAllZsort++;
//    }

//    public function checkZsort():void {
//        if (_needAllZsort) {
//            allZsortFunction();
//            _needAllZsort = 0;
//        }
//    }

//    public function allZsortFunction(cityObject:WorldObject = null):void {
//        var buffer:WorldObject;
//        var i:int;
//        var index:int = 0;
//
//        for (i = 0; i < _cityObjects.length; i++) {
//            (_cityObjects[i] as WorldObject).updateDepth();
//        }
//        _cityObjects.sortOn('depth', Array.NUMERIC);
//
//        for (i = 0; i < _cityObjects.length; i++) {
//            buffer = _cityObjects[i];
//            index = i;
//            if (buffer is BuildingZone) {
//               index = _cityObjects.length - 1;
//            }
//            _containerElements.setChildIndex(buffer.source, index);
//        }
//    }

//    public function zSort(cityObject:WorldObject):void {
//        var i:int;
//        var maxMinIndex:int = 0;
//        var index:int;
//        var wo:WorldObject;
//        var isChanged:Boolean;
//        var woIndex:int;
//
//        if (!cityObject) {
//            return;
//        }
//        if (!_containerElements.contains(cityObject.source)) {
//            return;
//        }
//        index = _containerElements.getChildIndex(cityObject.source);
//        for (i = 0; i < _cityObjects.length; i++) {
//            wo = _cityObjects[i];
//
//            if (wo == cityObject || !wo.source) {
//                continue;
//            }
//            if (wo.source.hitTestObject(cityObject.source)) {
//                isChanged = false;
//                woIndex = _containerElements.getChildIndex(wo.source);
//
//                if (cityObject.posX > (wo.posX + wo.sizeX - 1) || cityObject.posY > (wo.posY + wo.sizeY - 1)) {
//                    isChanged = true;
//                } else {
//                    isChanged = (cityObject.posX > wo.posX) && (cityObject.posY > wo.posY);
//                }
//
//                if (isChanged) {
//                    if (woIndex > maxMinIndex) {
//                        maxMinIndex = woIndex;
//                    }
//                    if (index > maxMinIndex) {
//                        maxMinIndex++;
//                    }
//                }
//            }
//        }
//        _containerElements.setChildIndex(cityObject.source, maxMinIndex);
//    }

//    public function setBuildFromIndex(cityObject:WorldObject, point:Point):void {
//        var pos:Point3D = new Point3D();
//        pos.x = point.x * FACTOR;
//        pos.z = point.y * FACTOR;
//        var isoPoint:Point = IsoUtils.isoToScreen(pos);
//        cityObject.source.x = isoPoint.x;
//        cityObject.source.y = isoPoint.y;
//        cityObject.posX = point.x;
//        cityObject.posY = point.y;
//    }

//    public function getIndexFromXY(point:Point):Point {
//        var point3d:Point3D = IsoUtils.screenToIso(point);
//        var bufX:int = Math.round(point3d.x / FACTOR);
//        var bufY:int = Math.round(point3d.z / FACTOR);
//
//        return new Point(bufX, bufY);
//    }

//    public function getXYFromIndex(point:Point):Point {
//        var point3d:Point3D = new Point3D(point.x * FACTOR, 0, point.y * FACTOR);
//        point = IsoUtils.isoToScreen(point3d);
//
//        return point;
//    }

//    public function set blockObjects(value:Boolean):void {
//        _containerElements.mouseChildren = !value;
//        _containerElementsBottom.mouseChildren = !value;
//        _containerElementsTop.mouseChildren = !value;
//    }

//    public function get blockObjects():Boolean {
//        return !_containerElements.mouseEnabled;
//    }

//    public function get cityObjects():Array {
//        return _cityObjects;
//    }

//    public function removeAllElements():void {
//        removeObjectsArray(_cityObjects);
//        removeObjectsArray(_cityObjectsBottom);
//        removeZones();
//    }

//    public function getObjectFroUserId(userBuildingId:int, type:int):AreaObject {
//        var key:String = String(userBuildingId) + '-' + String(type);
//
//        return _dataObjects[key];
//    }

//    public function findPath(startPosX:int, startPosY:int, endPosX:int, endPosY:int, type:int = 0):Array {
//        var path:Array;
//        var isFindPath:Boolean;
//        var node1:V_GridNode = new V_GridNode();
//        var node2:V_GridNode = new V_GridNode();
//
//        node1.i = startPosY + offsetY;
//        node1.j = startPosX;
//        node2.i = endPosY + offsetY;
//        node2.j = endPosX;
//
//        _finder.refresh();
//        _finder.addHevristic(_hev);
//        _finder.setGraf(_graf);
//        if (type == 0) {
//            _graf.calbackCondition = condition1;
//        } else {
//            _graf.calbackCondition = condition2;
//        }
//        isFindPath = _finder.find(_graf.getNode(node2.i, node2.j, node2.i, node2.j), _graf.getNode(node1.i, node1.j, node1.i, node1.j));
//        if (isFindPath) {
//            path = _finder.getPath();
//            //clearGrid();
//            for (var i:int = 0; i < path.length; i++) {
//                var node:V_GridNode = path[i];
//                var point:Point = new Point(node.j, node.i - offsetY);
////					drawGrid(point.x, point.y, 1, 1, 0xff0000);
//                point = getXYFromIndex(point);
//                path[i] = point;
//            }
//        }
//
//        return path;
//    }


//    public function set enabled(value:Boolean):void {
//        _enabled = value;
//    }

//    public function getArrayFromClass(c:Class):Array {
//        var temp:Array = [];
//
//        for (var i:int = 0; i < _cityObjects.length; i++) {
//            if (_cityObjects[i] is c) {
//                temp.push(_cityObjects[i]);
//            }
//        }
//
//        return temp;
//    }

//    private function removeObjectsArray(arr:Array):void {
//        var temp:WorldObject;
//
//        while (arr.length > 0) {
//            temp = arr.pop();
//            if (temp) {
//                if (temp.source && temp.source.parent) {
//                    temp.source.parent.removeChild(temp.source);
//                }
//                temp.remove();
//            }
//        }
//    }

    public function getMainRectangle():Rectangle {
        var rectangle:Rectangle = new Rectangle(_rectanglesArray[0].t_x, _rectanglesArray[0].t_y, _rectanglesArray[0].width, _rectanglesArray[0].height);
        for (var i:int = 1; i < _rectanglesArray.length; i++) {
            var rect:Rectangle = new Rectangle(_rectanglesArray[i].t_x, _rectanglesArray[i].t_y, _rectanglesArray[i].width, _rectanglesArray[i].height);
            rectangle = rectangle.union(rect);
        }
        return rectangle;
    }
}
}