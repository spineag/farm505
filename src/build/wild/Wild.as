/**
 * Created by user on 6/11/15.
 */
package build.wild {
import build.AreaObject;
import build.lockedLand.LockedLand;
import com.junkbyte.console.Cc;
import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.utils.Color;

import ui.xpPanel.XPStar;

public class Wild extends AreaObject{
    private var _isOnHover:Boolean;
    private var _curLockedLand:LockedLand;

    public function Wild(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('Wild:: no data');
            g.woGameError.showIt();
            return;
        }
        createBuild();

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;
        _isOnHover = false;
    }

    public function setLockedLand(l:LockedLand):void {
        _curLockedLand = l;
        _source.isTouchable = false;
    }

    public function setFilter(f:ColorMatrixFilter):void {
        _source.filter = f;
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.GREEN, 10, 2, 1);
        _isOnHover = true;
    }

    private function onOut():void {
        _source.filter = null;
        _isOnHover = false;
            if (!_isOnHover) g.wildHint.hideIt();
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.isActiveMapEditor)
                g.townArea.moveBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            if (g.isActiveMapEditor) {
                g.directServer.ME_removeWild(_dbBuildingId, null);
                g.townArea.deleteBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            if (g.isActiveMapEditor) {
                releaseFlip();
                g.directServer.ME_flipWild(_dbBuildingId, int(_dataBuild.isFlip), null);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (g.isAway) return;
            if (_source.wasGameContMoved) return;
            if (_isOnHover)  {
                g.wildHint.onDelete = wildDelete;
                g.wildHint.showIt(_source.x, _source.y + _dataBuild.innerY + 10, _dataBuild.removeByResourceId,_dataBuild.name);
            }
        } else {
            Cc.error('Wild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function wildDelete():void {
        if (g.userInventory.getCountResourceById(_dataBuild.removeByResourceId) == 0) return;
        g.userInventory.addResource(g.dataResource.objectResources[_dataBuild.removeByResourceId].id, -1);
        if (_dataBuild.xp) new XPStar(_source.x, _source.y, _dataBuild.xp);
        for (var i:int=0; i< g.user.userDataCity.objects.length; i++) {
            if (g.user.userDataCity.objects[i].dbId == _dbBuildingId) {
                g.user.userDataCity.objects.splice(i, 1);
                break;
            }
        }
        g.directServer.deleteUserWild(_dbBuildingId, null);
        g.townArea.deleteBuild(this);
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

    public function addItToMatrix():void {
        g.townArea.fillMatrix(posX, posY, _sizeX, _sizeY, this);
        _source.isTouchable = true;
    }
}
}
