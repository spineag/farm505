/**
 * Created by user on 11/26/15.
 */
package windows.WOComponents {
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class HorizontalPlawka extends Sprite{

    public function HorizontalPlawka(lt:Texture, ct:Texture, rt:Texture, w:int) {
        var imL:Image = new Image(lt);
        addChild(imL);
        var imR:Image = new Image(rt);
        imR.x = w - imR.width;
        addChild(imR);

        var imC:Image = new Image(ct);
        var k:int = Math.ceil((w - imL.width - imR.width)/imC.width);
        for (var i:int=0; i<k-1; i++) {
            imC.x = imL.width + i*imC.width;
            addChildAt(imC, 0);
            imC = new Image(ct);
        }
        imC.x = w - imR.width - imC.width;
        addChild(imC);
        flatten();
        touchable = false;
        imC=null;
        imL=null;
        imR=null;
    }
}
}
