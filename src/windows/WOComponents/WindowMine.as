/**
 * Created by user on 12/14/15.
 */
package windows.WOComponents {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;

public class WindowMine extends Sprite {
    private var g:Vars = Vars.getInstance();

    public function WindowMine(w:int, h:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var countW:int;
        var countH:int;
        var arr:Array = [];
        var i:int;
        var delta:int = 4;

        if (w%2) w++;
        if (h%2) h++;

        //top left
        im = new Image(tex.getTexture('build_window_top_left'));
        im.x = -w/2;
        im.y = -h/2;
        addChild(im);
        arr.push(im);

        // bottom left
        im = new Image(tex.getTexture('build_window_down_left'));
        im.x = -w/2;
        im.y = h/2 - im.height;
        addChild(im);
        arr.push(im);

        // top right
        im = new Image(tex.getTexture('build_window_top_right'));
        im.x = w/2 - im.width;
        im.y = -h/2;
        addChild(im);
        arr.push(im);

        // bottom right
        im = new Image(tex.getTexture('build_window_down_right'));
        im.x = w/2 - im.width;
        im.y = h/2 - im.height;
        addChild(im);
        arr.push(im);

        //top center and bottom center
        im = new Image(tex.getTexture('build_window_top'));
        countW = Math.ceil((w - arr[0].width - arr[2].width)/im.width);
        if (countW*(im.width - delta) < w - arr[0].width - arr[2].width) countW++;
        for (i=0; i<countW; i++) {
            im = new Image(tex.getTexture('build_window_top'));
            im.x = arr[0].x + arr[0].width + i * (im.width - delta) - 1;
            im.y = -h/2;
            addChildAt(im, 0);
            im = new Image(tex.getTexture('build_window_down'));
            im.x = arr[1].x + arr[1].width + i*(im.width - delta);
            im.y = h/2 - im.height;
            addChildAt(im, 0);
        }

        // left and right
        im = new Image(tex.getTexture('build_window_left'));
        countH = Math.ceil((h - arr[0].height - arr[1].height)/im.height);
        if (countH*(im.height - delta) < h - arr[0].height - arr[1].height) countH++;
        for (i=0; i<countH; i++) {
            im = new Image(tex.getTexture('build_window_left'));
            im.y = arr[0].y + arr[0].height + i*(im.height - delta);
            if (i == countH-1 && im.y > arr[1].y - 90) im.y = arr[1].y - 90;
            im.x = -w/2;
            addChildAt(im, 0);
            im = new Image(tex.getTexture('build_window_right'));
            im.y = arr[2].y + arr[2].height + i*(im.height - delta);
            if (i == countH-1 && im.y > arr[3].y - 90) im.y = arr[3].y - 90;
            im.x = w/2 - im.width;
            addChildAt(im, 0);
        }

        arr.length = 0;
        flatten();
    }
}
}
