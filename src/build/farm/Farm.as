/**
 * Created by andy on 5/28/15.
 */
package build.farm {
import build.AreaObject;

import com.junkbyte.console.Cc;
import flash.geom.Point;
import heroes.FarmCat;
import mouse.ToolsModifier;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.utils.Color;

import ui.xpPanel.XPStar;
import utils.CSprite;
import utils.MCScaler;

public class Farm extends AreaObject{
//    private var _house:CSprite;
    private var _dataAnimal:Object;
    private var _arrAnimals:Array;
    private var _contAnimals:Sprite;
    private var _farmCat:FarmCat;

    public function Farm(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Farm');
            g.woGameError.showIt();
            return;
        }
        createBuild();

        _dataBuild.isFlip = _flip;
        _source.endClickCallback = onClick;

//        _house = new CSprite();
//        var im:Image = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.imageHouse));
//        _house.addChild(im);
//        _house.x = _dataBuild.innerHouseX;
//        _house.y = _dataBuild.innerHouseY;
//        _source.addChild(_house);
//        if (!g.isAway) {
//            _house.hoverCallback = onHoverHouse;
//            _house.endClickCallback = onClickHouse;
//            _house.outCallback = onOutHouse;
//        }
        _source.releaseContDrag = true;

        _contAnimals = new Sprite();
        source.addChild(_contAnimals);

        _craftSprite = new Sprite();
        _craftSprite.y = 160;
        _source.addChild(_craftSprite);

        _arrAnimals = [];

        setDataAnimal();
        if (!g.isAway) {
            if (_dataAnimal.id != 6) {
                g.gameDispatcher.addEnterFrame(sortAnimals);
            }
        }
    }

//    private function onHoverHouse():void {
//        _house.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1);
//    }

//    private function onClickHouse():void {
//        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
//            g.townArea.moveBuild(this);
//        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
//            g.townArea.deleteBuild(this);
//        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
//            releaseFlip();
//        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
//            // ничего не делаем
//        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
//            // ничего не делаем вообще
//        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
//            g.toolsModifier.modifierType = ToolsModifier.NONE;
//        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
//            if (!isFull) {
//                g.farmHint.showIt(_source.x, _source.y + _dataBuild.innerHouseY + 15, _dataAnimal, onHintClick);
//                _house.filter = null;
//            }
//        } else {
//            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
//        }
//    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            g.townArea.moveBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            // ничего не делаем
        } else {
            Cc.error('Farm:: unknown g.toolsModifier.modifierType')
        }
    }

//    private function onOutHouse():void {
//        _house.filter = null;
//        var f:Function = function():void {
//            g.farmHint.hideIt();
//            g.gameDispatcher.removeFromTimer(f);
//        };
//        g.gameDispatcher.addToTimer(f);
//    }

    private function setDataAnimal():void {
        try {
            for (var id:String in g.dataAnimal.objectAnimal) {
                if (g.dataAnimal.objectAnimal[id].buildId == _dataBuild.id) {
                    _dataAnimal = g.dataAnimal.objectAnimal[id];
                    break;
                }
            }
        } catch (e:Error) {
            Cc.error('farm setDataAnimalError: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

//    private function onHintClick():void {
//        if (!isFull) addAnimal();
//    }

    public function addAnimal(isFromServer:Boolean = false, ob:Object = null):void {
        try {
            var an:Animal = new Animal(_dataAnimal, this);
            MCScaler.scale(an.source, 80, 80);
            var p:Point = g.farmGrid.getRandomPoint();
            an.source.x = p.x;
            an.source.y = p.y;
            _contAnimals.addChild(an.source);
            _arrAnimals.push(an);
            if (!isFromServer) {
                g.directServer.addUserAnimal(an, _dbBuildingId, null);
            } else {
                an.fillItFromServer(ob);
            }
            if (_dataAnimal.id != 6) {
                an.addRenderAnimation();
                sortAnimals();
            }
        } catch (e:Error) {
            Cc.error('farm addAnimal: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    public function get isFull():Boolean {
        return _arrAnimals.length >= _dataBuild.maxAnimalsCount;
    }

    override public function addXP():void {
        if (_dataBuild.xpForBuild) {
            var start:Point = new Point(int(_source.x), int(_source.y));
            start = _source.parent.localToGlobal(start);
            new XPStar(start.x, start.y, _dataBuild.xpForBuild);
        }
    }

    public function get arrAnimals():Array {
        return _arrAnimals;
    }

    private var counter:int = 0;
    private var arr:Array;
    private function sortAnimals():void {
        counter--;
        if (counter <= 0) {
            arr = _arrAnimals;
            if (_farmCat) arr.push(_farmCat);
            if (arr.length > 1) {
                arr.sortOn('depth', Array.NUMERIC);
                for (var i:int = 0; i < arr.length; i++) {
                    _contAnimals.setChildIndex(arr[i].source, i);
                }
            }
            counter = 15;
        }
    }

    override public function clearIt():void {
        _source.touchable = false;
//        _house.touchable = false;
//        while (_house.numChildren) _house.removeChildAt(0);
        while (_contAnimals.numChildren) _contAnimals.removeChildAt(0);
        g.gameDispatcher.removeEnterFrame(sortAnimals);
        for (var i:int=0; i<_arrAnimals.length; i++) {
            _arrAnimals[i].clearIt();
        }
//        _house = null;
        _contAnimals = null;
        _dataAnimal = null;
        _arrAnimals.length = 0;
        super.clearIt();
    }

    public function readyAnimal(an:Animal):void {
        var countNotWorkedAnimals:int = 0;
        for (var i:int=0; i<_arrAnimals.length; i++) {
            if ((_arrAnimals[i] as Animal).state != Animal.WORKED) ++countNotWorkedAnimals;
        }
        if (countNotWorkedAnimals == _arrAnimals.length) {
            stopAnimateCat();
            g.managerAnimal.freeFarmCat(_dbBuildingId);
        }
    }

    public function startAnimateCat():void {
        if (!_farmCat && !g.isAway) {
            _farmCat = new FarmCat();
            var p:Point = g.farmGrid.getZeroPoint();
            _farmCat.source.x = p.x;
            _farmCat.source.y = p.y;
            _contAnimals.addChild(_farmCat.source);
            _farmCat.startFarmAnimation();
        }
    }

    public function stopAnimateCat():void {
        if (_farmCat && !g.isAway) {
            _farmCat.clearIt();
            if (_contAnimals.contains(_farmCat.source)) _contAnimals.removeChild(_farmCat.source);
            _farmCat = null;
        }
    }
}
}
