/**
 * Created by user on 11/24/15.
 */
package windows.WOComponents {
import flash.geom.Rectangle;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;
import utils.CButton;
import utils.DrawToBitmap;

public class WOButtonTexture extends Sprite {
    public static const GREEN:int = 1;
    public static const BLUE:int = 2;
    public static const YELLOW:int = 3;
    private var g:Vars = Vars.getInstance();

    public function WOButtonTexture(w:int, h:int, _type:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var arr:Array = [];
        var st:String = 'bt_b_';
        var _s:Sprite = new Sprite();

        if (w%2) w++;
        if (h%2) h++;

        switch (_type) {
            case CButton.GREEN: st = 'bt_gr_'; break;
            case CButton.BLUE: st = 'bt_b_'; break;
            case CButton.YELLOW: st = 'bt_y_'; break;
        }

        //top left
        im = new Image(tex.getTexture(st+'lt'));
        im.x = 0;
        im.y = 0;
        _s.addChild(im);
        arr.push(im);

        // bottom left
        im = new Image(tex.getTexture(st+'ld'));
        im.x = 0;
        im.y = h - im.height;
        _s.addChild(im);
        arr.push(im);

        // top right
        im = new Image(tex.getTexture(st+'rt'));
        im.x = w - im.width;
        im.y = 0;
        _s.addChild(im);
        arr.push(im);

        // bottom right
        im = new Image(tex.getTexture(st+'rd'));
        im.x = w - im.width;
        im.y = h - im.height;
        _s.addChild(im);
        arr.push(im);

        //top center and bottom center and center
        im = new Image(tex.getTexture(st+'c'));
        im.tileGrid = new Rectangle();
        im.width = w - arr[0].width - arr[2].width;
        im.height = h;
        im.x = arr[0].width;
        im.tileGrid = im.tileGrid;
        _s.addChildAt(im,0);

        // left and right
        im = new Image(tex.getTexture(st+'c'));
        im.tileGrid = new Rectangle();
        im.height = h - arr[0].height - arr[1].height;
        im.y = arr[0].height;
        im.tileGrid = im.tileGrid;
        _s.addChildAt(im,0);
        im = new Image(tex.getTexture(st+'c'));
        im.tileGrid = new Rectangle();
        im.height = h - arr[0].height - arr[1].height;
        im.x = w - arr[2].width;
        im.y = arr[0].height;
        im.tileGrid = im.tileGrid;
        _s.addChildAt(im,0);

        arr.length = 0;
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(_s));
        addChild(im);
        _s.dispose();
    }

    public function deleteIt():void {
        dispose();
        g = null;
    }
}
}
