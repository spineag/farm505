/**
 * Created by user on 6/8/15.
 */
package build.decor {
import analytic.AnalyticManager;

import build.WorldObject;
import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.starling.StarlingArmatureDisplay;
import dragonBones.Bone;

import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;

import flash.geom.Point;

import heroes.BasicCat;

import heroes.HeroCat;

import manager.ManagerFilters;
import data.OwnEvent;

import manager.hitArea.ManagerHitArea;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.events.Event;

import windows.WindowsManager;

public class DecorAnimation extends WorldObject{
    private var _isHover:Boolean;
    private var _heroCat:HeroCat;
    private var _heroCatArray:Array;
    private var _armatureArray:Array;
    private var _decorWork:Boolean;
    private var _decorAnimation:int;
    private var  _awayAnimation:Boolean = false;

    public function DecorAnimation(_data:Object) {
        super(_data);
        createAnimatedBuild(onCreateBuild);
        _source.releaseContDrag = true;
        _isHover = false;
        _decorAnimation = 0;
        _heroCatArray = [];
        _armatureArray = [];
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlayByFrame('idle');
        if (g.managerHitArea.hasLoadedHitAreaByName(_dataBuild.url)) {
            _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.url, ManagerHitArea.TYPE_LOADED);
        } else {
            if (_dataBuild.color) {
                var name:String = (_dataBuild.url as String).replace(new RegExp("_" + String(_dataBuild.color), ""), '');
                _hitArea = g.managerHitArea.getHitArea(_source, name, ManagerHitArea.TYPE_LOADED);
            } else {
                _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.url, ManagerHitArea.TYPE_LOADED);
            }
        }
        _source.registerHitArea(_hitArea);
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
        if (_awayAnimation) {
            awayAnimation();
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        if (_isHover) return;
        _isHover = true;
        if (!_decorWork) {
            var fEndOver:Function = function(e:Event=null):void {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('idle');
            };
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('over');
        }
        super.onHover();
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY)
            _source.filter = ManagerFilters.BUILD_STROKE;
    }

    private function onClick():void {
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.ACTION_TEST, {id:2}); // temp
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            onOut();
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            onOut();
            releaseFlip();
            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (g.managerCutScenes.isCutScene && !g.managerCutScenes.isCutSceneResource(_dataBuild.id)) return;
            onOut();
            if (!g.selectedBuild) {
                if (g.managerCutScenes && g.managerCutScenes.isCutSceneBuilding(this)) {
                    g.managerCutScenes.checkCutSceneCallback();
                }
                g.directServer.addToInventory(_dbBuildingId, null);
                g.userInventory.addToDecorInventory(_dataBuild.id, _dbBuildingId);
                g.townArea.deleteBuild(this);
                g.event.dispatchEvent(new Event(OwnEvent.UPDATE_REPOSITORY));
            } else {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                }
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (!_dataBuild.catNeed) {
//                var oldBones:Vector.<Bone> = _armature.getBones();
//                var count:int = oldBones.length - 1;
//                if (count > 1) {
//                    var heroCat:HeroCat;
//                    var armature:Armature;
//                    for (var i:int = 0; i < count; i++) {
//                        heroCat = g.managerCats.getFreeCat();
//                        if (heroCat) {
//                            heroCat.isFree = false;
//                            armature = new Armature();
//                            armature = g.allData.factory[_dataBuild.url].buildArmature('cat' + String(count - i));
//                            WorldClock.clock.add(armature);
//                            armature.animation.gotoAndPlayByFrame('idle');
//                            _build.addChild(armature.display as StarlingArmatureDisplay);
//                            g.managerCats.goCatToPoint(heroCat, new Point(posX, posY), onHeroAnimationArray, armature, heroCat);
////                            _heroCatArray.push(heroCat);
////                            _armatureArray.push(armature);
//                        }
//                    }
//                } else {
                    if (!_heroCat) _heroCat = g.managerCats.getFreeCat();
                    if (_heroCat) {
                        _heroCat.isFree = false;
                        var fEndOver:Function = function(e:Event=null):void {
                            _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                            g.managerCats.goCatToPoint(_heroCat, new Point(posX, posY), onHeroAnimation);
                        };
                        _armature.addEventListener(EventObject.COMPLETE, fEndOver);
                        _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                        _armature.animation.gotoAndPlayByFrame('over');
                    }
//                }
            } else {
                onHeroAnimation();
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    override public function onOut():void {
        super.onOut();
        _isHover = false;
        if(_source) {
            if (_source.filter) _source.filter.dispose();
            _source.filter = null;
        }
    }

    private function onHeroAnimation():void {
        if (_decorWork) return;
        if (!_dataBuild.catNeed) {
            if (_heroCat) {
                _decorWork = true;
                startAnimation();
                _heroCat.visible = false;
            }
        } else {
            _decorWork = true;
            startAnimation();
        }
    }

//    private function onHeroAnimationArray(armature:Armature,heroCat:HeroCat):void {
//        if (heroCat) {
//            _decorWork = true;
//            heroCat.visible = false;
//            if (armature.animation.hasAnimation('start')) {
//                var fEndOver:Function = function (e:Event = null):void {
//                    armature.removeEventListener(EventObject.COMPLETE, fEndOver);
//                    armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
////                    armature.addEventListener(EventObject.COMPLETE, chooseAnimationArray);
////                    armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimationArray);
//                    chooseAnimationArray(null,armature, heroCat);
//                };
//                armature.addEventListener(EventObject.COMPLETE, fEndOver);
//                armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
//                armature.animation.gotoAndPlayByFrame('start');
//            }
//        }
//    }
//
//    private function chooseAnimationArray(e:Event=null, armature:Armature =null,heroCat:HeroCat = null):void {
//        var loop:Function = function (e:Event = null):void {
//            armature.removeEventListener(EventObject.COMPLETE, loop);
//            armature.removeEventListener(EventObject.LOOP_COMPLETE, loop);
//            if(_decorAnimation >= 7) return;
//            chooseAnimationArray(null,armature, heroCat);
//        };
//        if (!armature) return;
//        if (!armature.hasEventListener(EventObject.COMPLETE)) armature.addEventListener(EventObject.COMPLETE, loop);
//        if (!armature.hasEventListener(EventObject.LOOP_COMPLETE)) armature.addEventListener(EventObject.LOOP_COMPLETE, loop);
//        var k:int = int(Math.random() * 5);
//        switch (k) {
//            case 0:
//                armature.animation.gotoAndPlayByFrame('idle_1');
//                break;
//            case 1:
//                if (armature.animation.hasAnimation('idle_2')) armature.animation.gotoAndPlayByFrame('idle_2');
//                else armature.animation.gotoAndPlayByFrame('idle_1');
//                break;
//            case 2:
//                if (armature.animation.hasAnimation('idle_3')) armature.animation.gotoAndPlayByFrame('idle_3');
//                else if (armature.animation.hasAnimation('idle_2')) armature.animation.gotoAndPlayByFrame('idle_2');
//                else armature.animation.gotoAndPlayByFrame('idle_1');
//                break;
//            case 3:
//                if (armature.animation.hasAnimation('idle_4')) armature.animation.gotoAndPlayByFrame('idle_4');
//                else if (armature.animation.hasAnimation('idle_3')) armature.animation.gotoAndPlayByFrame('idle_3');
//                else if (armature.animation.hasAnimation('idle_2')) armature.animation.gotoAndPlayByFrame('idle_2');
//                else armature.animation.gotoAndPlayByFrame('idle_1');
//                break;
//            case 4:
//                if (armature.animation.hasAnimation('idle_5')) armature.animation.gotoAndPlayByFrame('idle_5');
//                else if (armature.animation.hasAnimation('idle_4')) armature.animation.gotoAndPlayByFrame('idle_4');
//                else if (armature.animation.hasAnimation('idle_3')) armature.animation.gotoAndPlayByFrame('idle_3');
//                else if (armature.animation.hasAnimation('idle_2')) armature.animation.gotoAndPlayByFrame('idle_2');
//                else armature.animation.gotoAndPlayByFrame('idle_1');
//                break;
//        }
//
//        var stopAnimationArray:Function = function (e:Event = null):void {
//            _decorWork = false;
//            if (heroCat) heroCat = null;
//            if (armature && armature.hasEventListener(EventObject.COMPLETE)) armature.removeEventListener(EventObject.COMPLETE, chooseAnimationArray);
//            if (armature && armature.hasEventListener(EventObject.LOOP_COMPLETE)) armature.removeEventListener(EventObject.LOOP_COMPLETE, chooseAnimationArray);
//            if (armature) armature.animation.gotoAndStopByFrame('idle');
//        };
//
//        _decorAnimation ++;
//        if (_decorAnimation >= 7) {
//            if (armature.animation.hasAnimation('back')) {
//                var fEndOver:Function = function (e:Event = null):void {
//                    armature.removeEventListener(EventObject.COMPLETE, fEndOver);
//                    armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
//                    if (heroCat) {
//                        heroCat.visible = true;
//                        heroCat.isFree = true;
//                    }
//                    stopAnimation();
//                };
//                armature.addEventListener(EventObject.COMPLETE, fEndOver);
//                armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
//                armature.animation.gotoAndPlayByFrame('back');
//                _decorAnimation = 0;
//            } else {
//                    if (heroCat) {
//                        heroCat.visible = true;
//                        heroCat.isFree = true;
//                    }
//                stopAnimationArray();
//                _decorAnimation = 0;
//            }
//        }
//    }

    private function startAnimation():void {
        if (!_armature) return;
        if (!_dataBuild.catNeed) {
            if (_armature.animation.hasAnimation('start')) {
                var fEndOver:Function = function (e:Event = null):void {
                    _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                    _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                    _armature.addEventListener(EventObject.COMPLETE, chooseAnimation);
                    _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
//                    releaseHeroCatWoman();
                    chooseAnimation();
                };
                _armature.addEventListener(EventObject.COMPLETE, fEndOver);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('start');
            } else {
                _armature.addEventListener(EventObject.COMPLETE, chooseAnimation);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
//                releaseHeroCatWoman();
                chooseAnimation();
            }
        } else {
            _armature.addEventListener(EventObject.COMPLETE, chooseAnimation);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
            chooseAnimation();
        }

    }

    public function awayAnimation():void {
        _awayAnimation = true;
        if (!_armature) return;
        _awayAnimation = false;
        if (!_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, chooseAnimation);
        if (!_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
        var k:int = int(Math.random() * 5);
        switch (k) {
            case 0:
                _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 1:
                if (_armature.animation.hasAnimation('idle_2')) _armature.animation.gotoAndPlayByFrame('idle_2');
                else _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 2:
                if (_armature.animation.hasAnimation('idle_3')) _armature.animation.gotoAndPlayByFrame('idle_3');
                else if (_armature.animation.hasAnimation('idle_2')) _armature.animation.gotoAndPlayByFrame('idle_2');
                else _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 3:
                if (_armature.animation.hasAnimation('idle_4')) _armature.animation.gotoAndPlayByFrame('idle_4');
                else if (_armature.animation.hasAnimation('idle_3')) _armature.animation.gotoAndPlayByFrame('idle_3');
                else if (_armature.animation.hasAnimation('idle_2')) _armature.animation.gotoAndPlayByFrame('idle_2');
                else _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 4:
                if (_armature.animation.hasAnimation('idle_5')) _armature.animation.gotoAndPlayByFrame('idle_5');
                else if (_armature.animation.hasAnimation('idle_4')) _armature.animation.gotoAndPlayByFrame('idle_4');
                else if (_armature.animation.hasAnimation('idle_3')) _armature.animation.gotoAndPlayByFrame('idle_3');
                else if (_armature.animation.hasAnimation('idle_2')) _armature.animation.gotoAndPlayByFrame('idle_2');
                else _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
        }
    }

    private function stopAnimation():void {
        _decorWork = false;
        if (_heroCat) _heroCat = null;
        if (_armature) _armature.animation.gotoAndStopByFrame('idle');
        if (_armature) _armature.removeEventListener(EventObject.COMPLETE, chooseAnimation);
        if (_armature) _armature.removeEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
    }

    private function chooseAnimation(e:Event=null):void {
        if (!_armature) return;
        if (!_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, chooseAnimation);
        if (!_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
        var k:int = int(Math.random() * 5);
        switch (k) {
            case 0:
                _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 1:
                if (_armature.animation.hasAnimation('idle_2')) _armature.animation.gotoAndPlayByFrame('idle_2');
                else _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 2:
                if (_armature.animation.hasAnimation('idle_3')) _armature.animation.gotoAndPlayByFrame('idle_3');
                else if (_armature.animation.hasAnimation('idle_2')) _armature.animation.gotoAndPlayByFrame('idle_2');
                else _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 3:
                if (_armature.animation.hasAnimation('idle_4')) _armature.animation.gotoAndPlayByFrame('idle_4');
                else if (_armature.animation.hasAnimation('idle_3')) _armature.animation.gotoAndPlayByFrame('idle_3');
                else if (_armature.animation.hasAnimation('idle_2')) _armature.animation.gotoAndPlayByFrame('idle_2');
                else _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 4:
                if (_armature.animation.hasAnimation('idle_5')) _armature.animation.gotoAndPlayByFrame('idle_5');
                else if (_armature.animation.hasAnimation('idle_4')) _armature.animation.gotoAndPlayByFrame('idle_4');
                else if (_armature.animation.hasAnimation('idle_3')) _armature.animation.gotoAndPlayByFrame('idle_3');
                else if (_armature.animation.hasAnimation('idle_2')) _armature.animation.gotoAndPlayByFrame('idle_2');
                else _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
        }
        _decorAnimation ++;
        if (_decorAnimation >= 4) {
            if (_armature.animation.hasAnimation('back')) {
                var fEndOver:Function = function (e:Event = null):void {
                    _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                    _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                    if (_heroCat) {
                        _heroCat.visible = true;
                        _heroCat.isFree = true;
                    }
                    stopAnimation();
                };
                _armature.addEventListener(EventObject.COMPLETE, fEndOver);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('back');
                _decorAnimation = 0;
            } else {
                if (!_dataBuild.catNeed) {
                    if (_heroCat) {
                        _heroCat.visible = true;
                        _heroCat.isFree = true;
                    }
                }
                stopAnimation();
                _decorAnimation = 0;
            }
        }
    }

    private function releaseHeroCatWoman():void {
        if (_heroCat) {
            if (_heroCat.typeMan == BasicCat.MAN) {
                if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7)
                    releaseManBackTexture();
                else releaseManFrontTexture();
            } else if (_heroCat.typeMan == BasicCat.WOMAN) {
                if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7)
                    releaseWomanBackTexture();
                else releaseWomanFrontTexture();
            }
        } else {
            if (g.isAway) {
                if (Math.random() < .5) {
                    if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7)
                        releaseManBackTexture();
                    else releaseManFrontTexture();
                } else {
                    if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7)
                        releaseWomanBackTexture();
                    else releaseWomanFrontTexture();
                }
            }
        }
    }

    private function releaseManFrontTexture():void {
        if (!_armature) return;
        changeTexture("head", "head");
        changeTexture("body", "body");
        changeTexture("handLeft", "hand_l");
        changeTexture("legLeft", "leg_l");
        changeTexture("handRight", "hand_r");
        changeTexture("legRight", "leg_r");
        changeTexture("tail", "tail");
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "hand_r");
        }
        var viyi:Bone = _armature.getBone('viyi'); {
            if (viyi) {
                viyi.visible = false;
            }
        }
    }

    private function releaseManBackTexture():void {
        changeTexture("head", "head_b");
        changeTexture("body", "body_b");
        changeTexture("handLeft", "hand_l_b");
        changeTexture("legLeft", "leg_l_b");
        changeTexture("handRight", "hand_r_b");
        changeTexture("legRight", "leg_r_b");
        changeTexture("tail", "tail");
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "hand_r_b");
        }
    }

    private function releaseWomanFrontTexture():void {
        if (!_armature) return;
        changeTexture("head", "head_w");
        changeTexture("body", "body_w");
        changeTexture("handLeft", "hand_w_l");
        changeTexture("legLeft", "leg_w_r");
        changeTexture("handRight", "hand_w_r");
        changeTexture("legRight", "leg_w_r");
        changeTexture("tail", "tail_w");
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "hand_w_r");
        }
        var viyi:Bone = _armature.getBone('viyi'); {
            if (viyi) {
                viyi.visible = true;
            }
        }
    }

    private function releaseWomanBackTexture():void {
        changeTexture("head", "head_w_b");
        changeTexture("body", "body_w_b");
        changeTexture("handLeft", "hand_w_l_b");
        changeTexture("legLeft", "leg_w_l_b");
        changeTexture("handRight", "hand_w_r_b");
        changeTexture("legRight", "leg_w_r_b");
        changeTexture("tail", "tail_w");
    }

    private function changeTexture(oldName:String, newName:String):void {
        var im:Image = new Image(g.allData.atlas['customisationAtlas'].getTexture(newName));
        if (_armature) var b:Slot = _armature.getSlot(oldName);
        if (im && b) {
            b.displayList = null;
            b.display = im;
        } else {
            Cc.error('Fabrica changeTexture:: null Bone for oldName= '+oldName + ' for fabricaId= '+String(_dataBuild.id));
        }
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

}
}
