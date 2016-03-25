/**
 * Created by user on 6/19/15.
 */
package build.farm {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import data.BuildType;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import flash.geom.Point;
import hint.MouseHint;
import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;
import resourceItem.RawItem;
import starling.display.Sprite;
import starling.textures.Texture;
import tutorial.SimpleArrow;
import tutorial.TutorialAction;

import utils.CSprite;

import windows.WindowsManager;

public class Animal {
    public static var HUNGRY:int = 1;
    public static var WORK:int = 2;
    public static var CRAFT:int = 3;
    private const WALK_SPEED:int = 20;

    public var source:CSprite;
    private var _data:Object;
    private var _timeToEnd:int;
    private var _state:int;
    private var _frameCounterTimerHint:int;
    private var _frameCounterMouseHint:int;
    private var _isOnHover:Boolean;
    private var _farm:Farm;
    public var animal_db_id:String;  // id в табличке user_animal
    private var _arrow:SimpleArrow;
    private var _rect:flash.geom.Rectangle;
    private var _tutorialCallback:Function;

    private var armature:Armature;
    private var defaultLabel:String;
    private var hungryLabel:String;
    private var feedLabel:String;
    private var walkLabel:String;
    private var idleLabels:Array;

    private var g:Vars = Vars.getInstance();

    public function Animal(data:Object, farm:Farm) {
        if (!data) {
            Cc.error('no data for Animal');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Animal');
            return;
        }
        _farm = farm;
        source = new CSprite();
        _data = data;
        _isOnHover = false;
        _tutorialCallback = null;

        armature = g.allData.factory[_data.image].buildArmature("animal");
        if (!armature) {
            Cc.error('Animal:: no armature for animalId: ' + _data.id);
            return;
        }
        WorldClock.clock.add(armature);
        source.addChild(armature.display as Sprite);

        _state = HUNGRY;

        if (!g.isAway) {
            source.hoverCallback = onHover;
            source.outCallback = onOut;
            source.endClickCallback = onClick;
        }

        switch (_data.id) {
            case 1: // chicken
                defaultLabel = 'walk';
                hungryLabel = 'hungry';
                feedLabel = 'feed';
                walkLabel = 'walk';
                idleLabels = ['idle_1'];
                break;
            case 2: // cow
                defaultLabel = 'walk';
                hungryLabel = 'hungry';
                feedLabel = 'feed';
                walkLabel = 'walk';
                idleLabels = ['idle_1', 'idle_2'];
                break;
            case 3: // pig
                defaultLabel = 'walk';
                hungryLabel = 'hungry';
                feedLabel = 'feed';
                walkLabel = 'walk';
                idleLabels = ['idle1', 'idle2', 'idle3'];
                break;
            case 6: // bee
                defaultLabel = 'idle';
                hungryLabel = 'idle';
                feedLabel = 'work';
                walkLabel = 'idle';
                idleLabels = ['work1', 'work2'];
                break;
            case 7: // sheep
                defaultLabel = 'walk';
                hungryLabel = 'hungry';
                feedLabel = 'feed';
                walkLabel = 'walk';
                idleLabels = ['idle_2', 'idle_1'];
                break;
        }
    }

    public function get state():int {
        return _state;
    }

    public function get farm():Farm {
        return _farm;
    }

    public function addArrow():void {
        _rect = source.getBounds(source);
        removeArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, source, 1);
        _arrow.animateAtPosition(0, _rect.y);
    }

    public function removeArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function set tutorialCallback(f:Function):void {
        _tutorialCallback = f;
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
                _state = WORK;
                if (!g.isAway) {
                    g.managerAnimal.addCatToFarm(_farm);
                    g.gameDispatcher.addToTimer(render);
                }
            }
        } else {
            _state = HUNGRY;
        }
    }

    private function render():void {
        _timeToEnd--;
        if (_timeToEnd <= 0 && _state == WORK) {
            _state = CRAFT;
            g.gameDispatcher.removeFromTimer(render);
            craftResource();
            _farm.readyAnimal();
            addRenderAnimation();
        }
    }

    private function craftResource():void {
        _farm.onAnimalReadyToCraft(_data.idResource, onCraft);
    }

    private function onCraft():void {
        _state = HUNGRY;
        addRenderAnimation();
        if (g.useDataFromServer) g.directServer.craftUserAnimal(animal_db_id, null);
    }

    private function onClick(last:Boolean = false):void {
        if (g.managerTutorial.isTutorial && _tutorialCallback == null) return;
        if (g.isActiveMapEditor) return;
        if (_state == HUNGRY) {
            onOut();
            if(g.userInventory.getCountResourceById(_data.idResourceRaw) < 1) {
                g.woNoResources.showItAnimal(_data,onClick);
                return;
            }
            if (!last && g.dataResource.objectResources[_data.idResourceRaw].buildType == BuildType.PLANT && g.userInventory.getCountResourceById(_data.idResourceRaw) == 1) {
                g.woLastResource.showItMarket(_data.idResourceRaw,onClick);
                return;
            }
            if (g.managerAnimal.checkIsCat(_farm.dbBuildingId)) {
                g.userInventory.addResource(_data.idResourceRaw, -1);
                _timeToEnd = _data.timeCraft;
                g.gameDispatcher.addToTimer(render);
                _state = WORK;
                g.managerAnimal.addCatToFarm(_farm);
                var p:Point = new Point(source.x, source.y);
                p = source.parent.localToGlobal(p);
                var texture:Texture;
                var obj:Object = g.dataResource.objectResources[_data.idResourceRaw];
                if (obj.buildType == BuildType.PLANT)
                    texture = g.allData.atlas['resourceAtlas'].getTexture(obj.imageShop + '_icon');
                else
                    texture = g.allData.atlas[obj.url].getTexture(obj.imageShop);

                new RawItem(p, texture, 1, 0);
                if (g.useDataFromServer) g.directServer.rawUserAnimal(animal_db_id, null);
                if (_data.id != 6) {
                    showFeedingAnimation();
                } else {
                    addRenderAnimation();
                }
                onOut();
                if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.ANIMAL_FEED) {
                    if (_tutorialCallback != null) {
                        _tutorialCallback.apply(null, [this]);
                    }
                }
            } else {
                onOut();
                if (g.managerCats.curCountCats == g.managerCats.maxCountCats) {
                    g.windowsManager.openWindow(WindowsManager.WO_WAIT_FREE_CATS);
                } else {
                    g.windowsManager.openWindow(WindowsManager.WO_NO_FREE_CATS);
                }
            }
        } else {
            source.filter = null;
            g.timerHint.showIt(90, g.ownMouse.mouseX + 20, g.ownMouse.mouseY + 20, _timeToEnd, _data.costForceCraft, _data.name,callbackSkip,onOut);
        }
    }

    private function onHover():void {
        if (g.managerTutorial.isTutorial && _tutorialCallback == null) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) return;
        if (g.isActiveMapEditor) return;
        _isOnHover = true;
        _frameCounterTimerHint = 7;
        source.filter = ManagerFilters.BUILD_STROKE;
        g.gameDispatcher.addEnterFrame(countEnterFrameMouseHint);
    }

    private function onOut():void {
        if (g.managerTutorial.isTutorial && _tutorialCallback == null) return;
        if (g.isActiveMapEditor) return;
        source.filter = null;
        _isOnHover = false;
        g.gameDispatcher.addEnterFrame(countEnterFrameMouseHint);
    }


    private function countEnterFrameMouseHint():void {
        _frameCounterMouseHint--;
        if (_frameCounterMouseHint <= 5){
            if (_isOnHover) {
                if (_state == HUNGRY) {
                    g.mouseHint.checkMouseHint('animal', _data);
                    g.gameDispatcher.removeEnterFrame(countEnterFrameMouseHint);
                } else if (_state == WORK) g.mouseHint.checkMouseHint(MouseHint.CLOCK, _data);
            } else g.gameDispatcher.removeEnterFrame(countEnterFrameMouseHint);
        }
        if (_frameCounterMouseHint <= 0) {
            g.gameDispatcher.removeEnterFrame(countEnterFrameMouseHint);
            if (_isOnHover && _state == WORK) {
                g.timerHint.showIt(90, g.ownMouse.mouseX + 20, g.ownMouse.mouseY + 20, _timeToEnd, _data.costForceCraft, _data.name,callbackSkip,onOut);
            }
        }
    }


    public function get animalData():Object {
        return _data;
    }

    private function showFeedingAnimation():void {
        stopAnimation();
        armature.addEventListener(AnimationEvent.COMPLETE, completeFeedingAnimation);
        armature.addEventListener(AnimationEvent.LOOP_COMPLETE, completeFeedingAnimation);
        armature.animation.gotoAndPlay('feed');
    }

    private function completeFeedingAnimation(e:AnimationEvent):void {
        armature.removeEventListener(AnimationEvent.COMPLETE, completeFeedingAnimation);
        armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, completeFeedingAnimation);
        addRenderAnimation();
    }

    public function addRenderAnimation():void {
        stopAnimation();
        if (_state == CRAFT || _state == HUNGRY) {
            showHungryAnimations();
        } else if (_state == WORK) {
            chooseAnimation();
        }
    }

    public function playDirectIdle():void {
        stopAnimation();
        armature.addEventListener(AnimationEvent.COMPLETE, completeDirectIdleAnimation);
        armature.addEventListener(AnimationEvent.LOOP_COMPLETE, completeDirectIdleAnimation);
        armature.animation.gotoAndPlay(idleLabels[0]);
    }

    private function completeDirectIdleAnimation(e:AnimationEvent):void {
        if (armature.hasEventListener(AnimationEvent.COMPLETE)) armature.removeEventListener(AnimationEvent.COMPLETE, completeDirectIdleAnimation);
        if (armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, completeDirectIdleAnimation);
        armature.addEventListener(AnimationEvent.COMPLETE, completeDirectIdleAnimation);
        armature.addEventListener(AnimationEvent.LOOP_COMPLETE, completeDirectIdleAnimation);
        armature.animation.gotoAndPlay(idleLabels[0]);
    }

    private function showHungryAnimations():void {
        if (_data.id == 6) {
            armature.animation.gotoAndPlay(hungryLabel, 0);
        } else {
            armature.animation.gotoAndPlay(hungryLabel);
            if (armature.hasEventListener(AnimationEvent.COMPLETE)) armature.removeEventListener(AnimationEvent.COMPLETE, completeIdleAnimation);
            if (armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, completeIdleAnimation);
            armature.addEventListener(AnimationEvent.COMPLETE, playHungry);
            armature.addEventListener(AnimationEvent.LOOP_COMPLETE, playHungry);
        }
    }

    private function playHungry(e:AnimationEvent):void {
        armature.animation.gotoAndPlay(hungryLabel);
    }

    private function chooseAnimation():void {
        stopAnimation();
        if (_data.id == 6) {
            idleAnimation();
        } else {
            if (Math.random() > .7) {
                walkAnimation();
            } else {
                idleAnimation();
            }
        }
    }

    private function idleAnimation():void {
        if (!idleLabels.length) {
            Cc.error('Animal:: empty idleLabels for animalId: ' + String(_data.id));
            return;
        }
        try {
            if (idleLabels.length == 1) {
                armature.animation.gotoAndPlay(idleLabels[0]);
            } else if (idleLabels.length == 2) {
                if (Math.random()<.75) {
                    armature.animation.gotoAndPlay(idleLabels[0]);
                } else {
                    armature.animation.gotoAndPlay(idleLabels[1]);
                }
            } else {
                var r:Number = Math.random();
                if (r < .75) {
                    armature.animation.gotoAndPlay(idleLabels[0]);
                } else if (r < .95) {
                    armature.animation.gotoAndPlay(idleLabels[1]);
                } else {
                    armature.animation.gotoAndPlay(idleLabels[2]);
                }
            }
        } catch(e:Error) {
            Cc.error('Animal idleAnimation:: error with animalId: ' + _data.id);
            return;
        }

        armature.addEventListener(AnimationEvent.COMPLETE, completeIdleAnimation);
        armature.addEventListener(AnimationEvent.LOOP_COMPLETE, completeIdleAnimation);
    }

    private function completeIdleAnimation(e:AnimationEvent):void {
        armature.removeEventListener(AnimationEvent.COMPLETE, completeIdleAnimation);
        armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, completeIdleAnimation);
        chooseAnimation();
    }

    private function walkAnimation():void {
        var p:Point;
        if (_data.id == 1) {
            p = g.farmGrid.getRandomPoint(7);
        } else {
            p = g.farmGrid.getRandomPoint();
        }
        var dist:int = Math.sqrt((source.x - p.x)*(source.x - p.x) + (source.y - p.y)*(source.y - p.y));
        if (p.x > source.x) {
            source.scaleX = -1;
        } else {
            source.scaleX = 1;
        }
        armature.animation.gotoAndPlay(walkLabel);
        new TweenMax(source, dist/WALK_SPEED, {x:p.x, y:p.y, ease:Linear.easeIn ,onComplete: chooseAnimation});
    }

    private function stopAnimation():void {
        if (armature.hasEventListener(AnimationEvent.COMPLETE)) armature.removeEventListener(AnimationEvent.COMPLETE, playHungry);
        if (armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, playHungry);
        armature.animation.gotoAndStop(defaultLabel, 0);
        TweenMax.killTweensOf(source);
    }

    public function get depth():Number {
        return source.y;
    }

    public function clearIt():void {
        if (armature.hasEventListener(AnimationEvent.COMPLETE)) armature.removeEventListener(AnimationEvent.COMPLETE, completeIdleAnimation);
        if (armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, completeIdleAnimation);
        WorldClock.clock.remove(armature);
        armature.dispose();
        _farm = null;
        g.mouseHint.hideIt();
        source.filter = null;
        TweenMax.killTweensOf(source);
        g.gameDispatcher.removeEnterFrame(countEnterFrameMouseHint);
        g.timerHint.hideIt();
        _data = null;
        while (source.numChildren) source.removeChildAt(0);
        source = null;
    }

    private function callbackSkip():void {
        onOut();
        g.directServer.skipTimeOnAnimal(_timeToEnd,animal_db_id,null);
        _timeToEnd = 0;
        render();
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.ANIMAL_SKIP) {
            if (_tutorialCallback != null) {
                _tutorialCallback.apply(null, [this]);
            }
        }
    }
}
}
