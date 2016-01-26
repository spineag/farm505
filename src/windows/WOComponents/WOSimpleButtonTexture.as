/**
 * Created by andy on 1/21/16.
 */
package windows.WOComponents {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import starling.textures.TextureAtlas;

import utils.CButton;

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
        var i:int;
        var st:String = 'bt_b_b_';
        var useBig:Boolean = h<=35;

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
        addChild(im);
        arr.push(im);

        //right
        im = new Image(tex.getTexture(st+'r'));
        im.x = w - im.width;
        im.y = 0;
        addChild(im);
        arr.push(im);

        //center
        im = new Image(tex.getTexture(st+'c'));
        var a:int = 0;
        var countW:int = Math.ceil(w - arr[0].width - arr[1].width) + 1;
        for (i=0; i<countW; i++) {
            im = new Image(tex.getTexture(st+'c'));
            im.x = arr[0].x + arr[0].width + i - 1;
            im.y = 0;
            addChildAt(im, 0);
        }

        height = h*1.2; // because we have shadow in pictures
        arr.length = 0;
        flatten();
    }
}
}
