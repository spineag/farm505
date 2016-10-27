/**
 * Created by user on 6/19/15.
 */
package build.farm {
import analytic.AnalyticManager;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import data.BuildType;
import dragonBones.events.EventObject;
import hint.MouseHint;
import manager.ManagerFilters;
import manager.Vars;
import media.SoundConst;
import mouse.ToolsModifier;
import resourceItem.RawItem;
import starling.textures.Texture;
import utils.SimpleArrow;
import tutorial.TutorialAction;
import utils.CSprite;
import windows.WindowsManager;
import flash.geom.Rectangle;

public class Animal {
    private const WALK_SPEED:int = 20;
    public static var HUNGRY:int = 1;
    public static var WORK:int = 2;
    public static var CRAFT:int = 3;

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
    private var _rect:Rectangle;
    private var _tutorialCallback:Function;
    private var _needShowArrow:Boolean = false;
    private var _wasStartActiveFeeding:Boolean;

    private var animation:AnimalAnimation;
    private var currentLabelAfterLoading:String;
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
        source.nameIt = 'animal';
        _data = data;
        _isOnHover = false;
        _tutorialCallback = null;
        _wasStartActiveFeeding = false;

        currentLabelAfterLoading = '';
        if (g.allData.factory[_data.url]) {
            createAnimal();
        } else {
            g.loadAnimation.load('animations_json/x1/' + _data.url, _data.url, createAnimal);
        }

        _state = HUNGRY;

        if (!g.isAway) {
            source.hoverCallback = onHover;
            source.outCallback = onOut;
            source.endClickCallback = onEndClick;
            source.startClickCallback = onStartClick;
        }
       if (g.isAway) source.releaseContDrag = true;
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

    private function createAnimal():void {
        animation = new AnimalAnimation();
        animation.animalArmature(g.allData.factory[_data.url].buildArmature(_data.image), _data.id);
        source.addChild(animation.source);
        _rect = source.getBounds(source);
        if (currentLabelAfterLoading != '') {
            addRenderAnimation();
        }
        if (_needShowArrow) {
            addArrow();
            _needShowArrow = false;
        }
    }
    
    public function get state():int {
        return _state;
    }

    public function get farm():Farm {
        return _farm;
    }

    public function get depth():Number {
        return source.y;
    }

    public function get animalData():Object {
        return _data;
    }

    public function get rect():Rectangle {
        return _rect;
    }

    public function isMouseUnderAnimal():Boolean {
        var p:Point = new Point(g.ownMouse.mouseX, g.ownMouse.mouseY);
        p = source.globalToLocal(p);

        if (p.x > _rect.x && p.x < _rect.x+_rect.width && p.y > _rect.y && p.y < _rect.y+_rect.height) {
            return true;
        } else return false;
    }

    public function addArrow(t:Number = 0):void {
        if (animation) {
            removeArrow();
            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, source);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(0, _rect.y + 30);
            if (t>0) _arrow.activateTimer(t, removeArrow);
        } else {
            _needShowArrow = true;
        }
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
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.ANIMAL_SKIP) {
                if (_tutorialCallback != null) {
                    g.timerHint.hideArrow();
                    g.timerHint.hideIt(true);
                    _tutorialCallback.apply(null, [this]);
                }
            }
        }
    }

    private function craftResource():void {
        _farm.onAnimalReadyToCraft(_data.idResource, this);
    }

    public function onCraft():void {
        _state = HUNGRY;
        addRenderAnimation();
        g.directServer.craftUserAnimal(animal_db_id, null);
    }

    public function feedAnimal(last:Boolean = false,show:Boolean = false):void {
        onOut();
        if (!g.managerAnimal.checkIsCat(_farm.dbBuildingId)) {
            onOut();
            if (g.managerCats.curCountCats == g.managerCats.maxCountCats) {
                if (!g.windowsManager.currentWindow) g.windowsManager.openWindow(WindowsManager.WO_WAIT_FREE_CATS);
//                source.releaseContDrag = false;
                return;
            } else {
                if (!g.windowsManager.currentWindow) g.windowsManager.openWindow(WindowsManager.WO_NO_FREE_CATS);
//                source.releaseContDrag = false;
                return;
            }
        }
        if (!show) {
            if (g.dataResource.objectResources[_data.idResourceRaw].buildType == BuildType.PLANT && g.userInventory.getCountResourceById(_data.idResourceRaw) < 1) {
                if (_wasStartActiveFeeding && g.managerAnimal.isMouseUnderAnimal(this)) {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, feedAnimal, 'animal', _data);
                } else {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                    return;
            } else if (g.userInventory.getCountResourceById(_data.idResourceRaw) < 1) {
                if (_wasStartActiveFeeding && g.managerAnimal.isMouseUnderAnimal(this)) {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, feedAnimal, 'animal', _data);
                } else {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                    return;
            }
            if (!last && g.dataResource.objectResources[_data.idResourceRaw].buildType == BuildType.PLANT && g.userInventory.getCountResourceById(_data.idResourceRaw) == 1 && !g.userInventory.checkLastResource(_data.idResourceRaw)) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, feedAnimal, {id: _data.idResourceRaw}, 'market');
                return;
            }
        }
        if (g.managerAnimal.checkIsCat(_farm.dbBuildingId)) {
            if (g.toolsModifier.modifierType != ToolsModifier.FEED_ANIMAL_ACTIVE) g.mouseHint.hideIt();
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
            g.directServer.rawUserAnimal(animal_db_id, null);
            if (_data.id != 6) {
                if (_data.id == 1) {
                    g.soundManager.playSound(SoundConst.RAW_CHICKEN);
                } else if (_data.id == 2) {
                    g.soundManager.playSound(SoundConst.RAW_COW);
                } else if (_data.id == 3) {
                    g.soundManager.playSound(SoundConst.RAW_PIG);
                } else if (_data.id == 7) {
                    g.soundManager.playSound(SoundConst.RAW_SHEEP);
                }
                showFeedingAnimation();
            } else {
//                g.soundManager.playSound(SoundConst);
                addRenderAnimation();
            }
            onOut();
            g.userInventory.addResource(_data.idResourceRaw, -1);
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.ANIMAL_FEED) {
                if (_tutorialCallback != null) {
                    _tutorialCallback.apply(null, [this]);
                }
            }
        }
//        } else {
//            onOut();
//            if (g.managerCats.curCountCats == g.managerCats.maxCountCats) {
//                if (!g.windowsManager.currentWindow) g.windowsManager.openWindow(WindowsManager.WO_WAIT_FREE_CATS);
//                trace('WO_WAIT_FREE_CATS');
//            } else {
//                if (!g.windowsManager.currentWindow) g.windowsManager.openWindow(WindowsManager.WO_NO_FREE_CATS);
//                trace('WO_NO_FREE_CATS');
//            }
//        }
    }

    public function onStartClick():void {
        if(_farm.isAnyCrafted) return;
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (g.toolsModifier.modifierType == ToolsModifier.NONE && _state == HUNGRY) {
            if (!g.managerTutorial.isTutorial) {
                g.managerAnimal.activeFeedAnimalId = _data.id;
                g.toolsModifier.modifierType = ToolsModifier.FEED_ANIMAL_ACTIVE;
                _wasStartActiveFeeding = true;
            }
        }
    }

import flash.geom.Point;

public function onEndClick(last:Boolean = false):void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.toolsModifier.modifierType == ToolsModifier.FEED_ANIMAL_ACTIVE) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            return;
        }
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial && _tutorialCallback == null) return;
        if (g.isActiveMapEditor) return;
        if(_farm.isAnyCrafted) return;
        if (_state == WORK) {
            source.filter = null;
            if (g.timerHint.isShow) {
                g.timerHint.managerHide(onClickCallbackWhenWork);
                return;
            }
            if (!g.mouseHint.isShowedAnimalFeed) {
                if (!_wasStartActiveFeeding) {
                    var p1:Point = new Point(0, _rect.y);
                    p1 = source.localToGlobal(p1);
                    if (_data.id == 1 || _data.id == 3) p1.y += 25;
                    g.timerHint.showIt(source.width * g.currentGameScale, p1.x, p1.y, _data.timeCraft, _timeToEnd, _data.costForceCraft, _data.name, callbackSkip, onOut, false, true);
                    stopAnimation();
                    idleAnimation();
                } else {
                    _wasStartActiveFeeding = false;
                }
            }
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.ANIMAL_SKIP) {
                removeArrow();
                g.mouseHint.hideIt();
                g.timerHint.addArrow();
            }
        } else if (_state == HUNGRY) {
            if (g.managerTutorial.isTutorial)
                feedAnimal(last);
        }
    }

    public function onResize():void {
        if (g.managerTutorial.isTutorial) {
            g.timerHint.hideArrow();
            g.timerHint.hideIt(true);
            var p1:Point = new Point(0, _rect.y);
            p1 = source.localToGlobal(p1);
            if (_data.id == 1 || _data.id == 3) p1.y += 25;
            g.timerHint.showIt(source.width * g.currentGameScale, p1.x, p1.y, _data.timeCraft, _timeToEnd, _data.costForceCraft, _data.name, callbackSkip, onOut, false, true);
            g.timerHint.addArrow();
        }
    }

    private function onClickCallbackWhenWork():void {
        if (!g.mouseHint.isShowedAnimalFeed) {
            var p1:Point = new Point(0, _rect.y);
            p1 = source.localToGlobal(p1);
            if (_data.id == 1 || _data.id == 3) p1.y += 25;
            g.timerHint.showIt(source.width * g.currentGameScale, p1.x, p1.y, _data.timeCraft_da, _timeToEnd, _data.costForceCraft, _data.name, callbackSkip, onOut,false,true);
            stopAnimation();
            idleAnimation();
        }
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.ANIMAL_SKIP) {
            removeArrow();
            g.mouseHint.hideIt();
            g.timerHint.addArrow();
        }
    }

    public function onHover():void {
        if (_isOnHover) return;
        if (g.isAway) return;
        if (g.managerTutorial.isTutorial && _tutorialCallback == null) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) return;
        if (g.isActiveMapEditor) return;
        if (_farm.isAnyCrafted) return;
        _isOnHover = true;
        g.hint.showIt(animalData.name);
        _frameCounterTimerHint = 7;
        source.filter = ManagerFilters.BUILD_STROKE;
        if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_state == HUNGRY) g.mouseHint.showMouseHint(MouseHint.ANIMAL, _data);
            else if (_state == WORK) g.mouseHint.showMouseHint(MouseHint.CLOCK, _data);
        }
//        g.gameDispatcher.addToTimer(countEnterFrameMouseHint);
    }

    public function onOut():void {
        if (g.managerTutorial.isTutorial && _tutorialCallback == null) return;
        if (g.isActiveMapEditor) return;
        g.hint.hideIt();
        if (source.filter) source.filter.dispose();
        source.filter = null;
        _isOnHover = false;
//        g.gameDispatcher.removeFromTimer(countEnterFrameMouseHint);
        g.mouseHint.hideIt();
    }

//    private function countEnterFrameMouseHint():void {
//        _frameCounterMouseHint--;
//        if (_frameCounterMouseHint <= 5){
//            if (!g.mouseHint.isShowedAnimalFeed) {
//                if (_isOnHover) {
//                    if (_state == HUNGRY)
//                        g.mouseHint.checkMouseHint(MouseHint.ANIMAL, _data);
//                    else if (_state == WORK) {
//                        g.mouseHint.checkMouseHint(MouseHint.CLOCK, _data);
//                    }
//                }
//            }
//            g.gameDispatcher.removeFromTimer(countEnterFrameMouseHint);
//        }
//    }

    private function showFeedingAnimation():void {
        stopAnimation();
        if (animation) {
            animation.playIt(feedLabel, true, addRenderAnimation);
        } else currentLabelAfterLoading = feedLabel;
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
        if (animation) animation.playIt(idleLabels[0]);
    }

    private function completeDirectIdleAnimation(e:EventObject):void {
        animation.playIt(idleLabels[0]);
    }

    private function showHungryAnimations():void {
        if (animation) {
            if (_data.id == 6) {
                animation.stopItAtLabel(hungryLabel);
            } else {
                animation.playIt(hungryLabel);
            }
        } else currentLabelAfterLoading = hungryLabel;
    }

    private function playHungry(e:EventObject):void {
        animation.playIt(hungryLabel);
    }

    private function chooseAnimation():void {
        if (animation) {
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
        } else currentLabelAfterLoading = defaultLabel;
    }

    private function idleAnimation():void {
        if (!idleLabels.length) {
            Cc.error('Animal:: empty idleLabels for animalId: ' + String(_data.id));
            return;
        }
        try {
            if (idleLabels.length == 1) {
                animation.playIt(idleLabels[0], true, chooseAnimation);
            } else if (idleLabels.length == 2) {
                if (Math.random()<.75) {
                    animation.playIt(idleLabels[0], true, chooseAnimation);
                } else {
                    animation.playIt(idleLabels[1], true, chooseAnimation);
                }
            } else {
                var r:Number = Math.random();
                if (r < .75) {
                    animation.playIt(idleLabels[0], true, chooseAnimation);
                } else if (r < .95) {
                    animation.playIt(idleLabels[1], true, chooseAnimation);
                } else {
                    animation.playIt(idleLabels[2], true, chooseAnimation);
                }
            }
        } catch(e:Error) {
            Cc.error('Animal idleAnimation:: error with animalId: ' + _data.id);
            return;
        }
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
        animation.playIt(walkLabel);
        new TweenMax(source, dist/WALK_SPEED, {x:p.x, y:p.y, ease:Linear.easeIn ,onComplete: chooseAnimation});
    }

    private function stopAnimation():void {
        if (animation) animation.stopIt();
        TweenMax.killTweensOf(source);
    }

    public function clearIt():void {
        if (animation) animation.stopIt();
        if (animation) animation.deleteIt();
        if (animation) animation = null;
        _farm = null;
        g.mouseHint.hideIt();
        source.filter = null;
        TweenMax.killTweensOf(source);
//        g.gameDispatcher.removeFromTimer(countEnterFrameMouseHint);
        g.timerHint.hideIt();
        _data = null;
        source.dispose();
        source = null;
    }

    private function callbackSkip():void {
        onOut();
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_ANIMAL_ID, info: _data.id});
        g.directServer.skipTimeOnAnimal(_timeToEnd, animal_db_id, null);
        _timeToEnd = 0;
        render();
    }

    public function deleteFilter():void {
        source.filter = null;
        _isOnHover = false;
//        g.gameDispatcher.removeFromTimer(countEnterFrameMouseHint);
        g.mouseHint.hideIt();
    }
}
}
