package utils {

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Stage;

public class DrawToBitmap {

    public static function drawToBitmap(displayObject:DisplayObject):Bitmap {
        var stageWidth:Number = Starling.current.stage.stageWidth;
        var stageHeight:Number = Starling.current.stage.stageHeight;

        var support:RenderSupport = new RenderSupport();
        RenderSupport.clear();
        support.setProjectionMatrix(0, 0, stageWidth, stageHeight);
        support.applyBlendMode(true);

        var stageBitmapData:BitmapData = new BitmapData(stageWidth, stageHeight, true, 0x0);
        support.blendMode = displayObject.blendMode;
        displayObject.render(support, 1.0);
        support.finishQuadBatch();
        Starling.context.drawToBitmapData(stageBitmapData);

        var cropBounds:Rectangle = new Rectangle(0, 0, displayObject.width / displayObject.scaleX, displayObject.height / displayObject.scaleY);
        var resultBitmapData:BitmapData = new BitmapData(cropBounds.width, cropBounds.height, true, 0x0);
        resultBitmapData.copyPixels(stageBitmapData, cropBounds, new Point());

        var resultBitmap:Bitmap = new Bitmap(resultBitmapData);
        resultBitmap.scaleX = displayObject.scaleX;
        resultBitmap.scaleY = displayObject.scaleY;
        return resultBitmap;
    }

//    public static function copyToBitmapScale(disp:DisplayObject, scl:Number=1.0):BitmapData {
//        var rc:Rectangle = new Rectangle();
//        disp.getBounds(disp, rc);
//
//        var stage:Stage= Starling.current.stage;
//        var rs:RenderSupport = new RenderSupport();
//
//        rs.clear();
//        rs.scaleMatrix(scl, scl);
//        rs.setProjectionMatrix(0, 0, stage.stageWidth, stage.stageHeight);
//        rs.translateMatrix(-rc.x, -rc.y); // move to 0,0
//        disp.render(rs, 1.0);
//        rs.finishQuadBatch();
//
//        var outBmp:BitmapData = new BitmapData(int(rc.width*scl), int(rc.height*scl), true);
//        Starling.context.drawToBitmapData(outBmp);
//
//        return outBmp;
//    }
}
}
