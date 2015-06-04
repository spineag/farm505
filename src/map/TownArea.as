package map {

import build.AreaObject;
import build.WorldObject;
import build.ridge.Ridge;
import build.testBuild.TestBuild;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import flash.geom.Rectangle;

import manager.Vars;

import starling.display.Sprite;


public class TownArea extends Sprite {
    private var _cityObjects:Array;
    private var _dataPreloaders:Object;
    private var _dataObjects:Object;
    private var _enabled:Boolean = true;
    private var _cont:Sprite;
    private var _townMatrix:Array;

    protected var g:Vars = Vars.getInstance();

    public function TownArea() {
        _cityObjects = [];
        _townMatrix = [];
        _dataPreloaders = {};
        _dataObjects = {};
        _cont = g.cont.contentCont;

        setDefaultMatrix();

//        _finder = new V_Finder();
//        _hev = new V_HevristicToTarget();
    }

    public function get townMatrix():Array {
        return _townMatrix;
    }

    public function get cityObjects():Array {
        return _cityObjects;
    }

    private function zSort():void{


        _cityObjects.sortOn("depth", Array.NUMERIC);
        for (var  i:int = 0; i < _cityObjects.length; i++) {
            _cont.setChildIndex(_cityObjects[i].source, i);
        }

//            var sortArray:Array = new Array();
//            var objectsCount:int = c.numChildren;
//
//            for (var i:int = 0; i < objectsCount; i++){
//                var currentFace:DisplayObject = c.getChildAt(i);
//
//                var m:Matrix3D = currentFace.transform.matrix3D.clone();
//                m.append(c.transform.matrix3D);
//
//                sortArray[i] = { obj:currentFace, z:m.position.z };
//            }
//
//            sortArray.sortOn("z", Array.NUMERIC | Array.DESCENDING);
//
//            for (i = 0; i < objectsCount; i++){
//                c.setChildIndex(sortArray[i].obj, i);
//            }
//
//            sortArray = null;
//        }//sort

    }

    public function setDefaultMatrix():void {
        var arr:Array = g.matrixGrid.matrix;
        var ln:int = g.matrixGrid.matrixSize;

        for (var i:int = 0; i < ln; i++) {
            _townMatrix.push([]);
            for (var j:int = 0; j < ln; j++) {
                _townMatrix[i][j] = {};
                if (arr[i][j].inGame) {
                    _townMatrix[i][j].build = null;
                    _townMatrix[i][j].isFull = false;
                    _townMatrix[i][j].inGame = true;
                    _townMatrix[i][j].isBlocked = false;
                } else {
                    _townMatrix[i][j].inGame = false;
                }
            }
        }
    }

    public function fillMatrix(posX:int, posY:int, sizeX:int, sizeY:int, source:*):void {
//		if (source is WorldObject) g.matrixGrid.drawDebugPartGrid(posX, posY, sizeX, sizeY);

        for (var i:int = posY; i < (posY + sizeY); i++) {
            for (var j:int = posX; j < (posX + sizeX); j++) {
                _townMatrix[i][j].build = source;
                _townMatrix[i][j].isFull = true;
            }
        }
    }

    public function unFillMatrix(posX:int, posY:int, sizeX:int, sizeY:int):void {
        for (var i:int = posY; i < (posY + sizeY); i++) {
            for (var j:int = posX; j < (posX + sizeX); j++) {
                _townMatrix[i][j].build = null;
                _townMatrix[i][j].isFull = false;
            }
        }
    }

    public function createNewBuild(_data:Object, _x:Number, _y:Number):void {
        var build:WorldObject;
        var isFlip:Boolean = false;

        if (_data.isFlip) isFlip = true;
        switch (_data.buildType) {
            case BuildType.TEST:
                build = new TestBuild(_data);
                break;
            case BuildType.RIDGE:
                build = new Ridge(_data);
                break;
            //case и так далее проходимся по всем классам
        }

        if (!build) {
            Cc.error('TownArea:: BUILD is null');
            return;
        }
        pasteBuild(build, _x, _y);
        if (isFlip && _data.buildType == BuildType.TEST) {
            (build as TestBuild).releaseFlip();
        }
    }

    public function pasteBuild(wordObject:WorldObject, _x:Number, _y:Number):void {
        if (!_cont.contains(wordObject.source)) {
            wordObject.source.x = _x;
            wordObject.source.y = _y;
            _cont.addChild(wordObject.source);
            var point:Point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
            wordObject.posX = point.x;
            wordObject.posY = point.y;
            fillMatrix(wordObject.posX, wordObject.posY, wordObject.sizeX, wordObject.sizeY, wordObject);
            // нужно добавить сортировку по з-индексу
            _cityObjects.push(wordObject);
            wordObject.updateDepth();
        }
        zSort();
    }

    public function deleteBuild(wordObject:WorldObject):void{
        if(_cont.contains(wordObject.source)){
            _cont.removeChild(wordObject.source);
            unFillMatrix(wordObject.posX, wordObject.posY, wordObject.sizeX, wordObject.sizeY);
            _cityObjects.splice(_cityObjects.indexOf(wordObject),1);
        }

    }

    public function moveBuild(wordObject:WorldObject):void{// не сохраняется флип при муве
        if(_cont.contains(wordObject.source)) {
            g.selectedBuild = wordObject;
            deleteBuild(wordObject);
            g.toolsModifier.startMove((wordObject as AreaObject).dataBuild, afterMove);
        }
    }

    private function afterMove(_x:Number, _y:Number):void {
        createNewBuild((g.selectedBuild as AreaObject).dataBuild, _x, _y);
        g.selectedBuild = null;
    }
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
}
}