/**
 * Created by user on 1/14/16.
 */
package windows.fabricaWindow {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;

import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;

public class WOFabricNumber {
    public var source:CSprite;
    protected var g:Vars = Vars.getInstance();

    public function WOFabricNumber(n:int) {
        var txt:CTextField;
        var im:Image;
        source = new CSprite();
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_bt_number'));
        source.addChild(im);
        txt = new CTextField(32, 32, String(n));
        txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR, Color.WHITE)
        txt.y = 20;
        txt.x = 2;
        source.addChild(txt);
    }

    private function onHover():void {
        source.filter = ManagerFilters.getButtonHoverFilter();
    }

    private function onOut():void {
        source.filter = null;
    }

    public function deleteIt():void {
        source.deleteIt();
        source = null;
    }


}
}
