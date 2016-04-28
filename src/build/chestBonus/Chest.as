/**
 * Created by user on 4/27/16.
 */
package build.chestBonus {
import build.AreaObject;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;

import mouse.ToolsModifier;

import starling.display.Sprite;

import windows.WindowsManager;

public class Chest extends AreaObject{
    private var _armature:Armature;
    private var _timerAnimation:int;
    public function Chest(data:Object) {
        super (data);
        _source.endClickCallback = onClick;
        createBuild();
    }

    override public function createBuild(isImageClicked:Boolean = true):void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _armature = g.allData.factory['chest_mini'].buildArmature("cat");
        _build.addChild(_armature.display as Sprite);
        WorldClock.clock.add(_armature);
        _defaultScale = 1;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        if (_flip) _build.scaleX = -_defaultScale;
        _source.addChild(_build);
        animation();
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES
                || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            g.windowsManager.openWindow(WindowsManager.WO_CHEST, null, 1);
            if (g.isAway) g.townArea.deleteAwayBuild(this);
            g.townArea.deleteBuild(this);
            g.managerChest.setCount = 1;
            g.directServer.useChest(g.managerChest.getCount);
        }
    }

    private function animation():void {
        _timerAnimation = 5*Math.random();
        g.gameDispatcher.addToTimer(timerAnimation);
    }

    private function timerAnimation():void {
        _timerAnimation --;
        if (_timerAnimation <=0) {
            if(_armature == null) return;
            _armature.animation.gotoAndPlay('idle',0);
            g.gameDispatcher.removeFromTimer(timerAnimation);
            animation();
        }
    }
}
}
