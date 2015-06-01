/**
 * Created by andy on 6/1/15.
 */
package utils {
import flash.display.BitmapData;
import flash.geom.Rectangle;

import starling.core.RenderSupport;

import starling.core.Starling;

import starling.display.DisplayObject;
import starling.display.Stage;

public class Screenshot {

    public static function copyToBitmap(disp:DisplayObject, scl:Number=1.0):BitmapData
    {
        var rc:Rectangle = new Rectangle();
        disp.getBounds(disp, rc);

        var stage:Stage= Starling.current.stage;
        var rs:RenderSupport = new RenderSupport();

        rs.clear();
        rs.scaleMatrix(scl, scl);
        rs.setOrthographicProjection(0, 0, stage.stageWidth, stage.stageHeight);
        rs.translateMatrix(-rc.x, -rc.y); // move to 0,0
        disp.render(rs, 1.0);
        rs.finishQuadBatch();

        var outBmp:BitmapData = new BitmapData(rc.width*scl, rc.height*scl, true);
        Starling.context.drawToBitmapData(outBmp);

        return outBmp;
    }
}
}
