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
        txt = new TextField(32, 32, String(n), g.allData.fonts['BloggerBold'], 22, ManagerFilters.TEXT_BLUE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
        txt.y = 20;
        txt.x = 2;
        source.addChild(txt);
        source.flatten();
    }

    private function onHover():void {
        source.filter = ManagerFilters.BUTTON_HOVER_FILTER;
    }

    private function onOut():void {
        source.filter = null;
    }

    public function deleteIt():void {
        source.filter = null;
        source.endClickParams = -1;
        source.endClickCallback = null;
        source.unflatten();
        while (source.numChildren) source.removeChildAt(0);
        source.dispose();
        source = null;
    }


}
}
