/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.WorldObject;
import com.junkbyte.console.Cc;
import manager.ManagerFilters;
import manager.OwnEvent;
import mouse.ToolsModifier;

import starling.display.Image;
import starling.events.Event;

import windows.WindowsManager;

public class Decor extends WorldObject{
    public function Decor(_data:Object) {
        super(_data);
        createBuildDecor();
        _source.releaseContDrag = true;
    }

    private function createBuildDecor():void {
        var im:Image;
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }

        im = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image));
        im.x = _dataBuild.innerX;
        im.y = _dataBuild.innerY;

        if (!im) {
            Cc.error('Ambar:: no such image: ' + _dataBuild.image + ' for ' + _dataBuild.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject:: no such image');
            return;
        }
        _build.addChild(im);
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        _source.addChild(_build);

        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
            _hitArea = g.managerHitArea.getHitArea(_source, 'decor' + _dataBuild.image);
            _source.registerHitArea(_hitArea);
        }
    }

    private function onHover():void {
        if (g.selectedBuild) return;
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY)
            _source.filter = ManagerFilters.BUILD_STROKE;
    }

    private function onClick():void {
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

        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function onOut():void {
        _source.filter = null;
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

}
}
