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
import heroes.OrderCat;

import manager.Vars;

import mouse.ToolsModifier;

import resourceItem.ResourceItem;
import resourceItem.UseMoneyMessage;

import starling.display.Sprite;

import tutorial.TutorialAction;

import user.Someone;

import utils.CSprite;


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
            g.woGameError.showIt();
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
            Cc.error('TownArea getCityObjectsById:: error id: ' + e.errorID + ' - ' + e.message + '    for id: ' + id);
            g.woGameError.showIt();
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
                _townTailMatrix[i][j] = {build: null, inGame: true};
                _townMatrix[i][j] = {};
                _townMatrix[i][j].build = null;
                _townMatrix[i][j].buildFence = null;
                _townMatrix[i][j].isFull = false;
                _townMatrix[i][j].inGame = true;
                _townMatrix[i][j].isBlocked = false; // ? propably it's old not used properties
                _townMatrix[i][j].isWall = false;
            }
        }
    }

    public function addDeactivatedArea(posX:int, posY:int, isDeactivated:Boolean):void {
        _townMatrix[posY][posX].inGame = !isDeactivated;
        _townTailMatrix[posY][posX].inGame = !isDeactivated;
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

        if (sizeX > 1 && sizeY > 1) {  // write coordinates left->right && top->down
            _objBuildingsDiagonals[String(posX) + '-' + String(posY+1) + '-' + String(posX+1) + '-' + String(posY)] = true;
            _objBuildingsDiagonals[String(posX+sizeX-1) + '-' + String(posY) + '-' + String(posX+sizeX) + '-' + String(posY+1)] = true;
            _objBuildingsDiagonals[String(posX) + '-' + String(posY+sizeY-1) + '-' + String(posX+1) + '-' + String(posY+sizeY)] = true;
            _objBuildingsDiagonals[String(posX+sizeX-1) + '-' + String(posY+sizeY) + '-' + String(posX+sizeX) + '-' + String(posY+sizeY-1)] = true;
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

        if (sizeX > 1 && sizeY > 1) {  // write coordinate left->right && top->down
            delete _objBuildingsDiagonals[String(posX) + '-' + String(posY+1) + '-' + String(posX+1) + '-' + String(posY)];
            delete _objBuildingsDiagonals[String(posX+sizeX-1) + '-' + String(posY) + '-' + String(posX+sizeX) + '-' + String(posY+1)];
            delete _objBuildingsDiagonals[String(posX) + '-' + String(posY+sizeY-1) + '-' + String(posX+1) + '-' + String(posY+sizeY)];
            delete _objBuildingsDiagonals[String(posX+sizeX-1) + '-' + String(posY+sizeY) + '-' + String(posX+sizeX) + '-' + String(posY+sizeY-1)];
        }
    }

    public function fillTailMatrix(posX:int, posY:int, source:WorldObject):void {
         _townTailMatrix[posY][posX].build = source;
    }

    public function unFillTailMatrix(posX:int, posY:int):void {
        _townTailMatrix[posY][posX].build = null;
    }

    public function fillMatrixWithFence(posX:int, posY:int, source:*):void {
        for (var i:int = posY; i < (posY + 2); i++) {
            for (var j:int = posX; j < (posX + 2); j++) {
                _townMatrix[i][j].isFull = true;
                if (i == posY && j == posX)
                    _townMatrix[i][j].buildFence = source;
            }
        }
    }

    public function unFillMatrixWithFence(posX:int, posY:int):void {
        for (var i:int = posY; i < (posY + 2); i++) {
            for (var j:int = posX; j < (posX + 2); j++) {
                _townMatrix[i][j].buildFence = null;
                _townMatrix[i][j].isFull = false;
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
        if (_cityObjects.indexOf(c) > -1) _cityObjects.slice(_cityObjects.indexOf(c), 1);
        if (_cont.contains(c.source))
            _cont.removeChild(c.source);
    }

    public function createNewBuild(_data:Object, dbId:int = 0):AreaObject {
        var build:AreaObject;

        if (!_data) {
            Cc.error('TownArea createNewBuild:: _data == nul for building');
            g.woGameError.showIt();
            return null;
        }

        if (dbId == 0 && _data.buildType == BuildType.FABRICA && !g.user.userBuildingData[_data.id]) {    // что означает, что через магазин купили и поставили новую фабрику
            var ob:Object = {};
            ob.dbId = int(Math.random()*100000);
            ob.timeBuildBuilding = 0;
            ob.isOpen = 0;
            g.user.userBuildingData[_data.id] = ob;
        }

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
            return null;
        }
        (build as WorldObject).dbBuildingId = dbId;

        if (_data.isFlip) {
            (build as AreaObject).makeFlipBuilding();
        }

        return build;
    }

    public function pasteBuild(worldObject:WorldObject, _x:Number, _y:Number, isNewAtMap:Boolean = true, updateAfterMove:Boolean = false, decorCost:Boolean = false):void {
        var point:Point;
        if (!worldObject) {
            Cc.error('TownArea pasteBuild:: empty worldObject');
            g.woGameError.showIt();
            return;
        }

        g.selectedBuild = null;
        if (_cont.contains(worldObject.source)) {
            _cont.removeChild(worldObject.source);
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
                        fillTailMatrix(jk, ik, worldObject);
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
            if (worldObject is Ridge)
                g.managerPlantRidge.addRidge(worldObject as Ridge);
        }

        if (updateAfterMove) {
            if (g.isActiveMapEditor) {
                if (worldObject is Ambar || worldObject is Sklad || worldObject is Order || worldObject is Shop || worldObject is Market ||
                        worldObject is Cave || worldObject is Paper || worldObject is Train || worldObject is DailyBonus) {
                    g.directServer.ME_moveMapBuilding(worldObject.dataBuild.id, worldObject.posX, worldObject.posY, null);
                }
            } else {
                g.directServer.updateUserBuildPosition(worldObject.dbBuildingId, worldObject.posX, worldObject.posY, null);
            }
        }

        if (isNewAtMap && g.managerTutorial.isTutorial) {
            if (worldObject is Fabrica && g.managerTutorial.currentAction == TutorialAction.PUT_FABRICA) {
                g.managerTutorial.addTutorialWorldObject(worldObject);
                g.managerTutorial.checkTutorialCallback();
            } else if (worldObject is Ridge && g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE) {
                g.managerTutorial.checkTutorialCallback();
            }
        }

        // временно полная сортировка, далее нужно будет дописать "умную"
        if (updateAfterMove) zSort();

        if (g.managerTutorial.isTutorial) return;
        if (isNewAtMap && (worldObject is Ridge || worldObject is Tree || worldObject is Decor || worldObject is DecorFence || worldObject is DecorPostFence || worldObject is DecorTail)) {
            var build:AreaObject;
            if (g.userInventory.decorInventory[worldObject.dataBuild.id]) {
                build = createNewBuild(worldObject.dataBuild);
                g.selectedBuild = build;
                (build as WorldObject).source.filter = null;
                g.toolsModifier.startMove(build, afterMoveFromInventory, true);
                return;
            }
            if (decorCost) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.bottomPanel.cancelBoolean(false);
                g.buyHint.hideIt();
                g.toolsModifier.startMove(build, afterMove, true);
                g.woShop.showIt();
                return;
            }
            var arr:Array;
            if (worldObject is DecorTail) {
                arr = getCityTailObjectsById(worldObject.dataBuild.id);
                if (g.user.softCurrencyCount < (arr.length * worldObject.dataBuild.deltaCost) + int(worldObject.dataBuild.cost)) {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.bottomPanel.cancelBoolean(false);
                    g.buyHint.hideIt();
                    return;
                }

            } else {
                arr = getCityObjectsById(worldObject.dataBuild.id);
                    if (g.user.softCurrencyCount < (arr.length * worldObject.dataBuild.deltaCost) + int(worldObject.dataBuild.cost)) {
                        g.toolsModifier.modifierType = ToolsModifier.NONE;
                        g.bottomPanel.cancelBoolean(false);
                        g.buyHint.hideIt();
                        return;
                    }
            }
            if (g.user.softCurrencyCount < worldObject.dataBuild.cost) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.bottomPanel.cancelBoolean(false);
                return;
            }
            g.bottomPanel.cancelBoolean(true);
            if (worldObject is Ridge) {
                g.toolsModifier.modifierType = ToolsModifier.ADD_NEW_RIDGE;
            } else if (worldObject is Tree) {
                g.toolsModifier.modifierType = ToolsModifier.PLANT_TREES;
            } else if (worldObject is Decor || worldObject is DecorFence || worldObject is DecorPostFence || worldObject is DecorTail) {
                g.toolsModifier.modifierType = ToolsModifier.MOVE;
                    g.buyHint.showIt((arr.length * worldObject.dataBuild.deltaCost) + int(worldObject.dataBuild.cost));
                    build = createNewBuild(worldObject.dataBuild);
                    g.selectedBuild = build;
                    (build as WorldObject).source.filter = null;
                    g.toolsModifier.startMove(build, afterMoveReturn, true);
                    return;
            }
            var curCount:int;
            var maxCount:int;
            var maxCountAtCurrentLevel:int = 0;
            arr = getCityObjectsById(worldObject.dataBuild.id);
            curCount = arr.length;
            for (i = 0; worldObject.dataBuild.blockByLevel.length; i++) {
                if (worldObject.dataBuild.blockByLevel[i] <= g.user.level) {
                    maxCountAtCurrentLevel++;
                } else break;
            }
            maxCount = maxCountAtCurrentLevel * worldObject.dataBuild.countUnblock;
            if (curCount >= maxCount) {
                g.bottomPanel.cancelBoolean(false);
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                return;
            }
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            build = createNewBuild(worldObject.dataBuild);
            g.selectedBuild = build;
            if (build is Tree) (build as Tree).showShopView();
            (build as WorldObject).source.filter = null;
            g.toolsModifier.startMove(build, afterMoveReturn, true);
        }
    }

    public function afterMoveFromInventory(build:AreaObject, _x:Number, _y:Number):void { // для декора из инвентаря
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
        g.toolsPanel.repositoryBox.updateThis();
    }

    private function afterMoveReturn(build:AreaObject, _x:Number, _y:Number):void {   // юзали для автоматической покупки грядок и деревьев
        (build as WorldObject).source.filter = null;
        var cost:int;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (build is Tree) (build as Tree).removeShopView();
        if (build is Decor || build is DecorFence || build is DecorPostFence) {
            arr = getCityObjectsById((build as WorldObject).dataBuild.id);
            cost = arr.length * (build as WorldObject).dataBuild.deltaCost + int((build as WorldObject).dataBuild.cost);
            if (g.user.softCurrencyCount < cost) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.bottomPanel.cancelBoolean(false);
                g.buyHint.hideIt();
                return;
            }
        } else if (build is DecorTail) {
            arr = getCityTailObjectsById((build as WorldObject).dataBuild.id);
            cost = arr.length * (build as WorldObject).dataBuild.deltaCost + int((build as WorldObject).dataBuild.cost);
            if (g.user.softCurrencyCount < cost ) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.bottomPanel.cancelBoolean(false);
                g.buyHint.hideIt();
                return;
            }
        }
        pasteBuild(build, _x, _y);
        if (build is Ridge) showSmallBuildAnimations(build,(build as WorldObject).dataBuild.currency,-(build as WorldObject).dataBuild.cost);
        var arr:Array;
        if (build is Decor || build is DecorFence || build is DecorPostFence) {
            arr = getCityObjectsById((build as WorldObject).dataBuild.id);
            cost = (arr.length-1) * (build as WorldObject).dataBuild.deltaCost + int((build as WorldObject).dataBuild.cost);
            if (g.user.softCurrencyCount < cost) {
                return;
            }
            showSmallBuildAnimations(build,(build as WorldObject).dataBuild.currency,-cost);
            g.userInventory.addMoney((build as WorldObject).dataBuild.currency, -cost);
        } else if (build is DecorTail) {
            arr = getCityTailObjectsById((build as WorldObject).dataBuild.id);
            cost = (arr.length-1) * (build as WorldObject).dataBuild.deltaCost + int((build as WorldObject).dataBuild.cost);
            if (g.user.softCurrencyCount < cost) {
                return;
            }
            showSmallBuildAnimations(build,(build as WorldObject).dataBuild.currency,-cost);
            g.userInventory.addMoney((build as WorldObject).dataBuild.currency, -cost);

        } else {
            g.userInventory.addMoney((build as WorldObject).dataBuild.currency, -(build as WorldObject).dataBuild.cost);
        }
    }

    private function showSmallBuildAnimations(b:AreaObject, moneyType:int, count:int):void {
        var p:Point = new Point((b as WorldObject).source.x, (b as WorldObject).source.y);
        p = g.cont.contentCont.localToGlobal(p);
        new UseMoneyMessage(p, moneyType, count, .3);
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
        g.selectedBuild = null;
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
            unFillMatrixWithFence(worldObject.posX, worldObject.posY);
        } else {
            unFillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
        }
        if (worldObject is Wild || worldObject is LockedLand) {
            for (var ik:int = worldObject.posY; ik < (worldObject.posY + worldObject.sizeY); ik++) {
                for (var jk:int = worldObject.posX; jk < (worldObject.posX + worldObject.sizeX); jk++) {
                    unFillTailMatrix(jk, ik);
                }
            }
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
        if(_contTail.contains(tail.source)){
            _contTail.removeChild(tail.source);
        }
        unFillTailMatrix(tail.posX, tail.posY);
        if (_cityTailObjects.indexOf(tail) > -1) _cityTailObjects.splice(_cityTailObjects.indexOf(tail), 1);
        tail.clearIt();
    }

    public function moveBuild(worldObject:WorldObject):void{
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
                unFillMatrixWithFence(worldObject.posX, worldObject.posY);
            } else {
                if (g.selectedBuild.useIsometricOnly) {
                    unFillMatrix(worldObject.posX, worldObject.posY, worldObject.sizeX, worldObject.sizeY);
                }
            }
            g.toolsModifier.startMove(worldObject as AreaObject, afterMove);
        }
    }


    private function afterMove(build:AreaObject, _x:Number, _y:Number):void {
        pasteBuild(build, _x, _y, false, true);
        g.selectedBuild = null;
        if (build is Farm) (build as Farm).checkAfterMove();
        if (build is Ridge) (build as Ridge).checkAfterMove();
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
            g.toolsModifier.startMoveTail(tail as AreaObject, afterMoveTail);
        }
    }

    private function afterMoveTail(build:AreaObject,_x:Number, _y:Number):void {
        pasteTailBuild(build as DecorTail, _x, _y, false, true);
        g.selectedBuild = null;
    }

    private function addFenceLenta(d:DecorPostFence):void {
        // проверяем, есть ли по соседству еще столбы забора, если да - то проводим между ними ленту
        var obj:Object;

        if (_townMatrix[d.posY][d.posX-2]) {
            obj = _townMatrix[d.posY][d.posX - 2];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                obj.buildFence.addRightLenta();
        }
        if (_townMatrix[d.posY-2]) {
            obj = _townMatrix[d.posY - 2][d.posX];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                obj.buildFence.addLeftLenta();
        }
        if (_townMatrix[d.posY][d.posX+2]) {
            obj = _townMatrix[d.posY][d.posX + 2];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                d.addRightLenta();
        }
        if (_townMatrix[d.posY+2]) {
            obj = _townMatrix[d.posY + 2][d.posX];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence && (obj.buildFence as DecorPostFence).dataBuild.id == d.dataBuild.id)
                d.addLeftLenta();
        }
    }

    private function removeFenceLenta(d:DecorPostFence):void {
        // проверяем, есть ли по соседству еще столбы забора, если да - то забираем между ними ленту
        var obj:Object;

        if (_townMatrix[d.posY][d.posX-2]) {
            obj = _townMatrix[d.posY][d.posX - 2];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence)
                obj.buildFence.removeRightLenta();
        }
        if (_townMatrix[d.posY-2]) {
            obj = _townMatrix[d.posY - 2][d.posX];
            if (obj && obj.inGame && obj.buildFence && obj.buildFence is DecorPostFence)
                obj.buildFence.removeLeftLenta();
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
        g.awayPreloader.showIt(false);
        g.visitedUser = person;
        if (g.isAway) {
            clearAwayCity();
        } else {
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
        sortAwayAtLockedLands();
        g.awayPreloader.hideIt();
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
                    _data.dbId = dbId;
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
            (build as AreaObject).makeFlipBuilding();
        }
    }

    public function pasteAwayBuild(worldObject:WorldObject, posX:Number, posY:Number):void {
        if (!worldObject) {
            Cc.error('TownArea pasteAwayBuild:: empty worldObject');
            g.woGameError.showIt();
            return;
        }

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
            var point:Point = g.matrixGrid.getXYFromIndex(new Point(posX, posY));
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
            g.woGameError.showIt();
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

    public function zAwaySort():void {
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

    public function sortAwayAtLockedLands():void {
        for (var i:int = 0; i < _cityAwayObjects.length; i++) {
            if (_cityAwayObjects[i] is LockedLand) (_cityAwayObjects[i] as LockedLand).sortWilds();
        }
    }

    public function backHome():void {
        g.awayPreloader.showIt(true);
        clearAwayCity();
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
        g.awayPreloader.hideIt();
    }

    private function clearAwayCity():void {
        for (var i:int = 0; i < _cityAwayObjects.length; i++) {
            if (_cityAwayObjects[i] is BasicCat || _cityAwayObjects[i] is OrderCat) continue;
            _cont.removeChild(_cityAwayObjects[i].source);
            (_cityAwayObjects[i] as AreaObject).clearIt();
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
        for (var i:int=0; i<_cityObjects.length; i++) {
            if (_cityObjects[i] is Order || _cityObjects[i] is Wild || _cityObjects[i] is LockedLand || _cityObjects[i] is Paper || _cityObjects[i] is Cave
                    || _cityObjects[i] is DailyBonus || _cityObjects[i] is Train || _cityObjects[i] is Market) {
                if (g.isActiveMapEditor) return;
                v ? _cityObjects[i].source.alpha = .5 : _cityObjects[i].source.alpha = 1;
                (_cityObjects[i].source as CSprite).isTouchable = !v;
            }
            if (_cityObjects[i] is Farm) {
                (_cityObjects[i] as Farm).onActivateMoveModifier(v);
            }
        }
    }

    public function onActivateRotateModifier(v:Boolean):void {
        for (var i:int=0; i<_cityObjects.length; i++) {
            if (_cityObjects[i] is Order || _cityObjects[i] is Wild || _cityObjects[i] is LockedLand || _cityObjects[i] is Paper || _cityObjects[i] is Cave
                    || _cityObjects[i] is DailyBonus || _cityObjects[i] is Train || _cityObjects[i] is Market) {
                if (g.isActiveMapEditor) return;
                v ? _cityObjects[i].source.alpha = .5 : _cityObjects[i].source.alpha = 1;
                (_cityObjects[i].source as CSprite).isTouchable = !v;
            }
            if (_cityObjects[i] is Farm) {
                (_cityObjects[i] as Farm).onActivateMoveModifier(v);
            }
        }
    }

    public function onActivateInventoryModifier(v:Boolean):void {
        for (var i:int=0; i<_cityObjects.length; i++) {
            if (_cityObjects[i] is Order || _cityObjects[i] is Wild || _cityObjects[i] is Ridge || _cityObjects[i] is Farm ||
                _cityObjects[i] is Fabrica || _cityObjects[i] is Tree || _cityObjects[i] is Ambar || _cityObjects[i] is Sklad  ||
                    _cityObjects[i] is Paper || _cityObjects[i] is Cave || _cityObjects[i] is DailyBonus || _cityObjects[i] is Train || _cityObjects[i] is Market || _cityObjects[i] is LockedLand) {
                v ? _cityObjects[i].source.alpha = .5 : _cityObjects[i].source.alpha = 1;
                (_cityObjects[i].source as CSprite).isTouchable = !v;
            }
        }
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