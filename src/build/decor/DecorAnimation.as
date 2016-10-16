/**
 * Created by user on 6/8/15.
 */
package build.decor {
import analytic.AnalyticManager;

import build.WorldObject;
import com.junkbyte.console.Cc;

import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;

import flash.geom.Point;

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
    private var _decorWork:Boolean;
    private var _decorAnimation:int;
    private var  _awayAnimation:Boolean = false;

    public function DecorAnimation(_data:Object) {
        super(_data);
        createAnimatedBuild(onCreateBuild);
        _source.releaseContDrag = true;
        _isHover = false;
        _decorAnimation = 0;
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlayByFrame('idle');
        _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.url, ManagerHitArea.TYPE_LOADED);
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
            if (!_heroCat) _heroCat = g.managerCats.getFreeCat();
            if (_heroCat) {
                _heroCat.isFree = false;
                g.managerCats.goCatToPoint(_heroCat, new Point(posX, posY), onHeroAnimation);
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
        if (_heroCat) {
            startAnimation();
            _decorWork = true;
            _heroCat.visible = false;
        }
    }

    private function startAnimation():void {
        if (!_armature) return;
        if (_armature.animation.hasAnimation('start')) {
            var fEndOver:Function = function (e:Event = null):void {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.addEventListener(EventObject.COMPLETE, chooseAnimation);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
                chooseAnimation();
            };
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('start');
        } else  chooseAnimation();

    }

    public function awayAnimation():void {
        _awayAnimation = true;
        if (!_armature) return;
        _awayAnimation = false;
        if (!_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, chooseAnimation);
        if (!_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
        var k:int = int(Math.random() * 2);
        switch (k) {
            case 0:
                _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 1:
                _armature.animation.gotoAndPlayByFrame('idle_2');
                break;
            case 2:
                _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
        }
    }

    private function stopAnimation():void {
        _decorWork = false;
        _heroCat = null;
        if (_armature) _armature.animation.gotoAndStopByFrame('idle');
        if (_armature && _armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, chooseAnimation);
        if (_armature && _armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
    }

    private function chooseAnimation(e:Event=null):void {
        if (!_armature) return;
        if (!_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, chooseAnimation);
        if (!_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimation);
        var k:int = int(Math.random() * 2);
        switch (k) {
            case 0:
                _armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 1:
                _armature.animation.gotoAndPlayByFrame('idle_2');
                break;
            case 2:
                _armature.animation.gotoAndPlayByFrame('idle_3');
                break;
            case 3:
                _armature.animation.gotoAndPlayByFrame('idle_4');
                break;
            case 3:
                _armature.animation.gotoAndPlayByFrame('idle_5');
                break;
        }
        _decorAnimation ++;
        if (_decorAnimation >= 7) {
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
                if (_heroCat) {
                    _heroCat.visible = true;
                    _heroCat.isFree = true;
                }
                stopAnimation();
                _decorAnimation = 0;
            }
        }
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

}
}
