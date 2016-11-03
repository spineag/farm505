/**
 * Created by andy on 11/3/16.
 */
package tutorial.pretuts {
import flash.geom.Rectangle;

import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;

public class TutorialMultBG {
    private var g:Vars = Vars.getInstance();
    public var source:Sprite;
    private var _w:int;
    private var _h:int;

    public function TutorialMultBG() {
        source = new Sprite();
        _w = g.managerResize.stageWidth;
        _h = g.managerResize.stageHeight;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('screen_fon_2'));
        im.tileGrid = new Rectangle();
        im.width = _w;
        source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('screen_fon_2'));
        im.tileGrid = new Rectangle();
        im.width = _w;
        im.scaleY=-1;
        im.y = _h;
        source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('screen_fon_1'));
        im.tileGrid = new Rectangle();
        im.width = _w;
        im.height = _h;
        source.addChildAt(im, 0);
//        var q:Quad = new Quad(500, 500);
//        _tempBG.setVertexColor(0, 0x7FAFB3);
//        _tempBG.setVertexColor(1, 0x7FAFB3);
//        _tempBG.setVertexColor(2, 0xA4C6C8);
//        _tempBG.setVertexColor(3, 0xA4C6C8);
        source.pivotX = _w/2;
        source.pivotY = _h/2;
        source.alignPivot();
    }
    
    public function deleteIt():void {
        source.dispose();
        source = null;
    }
}
}
