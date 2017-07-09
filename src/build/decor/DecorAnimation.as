/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.WorldObject;
import build.lockedLand.LockedLand;
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
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;
import mouse.ToolsModifier;
import starling.display.Image;
import starling.events.Event;
import utils.Utils;

public class DecorAnimation extends WorldObject{
    private var _isHover:Boolean;
    private var _heroCatArray:Array;
    private var _armatureArray:Array;
    private var _decorWork:Boolean;
    private var _decorAnimation:int;
    private var  _awayAnimation:Boolean = false;
    private var _catsRunCount:int;
    private var _curLockedLand:LockedLand;

    public function DecorAnimation(_data:Object) {
        super(_data);
        _source.releaseContDrag = true;
        _isHover = false;
        _decorAnimation = 0;
        _catsRunCount = 0;
        _heroCatArray = [];
        _armatureArray = [];
        _decorWork = false;
        createAnimatedBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        if (_armature) {
            WorldClock.clock.add(_armature);
            _armature.animation.gotoAndPlayByFrame('idle');
            if (_dataBuild.color) {
                var name:String = (_dataBuild.url as String).replace(new RegExp("_" + String(_dataBuild.color), ""), '');
                _hitArea = g.managerHitArea.getHitArea(_source, name, ManagerHitArea.TYPE_LOADED);
            } else {
                _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.url, ManagerHitArea.TYPE_LOADED);
            }
            _source.registerHitArea(_hitArea);
            if (!g.isAway) {
                _source.hoverCallback = onHover;
                _source.endClickCallback = onClick;
                _source.outCallback = onOut;
            }
            if (_awayAnimation) {
                var delay:int = int(Math.random() * 5) + 2;
                var f1:Function = function (e:Event = null):void {
                    if (!_dataBuild) return;
                    if (_dataBuild.catNeed) releaseHeroCatManOrWoman(_armature);
                    chooseAnimationWithSingleCatOrNone();
                };
                Utils.createDelay(delay, f1);
            }
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

    override public function onOut():void {
        super.onOut();
        _isHover = false;
        if(_source) {
            if (_source.filter) _source.filter.dispose();
            _source.filter = null;
        }
    }

    public function awayAnimation():void { _awayAnimation = true; }
    public function get catNeed():Boolean { return _dataBuild.catNeed; }
    public function get decorWork():Boolean { return _decorWork; }
    public function get catRun():Boolean { return Boolean(_catsRunCount > 0); }

    public function needCatsCount():int {
        var ob:Object = g.allData.factory[_dataBuild.url].allDragonBonesData[_dataBuild.url];
        var oldBones:Vector.<String> = ob.armatureNames;
        return oldBones.length - 1;
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.isActiveMapEditor) {
                if (_curLockedLand) {
                    _curLockedLand.activateOnMapEditor(null,null,null, this);
                    _curLockedLand = null;
                }
                onOut();
                g.townArea.moveBuild(this);
            } else if (!_curLockedLand) {
                onOut();
                if (g.selectedBuild) {
                    if (g.selectedBuild == this) {
                        g.toolsModifier.onTouchEnded();
                    } else return;
                } else {
                    g.townArea.moveBuild(this);
                }
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
                forceStopDecorAnimation();
                g.directServer.addToInventory(_dbBuildingId, null);
                g.userInventory.addToDecorInventory(_dataBuild.id, _dbBuildingId);
                g.townArea.deleteBuild(this);
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
            if (_decorWork && _catsRunCount > 0) {
                var onOver:Function = function(e:Event=null):void {
                    _armature.removeEventListener(EventObject.COMPLETE, onOver);
                    _armature.removeEventListener(EventObject.LOOP_COMPLETE, onOver);
                };
                _armature.addEventListener(EventObject.COMPLETE, onOver);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, onOver);
                _armature.animation.gotoAndPlayByFrame('over');
                return;
            } else if (_decorWork) return;
            if (!g.managerCats.isFreeCatDecor) {
                var p:Point = new Point(_source.x, _source.y);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p, String(g.managerLanguage.allTexts[619]));
                return;
            }
            _decorWork = true;
            if (_dataBuild.catNeed) {
                var count:int  = needCatsCount();
                var heroCat:HeroCat;
                var armature:Armature;
                _decorAnimation = 0;
                if (count > 1) {
                    for (var i:int = 0; i < count; i++) {
                        heroCat = g.managerCats.getFreeCatDecor();
                        if (heroCat) {
                            heroCat.isFreeDecor = false;
                            heroCat.decorAnimation = (this as DecorAnimation);
                            _heroCatArray.push(heroCat);
                            _catsRunCount++;
                            armature = g.allData.factory[_dataBuild.url].buildArmature('cat' + String(count - i));
                            if (!armature) continue;
                            WorldClock.clock.add(armature);
                            armature.animation.gotoAndPlayByFrame('idle');
                            _build.addChild(armature.display as StarlingArmatureDisplay);
                            _armatureArray.push(armature);
                            g.managerCats.goCatToPoint(heroCat, new Point(posX, posY), onFinishHeroCatRun, armature, heroCat);
                        }
                    }
                } else {
                    heroCat = g.managerCats.getFreeCatDecor();
                    if (heroCat) {
                        heroCat.isFreeDecor = false;
                        heroCat.decorAnimation = (this as DecorAnimation);
                        _heroCatArray.push(heroCat);
                        _catsRunCount++;
                        g.managerCats.goCatToPoint(heroCat, new Point(posX, posY), chooseAnimationWithSingleCatOrNoneBefore);
                    }
                }
            } else chooseAnimationWithSingleCatOrNone();
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function onFinishHeroCatRun(armature:Armature,heroCat:HeroCat):void {
        if (heroCat) {
            _catsRunCount--;
            heroCat.visible = false;
            if (armature.animation.hasAnimation('start')) {
                var fEnd:Function = function (e:Event = null):void {
                    armature.removeEventListener(EventObject.COMPLETE, fEnd);
                    armature.removeEventListener(EventObject.LOOP_COMPLETE, fEnd);
                    chooseAnimationCats(null,armature, heroCat);
                };
                armature.addEventListener(EventObject.COMPLETE, fEnd);
                armature.addEventListener(EventObject.LOOP_COMPLETE, fEnd);
                releaseHeroCatManOrWoman(armature, heroCat);
                armature.animation.gotoAndPlayByFrame('start');
            } else {
                releaseHeroCatManOrWoman(armature, heroCat);
                chooseAnimationCats(null,armature, heroCat);
            }
        }
    }

    private function chooseAnimationCats(e:Event=null, armature:Armature =null, heroCat:HeroCat = null):void {
        var loop:Function = function (e:Event = null):void {
            armature.removeEventListener(EventObject.COMPLETE, loop);
            armature.removeEventListener(EventObject.LOOP_COMPLETE, loop);
            _decorAnimation++;
            if (_decorAnimation >= 7*_heroCatArray.length) {  // якщо перший закінчив анімацію 7 разів, то по цьому if всі інші теж вскорі перестануть
                if (armature.animation.hasAnimation('back')) {
                    var fEnd:Function = function (e:Event = null):void {
                        armature.removeEventListener(EventObject.COMPLETE, fEnd);
                        armature.removeEventListener(EventObject.LOOP_COMPLETE, fEnd);
                        finishAnimationForCat(heroCat, armature);
                    };
                    armature.addEventListener(EventObject.COMPLETE, fEnd);
                    armature.addEventListener(EventObject.LOOP_COMPLETE, fEnd);
                    armature.animation.gotoAndPlayByFrame('back');
                } else finishAnimationForCat(heroCat, armature);
            } else chooseAnimationCats(null,armature, heroCat);
        };
        if (!armature) return;
        if (!armature.hasEventListener(EventObject.COMPLETE)) armature.addEventListener(EventObject.COMPLETE, loop);
        if (!armature.hasEventListener(EventObject.LOOP_COMPLETE)) armature.addEventListener(EventObject.LOOP_COMPLETE, loop);
        var k:int = int(Math.random() * 5);
        switch (k) {
            case 0:
                armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 1:
                if (armature.animation.hasAnimation('idle_2')) armature.animation.gotoAndPlayByFrame('idle_2');
                else armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 2:
                if (armature.animation.hasAnimation('idle_3')) armature.animation.gotoAndPlayByFrame('idle_3');
                else if (armature.animation.hasAnimation('idle_2')) armature.animation.gotoAndPlayByFrame('idle_2');
                else armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 3:
                if (armature.animation.hasAnimation('idle_4')) armature.animation.gotoAndPlayByFrame('idle_4');
                else if (armature.animation.hasAnimation('idle_3')) armature.animation.gotoAndPlayByFrame('idle_3');
                else if (armature.animation.hasAnimation('idle_2')) armature.animation.gotoAndPlayByFrame('idle_2');
                else armature.animation.gotoAndPlayByFrame('idle_1');
                break;
            case 4:
                if (armature.animation.hasAnimation('idle_5')) armature.animation.gotoAndPlayByFrame('idle_5');
                else if (armature.animation.hasAnimation('idle_4')) armature.animation.gotoAndPlayByFrame('idle_4');
                else if (armature.animation.hasAnimation('idle_3')) armature.animation.gotoAndPlayByFrame('idle_3');
                else if (armature.animation.hasAnimation('idle_2')) armature.animation.gotoAndPlayByFrame('idle_2');
                else armature.animation.gotoAndPlayByFrame('idle_1');
                break;
        }
    }

    private function finishAnimationForCat(heroCat:HeroCat, armature:Armature):void {
        if (armature) {
            armature.animation.gotoAndStopByFrame('idle');
            WorldClock.clock.remove(armature);
            if (_build.contains(armature.display as StarlingArmatureDisplay)) _build.removeChild(armature.display as StarlingArmatureDisplay);
            if (_armatureArray.indexOf(armature) >= 0) _heroCatArray.removeAt(_heroCatArray.indexOf(armature));
            armature.dispose();
        }
        if (heroCat) {
            heroCat.visible = true;
            heroCat.isFreeDecor = true;
            heroCat.decorAnimation = null;
            if (_heroCatArray.indexOf(heroCat) >= 0) _heroCatArray.removeAt(_heroCatArray.indexOf(heroCat));
        }
        if (!_heroCatArray.length) onFinishAllCatsAnimation();
    }

    private function onFinishAllCatsAnimation():void {
        _decorAnimation = 0;
        _catsRunCount = 0;
        _decorWork = false;
    }

    private function stopAnimationWithSingleCatOrNone():void {
        if (!_dataBuild) return;
        if (_armature) {
            _armature.animation.gotoAndPlayByFrame('idle');
            _armature.removeEventListener(EventObject.COMPLETE, chooseAnimationWithSingleCatOrNone);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, chooseAnimationWithSingleCatOrNone);
        }
        if (_heroCatArray.length) {
            (_heroCatArray[0] as HeroCat).visible = true;
            (_heroCatArray[0] as HeroCat).isFreeDecor = true;
            (_heroCatArray[0] as HeroCat).decorAnimation = null;
            _heroCatArray.length = 0;
        }
    }

    private function chooseAnimationWithSingleCatOrNoneBefore(e:Event=null):void {
        _heroCatArray[0].visible = false;
        releaseHeroCatManOrWoman(_armature,  _heroCatArray[0]);
        chooseAnimationWithSingleCatOrNone();
    }

    private function chooseAnimationWithSingleCatOrNone(e:Event=null):void {
        if (!_armature) return;
        if (!_dataBuild) return;
        if (!_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, chooseAnimationWithSingleCatOrNone);
        if (!_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimationWithSingleCatOrNone);
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
        _decorAnimation++;
        if (_decorAnimation >= 4 && !g.isAway) {
            if (_armature.animation.hasAnimation('back')) {
                var fEnd:Function = function (e:Event = null):void {
                    _decorWork = false;
                    _armature.removeEventListener(EventObject.COMPLETE, fEnd);
                    _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEnd);
                    stopAnimationWithSingleCatOrNone();
                };
                _armature.addEventListener(EventObject.COMPLETE, fEnd);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEnd);
                _armature.animation.gotoAndPlayByFrame('back');
                _decorAnimation = 0;
            } else {
                _decorWork = false;
                stopAnimationWithSingleCatOrNone();
                _decorAnimation = 0;
            }
        }
    }

    public function forceStopDecorAnimation():void {
        _decorAnimation = 0;
        _catsRunCount = 0;
        _decorWork = false;
        if (_armature) {
            _armature.animation.gotoAndPlayByFrame('idle');
        }
        if (_armatureArray.length) {
            for (var i:int=0; i<_armatureArray.length; i++) {
                if (_build.contains(_armatureArray[i].display as StarlingArmatureDisplay)) _build.removeChild(_armatureArray[i].display as StarlingArmatureDisplay);
                WorldClock.clock.remove(_armatureArray[i]);
                _armatureArray[i].dispose();
            }
            _armatureArray.length = 0;
        }
        if (_heroCatArray.length) {
            for (var k:int=0; k<_heroCatArray.length; k++) {
                (_heroCatArray[k] as HeroCat).isFreeDecor = true;
                (_heroCatArray[k] as HeroCat).decorAnimation = null;
                (_heroCatArray[k] as HeroCat).visible = true;
            }
            _heroCatArray.length = 0;
        }
    }

    public function forceStartDecorAnimation(h:HeroCat):void {
        if (!h) return;
        _heroCatArray.push(h);
        _decorWork = true;
        h.isFreeDecor = false;
        h.decorAnimation = (this as DecorAnimation);
        _catsRunCount = 1;
        var fEndOver:Function = function (e:Event = null):void {
            _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            g.managerCats.goCatToPoint(h, new Point(posX, posY), chooseAnimationWithSingleCatOrNone);
        };
        _armature.addEventListener(EventObject.COMPLETE, fEndOver);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
        _armature.animation.gotoAndPlayByFrame('over');
    }

    private function releaseHeroCatManOrWoman(armature:Armature = null, heroCat:HeroCat = null):void {
        if (!armature) return;
        if (!_dataBuild) return;
        if (heroCat) {
            if (heroCat.typeMan == BasicCat.MAN) {
                if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7 || _dataBuild.id == 255 || _dataBuild.id == 256 || _dataBuild.id == 257)
                    releaseManBackTexture(armature);
                else releaseManFrontTexture(armature);
            } else if (heroCat.typeMan == BasicCat.WOMAN) {
                if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7 || _dataBuild.id == 255 || _dataBuild.id == 256 || _dataBuild.id == 257)
                    releaseWomanBackTexture(armature);
                else releaseWomanFrontTexture(armature);
            }
        } else {
            if (_heroCatArray[0]) {
                if (_heroCatArray[0].typeMan == BasicCat.MAN) {
                    if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7 || _dataBuild.id == 255 || _dataBuild.id == 256 || _dataBuild.id == 257)
                        releaseManBackTexture();
                    else releaseManFrontTexture();
                } else if (_heroCatArray[0].typeMan == BasicCat.WOMAN) {
                    if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7 || _dataBuild.id == 255 || _dataBuild.id == 256 || _dataBuild.id == 257)
                        releaseWomanBackTexture();
                    else releaseWomanFrontTexture();
                }
            } else {
                if (g.isAway) {
                    if (Math.random() < .5) {
                        if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7 || _dataBuild.id == 255 || _dataBuild.id == 256 || _dataBuild.id == 257)
                            releaseManBackTexture(armature);
                        else releaseManFrontTexture(armature);
                    } else {
                        if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 7 || _dataBuild.id == 255 || _dataBuild.id == 256 || _dataBuild.id == 257)
                            releaseWomanBackTexture(armature);
                        else releaseWomanFrontTexture(armature);
                    }
                }
            }
        }
    }

    private function releaseManFrontTexture(armature:Armature = null):void {
        if (!_armature) return;
        changeTexture("head", "head",armature);
        changeTexture("body", "body",armature);
        changeTexture("handLeft", "hand_l",armature);
        changeTexture("legLeft", "leg_l",armature);
        changeTexture("handRight", "hand_r",armature);
        changeTexture("legRight", "leg_r",armature);
        changeTexture("tail", "tail",armature);
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "hand_r",armature);
        }
        var viyi:Bone;
        if (armature) viyi = armature.getBone('viyi');
        else viyi = _armature.getBone('viyi');
        if (viyi) {
            viyi.visible = false;
        }
    }

    private function releaseManBackTexture(armature:Armature = null):void {
        changeTexture("head", "head_b",armature);
        changeTexture("body", "body_b",armature);
        changeTexture("handLeft", "hand_l_b",armature);
        changeTexture("legLeft", "leg_l_b",armature);
        changeTexture("handRight", "hand_r_b",armature);
        changeTexture("legRight", "leg_r_b",armature);
        changeTexture("tail", "tail",armature);
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "hand_r_b",armature);
        }
    }

    private function releaseWomanFrontTexture(armature:Armature = null):void {
        if (!_armature) return;
        changeTexture("head", "head_w",armature);
        changeTexture("body", "body_w",armature);
        changeTexture("handLeft", "hand_w_l",armature);
        changeTexture("legLeft", "leg_w_r",armature);
        changeTexture("handRight", "hand_w_r",armature);
        changeTexture("legRight", "leg_w_r",armature);
        changeTexture("tail", "tail_w",armature);
        if (_dataBuild.id == 10) {
            changeTexture("handRight2", "hand_w_r",armature);
        }
        var viyi:Bone;
        if (armature)  viyi = armature.getBone('viyi');
        else viyi = _armature.getBone('viyi');
            if (viyi) {
                viyi.visible = true;
            }
    }

    private function releaseWomanBackTexture(armature:Armature = null):void {
        changeTexture("head", "head_w_b",armature);
        changeTexture("body", "body_w_b",armature);
        changeTexture("handLeft", "hand_w_l_b",armature);
        changeTexture("legLeft", "leg_w_l_b");
        changeTexture("handRight", "hand_w_r_b",armature);
        changeTexture("legRight", "leg_w_r_b",armature);
        changeTexture("tail", "tail_w",armature);
    }

    private function changeTexture(oldName:String, newName:String,armature:Armature = null):void {
        var im:Image;
        var b:Slot;
        if (armature) {
            im = new Image(g.allData.atlas['customisationAtlas'].getTexture(newName));
            if (armature) b = armature.getSlot(oldName);
            if (im && b) {
                b.displayList = null;
                b.display = im;
            } else {
                Cc.error('DecorAnimation changeTexture:: null Bone for oldName= ' + oldName + ' for decorId= ' + String(_dataBuild.id));
            }
        } else {
            im = new Image(g.allData.atlas['customisationAtlas'].getTexture(newName));
            if (_armature) b = _armature.getSlot(oldName);
            if (im && b) {
                b.displayList = null;
                b.display = im;
            } else {
                Cc.error('DecorAnimation changeTexture:: null Bone for oldName= ' + oldName + ' for decorId= ' + String(_dataBuild.id));
            }
        }
    }

    public function setLockedLand(l:LockedLand):void {
        _curLockedLand = l;
    }

    public function get isAtLockedLand():Boolean {
        if (_curLockedLand) return true;
        else return false;
    }

    public function removeLockedLand():void {
        _curLockedLand = null;
        g.directServer.deleteUserWild(_dbBuildingId, null);
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        forceStopDecorAnimation();
        super.clearIt();
    }

}
}
