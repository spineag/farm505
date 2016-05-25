/**
 * Created by andy on 5/28/15.
 */
package build.ambar {
import build.WorldObject;
import com.junkbyte.console.Cc;
import manager.ManagerFilters;
import mouse.ToolsModifier;

import starling.display.Image;
import starling.display.Sprite;

import windows.WindowsManager;
import windows.ambar.WOAmbars;

public class Ambar extends WorldObject{
    private var _isOnHover:Boolean;
    private var _ambarIndicator:AmbarIndicator;

    public function Ambar(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Ambar');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Ambar');
            return;
        }
        createAtlasBuild(onCreateBuild);
        _ambarIndicator = new AmbarIndicator();
        _ambarIndicator.source.x = -36 * g.scaleFactor;
        _ambarIndicator.source.y = -210 * g.scaleFactor;
        _build.addChild(_ambarIndicator.source);

        _source.releaseContDrag = true;
        _dbBuildingId = _data.dbId;
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (!_isOnHover) {
            makeOverAnimation();
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        }
        _isOnHover = true;
        g.hint.showIt(_dataBuild.name,true);
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) return;
        if (g.managerCutScenes.isCutScene) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                onOut();
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            onOut();
            g.townArea.deleteBuild(this);
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
            onOut();
            g.user.visitAmbar = true;
            if (!_source.wasGameContMoved) g.windowsManager.openWindow(WindowsManager.WO_AMBAR, null, WOAmbars.AMBAR);
        } else {
            Cc.error('Ambar:: unknown g.toolsModifier.modifierType')
        }
    }

    override public function onOut():void {
        super.onOut();
       _isOnHover = false;
        _source.filter = null;
        g.hint.hideIt();
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

    public function updateIndicatorProgress():void {
        _ambarIndicator.updateProgress();
    }


}
}
