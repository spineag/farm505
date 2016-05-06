/**
 * Created by andy on 5/28/15.
 */
package build.farm {
import build.AreaObject;

import com.junkbyte.console.Cc;
import flash.geom.Point;

import manager.ManagerFilters;

import mouse.ToolsModifier;

import particle.FarmFeedParticles;

import resourceItem.CraftItem;

import resourceItem.ResourceItem;

import starling.display.Image;
import starling.display.Sprite;

import tutorial.TutorialAction;

import ui.xpPanel.XPStar;

import windows.WindowsManager;

public class Farm extends AreaObject{
    private var _dataAnimal:Object;
    private var _arrAnimals:Array;
    private var _contAnimals:Sprite;
    private var _imageBottom:Image;
    private var _arrCrafted:Array;

    public function Farm(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Farm');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Farm');
            return;
        }
        setDataAnimal();
        createBuild();

        _source.endClickCallback = onClick;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _hitArea = g.managerHitArea.getHitArea(_source, 'farm' + _dataBuild.image);
        _source.registerHitArea(_hitArea);

        _contAnimals = new Sprite();
        source.addChild(_contAnimals);
        if (_dataAnimal.id != 6) {
            try {
                _imageBottom = new Image(g.allData.atlas[_data.url].getTexture(_data.image + '2'));
                if (_dataAnimal.id == 1) {
                    _imageBottom.x = -290 * g.scaleFactor;
                    _imageBottom.y = 67 * g.scaleFactor;
                } else {
                    _imageBottom.x = -338 * g.scaleFactor;
                    _imageBottom.y = 88 * g.scaleFactor;
                }
                _imageBottom.touchable = false;
                _source.addChild(_imageBottom);
            } catch (e:Error) {
                Cc.error('Farm:: no image: ' + _data.image + '2');
            }
        }
        _craftSprite = new Sprite();
        _craftSprite.y = 320*g.scaleFactor;
        _source.addChild(_craftSprite);
        _arrAnimals = [];
        _arrCrafted = [];

        if (!g.isAway) {
            if (_dataAnimal.id != 6) {
                g.gameDispatcher.addEnterFrame(sortAnimals);
            }
        }
    }

    private function onHover():void {
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        if (g.selectedBuild) return;
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            _source.filter = ManagerFilters.BUILD_STROKE;
        } else {
            if (_arrCrafted.length) {
                _craftSprite.filter = ManagerFilters.BUILD_STROKE;
            }
        }
    }

    private function onOut():void {
        if (g.isActiveMapEditor) return;
        _source.filter = null;
        _craftSprite.filter = null;
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction == TutorialAction.ANIMAL_CRAFT) {

            } else if (g.managerTutorial.currentAction != TutorialAction.PUT_FARM) {
                if (!g.managerTutorial.isTutorialBuilding(this)) return;
            }
        }
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                onOut();
                checkBeforeMove();
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            //g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_arrCrafted.length) {
                if (g.userInventory.currentCountInSklad + _arrCrafted[0].count > g.user.skladMaxCount) {
                    onOut();
                    g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, false);
                } else {
                    var item:CraftItem = _arrCrafted.pop();
                    item.flyIt();
                    checkForCraft();
                }
            }
        } else {
            Cc.error('Farm:: unknown g.toolsModifier.modifierType')
        }
    }

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
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'farm setDataAnimal');
        }
    }

    public function get dataAnimal():Object {
        return _dataAnimal;
    }

    public function addAnimal(isFromServer:Boolean = false, ob:Object = null):void {
//        try {
            var p:Point;
            var an:Animal = new Animal(_dataAnimal, this);
            _arrAnimals.push(an);
            if (_dataAnimal.id == 6) {
                p = new Point();
                if (_arrAnimals.length == 1) {
                    p.x = 4 * g.scaleFactor;
                    p.y = 125 * g.scaleFactor;
                } else  if (_arrAnimals.length == 2) {
                    p.x = 177 * g.scaleFactor;
                    p.y = 208 * g.scaleFactor;
                } else if (_arrAnimals.length == 3) {
                    p.x = -165 * g.scaleFactor;
                    p.y = 214 * g.scaleFactor;
                } else {
                    p.x = 7 * g.scaleFactor;
                    p.y = 297 * g.scaleFactor;
                }
            } else {
                p = g.farmGrid.getRandomPoint();
            }
            an.source.x = p.x;
            an.source.y = p.y;
            _contAnimals.addChild(an.source);
            if (!isFromServer) {
                g.directServer.addUserAnimal(an, _dbBuildingId, null);
            } else {
                an.fillItFromServer(ob);
            }
            an.addRenderAnimation();
            if (_dataAnimal.id != 6) {
                sortAnimals();
            }
//        } catch (e:Error) {
//            Cc.error('farm addAnimal: ' + e.errorID + ' - ' + e.message);
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'farm add animal');
//        }
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
        if (counter <= 0 || g.isAway) {
            arr = _arrAnimals.slice();
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
        while (_contAnimals.numChildren) _contAnimals.removeChildAt(0);
        g.gameDispatcher.removeEnterFrame(sortAnimals);
        for (var i:int=0; i<_arrAnimals.length; i++) {
            _arrAnimals[i].clearIt();
        }
        _contAnimals = null;
        _dataAnimal = null;
        _arrAnimals.length = 0;
        super.clearIt();
        if (_imageBottom) _imageBottom.dispose();
    }

    public function readyAnimal():void {
        var countNotWorkedAnimals:int = 0;
        for (var i:int=0; i<_arrAnimals.length; i++) {
            if ((_arrAnimals[i] as Animal).state != Animal.WORK) countNotWorkedAnimals++;
        }
        if (countNotWorkedAnimals >= _arrAnimals.length) {
            g.managerAnimal.freeFarmCat(_dbBuildingId);
        }
    }

    public function showParticles(p:Point, isFromLeftSide:Boolean):void {
        var tempCont:Sprite = new Sprite();
        var particles:FarmFeedParticles;
        _source.addChild(tempCont);
        p = tempCont.globalToLocal(p);

        var onFinish:Function = function():void {
            tempCont.removeChild(particles.source);
            particles.source.dispose();
            particles = null;
            _source.removeChild(tempCont);
            tempCont = null;
        };
        particles = new FarmFeedParticles(onFinish);
        particles.source.x = p.x;
        particles.source.y = p.y;
        if (!isFromLeftSide) {
            if (!_flip)
                particles.source.scaleX = -1;
        } else {
            if (_flip)
                particles.source.scaleX = -1;
        }
        tempCont.addChild(particles.source);
    }

    public function onActivateMoveModifier(v:Boolean):void {
        var i:int;
        if (v) {
            if (_arrCrafted.length) return;
            for (i=0; i<_arrAnimals.length; i++) {
                (_arrAnimals[i] as Animal).source.isTouchable = false;
            }
        } else {
            if (!_arrCrafted.length) {
                for (i = 0; i < _arrAnimals.length; i++) {
                    (_arrAnimals[i] as Animal).source.isTouchable = true;
                }
            }
        }
    }

    private function checkForCraft():void {
        var i:int;
        if (_arrCrafted.length) {
            for (i=0; i<_arrAnimals.length; i++) {
                (_arrAnimals[i] as Animal).source.isTouchable = false;
            }
        } else {
            for (i=0; i<_arrAnimals.length; i++) {
                (_arrAnimals[i] as Animal).source.isTouchable = true;
                _craftSprite.filter = null;
            }
        }
    }

    public function onAnimalReadyToCraft(idResource:int, onCraftCallback:Function):void {
        var rItem:ResourceItem = new ResourceItem();
        rItem.fillIt(g.dataResource.objectResources[idResource]);
        var item:CraftItem = new CraftItem(0, -70, rItem, craftSprite, 1, onCraftCallback, true);
        item.removeDefaultCallbacks();
        item.addParticle();
        _arrCrafted.push(item);
        checkForCraft();
    }

    public function addArrowToCraftItem(f:Function):void {
        if (_arrCrafted.length) {
            (_arrCrafted[0] as CraftItem).addArrow(f);
        }
    }

    public function get hasAnyCraftedResource():Boolean {
        return _arrCrafted.length > 0;
    }

    private function checkBeforeMove():void {
        g.managerAnimal.onFarmStartMove(_dbBuildingId);
    }

    public function checkAfterMove():void {
        g.managerAnimal.onFarmFinishMove(this);
    }
}
}
