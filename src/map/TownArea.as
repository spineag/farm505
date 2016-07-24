package map {
import build.TownAreaBuildSprite;
import build.WorldObject;
import build.ambar.Ambar;
import build.ambar.Sklad;
import build.cave.Cave;
import build.chestBonus.Chest;
import build.dailyBonus.DailyBonus;
import build.decor.Decor;
import build.decor.DecorFence;
import build.decor.DecorPostFence;
import build.decor.DecorTail;
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.farm.Farm;
import build.lockedLand.LockedLand;
import build.market.Market;
import build.orders.Order;
import build.paper.Paper;
import build.ridge.Ridge;
import build.train.Train;
import build.tree.Tree;
import build.tutorialPlace.TutorialPlace;
import build.wild.Wild;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import heroes.BasicCat;
import heroes.OrderCat;

import hint.FlyMessage;

import manager.Vars;
import mouse.ToolsModifier;
import preloader.AwayPreloader;
import resourceItem.ResourceItem;
import resourceItem.UseMoneyMessage;

import starling.core.Starling;
import starling.display.Sprite;
import tutorial.TutorialAction;
import tutorial.managerCutScenes.ManagerCutScenes;
import ui.xpPanel.XPStar;

import user.NeighborBot;
import user.Someone;
import windows.WindowsManager;
import windows.shop.WOShop;

public class TownArea extends Sprite {
    private var _cityObjects:Array;
    private var _cityTailObjects:Array;
    private var _cityAwayObjects:Array;
    private var _cityAwayTailObjects:Array;
    private var _dataPreloaders:Object;
    private var _cont:Sprite;
    private var _contTail:Sprite;
    private var _townMatrix:Array;
    private var _townAwayMatrix:Array;
    private var _townTailMatrix:Array;
    private var _objBuildingsDiagonals:Object; // object of building diagonals for aStar
    private var _objAwayBuildingsDiagonals:Object; // object of away building diagonals for aStar
    private var _awayPreloader:AwayPreloader;
    private var _needTownAreaSort:Boolean = false;
    private var _zSortCounter:int;
    private var _freePlace:TownAreaFreePlace;
    private var SORT_COUNTER_MAX:int = 10;

    protected var g:Vars = Vars.getInstance();

    public function TownArea() {
        _cityObjects = [];
        _cityAwayObjects = [];
        _cityTailObjects = [];
        _cityAwayTailObjects = [];
        _townMatrix = [];
        _townTailMatrix = [];
        _dataPreloaders = {};
        _objBuildingsDiagonals = {};
        _objAwayBuildingsDiagonals = {};
        _cont = g.cont.contentCont;
        _contTail = g.cont.tailCont;
        _freePlace = new TownAreaFreePlace(g.matrixGrid.matrixSize);

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

    public function get townAwayMatrix():Array {
        return _townAwayMatrix;
    }

    public function get cityAwayObjects():Array {
        return _cityAwayObjects;
    }

    public function get diagonalsObject():Object {
        return _objBuildingsDiagonals;
    }

    public function get awayDiagonalsObject():Object {
        return _objAwayBuildingsDiagonals;
    }

    public function getCityObjectsByType(buildType:int):Array {
        var ar:Array = [];
        try {
            for (var i:int = 0; i < _cityObjects.length; i++) {
                if (_cityObjects[i] is BasicCat || _cityObjects[i] is OrderCat) continue;
                if (_cityObjects[i].dataBuild.buildType == buildType)
                    ar.push(_cityObjects[i]);
            }
        } catch (e:Error) {
            Cc.error('TownArea getCityObjectsByType:: error id: ' + e.errorID + ' - ' + e.message + '    for type: ' + buildType);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
        }
        return ar;
    }

    public function getCityObjectsById(id:int):Array {
        var ar:Array = [];
        try {
            for (var i:int = 0; i < _cityObjects.length; i++) {
                if (_cityObjects[i] is BasicCat || _cityObjects[i] is OrderCat) continue;
                if (_cityObjects[i].dataBuild.id == id)
                    ar.push(_cityObjects[i]);
            }
        } catch (e:Error) {
//            Cc.error('TownArea getCityObjectsById:: error id: ' + e.errorID + ' - ' + e.message + '    for id: ' + id);
            Cc.error('TownArea getCityObjectsById:: error _cityObjects: ' + _cityObjects.length );
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
        }
        return ar;
    }

    public function getCityTreeById(id:int, checkLastState:Boolean = false):Array {
        var ar:Array = [];
        try {
            for (var i:int = 0; i < _cityObjects.length; i++) {
                if (_cityObjects[i] is BasicCat || _cityObjects[i] is OrderCat) continue;
                if (_cityObjects[i] is Tree) {
                    if (checkLastState) {
                        if (_cityObjects[i].dataBuild.id == id && (_cityObjects[i] as Tree).stateTree != Tree.FULL_DEAD)
                            ar.push(_cityObjects[i])
                    } else {
                        if (_cityObjects[i].dataBuild.id == id)
                            ar.push(_cityObjects[i])
                    }
                }
            }
        } catch (e:Error) {
            Cc.error('TownArea getCityObjectsById:: error id: ' + e.errorID + ' - ' + e.message + '    for id: ' + id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
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
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
        }
        return ar;
    }

    public function addTownAreaSortCheking():void {
        _zSortCounter = SORT_COUNTER_MAX;
        g.gameDispatcher.addEnterFrame(zSortMain); }
    public function removeTownAreaSortCheking():void { g.gameDispatcher.removeEnterFrame(zSortMain); }

    public function zSort():void {
        _needTownAreaSort = true;
    }

    private function zSortMain():void{
        if (_needTownAreaSort) {
            _zSortCounter--;
            if (_zSortCounter > 0) return;
            try {
                _cityObjects.sortOn("depth", Array.NUMERIC);
                for (var i:int = 0; i < _cityObjects.length; i++) {
                    if (_cont.contains(_cityObjects[i].source)) {
                        _cont.setChildIndex(_cityObjects[i].source, i);
                    }
                }
            } catch (e:Error) {
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
                Cc.error('TownArea zSort error: ' + e.errorID + ' - ' + e.message);
            }
            _needTownAreaSort = false;
            if (g.managerTutorial.isTutorial) {
                _zSortCounter = 3;
            } else {
                _zSortCounter = SORT_COUNTER_MAX;
            }
        }
    }

    public function decorTailSort():void {
        try {
            _cityTailObjects.sortOn("depth", Array.NUMERIC);
            for (var i:int = 0; i < _cityTailObjects.length; i++) {
                if (_contTail.contains(_cityTailObjects[i].source)) {
                    _contTail.setChildIndex(_cityTailObjects[i].source, i);
                }
            }
        } catch(e:Error) {
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            Cc.error('TownArea zSort error: ' + e.errorID + ' - ' + e.message);
        }
    }

    public function sortAtLockedLands():void {
        for (var i:int = 0; i < _cityObjects.length; i++) {
            if (_cityObjects[i] is LockedLand) (_cityObjects[i] as LockedLand).sortWilds();
        }
    }

    public function setDefaultMatrix():void {
        var ln:int = g.matrixGrid.matrixSize;
        for (var i:int = 0; i < ln; i++) {
            _townMatrix.push([]);
            _townTailMatrix.push([]);
            for (var j:int = 0; j < ln; j++) {
                _townTailMatrix[i][j] = {build: null, inGame: true, inTile:false};
                _townMatrix[i][j] = {};
                _townMatrix[i][j].build = null;
                _townMatrix[i][j].buildFence = null;
                _townMatrix[i][j].isFull = false;
                _townMatrix[i][j].inGame = true;
                _townMatrix[i][j].isBlocked = false; // ? propably it's old not used properties
                _townMatrix[i][j].isWall = false;
                _townMatrix[i][j].isTutorialBuilding = false;
            }
        }
    }

    public function addDeactivatedArea(posX:int, posY:int, isDeactivated:Boolean):void {
        _townMatrix[posY][posX].inGame = !isDeactivated;
        _townTailMatrix[posY][posX].inGame = !isDeactivated;
    }

    public function fillMatrix(posX:int, posY:int, sizeX:int, sizeY:int, source:*):void {
//		if (source is WorldObject) g.matrixGrid.drawDebugPartGrid(posX, posY, sizeX, sizeY);

        if (source is TutorialPlace) return;
        var j:int;
        for (var i:int = posY; i < (posY + sizeY); i++) {
            for (j = posX; j < (posX + sizeX); j++) {
                if (_townMatrix[i][j].build && _townMatrix[i][j].build is LockedLand && source is Wild) {
                    continue;
                }
                    _freePlace.fillCell(j, i);
                    _townMatrix[i][j].isTutorialBuilding = false;
                    _townMatrix[i][j].build = source;
                    _townMatrix[i][j].isFull = true;
                    if (sizeX > 1 && sizeY > 1) {
                        if (i != posY && i != posY + sizeY && j != posX && j != posX + sizeX)
                            _townMatrix[i][j].isWall = true;
                    }
            }
        }

        if (sizeX > 1 && sizeY > 1) {  // write coordinates left->right && top->down
            _objBuildingsDiagonals[String(posX) + '-' + String(posY+1) + '-' + String(posX+1) + '-' + String(posY)] = true;
            _objBuildingsDiagonals[String(posX+sizeX-1) + '-' + String(posY) + '-' + String(posX+sizeX) + '-' + String(posY+1)] = true;
            _objBuildingsDiagonals[String(posX) + '-' + String(posY+sizeY-1) + '-' + String(posX+1) + '-' + String(posY+sizeY)] = true;
            _objBuildingsDiagonals[String(posX+sizeX-1) + '-' + String(posY+sizeY) + '-' + String(posX+sizeX) + '-' + String(posY+sizeY-1)] = true;
        }
    }
    private var i:int;
    private var j:int;
    private var obj:Object;
    public function checkFreeGrids(posX:int, posY:int, width:int, height:int):Boolean {
        for (i = posY; i < posY + height; i++) {
            for (j = posX; j < posX + width; j++) {
                if (i < 0 || j < 0 || i >= 80 || j > 80) return false;
                obj = _townMatrix[i][j];
                if (!obj){
                    Cc.error('TownArea checkFreeGrids:: obj == nul');
                    return false;
                }
                if (g.managerTutorial.isTutorial) {
                    if (!obj.isTutorialBuilding) {
                        return true;
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

    public function checkAwayFreeGrids(posX:int, posY:int, width:int, height:int):Boolean {
        for (i = posY; i < posY + height; i++) {
            for (j = posX; j < posX + width; j++) {
                if (i < 0 || j < 0 || i >= 80 || j > 80) return false;
                obj = _townAwayMatrix[i][j];
                if (!obj) {
                    Cc.error('TownArea checkAwayFreeGrids:: obj == nul');
                    return false;
                }
                if (g.managerTutorial.isTutorial) {
                    if (!obj.isTutorialBuilding) {
                        return true;
                    }
                }
                if (!obj.inGame) {
                    return false;
                }
                if (obj.isFull) {
                    return false;
                }
                if (obj.isBlocked) {
                    return false;
                }
                if (obj.buildFence) {
                    return false;
                }
            }
        }
        return true;
    }

    public function fillMatrixWithTutorialBuildings(posX:int, posY:int, sizeX:int, sizeY:int, source:*):void {
        if (source is TutorialPlace) {
            var j:int;
            for (var i:int = posY; i < (posY + sizeY); i++) {
                for (j = posX; j < (posX + sizeX); j++) {
                    _townMatrix[i][j].isTutorialBuilding = true;
                    _freePlace.fillCell(j, i);
                    if (sizeX > 1 && sizeY > 1) {
                        if (i != posY && i != posY + sizeY && j != posX && j != posX + sizeX)
                            _townMatrix[i][j].isWall = true;
                    }
                }
            }
            if (sizeX > 1 && sizeY > 1) {  // write coordinates left->right && top->down
                _objBuildingsDiagonals[String(posX) + '-' + String(posY + 1) + '-' + String(posX + 1) + '-' + String(posY)] = true;
                _objBuildingsDiagonals[String(posX + sizeX - 1) + '-' + String(posY) + '-' + String(posX + sizeX) + '-' + String(posY + 1)] = true;
                _objBuildingsDiagonals[String(posX) + '-' + String(posY + sizeY - 1) + '-' + String(posX + 1) + '-' + String(posY + sizeY)] = true;
                _objBuildingsDiagonals[String(posX + sizeX - 1) + '-' + String(posY + sizeY) + '-' + String(posX + sizeX) + '-' + String(posY + sizeY - 1)] = true;
            }
        }
    }

    public function unFillMatrix(posX:int, posY:int, sizeX:int, sizeY:int):void {
        for (var i:int = posY; i < (posY + sizeY); i++) {
            for (var j:int = posX; j < (posX + sizeX); j++) {
                _freePlace.freeCell(j, i);
                _townMatrix[i][j].build = null;
                _townMatrix[i][j].isFull = false;
                _townMatrix[i][j].isWall = false;
                _townMatrix[i][j].isTutorialBuilding = false;
            }
        }

        if (sizeX > 1 && sizeY > 1) {  // write coordinate left->right && top->down
            delete _objBuildingsDiagonals[String(posX) + '-' + String(posY+1) + '-' + String(posX+1) + '-' + String(posY)];
            delete _objBuildingsDiagonals[String(posX+sizeX-1) + '-' + String(posY) + '-' + String(posX+sizeX) + '-' + String(posY+1)];
            delete _objBuildingsDiagonals[String(posX) + '-' + String(posY+sizeY-1) + '-' + String(posX+1) + '-' + String(posY+sizeY)];
            delete _objBuildingsDiagonals[String(posX+sizeX-1) + '-' + String(posY+sizeY) + '-' + String(posX+sizeX) + '-' + String(posY+sizeY-1)];
        }
    }

    public function fillTailMatrix(posX:int, posY:int, sizeX:int,sizeY:int, source:WorldObject):void {
        if (source.dataBuild.buildType == BuildType.DECOR_TAIL) {
            if (source is TutorialPlace) return;
            var j:int;
            for (var i:int = posY; i < (posY + sizeY); i++) {
                for (j = posX; j < (posX + sizeX); j++) {
                    if (_townTailMatrix[i][j].build && _townTailMatrix[i][j].build is LockedLand && source is Wild) {
                        continue;
                    }
                        _townTailMatrix[i][j].isTutorialBuilding = false;
                        _townTailMatrix[i][j].build = source;
                        _townTailMatrix[i][j].inTile = true;
//                    _townTailMatrix[i][j].isFull = true;
//                    if (sizeX > 1 && sizeY > 1) {
//                        if (i != posY && i != posY + sizeY && j != posX && j != posX + sizeX)
//                            _townTailMatrix[i][j].isWall = true;
//                    }
                }
            }

            if (sizeX > 1 && sizeY > 1) {  // write coordinates left->right && top->down
                _objBuildingsDiagonals[String(posX) + '-' + String(posY + 1) + '-' + String(posX + 1) + '-' + String(posY)] = true;
                _objBuildingsDiagonals[String(posX + sizeX - 1) + '-' + String(posY) + '-' + String(posX + sizeX) + '-' + String(posY + 1)] = true;
                _objBuildingsDiagonals[String(posX) + '-' + String(posY + sizeY - 1) + '-' + String(posX + 1) + '-' + String(posY + sizeY)] = true;
                _objBuildingsDiagonals[String(posX + sizeX - 1) + '-' + String(posY + sizeY) + '-' + String(posX + sizeX) + '-' + String(posY + sizeY - 1)] = true;
            }
        } else _townTailMatrix[posY][posX].build = source;

    }

    public function unFillTailMatrix(posX:int, posY:int, sizeX:int, sizeY:int):void {
        if (sizeX == 0) _townTailMatrix[posY][posX].build = null;
        else {
            for (var i:int = posY; i < (posY + sizeY); i++) {
                for (var j:int = posX; j < (posX + sizeX); j++) {
                    _townTailMatrix[i][j].build = null;
                    _townTailMatrix[i][j].inTile= false;
//                    _townTailMatrix[i][j].isFull = false;
//                    _townTailMatrix[i][j].isWall = false;
                    _townTailMatrix[i][j].isTutorialBuilding = false;
                }
            }

            if (sizeX > 1 && sizeY > 1) {  // write coordinate left->right && top->down
                delete _objBuildingsDiagonals[String(posX) + '-' + String(posY + 1) + '-' + String(posX + 1) + '-' + String(posY)];
                delete _objBuildingsDiagonals[String(posX + sizeX - 1) + '-' + String(posY) + '-' + String(posX + sizeX) + '-' + String(posY + 1)];
                delete _objBuildingsDiagonals[String(posX) + '-' + String(posY + sizeY - 1) + '-' + String(posX + 1) + '-' + String(posY + sizeY)];
                delete _objBuildingsDiagonals[String(posX + sizeX - 1) + '-' + String(posY + sizeY) + '-' + String(posX + sizeX) + '-' + String(posY + sizeY - 1)];
            }
        }
    }

    public function fillMatrixWithFence(posX:int, posY:int, source:*):void {
        var j:int;
        for (var i:int = posY; i < (posY + 2); i++) {
            for (j = posX; j < (posX + 2); j++) {
                _townMatrix[i][j].isFull = true;
                if (i == posY && j == posX) {
                    _freePlace.fillCell(j + 1, i + 1);
                    _townMatrix[i][j].buildFence = source;
                }
            }
        }
    }

    public function unFillMatrixWithFence(posX:int, posY:int):void {
        var j:int;
        for (var i:int = posY; i < (posY + 2); i++) {
            for (j = posX; j < (posX + 2); j++) {
                _townMatrix[i][j].buildFence = null;
                _townMatrix[i][j].isFull = false;
                _freePlace.freeCell(j, i);
            }
        }
    }

    public function addHero(c:BasicCat):void {
        if (_cityObjects.indexOf(c) == -1) _cityObjects.push(c);
        if (!_cont.contains(c.source)) {
            var p:Point = g.matrixGrid.getXYFromIndex(new Point(c.posX, c.posY));
            c.source.x = int(p.x);
            c.source.y = int(p.y);
            _cont.addChild(c.source);
        }
        zSort();
    }

    public function removeHero(c:BasicCat):void {
        if (_cityObjects.indexOf(c) > -1) _cityObjects.splice(_cityObjects.indexOf(c), 1);
        if (_cont.contains(c.source))
            _cont.removeChild(c.source);
    }

    public function createNewBuild(_data:Object, dbId:int = 0):WorldObject {
        var build:WorldObject;
        if (!_data) {
            Cc.error('TownArea createNewBuild:: _data == nul for building');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return null;
        }

        if (dbId == 0 && _data.buildType == BuildType.FABRICA) {    // что означает, что через магазин купили и поставили новую фабрику
            var ob:Object = {};
            ob.dbId = int(Math.random()*100000);
            ob.timeBuildBuilding = 0;
            ob.isOpen = 0;
            g.user.userBuildingData[_data.id] = ob;
        }

        switch (_data.buildType) {
            case BuildType.CHEST:
                build = new Chest(_data);
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
            case BuildType.TRAIN:
                build = new Train(_data);
                break;
            case BuildType.LOCKED_LAND:
                build = new LockedLand(_data);
                break;
            case BuildType.DECOR_TAIL:
                build = new DecorTail(_data);
                break;
            case BuildType.TUTORIAL_PLACE:
                build = new TutorialPlace(_data);
                break;
        }

        if (!build) {
            Cc.error('TownArea:: BUILD is null for type: ' + _data.buildType);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return null;
        }
        (build as WorldObject).dbBuildingId = dbId;

        if (_data.buildType == BuildType.SKLAD) {
            (build as WorldObject).makeFlipBuilding();
            return build;
        }
        if (_data.isFlip) {
            (build as WorldObject).makeFlipBuilding();
        }

        return build;
    }

    public function pasteBuild(worldObject:WorldObject, _x:Number, _y:Number, isNewAtMap:Boolean = true, updateAfterMove:Boolean = false):void {
        var point:Point;
        if (!worldObject) {
            Cc.error('TownArea pasteBuild:: empty worldObject');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }

        g.selectedBuild = null;
        if (_cont.contains(worldObject.source)) {
            _cont.removeChild(worldObject.source);
        }
        if (!isNewAtMap) {
            if (worldObject is Ambar || worldObject is Sklad || worldObject is Order || worldObject is Market ||
                    worldObject is Cave || worldObject is Paper || worldObject is Train || worldObject is DailyBonus|| worldObject is LockedLand || worldObject is Wild) {
            } else {
                point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
                if (!checkFreeGrids(point.x, point.y, worldObject.sizeX, worldObject.sizeY)) {
                    Cc.error('TownArea pasteBuild checkFreeGrids:: posX, posY not empty ' + worldObject.dataBuild.name + ' ' + worldObject.dataBuild.id);
                    return;
                }
            }
        }


        if (worldObject is Wild) {
            point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
            worldObject.posX = point.x;
            worldObject.posY = point.y;
            worldObject.source.x = int(_x);
            worldObject.source.y = int(_y);
            if (_townMatrix[worldObject.posY][worldObject.posX].build && _townMatrix[worldObject.posY][worldObject.posX].build is LockedLand) {
                (_townMatrix[worldObject.posY][worldObject.posX].build as LockedLand).addWild(worldObject as Wild, _x, _y);
                (worldObject as Wild).setLockedLand(_townMatrix[worldObject.posY][worldObject.posX].build as LockedLand);
            } else {
                _cont.addChild(worldObject.source);
                _cityObjects.push(worldObject);
                worldObject.updateDepth();
                fillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY, worldObject);
                for (var ik:int = worldObject.posY; ik < (worldObject.posY + worldObject.sizeY); ik++) {
                    for (var jk:int = worldObject.posX; jk < (worldObject.posX + worldObject.sizeX); jk++) {
                        fillTailMatrix(jk, ik,0,0, worldObject);
                    }
                }
            }
            if (isNewAtMap && g.isActiveMapEditor)
                g.directServer.ME_addWild(worldObject.posX, worldObject.posY, worldObject, null);
            if (updateAfterMove && g.isActiveMapEditor) {
                g.directServer.ME_moveWild(worldObject.posX, worldObject.posY, worldObject.dbBuildingId, null);
            }
            return;
        }

        worldObject.source.x = int(_x);
        worldObject.source.y = int(_y);
        _cont.addChild(worldObject.source);
        if (worldObject.useIsometricOnly) {
            point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
            worldObject.posX = point.x;
            worldObject.posY = point.y;
        } else {
            if (updateAfterMove) {
                worldObject.posX = int(_x / g.scaleFactor);
                worldObject.posY = int(_y / g.scaleFactor);
            } else {
                worldObject.source.x = int(_x) * g.scaleFactor;
                worldObject.source.y = int(_y) * g.scaleFactor;
            }

        }
        if (!updateAfterMove) _cityObjects.push(worldObject);
        worldObject.updateDepth();
        if (worldObject is DecorFence || worldObject is DecorPostFence) {
            fillMatrixWithFence(worldObject.posX, worldObject.posY, worldObject);
            if (worldObject is DecorPostFence) addFenceLenta(worldObject as DecorPostFence);
        } else {
            if (worldObject.useIsometricOnly) {
                fillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY, worldObject);
            }
            if (worldObject is Order || worldObject is LockedLand) {
                for (var i:int = worldObject.posY; i < (worldObject.posY + worldObject.sizeY); i++) {
                    for (var j:int = worldObject.posX; j < (worldObject.posX + worldObject.sizeX); j++) {
                        fillTailMatrix(j, i,0,0, worldObject);
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
            if (worldObject is Ridge)
                g.managerPlantRidge.onAddNewRidge(worldObject as Ridge);
            if (worldObject is Farm)
                g.managerAnimal.onAddNewFarm(worldObject as Farm);
        }

        if (updateAfterMove) {
            if (g.isActiveMapEditor) {
                if (worldObject is Ambar || worldObject is Sklad || worldObject is Order || worldObject is Market ||
                        worldObject is Cave || worldObject is Paper || worldObject is Train || worldObject is DailyBonus) {
                    g.directServer.ME_moveMapBuilding(worldObject.dataBuild.id, worldObject.posX, worldObject.posY, null);
                }
            } else {
                g.directServer.updateUserBuildPosition(worldObject.dbBuildingId, worldObject.posX, worldObject.posY, null);
            }
        }

        if (isNewAtMap && g.managerTutorial.isTutorial) {
            if (worldObject is TutorialPlace) return;
            if (worldObject is Fabrica && g.managerTutorial.currentAction == TutorialAction.PUT_FABRICA) {
                g.managerTutorial.addTutorialWorldObject(worldObject);
                g.managerTutorial.checkTutorialCallback();
            } else if (worldObject is Ridge && g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE) {
                g.managerTutorial.addTutorialWorldObject(worldObject);
                g.managerTutorial.checkTutorialCallback();
            } else if (worldObject is Farm && g.managerTutorial.currentAction == TutorialAction.PUT_FARM) {
                g.managerTutorial.addTutorialWorldObject(worldObject);
                g.managerTutorial.checkTutorialCallback();
            }
        }

        // временно полная сортировка, далее нужно будет дописать "умную"
        if (updateAfterMove) zSort();

        if (g.managerCutScenes.isCutScene) return;
        var build:WorldObject;
        var arr:Array;
        if (isNewAtMap && (worldObject is Ridge || worldObject is Tree)) {
            if (g.user.softCurrencyCount <  worldObject.dataBuild.cost) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.bottomPanel.cancelBoolean(false);
                return;
            }
            g.bottomPanel.cancelBoolean(true);
            if (worldObject is Ridge) {
                g.toolsModifier.modifierType = ToolsModifier.ADD_NEW_RIDGE;
            } else if (worldObject is Tree) {
                g.toolsModifier.modifierType = ToolsModifier.PLANT_TREES;
            }
            var curCount:int;
            var maxCount:int;
            var maxCountAtCurrentLevel:int = 0;
            arr = getCityObjectsById( worldObject.dataBuild.id);
            curCount = arr.length;
            for (i = 0;  worldObject.dataBuild.blockByLevel.length; i++) {
                if ( worldObject.dataBuild.blockByLevel[i] <= g.user.level) {
                    maxCountAtCurrentLevel++;
                } else break;
            }
            maxCount = maxCountAtCurrentLevel *  worldObject.dataBuild.countUnblock;
            if (curCount >= maxCount) {
                g.bottomPanel.cancelBoolean(false);
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                return;
            }
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            build = createNewBuild( worldObject.dataBuild);
            g.selectedBuild = build;
            if (build is Tree) (build as Tree).showShopView();
            (build as WorldObject).source.filter = null;
            g.toolsModifier.startMove(build, afterMoveReturn, true);

        } else if (isNewAtMap &&(worldObject is Decor || worldObject is DecorFence || worldObject is DecorPostFence)) {
            if (g.userInventory.decorInventory[ worldObject.dataBuild.id]) {
                build = createNewBuild( worldObject.dataBuild);
                g.selectedBuild = build;
                (build as WorldObject).source.filter = null;
                g.toolsModifier.startMove(build, afterMoveFromInventory, true);
                return;
            }
            if ( worldObject.dataBuild.currency[0] != DataMoney.SOFT_CURRENCY && worldObject.dataBuild.currency[0] != DataMoney.HARD_CURRENCY ) {
                for (i = 0; i <  worldObject.dataBuild.currency.length; i++){
                    if ( worldObject.dataBuild.currency[i] == DataMoney.BLUE_COUPONE && g.user.blueCouponCount <  worldObject.dataBuild.cost[i]) {
                        g.toolsModifier.modifierType = ToolsModifier.NONE;
                        g.bottomPanel.cancelBoolean(false);
                        g.buyHint.hideIt();
                        return;
                    } else if ( worldObject.dataBuild.currency[i] == DataMoney.RED_COUPONE && g.user.redCouponCount <  worldObject.dataBuild.cost[i]) {
                        g.toolsModifier.modifierType = ToolsModifier.NONE;
                        g.bottomPanel.cancelBoolean(false);
                        g.buyHint.hideIt();
                        return;
                    } else if ( worldObject.dataBuild.currency[i] == DataMoney.GREEN_COUPONE && g.user.greenCouponCount <  worldObject.dataBuild.cost[i]) {
                        g.toolsModifier.modifierType = ToolsModifier.NONE;
                        g.bottomPanel.cancelBoolean(false);
                        g.buyHint.hideIt();
                        return;
                    } else if ( worldObject.dataBuild.currency[i] == DataMoney.YELLOW_COUPONE && g.user.yellowCouponCount <  worldObject.dataBuild.cost[i]) {
                        g.toolsModifier.modifierType = ToolsModifier.NONE;
                        g.bottomPanel.cancelBoolean(false);
                        g.buyHint.hideIt();
                        return;
                    }
                }
                g.bottomPanel.cancelBoolean(true);
                g.toolsModifier.modifierType = ToolsModifier.MOVE;
                build = createNewBuild( worldObject.dataBuild);
                g.selectedBuild = build;
                (build as WorldObject).source.filter = null;
                g.toolsModifier.startMove(build, afterMoveReturn, true);
                return;
            }
            arr = getCityObjectsById(worldObject.dataBuild.id);
            if (worldObject.dataBuild.currency[0] == DataMoney.SOFT_CURRENCY && g.user.softCurrencyCount < (arr.length *  worldObject.dataBuild.deltaCost) + int( worldObject.dataBuild.cost)) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.bottomPanel.cancelBoolean(false);
                g.buyHint.hideIt();
                return;
            } else if (worldObject.dataBuild.currency[0] == DataMoney.HARD_CURRENCY && g.user.hardCurrency < int( worldObject.dataBuild.cost)) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.bottomPanel.cancelBoolean(false);
                g.buyHint.hideIt();
                return;
            }
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.buyHint.showIt((arr.length *  worldObject.dataBuild.deltaCost) + int( worldObject.dataBuild.cost));
            build = createNewBuild( worldObject.dataBuild);
            g.selectedBuild = build;
            (build as WorldObject).source.filter = null;
            g.toolsModifier.startMove(build, afterMoveReturn, true);
            g.bottomPanel.cancelBoolean(true);
//            g.buyHint.hideIt();
            return;

        } else if (isNewAtMap && worldObject is DecorTail){
            Cc.error('TownArea.PasteBuild -- DecorTail wtf you do this');
        }
    }
    private function afterMoveReturn(build:WorldObject, _x:Number, _y:Number):void {// для ridge, tree, decorFence, decor,decorPostFence
        (build as WorldObject).source.filter = null;
        var cost:int;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (build is Tree) {
            (build as Tree).removeShopView();
            cost = (build as WorldObject).dataBuild.cost;
        }
        if (build is Ridge) cost = (build as WorldObject).dataBuild.cost;
        var arr:Array;
        if (build is Decor || build is DecorFence || build is DecorPostFence) {
            arr = getCityObjectsById((build as WorldObject).dataBuild.id);
            if ((build as WorldObject).dataBuild.currency.length > 1) {
                for (var i:int = 0; i < (build as WorldObject).dataBuild.currency.length; i++) {
                    g.userInventory.addMoney((build as WorldObject).dataBuild.currency[i], -(build as WorldObject).dataBuild.cost[i]);
                }
                cost = (build as WorldObject).dataBuild.cost[0];
            } else if ((build as WorldObject).dataBuild.currency != DataMoney.SOFT_CURRENCY) {
                cost = (build as WorldObject).dataBuild.cost;
                g.userInventory.addMoney((build as WorldObject).dataBuild.currency, -cost);
            } else {
                cost = (arr.length) * (build as WorldObject).dataBuild.deltaCost + int((build as WorldObject).dataBuild.cost);
                g.userInventory.addMoney((build as WorldObject).dataBuild.currency, -cost);
            }
        } else {
            g.userInventory.addMoney((build as WorldObject).dataBuild.currency, -(build as WorldObject).dataBuild.cost);
        }
        pasteBuild(build, _x, _y);
        showSmallBuildAnimations(build, (build as WorldObject).dataBuild.currency,-cost);

    }

    public function afterMoveFromInventory(build:WorldObject, _x:Number, _y:Number):void { // для декора из инвентаря
        (build as WorldObject).source.filter = null;
        g.bottomPanel.cancelBoolean(true);
        var dbId:int = g.userInventory.removeFromDecorInventory((build as WorldObject).dataBuild.id);
        var p:Point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
        (build as WorldObject).dbBuildingId = dbId;
        g.directServer.removeFromInventory(dbId, p.x, p.y, null);
        if (build is DecorTail) {
            pasteTailBuild(build as DecorTail, _x, _y);
        } else {
            pasteBuild(build, _x, _y);
        }
        if (g.toolsPanel.repositoryBox.source.visible) g.toolsPanel.repositoryBox.updateThis();
        if (g.managerCutScenes.isCutScene && g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_FROM_INVENTORY_DECOR)) g.managerCutScenes.checkCutSceneCallback();
    }

    private function showSmallBuildAnimations(build:WorldObject, moneyType:int, count:int):void {
        var p:Point = new Point((build as WorldObject).source.x, (build as WorldObject).source.y);
        p = g.cont.contentCont.localToGlobal(p);
        new UseMoneyMessage(p, moneyType, count, .3);
        if (build  is Decor || build is DecorFence || build is DecorPostFence || build is DecorTail) new XPStar(p.x, p.y, (build as WorldObject).dataBuild.xpForBuild);
    }

    public function startMoveAfterShop(build:WorldObject, isFromInventory:Boolean = false):void {
        if (build is DecorTail) {
            if (isFromInventory) g.toolsModifier.startMoveTail(build, endMoveFromInventoryAfterShop, true);
            else g.toolsModifier.startMoveTail(build, endMoveAfterShop, true);
        } else {
            if (isFromInventory) g.toolsModifier.startMove(build, endMoveFromInventoryAfterShop, true);
            else g.toolsModifier.startMove(build, endMoveAfterShop, true);
        }
    }

    private function endMoveAfterShop(build:WorldObject,_x:Number, _y:Number):void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        (build as WorldObject).source.filter = null;
        if ((build as WorldObject).dataBuild.buildType == BuildType.FARM) {
            g.user.buyShopTab = WOShop.VILLAGE;
        }
        if ((build as WorldObject).dataBuild.buildType == BuildType.ANIMAL || (build as WorldObject).dataBuild.buildType == BuildType.FARM || (build as WorldObject).dataBuild.buildType == BuildType.FABRICA) {
            g.bottomPanel.cancelBoolean(false);
        }
        if ((build as WorldObject).dataBuild.buildType == BuildType.DECOR || (build as WorldObject).dataBuild.buildType == BuildType.DECOR_TAIL || (build as WorldObject).dataBuild.buildType == BuildType.DECOR_POST_FENCE) {
            var cont:Sprite = new Sprite();
            cont.x = _x;
            cont.y = _y;
            g.cont.gameCont.addChild(cont);
        }

        if ((build as WorldObject).dataBuild.currency.length > 1) {
            for (var i:int = 0; i < (build as WorldObject).dataBuild.currency.length; i++) {
                g.userInventory.addMoney((build as WorldObject).dataBuild.currency[i], -(build as WorldObject).dataBuild.cost[i]);
            }
            if (build is DecorTail) {
                pasteTailBuild(build as DecorTail, _x, _y);
            } else {
                pasteBuild(build, _x, _y, true, false);
            }
            return;
        } else {
            if ((build as WorldObject).dataBuild.currency != DataMoney.SOFT_CURRENCY) {
                g.userInventory.addMoney((build as WorldObject).dataBuild.currency, -(build as WorldObject).countShopCost);
                if (build is DecorTail) {
                    pasteTailBuild(build as DecorTail, _x, _y);
                } else {
                    pasteBuild(build, _x, _y, true, false);
                }
                showSmallBuildAnimations(build, (build as WorldObject).dataBuild.currency, -(build as WorldObject).countShopCost);
                g.buyHint.hideIt();
                return;
            } else {
                if ((build as WorldObject).countShopCost == 0) {
                    var arr:Array = getCityTailObjectsById((build as WorldObject).dataBuild.id);
                    (build as WorldObject).countShopCost = (arr.length * (build as WorldObject).dataBuild.deltaCost) + int((build as WorldObject).dataBuild.cost);
                    g.buyHint.showIt((build as WorldObject).countShopCost);
                }
                g.userInventory.addMoney((build as WorldObject).dataBuild.currency, -(build as WorldObject).countShopCost);
            }
        }
        if (build is Tree) (build as Tree).removeShopView();
        if (build is DecorTail) {
            pasteTailBuild(build as DecorTail, _x, _y);
        } else {
            pasteBuild(build, _x, _y);
        }
        if (build is Fabrica) (build as Fabrica).removeShopView();
        showSmallBuildAnimations(build, DataMoney.SOFT_CURRENCY, -(build as WorldObject).countShopCost);
        if (g.managerCutScenes.isCutScene && (build as WorldObject).dataBuild.buildType == BuildType.DECOR) {
            if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_BUY_DECOR)) {
                g.managerCutScenes.checkCutSceneCallback();
                g.bottomPanel.cancelBoolean(false);
                g.buyHint.hideIt();
            }
        }
    }

    private function endMoveFromInventoryAfterShop(build:WorldObject, _x:Number, _y:Number):void {
        var dbId:int = g.userInventory.removeFromDecorInventory((build as WorldObject).dataBuild.id);
        var p:Point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
        (build as WorldObject).dbBuildingId = dbId;
        g.directServer.removeFromInventory(dbId, p.x, p.y, null);
        if (build is DecorTail) {
            pasteTailBuild(build as DecorTail, _x, _y);
        } else {
            pasteBuild(build, _x, _y);
        }
    }

    public function getRandomFreeCell():Point {
        if (g.isAway) {
            return _freePlace.getAwayFreeCell();
        } else {
            return _freePlace.getFreeCell();
        }
    }

    public function pasteTailBuild(tail:DecorTail, _x:Number, _y:Number, isNewAtMap:Boolean = true, updateAfterMove:Boolean = false):void {
        if (!tail) {
            Cc.error('TownArea pasteTailBuild:: empty tail');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }

        if (!_contTail.contains(tail.source)) {
            tail.source.x = int(_x);
            tail.source.y = int(_y);
            _contTail.addChild(tail.source);
            var point:Point = g.matrixGrid.getIndexFromXY(new Point(_x, _y));
            tail.posX = point.x;
            tail.posY = point.y;
            if (!updateAfterMove)_cityTailObjects.push(tail);
            fillTailMatrix(tail.posX, tail.posY, tail.sizeX, tail.sizeY, tail as WorldObject);
            if (isNewAtMap) {
                g.directServer.addUserBuilding(tail as WorldObject, onAddNewBuilding);
                tail.addXP();
            }
            if (updateAfterMove) {
                g.directServer.updateUserBuildPosition(tail.dbBuildingId, tail.posX, tail.posY, null);
            }
        }
        (tail as WorldObject).updateDepth();
        decorTailSort();

        g.selectedBuild = null;
        if (isNewAtMap){
            if (g.userInventory.decorInventory[tail.dataBuild.id]) {
            var build:WorldObject;
            build = createNewBuild(tail.dataBuild);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.startMoveTail(build,afterMoveFromInventory,true);
            return;
            }
            var arr:Array = getCityTailObjectsById(tail.dataBuild.id);
            if (tail.dataBuild.currency[0] != DataMoney.SOFT_CURRENCY && tail.dataBuild.currency[0] != DataMoney.HARD_CURRENCY ) {
                for (var i:int = 0; i <  tail.dataBuild.currency.length; i++){
                    if ( tail.dataBuild.currency[i] == DataMoney.BLUE_COUPONE && g.user.blueCouponCount <  tail.dataBuild.cost[i]) {
                        g.toolsModifier.modifierType = ToolsModifier.NONE;
                        g.bottomPanel.cancelBoolean(false);
                        g.buyHint.hideIt();
                        return;
                    } else if (tail.dataBuild.currency[i] == DataMoney.RED_COUPONE && g.user.redCouponCount <  tail.dataBuild.cost[i]) {
                        g.toolsModifier.modifierType = ToolsModifier.NONE;
                        g.bottomPanel.cancelBoolean(false);
                        g.buyHint.hideIt();
                        return;
                    } else if (tail.dataBuild.currency[i] == DataMoney.GREEN_COUPONE && g.user.greenCouponCount <  tail.dataBuild.cost[i]) {
                        g.toolsModifier.modifierType = ToolsModifier.NONE;
                        g.bottomPanel.cancelBoolean(false);
                        g.buyHint.hideIt();
                        return;
                    } else if (tail.dataBuild.currency[i] == DataMoney.YELLOW_COUPONE && g.user.yellowCouponCount <  tail.dataBuild.cost[i]) {
                        g.toolsModifier.modifierType = ToolsModifier.NONE;
                        g.bottomPanel.cancelBoolean(false);
                        g.buyHint.hideIt();
                        return;
                    }
                }
            }
            if (tail.dataBuild.currency[0] == DataMoney.SOFT_CURRENCY && g.user.softCurrencyCount < (arr.length *  tail.dataBuild.deltaCost) + int( tail.dataBuild.cost)) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.bottomPanel.cancelBoolean(false);
                g.buyHint.hideIt();
                return;
            } else if (tail.dataBuild.currency[0] == DataMoney.HARD_CURRENCY && g.user.hardCurrency < int( tail.dataBuild.cost)) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.bottomPanel.cancelBoolean(false);
                g.buyHint.hideIt();
                return;
            }
            if (g.user.softCurrencyCount < (arr.length * tail.dataBuild.deltaCost) + int(tail.dataBuild.cost)) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.bottomPanel.cancelBoolean(false);
                g.buyHint.hideIt();
                return;
            }
            g.buyHint.showIt((arr.length* tail.dataBuild.deltaCost) + int(tail.dataBuild.cost));
            build = createNewBuild(tail.dataBuild);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.toolsModifier.startMoveTail(build,afterMoveTail,true);
        }
    }

    private function afterMoveTail(build:WorldObject, _x:Number, _y:Number):void { // только для DecorTile
        g.selectedBuild = null;
        (build as WorldObject).source.filter = null;
        var cost:int;
        var arr:Array;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        arr = getCityTailObjectsById((build as WorldObject).dataBuild.id);
        if ((build as WorldObject).dataBuild.currency.length > 1) {
            for (var i:int = 0; i < (build as WorldObject).dataBuild.currency.length; i++) {
                g.userInventory.addMoney((build as WorldObject).dataBuild.currency[i], -(build as WorldObject).dataBuild.cost[i]);
            }
            cost = (build as WorldObject).dataBuild.cost[0];
        } else if ((build as WorldObject).dataBuild.currency != DataMoney.SOFT_CURRENCY) {
            cost = (build as WorldObject).dataBuild.cost;
            g.userInventory.addMoney((build as WorldObject).dataBuild.currency, -cost);
        } else {
            cost = (arr.length) * (build as WorldObject).dataBuild.deltaCost + int((build as WorldObject).dataBuild.cost);
            g.userInventory.addMoney((build as WorldObject).dataBuild.currency, -cost);
        }

        pasteTailBuild(build as DecorTail, _x, _y);
        showSmallBuildAnimations(build, (build as WorldObject).dataBuild.currency, -cost);
    }

    public function moveTailBuild(tail:DecorTail):void { // не сохраняется флип при муве
        if (!tail) {
            Cc.error('TownArea moveTailBuild:: empty tail');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }
        if(_contTail.contains(tail.source)) {
            g.selectedBuild = tail;
            _contTail.removeChild(tail.source);
            unFillTailMatrix(tail.posX, tail.posY,tail.sizeX,tail.sizeY);
            g.toolsModifier.startMoveTail(tail as WorldObject, afterMove);
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
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }
        if(_cont.contains(worldObject.source)){
            _cont.removeChild(worldObject.source);
        }
        if (worldObject is DecorFence || worldObject is DecorPostFence) {
            if (worldObject is DecorPostFence) removeFenceLenta(worldObject as DecorPostFence);
            unFillMatrixWithFence(worldObject.posX, worldObject.posY);
        } else {
            unFillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
        }
        if (worldObject is Wild || worldObject is LockedLand) {
            for (var ik:int = worldObject.posY; ik < (worldObject.posY + worldObject.sizeY); ik++) {
                for (var jk:int = worldObject.posX; jk < (worldObject.posX + worldObject.sizeX); jk++) {
                    unFillTailMatrix(jk, ik,0,0);
                }
            }
        }
        if (_cityObjects.indexOf(worldObject) > -1) _cityObjects.splice(_cityObjects.indexOf(worldObject), 1);
        worldObject.clearIt();
    }

    public function deleteTailBuild(tail:DecorTail):void{
        if (!tail) {
            Cc.error('TownArea deleteTailBuild:: empty tail');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }
        if(_contTail.contains(tail.source)){
            _contTail.removeChild(tail.source);
        }
        unFillTailMatrix(tail.posX, tail.posY,tail.sizeX,tail.sizeY);
        if (_cityTailObjects.indexOf(tail) > -1) _cityTailObjects.splice(_cityTailObjects.indexOf(tail), 1);
        tail.clearIt();
    }

    public function moveBuild(worldObject:WorldObject):void{
        if (!worldObject) {
            Cc.error('TownArea moveBuild:: empty worldObject');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }
        if(_cont.contains(worldObject.source)) {
            g.selectedBuild = worldObject;
            _cont.removeChild(worldObject.source);
            if (worldObject is DecorFence || worldObject is DecorPostFence) {
                if (worldObject is DecorPostFence) removeFenceLenta(worldObject as DecorPostFence);
                unFillMatrixWithFence(worldObject.posX, worldObject.posY);
            } else {
                if (g.selectedBuild.useIsometricOnly) {
                    unFillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
                }
            }
            g.toolsModifier.startMove(worldObject, afterMove);
        }
    }

    private function afterMove(build:WorldObject, _x:Number, _y:Number):void {
        if (build is DecorTail) pasteTailBuild(build as DecorTail, _x, _y, false, true);
        else pasteBuild(build, _x, _y, false, true);
        g.selectedBuild = null;
        if (build is Farm) (build as Farm).checkAfterMove();
        if (build is Ridge) (build as Ridge).checkAfterMove();
    }

    private function addFenceLenta(d:DecorPostFence):void {
        // проверяем, есть ли по соседству еще столбы забора, если да - то проводим между ними ленту
        var obj:Object;

        if (_townMatrix[d.posY][d.posX - 2]) {
            obj = _townMatrix[d.posY][d.posX - 2];
            if (obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                (obj.buildFence as DecorPostFence).addRightLenta();
        }
        if (_townMatrix[d.posY - 2]) {
            obj = _townMatrix[d.posY - 2][d.posX];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                (obj.buildFence as DecorPostFence).addLeftLenta();
        }
        if (_townMatrix[d.posY][d.posX + 2]) {
            obj = _townMatrix[d.posY][d.posX + 2];
            if (obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                d.addRightLenta();
        }
        if (_townMatrix[d.posY + 2]) {
            obj = _townMatrix[d.posY + 2][d.posX];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                d.addLeftLenta();
        }
    }

    private function removeFenceLenta(d:DecorPostFence):void {
        // проверяем, есть ли по соседству еще столбы забора, если да - то забираем между ними ленту
        var obj:Object;

        if (_townMatrix[d.posY][d.posX - 2]) {
            obj = _townMatrix[d.posY][d.posX - 2];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence)
                (obj.buildFence as DecorPostFence).removeRightLenta();
        }
        if (_townMatrix[d.posY - 2]) {
            obj = _townMatrix[d.posY - 2][d.posX];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence)
                (obj.buildFence as DecorPostFence).removeLeftLenta();
        }

        d.removeLeftLenta();
        d.removeRightLenta();
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

     // ---------------------------------------------------- AWAY SECTION -------------------------------------------------------

    public function goAway(person:Someone):void {
        var b:Boolean = true;
        if (person.level <= 0 && !person.marketItems) {
            if (person is NeighborBot) b = false;
            if (b) {
                var p0:Point = new Point(Starling.current.nativeStage.stageWidth / 2, Starling.current.nativeStage.stageHeight / 2);
                new FlyMessage(p0, "ЭТОТ ЧЕЛОВЕК УДАЛЕН ИЗ ИГРЫ");
                return;
            }
        }
        g.managerHelpers.stopIt();
        g.hideAllHints();
        g.catPanel.visibleCatPanel(false);
        _awayPreloader = new AwayPreloader();
        _awayPreloader.showIt(false);
        g.visitedUser = person;
        _freePlace.deleteAway();
        _freePlace.fillAway();
        if (g.isAway) {
            removeAwayTownAreaSortCheking();
            clearAwayCity();
        } else {
            removeTownAreaSortCheking();
            for (var i:int = 0; i < _cityObjects.length; i++) {
                _cont.removeChild(_cityObjects[i].source);
            }
            for (i = 0; i < _cityTailObjects.length; i++) {
                _contTail.removeChild(_cityTailObjects[i].source);
            }
        }
        g.isAway = true;
        g.bottomPanel.doorBoolean(true,person);
        _townAwayMatrix = [];
        setDefaultAwayMatrix();
        if (person.userDataCity.objects) {
            setAwayCity(person);
        } else {
            g.directServer.getAllCityData(person, setAwayCity);
        }
        addAwayTownAreaSortCheking();
        g.managerChest.createChest(true);
        var p:Point = new Point();
        p.x = 24;
        p.y = 26;
        g.cont.moveCenterToPos(p.x, p.y, true, 2);
    }

    private function setDefaultAwayMatrix():void {
        var arr:Array = g.matrixGrid.matrix;
        var ln:int = g.matrixGrid.matrixSize;

        for (var i:int = 0; i < ln; i++) {
            _townAwayMatrix.push([]);
            for (var j:int = 0; j < ln; j++) {
                _townAwayMatrix[i][j] = {};
                if (arr[i][j].inGame) {
                    _townAwayMatrix[i][j].build = null;
                    _townAwayMatrix[i][j].buildFence = null;
                    _townAwayMatrix[i][j].isFull = false;
                    _townAwayMatrix[i][j].inGame = true;
                    _townAwayMatrix[i][j].isBlocked = false;
                    _townAwayMatrix[i][j].isWall = false;
                } else {
                    _townMatrix[i][j].inGame = false;
                }
            }
        }
    }

    private function fillAwayMatrix(posX:int, posY:int, sizeX:int, sizeY:int, source:*):void {
        for (var i:int = posY; i < (posY + sizeY); i++) {
            for (var j:int = posX; j < (posX + sizeX); j++) {
                if (_townAwayMatrix[i][j].build && _townAwayMatrix[i][j].build is LockedLand && source is Wild) {
                    continue;
                }
                _freePlace.fillAwayCell(j, i);
                _townAwayMatrix[i][j].build = source;
                _townAwayMatrix[i][j].isFull = true;
                if (sizeX > 1 && sizeY > 1) {
                    if (i != posY && i != posY + sizeY && j != posX && j != posX + sizeX)
                        _townAwayMatrix[i][j].isWall = true;
                }
            }
        }

        if (sizeX > 1 && sizeY > 1) {  // write coordinates left->right && top->down
            _objAwayBuildingsDiagonals[String(posX) + '-' + String(posY+1) + '-' + String(posX+1) + '-' + String(posY)] = true;
            _objAwayBuildingsDiagonals[String(posX+sizeX-1) + '-' + String(posY) + '-' + String(posX+sizeX) + '-' + String(posY+1)] = true;
            _objAwayBuildingsDiagonals[String(posX) + '-' + String(posY+sizeY-1) + '-' + String(posX+1) + '-' + String(posY+sizeY)] = true;
            _objAwayBuildingsDiagonals[String(posX+sizeX-1) + '-' + String(posY+sizeY) + '-' + String(posX+sizeX) + '-' + String(posY+sizeY-1)] = true;
        }
    }

    private function fillAwayMatrixWithFence(posX:int, posY:int, source:*):void {
        for (var i:int = posY; i < (posY + 2); i++) {
            for (var j:int = posX; j < (posX + 2); j++) {
                _townAwayMatrix[i][j].isFull = true;
                if (i == posY && j == posX)
                    _freePlace.fillAwayCell(j, i);
                    _townAwayMatrix[i][j].buildFence = source;
            }
        }
    }

    private function setAwayCity(p:Someone):void {
        var i:int;
        for (i=0; i<p.userDataCity.objects.length; i++) {
            createAwayNewBuild(g.dataBuilding.objectBuilding[p.userDataCity.objects[i].buildId], p.userDataCity.objects[i].posX, p.userDataCity.objects[i].posY, int(p.userDataCity.objects[i].dbId), p.userDataCity.objects[i].isFlip);
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
        g.managerCats.makeAwayCats();
        zAwaySort();
        decorAwayTailSort();
        sortAwayAtLockedLands();
        _awayPreloader.deleteIt();
        _awayPreloader = null;
    }

    public function createAwayNewBuild(_data:Object, posX:int, posY:int, dbId:int, flip:int = 0):void {
        var build:WorldObject;
        var isFlip:Boolean;
        if (!_data) {
            Cc.error('TownArea createAwayNewBuild:: _data == nul for building');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }
        _data.isFlip = flip;
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
            case BuildType.TRAIN:
                build = new Train(_data);
                break;
            case BuildType.LOCKED_LAND:
                    _data.dbId = dbId;
                build = new LockedLand(_data);
                break;
            case BuildType.DECOR_TAIL:
                build = new DecorTail(_data);
                break;
            case BuildType.CHEST:
                build = new Chest(_data);
                break;
        }

        if (!build) {
            Cc.error('TownArea:: BUILD is null for type: ' + _data.buildType);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }
        (build as WorldObject).dbBuildingId = dbId;
        if (_data.buildType == BuildType.DECOR_TAIL) {
            pasteAwayTailBuild(build as DecorTail, posX, posY);
        } else {
            pasteAwayBuild(build, posX, posY);
        }

        if (isFlip && !(build is DecorPostFence)) {
            (build as WorldObject).makeFlipBuilding();
        }

        if (_data.id == 93 || _data.id == 95 || _data.id == 97
                || _data.id == 107 || _data.id == 108 || _data.id == 109 || _data.id == 110 || _data.id == 111 || _data.id == 112 || _data.id == 113
                || _data.id == 114 || _data.id == 115 || _data.id == 116 || _data.id == 117 || _data.id == 118) {
            (build as WorldObject).makeFlipBuilding();
        }

    }

    public function pasteAwayBuild(worldObject:WorldObject, posX:Number, posY:Number):void {
        if (!worldObject) {
            Cc.error('TownArea pasteAwayBuild:: empty worldObject');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }
            if (worldObject is Ambar || worldObject is Sklad || worldObject is Order || worldObject is Market ||
                    worldObject is Cave || worldObject is Paper || worldObject is Train || worldObject is DailyBonus|| worldObject is LockedLand || worldObject is Wild ) {
            } else {
                if (!checkAwayFreeGrids(posX, posY, worldObject.sizeX, worldObject.sizeY)) {
                    Cc.error('TownArea pasteAwayBuild checkFreeGrids:: posX, posY not empty ' + worldObject.dataBuild.name + ' ' + worldObject.dataBuild.id);
                    return;
                }
            }
        var point:Point;
        if (worldObject is Wild) {
            point = g.matrixGrid.getXYFromIndex(new Point(posX, posY));
            worldObject.posX = posX;
            worldObject.posY = posY;
            worldObject.source.x = int(point.x);
            worldObject.source.y = int(point.y);
            if (_townAwayMatrix[worldObject.posY][worldObject.posX].build && _townAwayMatrix[worldObject.posY][worldObject.posX].build is LockedLand) {
                (_townAwayMatrix[worldObject.posY][worldObject.posX].build as LockedLand).addWild(worldObject as Wild, point.x, point.y);
                (worldObject as Wild).setLockedLand(_townAwayMatrix[worldObject.posY][worldObject.posX].build as LockedLand);
            } else {
                worldObject.updateDepth();
                _cont.addChild(worldObject.source);
                _cityAwayObjects.push(worldObject);
                fillAwayMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY, worldObject);
            }
            return;
        }

        worldObject.posX = posX;
        worldObject.posY = posY;
        if (worldObject.useIsometricOnly) {
            point = g.matrixGrid.getXYFromIndex(new Point(posX, posY));
            worldObject.source.x = int(point.x);
            worldObject.source.y = int(point.y);
        } else {
            worldObject.source.x =  int(posX * g.scaleFactor);
            worldObject.source.y = int(posY * g.scaleFactor);
        }
        worldObject.updateDepth();

        if (!_cont.contains(worldObject.source)) {
            _cont.addChild(worldObject.source);
        }

        if (worldObject is DecorFence || worldObject is DecorPostFence) {
            fillAwayMatrixWithFence(worldObject.posX, worldObject.posY, worldObject);
            if (worldObject is DecorPostFence) addAwayFenceLenta(worldObject as DecorPostFence);
        } else {
            if (worldObject.useIsometricOnly && !(worldObject is DecorTail)) {
                fillAwayMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY, worldObject);
            }
        }
        if (!(worldObject is DecorTail)) _cityAwayObjects.push(worldObject);
    }

    private function addAwayFenceLenta(d:DecorPostFence):void {
        // проверяем, есть ли по соседству еще столбы забора, если да - то проводим между ними ленту
        var obj:Object;

        if (_townAwayMatrix[d.posY][d.posX-2]) {
            obj = _townAwayMatrix[d.posY][d.posX - 2];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                obj.buildFence.addRightLenta();
        }
        if (_townAwayMatrix[d.posY-2]) {
            obj = _townAwayMatrix[d.posY - 2][d.posX];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                obj.buildFence.addLeftLenta();
        }
        if (_townAwayMatrix[d.posY][d.posX+2]) {
            obj = _townAwayMatrix[d.posY][d.posX + 2];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                d.addRightLenta();
        }
        if (_townAwayMatrix[d.posY+2]) {
            obj = _townAwayMatrix[d.posY + 2][d.posX];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                d.addLeftLenta();
        }
    }

    public function pasteAwayTailBuild(tail:DecorTail, posX:Number, posY:Number):void {
        if (!tail) {
            Cc.error('TownArea pasteAWayTailBuild:: empty tail');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }
        if (!_contTail.contains(tail.source)) {
            tail.posX = posX;
            tail.posY = posY;
            var point:Point = g.matrixGrid.getXYFromIndex(new Point(posX, posY));
            tail.source.x = int(point.x);
            tail.source.y = int(point.y);
            _contTail.addChild(tail.source);
            _cityAwayTailObjects.push(tail);
        }
        (tail as WorldObject).updateDepth();
    }

    public function decorAwayTailSort():void {
        try {
            _cityAwayTailObjects.sortOn("depth", Array.NUMERIC);
            for (var i:int = 0; i < _cityAwayTailObjects.length; i++) {
                if (_contTail.contains(_cityAwayTailObjects[i].source)) {
                    _contTail.setChildIndex(_cityAwayTailObjects[i].source, i);
                }
            }
        } catch(e:Error) {
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            Cc.error('TownArea zSort error: ' + e.errorID + ' - ' + e.message);
        }
    }

    public function addAwayHero(c:BasicCat):void {
        if (_cityAwayObjects.indexOf(c) == -1) _cityAwayObjects.push(c);
        if (!_cont.contains(c.source)) {
            var p:Point = g.matrixGrid.getXYFromIndex(new Point(c.posX, c.posY));
            c.source.x = int(p.x);
            c.source.y = int(p.y);
            _cont.addChild(c.source);
        }
    }

    public function removeAwayHero(c:BasicCat):void {
        if (_cityAwayObjects.indexOf(c) > -1) _cityAwayObjects.slice(_cityAwayObjects.indexOf(c), 1);
        if (_cont.contains(c.source))
            _cont.removeChild(c.source);
    }

    public function addAwayTownAreaSortCheking():void {
        _zSortCounter = SORT_COUNTER_MAX;
        g.gameDispatcher.addEnterFrame(zSortAwayMain);
    }
    public function removeAwayTownAreaSortCheking():void { g.gameDispatcher.removeEnterFrame(zSortAwayMain); }

    public function zAwaySort():void {
        _needTownAreaSort = true;
    }

    public function zSortAwayMain():void {
        if (_needTownAreaSort) {
            _zSortCounter--;
            if (_zSortCounter <= 0) {
                try {
                    _cityAwayObjects.sortOn("depth", Array.NUMERIC);
                    for (var i:int = 0; i < _cityAwayObjects.length; i++) {
                        _cont.setChildIndex(_cityAwayObjects[i].source, i);
                    }
                } catch (e:Error) {
                    g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
                    Cc.error('TownArea zAwaySort error: ' + e.errorID + ' - ' + e.message);
                }
                _needTownAreaSort = false;
                if (g.managerTutorial.isTutorial) {
                    _zSortCounter = 3;
                } else {
                    _zSortCounter = SORT_COUNTER_MAX;
                }
            }
        }
    }

    public function deleteAwayBuild(worldObject:WorldObject):void{
        if (!worldObject) {
            Cc.error('TownArea deleteBuild:: empty worldObject');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
            return;
        }
        if(_cont.contains(worldObject.source)){
            _cont.removeChild(worldObject.source);
        }
        if (worldObject is DecorFence || worldObject is DecorPostFence) {
            if (worldObject is DecorPostFence) removeFenceLenta(worldObject as DecorPostFence);
            unFillMatrixWithFence(worldObject.posX, worldObject.posY);
        } else {
            unFillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
        }
        if (worldObject is Wild || worldObject is LockedLand) {
            for (var ik:int = worldObject.posY; ik < (worldObject.posY + worldObject.sizeY); ik++) {
                for (var jk:int = worldObject.posX; jk < (worldObject.posX + worldObject.sizeX); jk++) {
                    unFillTailMatrix(jk, ik,0,0);
                }
            }
        }
        if (_cityAwayObjects.indexOf(worldObject) > -1) _cityAwayObjects.splice(_cityAwayObjects.indexOf(worldObject), 1);
        worldObject.clearIt();
    }

    public function sortAwayAtLockedLands():void {
        for (var i:int = 0; i < _cityAwayObjects.length; i++) {
            if (_cityAwayObjects[i] is LockedLand) (_cityAwayObjects[i] as LockedLand).sortWilds();
        }
    }

    public function backHome():void {
        g.managerHelpers.checkIt();
        g.hideAllHints();
        removeAwayTownAreaSortCheking();
        _awayPreloader = new AwayPreloader();
        _awayPreloader.showIt(true);
        clearAwayCity();
        _freePlace.deleteAway();
        g.isAway = false;
        g.visitedUser = null;
        g.bottomPanel.doorBoolean(false);
        for (var i:int = 0; i < _cityObjects.length; i++) {
            if (_cityObjects[i] is BasicCat && !_cityObjects[i].isFree) continue;
            _cont.addChild(_cityObjects[i].source);
        }
        for (i = 0; i < _cityTailObjects.length; i++) {
            _contTail.addChild(_cityTailObjects[i].source);
        }
        _awayPreloader.deleteIt();
        _awayPreloader = null;
        addTownAreaSortCheking();
        var p:Point = new Point();
        p.x = 24;
        p.y = 26;
        if (!g.managerTutorial.isTutorial) g.cont.moveCenterToPos(p.x, p.y, true, 2);
    }

    private function clearAwayCity():void {
        for (var i:int = 0; i < _cityAwayObjects.length; i++) {
            if (_cityAwayObjects[i] is BasicCat || _cityAwayObjects[i] is OrderCat) continue;
            _cont.removeChild(_cityAwayObjects[i].source);
            _cityAwayObjects[i].clearIt();
        }
        for (i = 0; i < _cityAwayTailObjects.length; i++) {
            _contTail.removeChild(_cityAwayTailObjects[i].source);
            _cityAwayTailObjects[i].clearIt();
        }
        g.managerCats.removeAwayCats();
        _cityAwayObjects = [];
        _cityAwayTailObjects = [];
        _townAwayMatrix = [];
        _objAwayBuildingsDiagonals = {};
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
            if (_cityAwayObjects[i] is BasicCat || _cityAwayObjects[i] is OrderCat) continue;
            if (_cityAwayObjects[i].dbBuildingId == dbId)
            return _cityAwayObjects[i];
        }
        return null;
    }

    public function getAwayCityObjectsById(id:int):Array {
        var ar:Array = [];
        try {
            for (var i:int = 0; i < _cityAwayObjects.length; i++) {
                if (_cityAwayObjects[i] is BasicCat || _cityAwayObjects[i] is OrderCat) continue;
                if (_cityAwayObjects[i].dataBuild.id == id)
                    ar.push(_cityAwayObjects[i]);
            }
        } catch (e:Error) {
            Cc.error('TownArea getAwayCityObjectsById:: error id: ' + e.errorID + ' - ' + e.message + '    for id: ' + id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'townArea');
        }
        return ar;
    }

//   --------------------- END AWAY SECTION -----------------------------------

    public function onOpenMapEditor(value:Boolean):void {
        var i:int;
        if (value) {
            for (i=0; i<_cityObjects.length; i++) {
                if (_cityObjects[i] is LockedLand) {
                    (_cityObjects[i] as LockedLand).onOpenMapEditor();
                }
            }
        } else {
            for (i=0; i<_cityObjects.length; i++) {
                if (_cityObjects[i] is LockedLand) {
                    (_cityObjects[i] as LockedLand).onCloseMapEditor();
                }
            }
        }
    }

    public function onActivateMoveModifier(v:Boolean):void {
        g.townAreaTouchManager.tailAreTouchable = v;
        for (var i:int=0; i<_cityObjects.length; i++) {
            if (_cityObjects[i] is Order || _cityObjects[i] is Wild || _cityObjects[i] is LockedLand || _cityObjects[i] is Paper || _cityObjects[i] is Cave
                    || _cityObjects[i] is DailyBonus || _cityObjects[i] is Train || _cityObjects[i] is Market || _cityObjects[i] is Chest) {
                if (g.isActiveMapEditor) return;
                v ? _cityObjects[i].source.alpha = .5 : _cityObjects[i].source.alpha = 1;
                (_cityObjects[i].source as TownAreaBuildSprite).isTouchable = !v;
            }
            if (_cityObjects[i] is Farm) {
                (_cityObjects[i] as Farm).onActivateMoveModifier(v);
            }
        }
    }

    public function onActivateRotateModifier(v:Boolean):void {
        g.townAreaTouchManager.tailAreTouchable = v;
        for (var i:int=0; i<_cityObjects.length; i++) {
            if (_cityObjects[i] is Order || _cityObjects[i] is Wild || _cityObjects[i] is LockedLand || _cityObjects[i] is Paper || _cityObjects[i] is Cave
                    || _cityObjects[i] is DailyBonus || _cityObjects[i] is Train || _cityObjects[i] is Market || _cityObjects[i] is Chest) {
                if (g.isActiveMapEditor) return;
                v ? _cityObjects[i].source.alpha = .5 : _cityObjects[i].source.alpha = 1;
                (_cityObjects[i].source as TownAreaBuildSprite).isTouchable = !v;
            }
            if (_cityObjects[i] is Farm) {
                (_cityObjects[i] as Farm).onActivateMoveModifier(v);
            }
        }
    }

    public function onActivateInventoryModifier(v:Boolean):void {
        g.townAreaTouchManager.tailAreTouchable = v;
        for (var i:int=0; i<_cityObjects.length; i++) {
            if (_cityObjects[i] is Order || _cityObjects[i] is Wild || _cityObjects[i] is Ridge || _cityObjects[i] is Farm ||
                _cityObjects[i] is Fabrica || _cityObjects[i] is Tree || _cityObjects[i] is Ambar || _cityObjects[i] is Sklad  ||
                    _cityObjects[i] is Paper || _cityObjects[i] is Cave || _cityObjects[i] is DailyBonus || _cityObjects[i] is Train || _cityObjects[i] is Market || _cityObjects[i] is LockedLand || _cityObjects[i] is Chest) {
                v ? _cityObjects[i].source.alpha = .5 : _cityObjects[i].source.alpha = 1;
                (_cityObjects[i].source as TownAreaBuildSprite).isTouchable = !v;
            }
        }
    }

    public function onStartPlanting(isStart:Boolean):void {
        for (var i:int=0; i<_cityObjects.length; i++) {
            if (_cityObjects[i] is Ridge) {
                (_cityObjects[i] as Ridge).stopDragMapDuringPlanting(isStart);
            }
        }
        g.cont.contentCont.releaseContDrag = !isStart;
        g.cont.tailCont.releaseContDrag = !isStart;
    }


    // ----------------- ORDER CATS --------------------
    public function addOrderCatToCont(cat:OrderCat):void {
        _cont.addChild(cat.source);
    }

    public function removeOrderCatFromCont(cat:OrderCat):void {
        _cont.removeChild(cat.source);
    }

    public function addOrderCatToCityObjects(cat:OrderCat):void {
        _cityObjects.push(cat);
    }

    public function removeOrderCatFromCityObjects(cat:OrderCat):void {
        if (_cityObjects.indexOf(cat) > -1) _cityObjects.splice(_cityObjects.indexOf(cat), 1);
    }
}
}