/**
 * Created by user on 6/11/15.
 */
package build.wild {
import build.AreaObject;

import com.junkbyte.console.Cc;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.utils.Color;

public class Wild extends AreaObject{
    private var _isOnHover:Boolean;

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

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.GREEN, 10, 2, 1);
        _isOnHover = true;
        g.wildHint.onDelete = wildDelete;
    }

    private function onOut():void {
        _source.filter = null;
        _isOnHover = false;
            if (!_isOnHover) g.wildHint.hideIt();
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            g.townArea.moveBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) return;
            if (_isOnHover)  g.wildHint.showIt(_source.x, _source.y + _dataBuild.innerY + 10,_dataBuild.removeByResourceId);
        } else {
            Cc.error('Wild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function wildDelete():void {
        g.userInventory.addResource(g.dataResource.objectResources[_dataBuild.removeByResourceId].id, 1);
        g.townArea.deleteBuild(this);
    }


}
}
