/**
 * Created by andy on 11/5/15.
 */
package windows {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;

public class CartonBackground extends Sprite{
    private var g:Vars = Vars.getInstance();

    public function CartonBackground(w:int, h:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var countW:int;
        var countH:int;
        var arr:Array = [];
        var i:int;
        var delta:int = 5;

        //top left
        im = new Image(tex.getTexture('carton_lt'));
        im.x = 0;
        im.y = 0;
        addChild(im);
        arr.push(im);

        // bottom left
        im = new Image(tex.getTexture('carton_ld'));
        im.x = 0;
        im.y = h - im.height;
        addChild(im);
        arr.push(im);

        // top right
        im = new Image(tex.getTexture('carton_rt'));
        im.x = w - im.width;
        im.y = 0;
        addChild(im);
        arr.push(im);

        // bottom right
        im = new Image(tex.getTexture('carton_rd'));
        im.x = w - im.width;
        im.y = h - im.height;
        addChild(im);
        arr.push(im);

        //top center and bottom center
        im = new Image(tex.getTexture('carton_cc'));
        countW = Math.ceil((w - arr[0].width - arr[2].width)/im.width);
        if (countW*(im.width - delta) < w - arr[0].width - arr[2].width) countW++;
        for (i=0; i<countW; i++) {
            im = new Image(tex.getTexture('carton_cc'));
            im.x = arr[0].x + arr[0].width + i*(im.width - delta);
            if (i == countW-1 && im.x > arr[2].x - 20) im.x = arr[2].x - 20;
            im.y = 0;
            addChildAt(im, 0);
            im = new Image(tex.getTexture('carton_cc'));
            im.x = arr[1].x + arr[1].width + i*(im.width - delta);
            if (i == countW-1 && im.x > arr[3].x - 20) im.x = arr[3].x - 20;
            im.y = h - im.height;
            addChildAt(im, 0);
        }

        // left and right
        im = new Image(tex.getTexture('carton_cc'));
        countH = Math.ceil((h - arr[0].height - arr[1].height)/im.height);
        if (countH*(im.height - delta) < h - arr[0].height - arr[1].height) countH++;
        for (i=0; i<countH; i++) {
            im = new Image(tex.getTexture('carton_cc'));
            im.y = arr[0].y + arr[0].height + i*(im.height - delta);
            if (i == countH-1 && im.y > arr[1].y - 20) im.y = arr[1].y - 20;
            im.x = 0;
            addChildAt(im, 0);
            im = new Image(tex.getTexture('carton_cc'));
            im.y = arr[2].y + arr[2].height + i*(im.height - delta);
            if (i == countH-1 && im.y > arr[3].y - 20) im.y = arr[3].y - 20;
            im.x = w - im.width;
            addChildAt(im, 0);
        }

        for (i=0; i<countW; i++) {
            for (var j:int=0; j<countH; j++) {
                im = new Image(tex.getTexture('carton_cc'));
                im.x = arr[0].x + arr[0].width + i*(im.width - delta);
                im.y = arr[0].y + arr[0].height + j*(im.height - delta);
                if (i == countH-1 && im.y > arr[3].y - 20) im.y = arr[3].y - 20;
                addChildAt(im, 0);
            }
            if (i == countW-1 && im.x > arr[2].x - 20) im.x = arr[2].x - 20;
        }

        arr.length = 0;
        touchable = false;
        flatten();
    }
}
}
