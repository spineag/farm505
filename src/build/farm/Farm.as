/**
 * Created by andy on 5/28/15.
 */
package build.farm {
import build.AreaObject;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import flash.media.SoundChannel;

import map.TownArea;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CSprite;
import utils.MCScaler;

public class Farm extends AreaObject{
    private var _house:CSprite;
    private var _dataAnimal:Object;
    private var _arrAnimals:Array;

    public function Farm(_data:Object) {
        super(_data);
        createBuild();

        _dataBuild.isFlip = _flip;
        _source.endClickCallback = onClick;

        _house = new CSprite();
        var im:Image = new Image(g.tempBuildAtlas.getTexture(_dataBuild.imageHouse));
        _house.addChild(im);
        _house.x = _dataBuild.innerHouseX;
        _house.y = _dataBuild.innerHouseY;
        _source.addChild(_house);
        _house.hoverCallback = onHoverHouse;
        _house.endClickCallback = onClickHouse;
        _house.outCallback = onOutHouse;
        _source.releaseContDrag = true;

        _craftSprite = new Sprite();
        _craftSprite.y = 80;
        _source.addChild(_craftSprite);

        _arrAnimals = [];
        setDataAnimal();
    }

    private function onHoverHouse():void {
        _house.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1);
    }

    private function onClickHouse():void {
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
            if (!isFull) {
                g.farmHint.showIt(_source.x, _source.y + _dataBuild.innerHouseY + 15, _dataAnimal, onHintClick);
                _house.filter = null;
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

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

    private function onOutHouse():void {
        _house.filter = null;
        var f:Function = function():void {
            g.farmHint.hideIt();
            g.gameDispatcher.removeFromTimer(f);
        };
        g.gameDispatcher.addToTimer(f);
    }

    private function setDataAnimal():void {
        for (var id:String in g.dataAnimal.objectAnimal) {
            if (g.dataAnimal.objectAnimal[id].buildId == _dataBuild.id) {
                _dataAnimal = g.dataAnimal.objectAnimal[id];
                break;
            }
        }
    }

    private function onHintClick():void {
        if (!isFull) addAnimal();
    }

    public function addAnimal(isFromServer:Boolean = false, ob:Object = null):void {
        var an:Animal = new Animal(_dataAnimal, this);
        MCScaler.scale(an.source, 50, 50);
        an.source.x = (1/2 - Math.random()) * _source.width/2;
        an.source.y = (1 - Math.random()/2) * _source.height/2;
        _source.addChildAt(an.source, _source.numChildren-2);
        _arrAnimals.push(an);
        if (!isFromServer) {
            g.directServer.addUserAnimal(an, _dbBuildingId, null);
        } else {
            an.fillItFromServer(ob);
        }
//        checkAnimalsZindex();
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
}
}
