/**
 * Created by user on 6/19/15.
 */
package build.farm {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import flash.geom.Point;

import hint.MouseHint;

import manager.Vars;

import resourceItem.CraftItem;
import resourceItem.RawItem;
import resourceItem.ResourceItem;

import starling.display.Image;
import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.CSprite;

public class Animal {
    public static var EMPTY:int = 1;
    public static var WORKED:int = 2;
    public static var CRAFT:int = 3;
    private const WALK_SPEED:int = 20;

    public var source:CSprite;
    private var _image:Image;
    private var _data:Object;
    private var _timeToEnd:int;
    private var _state:int;
    private var _frameCounterTimerHint:int;
    private var _frameCounterMouseHint:int;
    private var _isOnHover:Boolean;
    private var _farm:Farm;
    private var _defautScale:Number;
    public var animal_db_id:String;  // id в табличке user_animal

    private var g:Vars = Vars.getInstance();

    public function Animal(data:Object, farm:Farm) {
        if (!data) {
            Cc.error('no data for Animal');
            g.woGameError.showIt();
            return;
        }
        _farm = farm;
        source = new CSprite();
        _data = data;
        _isOnHover = false;

        try {
            _image = new Image(g.allData.atlas[_data.url].getTexture(_data.image));
            _image.pivotX = _image.width / 2;
            _image.pivotY = _image.height;
            source.addChild(_image);
        } catch (e:Error) {
            Cc.error('no image for Animal: ' + _data.image);
            g.woGameError.showIt();
            return;
        }

        _state = EMPTY;
        _defautScale = source.scaleX;

        if (!g.isAway) {
            source.hoverCallback = onHover;
            source.outCallback = onOut;
            source.endClickCallback = onClick;
        }
    }

    public function get state():int {
        return _state;
    }

    public function fillItFromServer(ob:Object):void {
        if (ob.id) animal_db_id = ob.id;
            else animal_db_id = '0';
        if (int(ob.time_work) > 0) {
            if (int(ob.time_work) > _data.timeCraft) {
                craftResource();
                _state = CRAFT;
            } else {
                _timeToEnd = _data.timeCraft - int(ob.time_work);
                _state = WORKED;
                if (!g.isAway) {
                    g.managerAnimal.addCatToFarm(_farm);
                    g.gameDispatcher.addToTimer(render);
                }
            }
        } else {
            _state = EMPTY;
        }
    }

    public function render():void {
        _timeToEnd--;
        if (_timeToEnd <=0) {
            g.gameDispatcher.removeFromTimer(render);
            craftResource();
            _state = CRAFT;
            _farm.readyAnimal(this);
            addRenderAnimation();
        }
    }

    private function craftResource():void {
        var rItem:ResourceItem = new ResourceItem();
        rItem.fillIt(g.dataResource.objectResources[_data.idResource]);
        var item:CraftItem = new CraftItem(0, 0, rItem, _farm.craftSprite, 1, onCraft, true);
    }

    private function onCraft():void {
        _state = EMPTY;
        addRenderAnimation();
        if (g.useDataFromServer) g.directServer.craftUserAnimal(animal_db_id, null);
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
        if (_state == EMPTY) {
            source.filter = null;
            if(g.userInventory.getCountResourceById(_data.idResourceRaw) < 1) {
                g.woNoResources.showItMenu(_data,1,onClick);
            return;
            }
            if (g.managerAnimal.checkIsCat(_farm.dbBuildingId)) {
                var rawItem:RawItem;
                g.userInventory.addResource(_data.idResourceRaw, -1);
                _timeToEnd = _data.timeCraft;
                g.gameDispatcher.addToTimer(render);
                _state = WORKED;
//                g.managerAnimal.addCatToFarm(_farm);
                var p:Point = new Point(source.x, source.y);
                p = source.parent.localToGlobal(p);
                rawItem = new RawItem(p, g.allData.atlas[g.dataResource.objectResources[_data.idResourceRaw].url].getTexture(g.dataResource.objectResources[_data.idResourceRaw].imageShop), 1, 0);
                if (g.useDataFromServer) g.directServer.rawUserAnimal(animal_db_id, null);
                addRenderAnimation();
            } else {
                if (g.managerCats.curCountCats == g.managerCats.maxCountCats) {
                    g.woWaitFreeCats.showIt();
                } else {
                    g.woNoFreeCats.showIt();
                }
            }
        }
    }

    private function onHover():void {
        if (g.isActiveMapEditor) return;
        _isOnHover = true;
        if (_state == EMPTY) {
            source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
            _frameCounterMouseHint = 2;
            g.gameDispatcher.addEnterFrame(countEnterFrameMouseHint);
        } else {
            source.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1);
            _frameCounterTimerHint = 5;
            g.gameDispatcher.addEnterFrame(countEnterFrameMouseHint);
            g.gameDispatcher.addEnterFrame(countEnterFrame);
        }

//        if (_state == WORKED) {
//
//        } else if (_state == EMPTY) {
//
//        }
    }

    private function onOut():void {
        if (g.isActiveMapEditor) return;
        source.filter = null;
        _isOnHover = false;
//        g.timerHint.hideIt();
        g.gameDispatcher.addEnterFrame(countEnterFrame);
        g.mouseHint.hideHintMouse();
    }

    private function countEnterFrame():void{
        _frameCounterTimerHint--;
        if(_frameCounterTimerHint <=0){
            g.gameDispatcher.removeEnterFrame(countEnterFrame);
            if (_isOnHover == true) {
                g.timerHint.showIt(g.ownMouse.mouseX + 20, g.ownMouse.mouseY + 20, _timeToEnd, _data.costForceCraft, _data.name,callbackSkip);
            }
        }
    }

    private function countEnterFrameMouseHint():void {
        _frameCounterMouseHint--;
        if(_frameCounterMouseHint <= 0){
            g.gameDispatcher.removeEnterFrame(countEnterFrameMouseHint);
            if (_isOnHover == true) {
                if (_state == EMPTY) {
                    g.mouseHint.checkMouseHint('animal', _data);
                }
                if (_state == WORKED){
                    g.mouseHint.checkMouseHint(MouseHint.CLOCK, _data);

                }
            }
            if(_isOnHover == false){
                g.gameDispatcher.removeEnterFrame(countEnterFrameMouseHint);
            }
        }
    }

    public function get animalData():Object {
        return _data;
    }

    public function addRenderAnimation():void {
        stopAnimation();
        if (_state == EMPTY) {
            waitForRawAnimation();
        } else if (_state == CRAFT) {
            waitForCraftAnimation();
        } else {
//            g.gameDispatcher.addToTimer(render);
            chooseAnimation();
        }
    }

    private function waitForCraftAnimation():void {
        source.scaleX = source.scaleY = .5*_defautScale;
    }

    private function waitForRawAnimation():void {
        if (_data.id == 6) return;
        var f1:Function = function():void {
            new TweenMax(_image, .5, {scaleX:0.97*_defautScale, scaleY:1.03*_defautScale, ease:Linear.easeOut ,onComplete: f2});
        };
        var f2:Function = function():void {
            new TweenMax(_image, .5, {scaleX:1.03*_defautScale, scaleY:0.97*_defautScale, ease:Linear.easeIn ,onComplete: f1});
        };
        f1();
    }

    private function chooseAnimation():void {
        stopAnimation();
        if (_data.id == 6) return;
        var i:int = int(Math.random()*3);
        if (i > 0) {
            walkAnimation();
        } else {
            countIdle = 3;
            idleAnimation();
        }
    }

    private var countIdle:int;
    private function idleAnimation():void {
        var f1:Function = function():void {
            new TweenMax(_image, .2, {y:0, ease:Linear.easeOut ,onComplete: f2});
        };
        var f2:Function = function():void {
            countIdle--;
            if (countIdle <= 0) {
                chooseAnimation();
                return;
            }
            new TweenMax(_image, .2, {y:-20, ease:Linear.easeIn ,onComplete: f1});
        };
        f2();
    }

    private function walkAnimation():void {
        var p:Point = g.farmGrid.getRandomPoint();
        var dist:int = Math.sqrt((source.x - p.x)*(source.x - p.x) + (source.y - p.y)*(source.y - p.y));
        if (p.x > source.x) {
            source.scaleX = -_defautScale;
        } else {
            source.scaleX = _defautScale;
        }
        new TweenMax(source, dist/WALK_SPEED, {x:p.x, y:p.y, ease:Linear.easeIn ,onComplete: chooseAnimation});
    }

    private function stopAnimation():void {
        TweenMax.killTweensOf(source);
        TweenMax.killTweensOf(_image);
        _image.y = 0;
        countIdle = 0;
        source.scaleX = source.scaleY = _defautScale;
    }

    public function get depth():Number {
//        var point3d:Point3D = g.farmGrid.screenToIso(new Point(source.x, source.y));
//        point3d.x += 7;
//        point3d.z += 7;
//        return point3d.x + point3d.z;
        return source.y;
    }

    public function clearIt():void {
        _farm = null;
        g.mouseHint.hideHintMouse();
        source.filter = null;
        TweenMax.killTweensOf(source);
        g.gameDispatcher.removeEnterFrame(countEnterFrameMouseHint);
        g.gameDispatcher.removeEnterFrame(countEnterFrame);
        _data = null;
        while (source.numChildren) source.removeChildAt(0);
        _image.dispose();
        source = null;
    }

    private function callbackSkip():void {
        g.directServer.skipTimeOnAnimal(_timeToEnd,animal_db_id,null);
        _timeToEnd = 0;
        render();
    }
}
}
