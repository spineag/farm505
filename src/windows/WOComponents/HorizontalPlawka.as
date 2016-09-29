/**
 * Created by user on 11/26/15.
 */
package windows.WOComponents {
import flash.geom.Rectangle;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class HorizontalPlawka extends Sprite{

    public function HorizontalPlawka(lt:Texture, ct:Texture, rt:Texture, w:int) {
        var lW:int;
        var iL:Image;
        if (lt) {
            iL = new Image(lt);
            addChild(iL);
            lW = iL.width;
        } else {
            lW = 0;
        }
        var imR:Image = new Image(rt);
        imR.x = w - imR.width;
        addChild(imR);

        var imC:Image = new Image(ct);
        imC.tileGrid = new Rectangle();
        imC.width = w - lW - imR.width;
        imC.x = lW;
        addChild(imC);
    }

    public function deleteIt():void {
        dispose();
    }
}
}
