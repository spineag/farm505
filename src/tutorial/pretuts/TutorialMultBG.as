/**
 * Created by andy on 11/3/16.
 */
package tutorial.pretuts {
import flash.geom.Rectangle;
import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import utils.GradientTexture;

public class TutorialMultBG {
    private var g:Vars = Vars.getInstance();
    public var source:Sprite;
    private var _w:int;
    private var _h:int;

    public function TutorialMultBG() {
        source = new Sprite();
        _w = g.managerResize.stageWidth;
        _h = g.managerResize.stageHeight;
        var q:Quad = new Quad(_w+20, _h+20, Color.WHITE);
        source.addChild(q);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('screen_fon_2'));
        im.tileGrid = new Rectangle();
        im.width = _w + 20;
        source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('screen_fon_2'));
        im.tileGrid = new Rectangle();
        im.width = _w + 20;
        im.scaleY=-1;
        im.y = _h+20;
        source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('screen_fon_1'));
        im.tileGrid = new Rectangle();
        im.width = _w + 20;
        im.height = _h + 20;
        source.addChildAt(im, 1);

        source.pivotX = _w/2;
        source.pivotY = _h/2;

        var bgGradientTexture:Texture = GradientTexture.createRadilGradientInCircle(400, [Color.WHITE, 0xEEEEEE], [1, 0]);
        im = new Image(bgGradientTexture);
        im.alignPivot();
        im.x = _w/2 + 20;
        im.y = _h/2 + 20;
        source.addChild(im);
    }
    
    public function deleteIt():void {
        source.dispose();
        source = null;
    }
}
}
