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

import resourceItem.ResourceItem;

import starling.display.Sprite;

import user.Someone;


public class TownArea extends Sprite {
    private var _cityObjects:Array;
    private var _cityTailObjects:Array;
    private var _cityAwayObjects:Array;
    private var _cityAwayTailObjects:Array;
    private var _dataPreloaders:Object;
    private var _dataObjects:Object;
    private var _cont:Sprite;
    private var _contTail:Sprite;
    private var _townMatrix:Array;
    private var _townTailMatrix:Array;

    protected var g:Vars = Vars.getInstance();

    public function TownArea() {
        _cityObjects = [];
        _cityAwayObjects = [];
        _cityTailObjects = [];
        _cityAwayTailObjects = [];
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

    public function getCityTreeById(id:int):Array {
        var ar:Array = [];
        try {
            for (var i:int = 0; i < _cityObjects.length; i++) {
                if (_cityObjects[i] is BasicCat) continue;
                if (_cityObjects[i].dataBuild.id == id && _cityObjects[i].stateTree != Tree.FULL_DEAD)
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
                if (_cont.contains(_cityObjects[i].source)) {
                    _cont.setChildIndex(_cityObjects[i].source, i);
                }
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
                if (_townMatrix[i][j].build && _townMatrix[i][j].build is LockedLand && source is Wild) {
                    continue;
                }
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

    public function fillTailMatrix(posX:int, posY:int, source:WorldObject):void {
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
        addHeroSourceOnMap(c);
    }

    public function addHeroSourceOnMap(c:BasicCat):void {
        var p:Point = g.matrixGrid.getXYFromIndex(new Point(c.posX, c.posY));
        c.source.x = int(p.x);
        c.source.y = int(p.y);
//        c.updateDepth();
        if (!_cont.contains(c.source))
            _cont.addChild(c.source);
        zSort();
    }

    public function removeHero(c:BasicCat):void {
        if (_cityObjects.indexOf(c) > -1) _cityObjects.slice(_cityObjects.indexOf(c), 1);
        removeHeroSourceFromMap(c);
    }

    public function removeHeroSourceFromMap(c:BasicCat):void {
        if (_cont.contains(c.source))
            _cont.removeChild(c.source);
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
            if (!isFromServer) g.directServer.userBuildingFlip(dbId, int(isFlip), null);
        }
    }

    public function pasteBuild(worldObject:WorldObject, _x:Number, _y:Number, isNewAtMap:Boolean = true, updateAfterMove:Boolean = false):void {
        if (!worldObject) {
            Cc.error('TownArea pasteBuild:: empty worldObject');
            g.woGameError.showIt();
            return;
        }

        if (_cont.contains(worldObject.source)) {
            _cont.removeChild(worldObject.source);
        }
        worldObject.source.x = int(_x);
        worldObject.source.y = int(_y);
        _cont.addChild(worldObject.source);
        if (worldObject.useIsometricOnly) {
            var point:Point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
            worldObject.posX = point.x;
            worldObject.posY = point.y;
        } else {
            worldObject.posX = _x;
            worldObject.posY = _y;
        }
        if (!updateAfterMove) _cityObjects.push(worldObject);
        worldObject.updateDepth();
        if (worldObject is DecorFence || worldObject is DecorPostFence) {
            fillMatrixWithFence(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY, worldObject);
            if (worldObject is DecorPostFence) addFenceLenta(worldObject as DecorPostFence);
        } else {
            if (worldObject.useIsometricOnly) {
                fillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY, worldObject);
            }
            if (worldObject is Order || worldObject is Wild) {
                for (var i:int = worldObject.posY; i < (worldObject.posY + worldObject.sizeY); i++) {
                    for (var j:int = worldObject.posX; j < (worldObject.posX + worldObject.sizeX); j++) {
                        fillTailMatrix(j, i, worldObject);
                    }
                }
            }
        }
        if (isNewAtMap) {
            if (worldObject is Fabrica || worldObject is Farm || worldObject is Ridge || worldObject is Decor || worldObject is DecorFence || worldObject is DecorPostFence || worldObject is DecorTail)
                g.directServer.addUserBuilding(worldObject, onAddNewBuilding);
            if (worldObject is Farm || worldObject is Tree || worldObject is Decor || worldObject is DecorFence || worldObject is DecorPostFence || worldObject is DecorTail)
                worldObject.addXP();
            if (worldObject is Tree)
                g.directServer.addUserBuilding(worldObject, onAddNewTree);
            if (worldObject is Wild && g.isActiveMapEditor)
                g.directServer.ME_addWild(worldObject.posX, worldObject.posY, worldObject, null);
        }

        if (worldObject is Wild) {
            if (_townMatrix[worldObject.posY][worldObject.posX].build && _townMatrix[worldObject.posY][worldObject.posX].build is LockedLand) {
                (_townMatrix[worldObject.posY][worldObject.posX].build as LockedLand).addWild(worldObject as Wild);
                (worldObject as Wild).setLockedLand(_townMatrix[worldObject.posY][worldObject.posX].build as LockedLand);
            }
        }

        if (updateAfterMove) {
            if (g.isActiveMapEditor) {
                if (worldObject is Wild) {
                    g.directServer.ME_moveWild(worldObject.posX, worldObject.posY, worldObject.dbBuildingId, null);
                } else if (worldObject is Ambar || worldObject is Sklad || worldObject is Order || worldObject is Shop || worldObject is Market ||
                    worldObject is Cave || worldObject is Paper || worldObject is Train || worldObject is DailyBonus) {
                        g.directServer.ME_moveMapBuilding(worldObject.dataBuild.id, worldObject.posX, worldObject.posY, null);
                }
            } else {
                g.directServer.updateUserBuildPosition(worldObject.dbBuildingId, worldObject.posX, worldObject.posY, null);
            }
        }

        // временно полная сортировка, далее нужно будет дописать "умную"
        zSort();

        if (isNewAtMap && (worldObject is Ridge || worldObject is Tree)) {
//            g.bottomPanel.cancelBoolean(true);
            var arr:Array;
            var curCount:int;
            var maxCount:int;
            var maxCountAtCurrentLevel:int = 0;
            _dataObjects = worldObject.dataBuild;
            arr = g.townArea.getCityObjectsById(_dataObjects.id);
            curCount = arr.length;
            for (i = 0; _dataObjects.blockByLevel.length; i++) {
                if (_dataObjects.blockByLevel[i] <= g.user.level) {
                    maxCountAtCurrentLevel++;
                } else break;
            }
            maxCount = maxCountAtCurrentLevel * _dataObjects.countUnblock;
            if (curCount == maxCount) {
//                g.bottomPanel.cancelBoolean(false);
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
            fillTailMatrix(tail.posX, tail.posY, tail as WorldObject);
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
        if(_cont.contains(worldObject.source)){
            _cont.removeChild(worldObject.source);
        }
        if (worldObject is DecorFence || worldObject is DecorPostFence) {
            if (worldObject is DecorPostFence) removeFenceLenta(worldObject as DecorPostFence);
            unFillMatrixWithFence(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
        } else {
            unFillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
        }
        if (_cityObjects.indexOf(worldObject) > -1) _cityObjects.splice(_cityObjects.indexOf(worldObject), 1);
        (worldObject as AreaObject).clearIt();
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

    public function moveBuild(worldObject:WorldObject, treeState:int = 1,ridgeState:int = 1):void{
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
                if (g.selectedBuild.useIsometricOnly) {
                    unFillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
                }
            }
            g.toolsModifier.startMove((worldObject as AreaObject).dataBuild, afterMove, treeState,ridgeState);
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
        if (g.user.softCurrencyCount < _dataObjects.cost) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
//            g.bottomPanel.cancelBoolean(false);
            return;
        }
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            g.townArea.createNewBuild(_dataObjects, _x, _y);
            g.userInventory.addMoney(_dataObjects.currency, -_dataObjects.cost);
    }

    private function removeAllBuildingsFromTown():void {
        while (_cont.numChildren) _cont.removeChildAt(0);
        while (_contTail.numChildren) _contTail.removeChildAt(0);
        for (var i:int=0; i<_cityObjects.length; i++) {
            _cityObjects.clearIt();
        }
        for (i=0; i<_cityTailObjects.length; i++) {
            _cityTailObjects.clearIt();
        }
        _cityObjects.length = 0;
        _cityTailObjects.length = 0;
    }

    public function goAway(person:Someone):void {
        g.visitedUser = person;
        if (person.userDataCity.objects) {
            setAwayCity(person);
        } else {
            g.directServer.getAllCityData(person, setAwayCity);
        }
    }

    private function setAwayCity(p:Someone):void {
        for (var i:int = 0; i < _cityObjects.length; i++) {
            _cont.removeChild(_cityObjects[i].source);
        }
        for (i = 0; i < _cityTailObjects.length; i++) {
            _contTail.removeChild(_cityTailObjects[i].source);
        }
        if (g.isAway) {
            clearAwayCity();
        }
        g.isAway = true;
        g.bottomPanel.doorBoolean(true);
        for (i=0; i<p.userDataCity.objects.length; i++) {
            createAwayNewBuild(g.dataBuilding.objectBuilding[p.userDataCity.objects[i].buildId], p.userDataCity.objects[i].posX, p.userDataCity.objects[i].posY, p.userDataCity.objects[i].dbId, p.userDataCity.objects[i].isFlip);
        }
        for (i=0; i<p.userDataCity.treesInfo.length; i++) {
            fillAwayTree(p.userDataCity.treesInfo[i]);
        }
        for (i=0; i<p.userDataCity.plants.length; i++) {
            fillAwayPlant(p.userDataCity.plants[i]);
        }
        for (i=0; i<p.userDataCity.animalsInfo.length; i++) {
            fillAwayAnimal(p.userDataCity.animalsInfo[i]);
        }
        for (i=0; i<p.userDataCity.recipes.length; i++) {
            fillAwayRecipe(p.userDataCity.recipes[i]);
        }
        zAwaySort();
    }

    public function createAwayNewBuild(_data:Object, posX:int, posY:int, dbId:int, flip:int = 0):void {
        var build:WorldObject;
        var isFlip:Boolean;

        if (!_data) {
            Cc.error('TownArea createAwayNewBuild:: _data == nul for building');
            g.woGameError.showIt();
            return;
        }

        isFlip = Boolean(flip);
        switch (_data.buildType) {
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
        (build as WorldObject).dbBuildingId = dbId;
        if (_data.buildType == BuildType.DECOR_TAIL) {
            pasteAwayTailBuild(build as DecorTail, posX, posY);
        } else {
            pasteAwayBuild(build, posX, posY);
        }

        if (isFlip && !(build is DecorPostFence)) {
            (build as AreaObject).releaseFlip();
        }
    }

    public function pasteAwayBuild(worldObject:WorldObject, posX:Number, posY:Number):void {
        if (!worldObject) {
            Cc.error('TownArea pasteAwayBuild:: empty worldObject');
            g.woGameError.showIt();
            return;
        }

        worldObject.posX = posX;
        worldObject.posY = posY;

        if (worldObject.useIsometricOnly) {
            var point:Point = g.matrixGrid.getXYFromIndex(new Point(posX, posY));
            worldObject.source.x = int(point.x);
            worldObject.source.y = int(point.y);
        } else {
            worldObject.source.x = posX;
            worldObject.source.y = posY;
        }

        if (!_cont.contains(worldObject.source)) {
            _cont.addChild(worldObject.source);
        }
        _cityAwayObjects.push(worldObject);
        worldObject.updateDepth();
    }

    public function pasteAwayTailBuild(tail:DecorTail, posX:Number, posY:Number):void {
        if (!tail) {
            Cc.error('TownArea pasteAWayTailBuild:: empty tail');
            g.woGameError.showIt();
            return;
        }
        if (!_contTail.contains(tail.source)) {
            tail.posX = posX;
            tail.posY = posY;
            var point:Point = g.matrixGrid.getXYFromIndex(new Point(posX, posY));
            tail.source.x = int(point.x);
            tail.source.y = int(point.y);
            _cont.addChild(tail.source);

            _cityAwayTailObjects.push(tail);
//            tail.updateDepth();
        }
    }

    private function zAwaySort():void {
        try {
            _cityAwayObjects.sortOn("depth", Array.NUMERIC);
            for (var i:int = 0; i < _cityAwayObjects.length; i++) {
                _cont.setChildIndex(_cityAwayObjects[i].source, i);
            }
        } catch(e:Error) {
            g.woGameError.showIt();
            Cc.error('TownArea zAwaySort error: ' + e.errorID + ' - ' + e.message);
        }
    }

    public function backHome():void {
        clearAwayCity();
        g.isAway = false;
        g.visitedUser = null;
        g.bottomPanel.doorBoolean(false);
        for (var i:int = 0; i < _cityObjects.length; i++) {
            _cont.addChild(_cityObjects[i].source);
        }
        for (i = 0; i < _cityTailObjects.length; i++) {
            _contTail.addChild(_cityTailObjects[i].source);
        }
    }

    private function clearAwayCity():void {
        for (var i:int = 0; i < _cityAwayObjects.length; i++) {
            _cont.removeChild(_cityAwayObjects[i].source);
            (_cityAwayObjects[i] as AreaObject).clearIt();
        }
        for (i = 0; i < _cityAwayTailObjects.length; i++) {
            _contTail.removeChild(_cityAwayTailObjects[i].source);
            _cityAwayTailObjects[i].clearIt();
        }
        _cityAwayObjects = [];
        _cityAwayTailObjects = [];
    }

    private function fillAwayTree(ob:Object):void {
        var b:WorldObject = getAwayBuildingByDbId(ob.dbId);
        if (b && b is Tree) {
            (b as Tree).releaseTreeFromServer(ob);
        } else {
            Cc.error('TownArea fillAwayTree:: no such Tree with dbId: ' + ob.dbId);
        }
    }

    private function fillAwayPlant(ob:Object):void {
        var b:WorldObject = getAwayBuildingByDbId(ob.dbId);
        if (b && b is Ridge) {
            (b as Ridge).fillPlant(g.dataResource.objectResources[ob.plantId], true, ob.timeWork);
        } else {
            Cc.error('TownArea fillAwayRidge:: no such Ridge with dbId: ' + ob.dbId);
        }
    }

    private function fillAwayAnimal(ob:Object):void {
        var b:WorldObject = getAwayBuildingByDbId(ob.dbId);
        if (b && b is Farm) {
            (b as Farm).addAnimal(true, ob);
        } else {
            Cc.error('TownArea fillAwayAnimal:: no such Farm with dbId: ' + ob.dbId);
        }
    }

    private function fillAwayRecipe(ob:Object):void {
        var b:WorldObject = getAwayBuildingByDbId(ob.dbId);
        if (b && b is Fabrica) {
            var resItem:ResourceItem = new ResourceItem();
            resItem.fillIt(g.dataResource.objectResources[g.dataRecipe.objectRecipe[ob.recipeId].idResource]);
            if (int(ob.delay) > int(ob.timeWork)) {
                // do nothing because the recipe is waiting for start
            } else if (ob.delay + resItem.buildTime <= ob.timeWork) {
                (b as Fabrica).craftResource(resItem);
            } else {
                (b as Fabrica).awayImitationOfWork();
            }
        } else {
            Cc.error('TownArea fillAwayRecipe:: no such Fabrica with dbId: ' + ob.dbId);
        }
    }

    private function getAwayBuildingByDbId(dbId:int):WorldObject {
        for (var i:int=0; i<_cityAwayObjects.length; i++) {
            if (_cityAwayObjects[i].dbBuildingId == dbId)
            return _cityAwayObjects[i];
        }
        return null;
    }
}
}