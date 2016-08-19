package utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import manager.Vars;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.rendering.Painter;

public class DrawToBitmap {
    private static var g:Vars = Vars.getInstance();

    public static function drawToBitmap(displayObject:DisplayObject):Bitmap {
        var resultBitmap:Bitmap = new Bitmap(copyToBitmapData(displayObject));
        return resultBitmap;
    }

    public static function copyToBitmapData(disp:DisplayObject):BitmapData {
        var stageWidth:Number = Starling.current.stage.stageWidth;
        var stageHeight:Number = Starling.current.stage.stageHeight;

        var support:Painter = new Painter(Starling.current.stage3D);
        support.clear();

        var stageBitmapData:BitmapData = new BitmapData(stageWidth, stageHeight, true, 0x0);
        disp.render(support);
        Starling.context.drawToBitmapData(stageBitmapData);

        var cropBounds:Rectangle = new Rectangle(0, 0, disp.width / disp.scaleX, disp.height / disp.scaleY);
        var resultBitmapData:BitmapData = new BitmapData(cropBounds.width, cropBounds.height, true, 0x0);
        resultBitmapData.copyPixels(stageBitmapData, cropBounds, new Point());

        return resultBitmapData;
    }
    
}
}
