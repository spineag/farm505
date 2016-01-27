/**
 * Created by user on 11/26/15.
 */
package windows.WOComponents {
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class HorizontalPlawka extends Sprite{

    public function HorizontalPlawka(lt:Texture, ct:Texture, rt:Texture, w:int) {
        var lW:int;
        if (lt) {
            var iL:Image = new Image(lt);
            addChild(iL);
            lW = iL.width;
        } else {
            lW = 0;
        }
        var imR:Image = new Image(rt);
        imR.x = w - imR.width;
        addChild(imR);

        var imC:Image = new Image(ct);
        var k:int = Math.ceil((w - lW - imR.width)/(imC.width-1));
        for (var i:int=0; i<k-1; i++) {
            imC.x = lW + i*(imC.width-1);
            addChildAt(imC, 0);
            imC = new Image(ct);
        }
        imC.x = w - imR.width - (imC.width-1);
        addChild(imC);
        flatten();
        imC=null;
        if (iL) iL=null;
        imR=null;
    }
}
}
