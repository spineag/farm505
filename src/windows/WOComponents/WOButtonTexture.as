/**
 * Created by user on 11/24/15.
 */
package windows.WOComponents {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;
import utils.CButton;

public class WOButtonTexture extends Sprite {
    public static const GREEN:int = 1;
    public static const BLUE:int = 2;
    public static const YELLOW:int = 3;
    private var g:Vars = Vars.getInstance();

    public function WOButtonTexture(w:int, h:int, _type:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var countW:int;
        var countH:int;
        var arr:Array = [];
        var i:int;
        var delta:int = 0;
        var st:String = 'bt_b_';

        switch (_type) {
            case CButton.GREEN: st = 'bt_gr_'; break;
            case CButton.BLUE: st = 'bt_b_'; break;
            case CButton.YELLOW: st = 'bt_y_'; break;
        }

        //top left
        im = new Image(tex.getTexture(st+'lt'));
        im.x = 0;
        im.y = 0;
        addChild(im);
        arr.push(im);

        // bottom left
        im = new Image(tex.getTexture(st+'ld'));
        im.x = 0;
        im.y = h - im.height;
        addChild(im);
        arr.push(im);

        // top right
        im = new Image(tex.getTexture(st+'rt'));
        im.x = w - im.width;
        im.y = 0;
        addChild(im);
        arr.push(im);

        // bottom right
        im = new Image(tex.getTexture(st+'rd'));
        im.x = w - im.width;
        im.y = h - im.height;
        addChild(im);
        arr.push(im);

        //top center and bottom center
        im = new Image(tex.getTexture(st+'c'));
        countW = Math.ceil((w - arr[0].width - arr[2].width)/im.width);
        for (i=0; i<countW; i++) {
            im = new Image(tex.getTexture(st+'c'));
            im.x = arr[0].x + arr[0].width + i*(im.width - delta);
            if (i == countW-1 && im.x > arr[2].x - 2) im.x = arr[2].x - 2;
            im.y = 0;
            addChildAt(im, 0);
            im = new Image(tex.getTexture(st+'c'));
            im.x = arr[1].x + arr[1].width + i*(im.width - delta);
            im.y = h - im.height;
            addChildAt(im, 0);
        }

        // left and right
        im = new Image(tex.getTexture(st+'c'));
        countH = Math.ceil((h - arr[0].height - arr[1].height)/im.height);
        if (countH*(im.height - delta) < h - arr[0].height - arr[1].height) countH++;
        for (i=0; i<countH; i++) {
            im = new Image(tex.getTexture(st+'c'));
            im.y = arr[0].y + arr[0].height + i*(im.height - delta);
            im.x = 0;
            addChildAt(im, 0);
            im = new Image(tex.getTexture(st+'c'));
            im.y = arr[2].y + arr[2].height + i*(im.height - delta);
            im.x = w - im.width;
            addChildAt(im, 0);
        }

        for (i=0; i<countW; i++) {
            for (var j:int=0; j<countH; j++) {
                im = new Image(tex.getTexture(st+'c'));
                im.x = arr[0].x + arr[0].width + i*(im.width - delta);
                im.y = arr[0].y + arr[0].height + j*(im.height - delta);
                addChildAt(im, 0);
            }
        }

        arr.length = 0;
        flatten();
    }
}
}
