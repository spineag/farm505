package map {

import build.AreaObject;
import build.WorldObject;
import build.ambar.Ambar;
import build.ambar.Sklad;
import build.cave.Cave;
import build.dailyBonus.DailyBonus;
import build.decor.Decor;
import build.decor.DecorFence;
import build.decor.DecorPostFence;
import build.fabrica.Fabrica;
import build.farm.Farm;
import build.market.Market;
import build.orders.Order;
import build.paper.Paper;
import build.ridge.Ridge;
import build.shop.Shop;
import build.testBuild.TestBuild;
import build.train.Train;
import build.tree.Tree;
import build.wild.Wild;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import flash.geom.Rectangle;

import heroes.BasicCat;

import manager.Vars;

import mouse.ToolsModifier;

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

    public function getCityObjectsByType(buildType:int):Array {
        var ar:Array = [];
        for (var i:int=0; i<_cityObjects.length; i++) {
            if (_cityObjects[i].dataBuild.buildType == buildType)
                ar.push(_cityObjects[i]);
        }
        return ar;
    }

    public function getCityObjectsById(id:int):Array {
        var ar:Array = [];
        for (var i:int=0; i<_cityObjects.length; i++) {
            if (_cityObjects[i].dataBuild.id == id)
                ar.push(_cityObjects[i]);
        }
        return ar;
    }

    private function zSort():void{
        _cityObjects.sortOn("depth", Array.NUMERIC);
        for (var  i:int = 0; i < _cityObjects.length; i++) {
            _cont.setChildIndex(_cityObjects[i].source, i);
        }
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
                    _townMatrix[i][j].buildFence = null;
                    _townMatrix[i][j].isFull = false;
                    _townMatrix[i][j].inGame = true;
                    _townMatrix[i][j].isBlocked = false;
                    _townMatrix[i][j].isFence = false;
                    _townMatrix[i][j].isWall = false;
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
                if (i != posY && i != posY + sizeY - 1 && j != posX && j != posX + sizeX -1)
                    _townMatrix[i][j].isWall = true;
            }
        }
    }

    public function unFillMatrix(posX:int, posY:int, sizeX:int, sizeY:int):void {
        for (var i:int = posY; i < (posY + sizeY); i++) {
            for (var j:int = posX; j < (posX + sizeX); j++) {
                _townMatrix[i][j].build = null;
                _townMatrix[i][j].isFull = false;
                _townMatrix[i][j].isWall = false;
            }
        }
    }

    public function fillMatrixWithFence(posX:int, posY:int, sizeX:int, sizeY:int, source:*):void {
        for (var i:int = posY; i < (posY + sizeY); i++) {
            for (var j:int = posX; j < (posX + sizeX); j++) {
                _townMatrix[i][j].buildFence = source;
                _townMatrix[i][j].isFence = true;
            }
        }
    }

    public function unFillMatrixWithFence(posX:int, posY:int, sizeX:int, sizeY:int):void {
        for (var i:int = posY; i < (posY + sizeY); i++) {
            for (var j:int = posX; j < (posX + sizeX); j++) {
                _townMatrix[i][j].buildFence = null;
                _townMatrix[i][j].isFence = false;
            }
        }
    }

    public function addHero(h:BasicCat):void {
        _cityObjects.push(h);
        var p:Point = g.matrixGrid.getXYFromIndex(new Point(h.posX, h.posY));
        h.source.x = int(p.x);
        h.source.y = int(p.y);
        h.updateDepth();
        _cont.addChild(h.source);
        zSort();
    }

    public function createNewBuild(_data:Object, _x:Number, _y:Number, isFromServer:Boolean = false, dbId:int = 0):void {
        var build:WorldObject;
        var isFlip:Boolean = false;
        var ob:Object = {};

        if (!isFromServer && _data.buildType == BuildType.FABRICA) {    // что означает, что через магазин купили и поставили новое здание
            if (g.useDataFromServer) {
                ob.dbId = -1;
                ob.timeBuildBuilding = 0;
                ob.isOpen = 0;
                g.user.userBuildingData[_data.id] = ob;
            } else {
                ob.dbId = int(Math.random() * 1000);
                ob.dateStartBuild = new Date().getTime();
                ob.isOpen = 0;
                g.user.userBuildingData[_data.id] = ob;
            }
        }

        if (_data.isFlip) isFlip = true;
        switch (_data.buildType) {
            case BuildType.TEST:
                build = new TestBuild(_data);
                break;
            case BuildType.RIDGE:
                build = new Ridge(_data);
                break;
            case BuildType.DECOR_POST_FENCE:
                build = new DecorPostFence(_data);
                break;
            case BuildType.DECOR:
                build = new Decor(_data);
                break;
            case BuildType.FABRICA:
                build = new Fabrica(_data);
                break;
            case BuildType.TREE:
                build = new Tree(_data);
                if (!isFromServer) (build as Tree).releaseNewTree();
                break;
            case BuildType.WILD:
                build = new Wild(_data);
                break;
            case BuildType.AMBAR:
                build = new Ambar(_data);
                break;
            case BuildType.SKLAD:
                build = new Sklad(_data);
                break;
            case BuildType.FARM:
                build = new Farm(_data);
                break;
            case BuildType.ORDER:
                build = new Order(_data);
                break;
            case BuildType.MARKET:
                build = new Market(_data);
                break;
            case BuildType.CAVE:
                build = new Cave(_data);
                break;
            case BuildType.DAILY_BONUS:
                build = new DailyBonus(_data);
                break;
            case BuildType.PAPER:
                build = new Paper(_data);
                break;
            case BuildType.SHOP:
                build = new Shop(_data);
                break;
            case BuildType.TRAIN:
                build = new Train(_data);
                break;
        }

        if (!build) {
            Cc.error('TownArea:: BUILD is null');
            return;
        }
        (build as WorldObject).dbBuildingId = dbId;
        pasteBuild(build, _x, _y, !isFromServer);
        if (isFlip && !(build is DecorPostFence)) {
            (build as AreaObject).releaseFlip();
        }
    }

    public function pasteBuild(worldObject:WorldObject, _x:Number, _y:Number, isNewAtMap:Boolean = true, updateAfterMove:Boolean = false):void {
        if (!_cont.contains(worldObject.source)) {
            worldObject.source.x = int(_x);
            worldObject.source.y = int(_y);
            _cont.addChild(worldObject.source);
            var point:Point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
            worldObject.posX = point.x;
            worldObject.posY = point.y;
            _cityObjects.push(worldObject);
            worldObject.updateDepth();
            if (worldObject is DecorFence || worldObject is DecorPostFence) {
                fillMatrixWithFence(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY, worldObject);
                if (worldObject is DecorPostFence) addFenceLenta(worldObject as DecorPostFence);
            } else {
                fillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY, worldObject);
            }
            if (isNewAtMap) {
                if (worldObject is Fabrica || worldObject is Farm || worldObject is Ridge)
                    g.directServer.addUserBuilding(worldObject, onAddNewBuilding);
                if (worldObject is Farm || worldObject is Tree)
                    worldObject.addXP();
                if (worldObject is Tree)
                    g.directServer.addUserBuilding(worldObject, onAddNewTree);
            }

            if (updateAfterMove) {
                g.directServer.updateUserBuildPosition(worldObject.dbBuildingId, worldObject.posX, worldObject.posY, null);
            }
        }

        // временно полная сортировка, далее нужно будет дописать "умную"
        zSort();

            if (isNewAtMap && worldObject is Ridge || isNewAtMap && worldObject is Tree) {
                g.bottomPanel.cancelBoolean(true);
                var arr:Array;
                var curCount:int;
                var maxCount:int;
                var maxCountAtCurrentLevel:int = 0;
                arr = [];
                _dataObjects = worldObject.dataBuild;
                arr = g.townArea.getCityObjectsById(_dataObjects.id);
                curCount = arr.length;
                for (var i:int = 0; _dataObjects.blockByLevel.length; i++) {
                    if (_dataObjects.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                maxCount = maxCountAtCurrentLevel * _dataObjects.countUnblock;
                if (curCount == maxCount) {
                    g.bottomPanel.cancelBoolean(false);
                    return;
                }
                g.toolsModifier.startMove(_dataObjects, afterMoveReturn);
            }
    }

    private function onAddNewBuilding(value:Boolean, wObject:WorldObject):void {
        g.directServer.startBuildBuilding(wObject, null);
    }

    private function onAddNewTree(value:Boolean, wObject:WorldObject):void {
        g.directServer.addUserTree(wObject, null);
    }

    public function deleteBuild(worldObject:WorldObject):void{
        if(_cont.contains(worldObject.source)){
            _cont.removeChild(worldObject.source);
            if (worldObject is DecorFence || worldObject is DecorPostFence) {
                if (worldObject is DecorPostFence) removeFenceLenta(worldObject as DecorPostFence);
                unFillMatrixWithFence(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
            } else {
                unFillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
            }
            _cityObjects.splice(_cityObjects.indexOf(worldObject), 1);
        }

    }

    public function moveBuild(worldObject:WorldObject, treeState:int = 1):void{// не сохраняется флип при муве
        if(_cont.contains(worldObject.source)) {
            g.selectedBuild = worldObject;
            _cont.removeChild(worldObject.source);
            if (worldObject is DecorFence || worldObject is DecorPostFence) {
                if (worldObject is DecorPostFence) removeFenceLenta(worldObject as DecorPostFence);
                unFillMatrixWithFence(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
            } else {
                unFillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
            }
            g.toolsModifier.startMove((worldObject as AreaObject).dataBuild, afterMove, treeState);
        }
    }

    private function afterMove(_x:Number, _y:Number):void {
        pasteBuild(g.selectedBuild, _x, _y, false, true);
        g.selectedBuild = null;
    }

    private function addFenceLenta(d:DecorPostFence):void {
        // проверяем, есть ли по соседству еще столбы забора, если да - то проводим между ними ленту
        var obj:Object;

        obj = _townMatrix[d.posY][d.posX-1];
        if (obj && obj.inGame && obj.isFence && obj.buildFence && obj.buildFence is DecorPostFence)
            obj.buildFence.addRightLenta();

        obj = _townMatrix[d.posY-1][d.posX];
        if (obj && obj.inGame && obj.isFence && obj.buildFence && obj.buildFence is DecorPostFence)
            obj.buildFence.addLeftLenta();

        obj = _townMatrix[d.posY][d.posX+1];
        if (obj && obj.inGame && obj.isFence && obj.buildFence && obj.buildFence is DecorPostFence)
            d.addRightLenta();

        obj = _townMatrix[d.posY+1][d.posX];
        if (obj && obj.inGame && obj.isFence && obj.buildFence && obj.buildFence is DecorPostFence)
            d.addLeftLenta();
    }

    private function removeFenceLenta(d:DecorPostFence):void {
        // проверяем, есть ли по соседству еще столбы забора, если да - то забираем между ними ленту
        var obj:Object;

        obj = _townMatrix[d.posY][d.posX-1];
        if (obj && obj.inGame && obj.isFence && obj.buildFence && obj.buildFence is DecorPostFence)
            obj.buildFence.removeRightLenta();

        obj = _townMatrix[d.posY-1][d.posX];
        if (obj && obj.inGame && obj.isFence && obj.buildFence && obj.buildFence is DecorPostFence)
            obj.buildFence.removeLeftLenta();

        d.removeLeftLenta();
        d.removeRightLenta();
    }

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

    private function afterMoveReturn(_x:Number, _y:Number):void {
        if (!g.userInventory.checkMoney(_dataObjects)) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            g.bottomPanel.cancelBoolean(false);
            return;
        }
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            g.townArea.createNewBuild(_dataObjects, _x, _y);
            g.userInventory.addMoney(_dataObjects.currency, -_dataObjects.cost);
    }

}
}