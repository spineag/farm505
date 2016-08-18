/**
 * Created by user on 1/14/16.
 */
package windows.fabricaWindow {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;

import starling.text.TextField;

import utils.CSprite;

public class WOFabricNumber {
    public var source:CSprite;
    protected var g:Vars = Vars.getInstance();

    public function WOFabricNumber(n:int) {
        var txt:TextField;
        var im:Image;
        source = new CSprite();
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_bt_number'));
        source.addChild(im);
        txt = new TextField(32, 32, String(n), g.allData.bFonts['BloggerBold24'], 22, ManagerFilters.TEXT_BLUE_COLOR);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
        txt.y = 20;
        txt.x = 2;
        source.addChild(txt);
        source.flatten();
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
