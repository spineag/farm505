/**
 * Created by andy on 1/21/16.
 */
package windows.WOComponents {
import flash.geom.Rectangle;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;
import utils.CButton;
import utils.DrawToBitmap;

public class WOSimpleButtonTexture  extends Sprite {
    public static const GREEN:int = 1;
    public static const BLUE:int = 2;
    public static const YELLOW:int = 3;
    public static const PINK:int = 4;
    private var g:Vars = Vars.getInstance();

    public function WOSimpleButtonTexture(w:int, h:int, _type:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var arr:Array = [];
        var st:String = 'bt_b_b_';
        var useBig:Boolean = h<=35;
        var _s:Sprite = new Sprite();

        if (w%2) w++;
        if (h%2) h++;

        switch (_type) {
            case CButton.GREEN:
                if (useBig) st = 'bt_b_g_';
                    else st = 'bt_s_g_';
                break;
            case CButton.BLUE:
                if (useBig) st = 'bt_b_b_';
                    else st = 'bt_s_b_';
                break;
            case CButton.YELLOW:
                if (useBig) st = 'bt_b_y_';
                    else st = 'bt_s_y_';
                break;
            case CButton.PINK:
                if (useBig )st = 'bt_b_m_';
                    else st = 'bt_s_m_';
                break;
        }

        //left
        im = new Image(tex.getTexture(st+'l'));
        im.x = 0;
        im.y = 0;
        _s.addChild(im);
        arr.push(im);

        //right
        im = new Image(tex.getTexture(st+'r'));
        im.x = w - im.width;
        im.y = 0;
        _s.addChild(im);
        arr.push(im);

        //center
        var temp:int;
        im = new Image(tex.getTexture(st+'c'));
        temp = im.height;
        im.tileGrid = new Rectangle();
        im.width = w - arr[0].width - arr[1].width;
        im.x = arr[0].x + arr[0].width;
        im.tileGrid = im.tileGrid;
        _s.addChildAt(im, 0);

        // add shadows
        im = new Image(tex.getTexture('shadow_s'));
        im.tileGrid = new Rectangle();
        im.width = w - arr[0].width - arr[1].width;
        im.x = arr[0].x + arr[0].width;
        im.y = temp - 2;
        _s.addChildAt(im, 0);

        arr.length = 0;
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(_s));
        im.height = int(h*1.2); // because we have shadow in pictures
        addChild(im);
        _s.dispose();
    }

    public function deleteIt():void {
        dispose();
        g = null;
    }
}
}
