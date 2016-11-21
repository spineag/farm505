/**
 * Created by user on 12/14/15.
 */
package windows.WOComponents {
import flash.geom.Rectangle;
import manager.Vars;

import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;

public class WindowMine extends Sprite {
    private var g:Vars = Vars.getInstance();

    public function WindowMine(w:int, h:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var arr:Array = [];

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
        im.tileGrid = new Rectangle();
        im.width = w - arr[0].width - arr[2].width;
        im.x = arr[0].x + arr[0].width;
        im.y = arr[0].y;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);
        im = new Image(tex.getTexture('build_window_down'));
        im.tileGrid = new Rectangle();
        im.width = w - arr[0].width - arr[2].width;
        im.x = arr[0].x + arr[0].width;
        im.y = arr[0].y + h - arr[1].height;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);
        if (g.socialNetworkID != SocialNetworkSwitch.SN_VK_ID) {
            // double image to fix artifacts
            im = new Image(tex.getTexture('build_window_top'));
            im.tileGrid = new Rectangle();
            im.width = w - arr[0].width - arr[2].width + 6;
            im.x = arr[0].x + arr[0].width - 3;
            im.y = arr[0].y;
            im.tileGrid = im.tileGrid;
            addChildAt(im, 0);
            im = new Image(tex.getTexture('build_window_down'));
            im.tileGrid = new Rectangle();
            im.width = w - arr[0].width - arr[2].width + 6;
            im.x = arr[0].x + arr[0].width - 3;
            im.y = arr[0].y + h - arr[1].height;
            im.tileGrid = im.tileGrid;
            addChildAt(im, 0);
        }
        
        // left and right
        im = new Image(tex.getTexture('build_window_left'));
        im.tileGrid = new Rectangle();
        im.height = h - arr[0].height - arr[2].height;
        im.x = arr[0].x;
        im.y = arr[0].y + arr[0].height;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);
        im = new Image(tex.getTexture('build_window_right'));
        im.tileGrid = new Rectangle();
        im.height = h - arr[0].height - arr[2].height;
        im.x = arr[0].x + w - arr[2].height;
        im.y = arr[0].y + arr[0].height;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);
        
        arr.length = 0;
    }

    public function deleteIt():void {
        dispose();
        g = null;
    }
}
}
