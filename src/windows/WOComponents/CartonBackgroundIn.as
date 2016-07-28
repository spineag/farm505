/**
 * Created by andy on 11/5/15.
 */
package windows.WOComponents {
import manager.Vars;

import starling.display.BlendMode;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class CartonBackgroundIn extends Sprite{
    private var g:Vars = Vars.getInstance();

    public function CartonBackgroundIn(w:int, h:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var countW:int;
        var countH:int;
        var arr:Array = [];
        var i:int;
        var delta:int = 1;

        if (w%2) w++;
        if (h%2) h++;

        //top left
        im = new Image(tex.getTexture('shop_window_lt'));
        im.x = 0;
        im.y = 0;
        addChild(im);
        arr.push(im);

        // bottom left
        im = new Image(tex.getTexture('shop_window_dl'));
        im.x = 0;
        im.y = h - im.height;
        addChild(im);
        arr.push(im);

        // top right
        im = new Image(tex.getTexture('shop_window_rt'));
        im.x = w - im.width;
        im.y = 0;
        addChild(im);
        arr.push(im);

        // bottom right
        im = new Image(tex.getTexture('shop_window_dr'));
        im.x = w - im.width;
        im.y = h - im.height;
        addChild(im);
        arr.push(im);

        //top center and bottom center
        var te1:Texture = tex.getTexture('shop_window_ct');
        var te2:Texture = tex.getTexture('shop_window_dc');
        im = new Image(te1);
        countW = Math.ceil((w - arr[0].width - arr[2].width)/im.width);
        if (countW*(im.width - delta) < w - arr[0].width - arr[2].width) countW++;
        for (i=0; i<=countW; i++) {
            im = new Image(te1);
            if (i == countW) {
                im.x = arr[2].x - im.width + 5;
            } else {
                im.x = arr[1].x + arr[1].width + i * (im.width - delta);
            }
            im.y = 0;
            addChildAt(im, 0);
            im = new Image(te2);
            if (i == countW) {
                im.x = arr[3].x - im.width + 5;
            } else {
                im.x = arr[1].x + arr[1].width + i * (im.width - delta);
            }
            im.y = h - im.height;
            addChildAt(im, 0);
        }

        // left and right
        te1 = tex.getTexture('shop_window_cl');
        te2 = tex.getTexture('shop_window_cr');
        im = new Image(te1);
        countH = Math.ceil((h - arr[0].height - arr[1].height)/im.height);
        if (countH*(im.height - delta) < h - arr[0].height - arr[1].height) countH++;
        for (i=0; i<=countH; i++) {
            im = new Image(te1);
            if (i == countH) {
                im.y = arr[1].y - im.width + 5;
            } else {
                im.y = arr[0].y + arr[0].height + i * (im.height - delta);
            }
            im.x = 0;
            addChildAt(im, 0);
            im = new Image(te2);
            if (i == countH) {
                im.y = arr[3].y - im.width + 5;
            } else {
                im.y = arr[2].y + arr[2].height + i * (im.height - delta);
            }
            im.x = w - im.width;
            addChildAt(im, 0);
        }

        var j:int;
        te1 = tex.getTexture('shop_window_cc');
        for (i=0; i<=countW; i++) {
            for (j=0; j<countH; j++) {
                im = new Image(te1);
                if (i == countW) {
                    im.x = arr[2].x - im.width;
                } else {
                    im.x = arr[0].x + arr[0].width + i*(im.width - delta);
                }
                if (j == countH-1) {
                    im.y = arr[1].y - im.height;
                } else {
                    im.y = arr[0].y + arr[0].height + j*(im.height - delta);
                }
                addChildAt(im, 0);
            }
        }

        arr.length = 0;
        touchable = false;
        flatten();
    }

    public function deleteIt():void {
        filter = null;
        dispose();
        g = null;
    }
}
}
