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
import build.decor.DecorTail;
import build.fabrica.Fabrica;
import build.farm.Farm;
import build.lockedLand.LockedLand;
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
import heroes.BasicCat;
import manager.Vars;
import mouse.ToolsModifier;
import starling.display.Sprite;


public class TownArea extends Sprite {
    private var _cityObjects:Array;
    private var _cityTailObjects:Array;
    private var _dataPreloaders:Object;
    private var _dataObjects:Object;
    private var _enabled:Boolean = true;
    private var _cont:Sprite;
    private var _contTail:Sprite;
    private var _townMatrix:Array;
    private var _townTailMatrix:Array;

    protected var g:Vars = Vars.getInstance();

    public function TownArea() {
        _cityObjects = [];
        _cityTailObjects = [];
        _townMatrix = [];
        _townTailMatrix = [];
        _dataPreloaders = {};
        _dataObjects = {};
        _cont = g.cont.contentCont;
        _contTail = g.cont.tailCont;

        setDefaultMatrix();
    }

    public function get townMatrix():Array {
        return _townMatrix;
    }

    public function get townTailMatrix():Array {
        return _townTailMatrix;
    }

    public function get cityObjects():Array {
        return _cityObjects;
    }

    public function get cityTailObjects():Array {
        return _cityTailObjects;
    }

    public function getCityObjectsByType(buildType:int):Array {
        var ar:Array = [];
        try {
            for (var i:int = 0; i < _cityObjects.length; i++) {
                if (_cityObjects[i] is BasicCat) continue;
                if (_cityObjects[i].dataBuild.buildType == buildType)
                    ar.push(_cityObjects[i]);
            }
        } catch (e:Error) {
            Cc.error('TownArea getCityObjectsByType:: error id: ' + e.errorID + ' - ' + e.message + '    for type: ' + buildType);
            g.woGameError.showIt();
        }
        return ar;
    }

    public function getCityObjectsById(id:int):Array {
        var ar:Array = [];
        try {
            for (var i:int = 0; i < _cityObjects.length; i++) {
                if (_cityObjects[i] is BasicCat) continue;
                if (_cityObjects[i].dataBuild.id == id)
                    ar.push(_cityObjects[i]);
            }
        } catch (e:Error) {
            Cc.error('TownArea getCityObjectsById:: error id: ' + e.errorID + ' - ' + e.message + '    for id: ' + id);
            g.woGameError.showIt();
        }
        return ar;
    }

    public function getCityTailObjectsById(id:int):Array {
        var ar:Array = [];
        try {
            for (var i:int = 0; i < _cityTailObjects.length; i++) {
                if (_cityTailObjects[i].dataBuild.id == id)
                    ar.push(_cityTailObjects[i]);
            }
        } catch (e:Error) {
            Cc.error('TownArea getCityTailObjectsById:: error id: ' + e.errorID + ' - ' + e.message + '    for id: ' + id);
            g.woGameError.showIt();
        }
        return ar;
    }

    public function zSort():void{
        try {
            _cityObjects.sortOn("depth", Array.NUMERIC);
            for (var i:int = 0; i < _cityObjects.length; i++) {
                _cont.setChildIndex(_cityObjects[i].source, i);
            }
        } catch(e:Error) {
            g.woGameError.showIt();
            Cc.error('TownArea zSort error: ' + e.errorID + ' - ' + e.message);
        }
    }

    public function setDefaultMatrix():void {
        var arr:Array = g.matrixGrid.matrix;
        var ln:int = g.matrixGrid.matrixSize;

        for (var i:int = 0; i < ln; i++) {
            _townMatrix.push([]);
            _townTailMatrix.push([]);
            for (var j:int = 0; j < ln; j++) {
                _townMatrix[i][j] = {};
                _townTailMatrix[i][j] = {build: null};
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
                if (sizeX > 1 && sizeY > 1) {
                    if (i != posY && i != posY + sizeY && j != posX && j != posX + sizeX)
                        _townMatrix[i][j].isWall = true;
                }
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

    public function fillTailMatrix(posX:int, posY:int, source:DecorTail):void {
         _townTailMatrix[posY][posX].build = source;
    }

    public function unFillTailMatrix(posX:int, posY:int):void {
        _townTailMatrix[posY][posX].build = null;
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

    public function addHero(c:BasicCat):void {
        _cityObjects.push(c);
        var p:Point = g.matrixGrid.getXYFromIndex(new Point(c.posX, c.posY));
        c.source.x = int(p.x);
        c.source.y = int(p.y);
        c.updateDepth();
        _cont.addChild(c.source);
        zSort();
    }

    public function createNewBuild(_data:Object, _x:Number, _y:Number, isFromServer:Boolean = false, dbId:int = 0):void {
        var build:WorldObject;
        var isFlip:Boolean = false;
        var ob:Object = {};

        if (!_data) {
            Cc.error('TownArea createNewBuild:: _data == nul for building');
            g.woGameError.showIt();
            return;
        }

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
            case BuildType.LOCKED_LAND:
                build = new LockedLand(_data);
                break;
            case BuildType.DECOR_TAIL:
                build = new DecorTail(_data);
                break;
        }

        if (!build) {
            Cc.error('TownArea:: BUILD is null for type: ' + _data.buildType);
            g.woGameError.showIt();
            return;
        }
        g.selectedBuild = build;
        (build as WorldObject).dbBuildingId = dbId;
        if (_data.buildType == BuildType.DECOR_TAIL) {
            pasteTailBuild(build as DecorTail, _x, _y, !isFromServer);
        } else {
            pasteBuild(build, _x, _y, !isFromServer);
        }
        if (isFlip && !(build is DecorPostFence)) {
            (build as AreaObject).releaseFlip();
        }
    }

    public function pasteBuild(worldObject:WorldObject, _x:Number, _y:Number, isNewAtMap:Boolean = true, updateAfterMove:Boolean = false):void {
        if (!worldObject) {
            Cc.error('TownArea pasteBuild:: empty worldObject');
            g.woGameError.showIt();
            return;
        }
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
                if (worldObject is Fabrica || worldObject is Farm || worldObject is Ridge || worldObject is Decor || worldObject is DecorFence || worldObject is DecorPostFence || worldObject is DecorTail)
                    g.directServer.addUserBuilding(worldObject, onAddNewBuilding);
                if (worldObject is Farm || worldObject is Tree || worldObject is Decor || worldObject is DecorFence || worldObject is DecorPostFence || worldObject is DecorTail)
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

    public function pasteTailBuild(tail:DecorTail, _x:Number, _y:Number, isNewAtMap:Boolean = true, updateAfterMove:Boolean = false):void {
        if (!tail) {
            Cc.error('TownArea pasteTailBuild:: empty tail');
            g.woGameError.showIt();
            return;
        }
        if (!_contTail.contains(tail.source)) {
            tail.source.x = int(_x);
            tail.source.y = int(_y);
            _contTail.addChild(tail.source);
            var point:Point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
            tail.posX = point.x;
            tail.posY = point.y;
            _cityTailObjects.push(tail);
            fillTailMatrix(tail.posX, tail.posY, tail);
            if (isNewAtMap) {
                g.directServer.addUserBuilding(tail as WorldObject, onAddNewBuilding);
                tail.addXP();
            }

            if (updateAfterMove) {
                g.directServer.updateUserBuildPosition(tail.dbBuildingId, tail.posX, tail.posY, null);
            }
        }
    }

    private function onAddNewBuilding(value:Boolean, wObject:WorldObject):void {
        g.directServer.startBuildBuilding(wObject, null);
    }

    private function onAddNewTree(value:Boolean, wObject:WorldObject):void {
        g.directServer.addUserTree(wObject, null);
    }

    public function deleteBuild(worldObject:WorldObject):void{
        if (!worldObject) {
            Cc.error('TownArea deleteBuild:: empty worldObject');
            g.woGameError.showIt();
            return;
        }
        worldObject.clearIt();
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

    public function deleteTailBuild(tail:DecorTail):void{
        if (!tail) {
            Cc.error('TownArea deleteTailBuild:: empty tail');
            g.woGameError.showIt();
            return;
        }
        tail.clearIt();
        if(_contTail.contains(tail.source)){
            _contTail.removeChild(tail.source);
            unFillTailMatrix(tail.posX, tail.posY);
            _cityTailObjects.splice(_cityTailObjects.indexOf(tail), 1);
        }

    }

    public function moveBuild(worldObject:WorldObject, treeState:int = 1):void{// не сохраняется флип при муве
        if (!worldObject) {
            Cc.error('TownArea moveBuild:: empty worldObject');
            g.woGameError.showIt();
            return;
        }
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

    public function moveTailBuild(tail:DecorTail):void{// не сохраняется флип при муве
        if (!tail) {
            Cc.error('TownArea moveTailBuild:: empty tail');
            g.woGameError.showIt();
            return;
        }
        if(_contTail.contains(tail.source)) {
            g.selectedBuild = tail;
            _contTail.removeChild(tail.source);
            unFillTailMatrix(tail.posX, tail.posY);
            g.toolsModifier.startMoveTail((tail as AreaObject).dataBuild, afterMoveTail);
        }
    }

    private function afterMoveTail(_x:Number, _y:Number):void {
        pasteTailBuild(g.selectedBuild as DecorTail, _x, _y, false, true);
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

    private function removeAllBuildingsFromTown():void {

    }

}
}