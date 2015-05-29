/**
 * Created by andy on 5/28/15.
 */
package build.testBuild {
import build.AreaObject;

import com.junkbyte.console.Cc;

import mouse.ToolsModifier;

public class TestBuild extends AreaObject{
    public function TestBuild(_data:Object) {
        super(_data);

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
    }

    private function onHover():void {

    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {

        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function onOut():void {

    }
}
}
