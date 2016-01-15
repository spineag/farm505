/**
 * Created by user on 7/22/15.
 */
package build.orders {
import build.AreaObject;

import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;

import manager.ManagerFilters;


import mouse.ToolsModifier;

import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.utils.Color;


public class Order extends AreaObject{
    private var _armature:Armature;

    public function Order (data:Object) {
        super (data);
        if (!data) {
            Cc.error('no data for Order');
            g.woGameError.showIt();
            return;
        }
        createOrderBuild();
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;
    }

    public function createOrderBuild():void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _armature = g.allData.factory['order'].buildArmature("cat");
        _build.addChild(_armature.display as Sprite);
        _defaultScale = 1;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        if (_flip) _build.scaleX = -_defaultScale;
        _source.addChild(_build);
        WorldClock.clock.add(_armature);
        _armature.addEventListener(AnimationEvent.COMPLETE, makeAnimation);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, makeAnimation);
        makeAnimation();
    }

    private function onHover():void {
        if (g.selectedBuild) return;
        _source.filter = ManagerFilters.BUILD_STROKE;
        g.hint.showIt(_dataBuild.name);
    }

    private function onOut():void {
        _source.filter = null;
        g.hint.hideIt();
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                onOut();
                if (g.isActiveMapEditor)
                    g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) return;
            _source.filter = null;
            g.woOrder.showIt();
            g.hint.hideIt();
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        _armature.removeEventListener(AnimationEvent.COMPLETE, makeAnimation);
        _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, makeAnimation);
        WorldClock.clock.remove(_armature);
        _armature.dispose();
        super.clearIt();
    }

    private function makeAnimation(e:AnimationEvent=null):void {
        var k:Number = Math.random();
        if (k < .2)
            _armature.animation.gotoAndPlay('idle');
        else if (k < .4)
           _armature.animation.gotoAndPlay('idle2');
        else if (k < .6)
            _armature.animation.gotoAndPlay('idle3');
        else if (k < .8)
            _armature.animation.gotoAndPlay('idle4');
        else
            _armature.animation.gotoAndPlay('idle5');
    }
}
}
