/**
 * Created by andy on 5/30/15.
 */
package temp.deactivatedArea {

import manager.Vars;
import mouse.ToolsModifier;
import starling.display.Image;
import starling.display.Sprite;

import utils.CSprite;

public class DeactivatedArea {
    public var source:Sprite;
    public var posX:int;
    public var posY:int;
    private var onRemoveCallback:Function;
    private var g:Vars = Vars.getInstance();

    public function DeactivatedArea(_x:int, _y:int) {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_tile'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -im.width/2;
        source = new Sprite();
        source.addChild(im);
        posX = _x;
        posY = _y;
        source.touchable = false;
    }

    public function clearIt():void {
        source.dispose();
        onRemoveCallback = null;
    }
}
}
