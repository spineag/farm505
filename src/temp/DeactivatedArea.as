/**
 * Created by andy on 5/30/15.
 */
package temp {

import starling.display.Image;
import starling.textures.Texture;
import utils.CSprite;

public class DeactivatedArea {
    public var source:CSprite;
    public var posX:int;
    public var posY:int;
    private var onRemoveCallback:Function;

    public function DeactivatedArea(_x:int, _y:int, texture:Texture, f:Function) {
        var im:Image = new Image(texture);
        im.x = -im.width/2;
        source = new CSprite();
        source.addChild(im);
        source.endClickCallback = onEndedTouch;
        onRemoveCallback = f;
        posX = _x;
        posY = _y;
    }

    private function onEndedTouch():void {
        if (onRemoveCallback != null) {
            onRemoveCallback.apply(null, [this]);
        }
    }
}
}
