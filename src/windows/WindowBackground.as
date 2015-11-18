/**
 * Created by andy on 11/5/15.
 */
package windows {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;

public class WindowBackground extends Sprite{
    private var g:Vars = Vars.getInstance();

    public function WindowBackground(w:int, h:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var countW:int;
        var countH:int;
        var arr:Array = [];
        var i:int;
        var delta:int = 5;

        //top left
        im = new Image(tex.getTexture('window_lt'));
        im.x = -w/2;
        im.y = -h/2;
        addChild(im);
        arr.push(im);

        // bottom left
        im = new Image(tex.getTexture('window_ld'));
        im.x = -w/2;
        im.y = h/2 - im.height;
        addChild(im);
        arr.push(im);

        // top right
        im = new Image(tex.getTexture('window_rt'));
        im.x = w/2 - im.width;
        im.y = -h/2;
        addChild(im);
        arr.push(im);

        // bottom right
        im = new Image(tex.getTexture('window_rd'));
        im.x = w/2 - im.width;
        im.y = h/2 - im.height;
        addChild(im);
        arr.push(im);

        //top center and bottom center
        im = new Image(tex.getTexture('window_ct'));
        countW = Math.ceil((w - arr[0].width - arr[2].width)/im.width);
        if (countW*(im.width - delta) < w - arr[0].width - arr[2].width) countW++;
        for (i=0; i<countW; i++) {
            im = new Image(tex.getTexture('window_ct'));
            im.x = arr[0].x + arr[0].width + i*(im.width - delta);
            im.y = -h/2;
            addChildAt(im, 0);
            im = new Image(tex.getTexture('window_cd'));
            im.x = arr[1].x + arr[1].width + i*(im.width - delta);
            im.y = h/2 - im.height;
            addChildAt(im, 0);
        }

        // left and right
        im = new Image(tex.getTexture('window_lc'));
        countH = Math.ceil((h - arr[0].height - arr[1].height)/im.height);
        if (countH*(im.height - delta) < h - arr[0].height - arr[1].height) countH++;
        for (i=0; i<countH; i++) {
            im = new Image(tex.getTexture('window_lc'));
            im.y = arr[0].y + arr[0].height + i*(im.height - delta);
            im.x = -w/2;
            addChildAt(im, 0);
            im = new Image(tex.getTexture('window_rc'));
            im.y = arr[2].y + arr[2].height + i*(im.height - delta);
            im.x = w/2 - im.width;
            addChildAt(im, 0);
        }

        for (i=0; i<countW; i++) {
            for (var j:int=0; j<countH; j++) {
                im = new Image(tex.getTexture('window_cc'));
                im.x = arr[0].x + arr[0].width + i*(im.width - delta);
                im.y = arr[0].y + arr[0].height + j*(im.height - delta);
                addChildAt(im, 0);
            }
        }

        arr.length = 0;
//        touchable = false;
        flatten();
    }
}
}
